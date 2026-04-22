package com.trohub.backend.security;

import com.trohub.backend.modal.NguoiThue;
import com.trohub.backend.modal.Phong;
import com.trohub.backend.repository.ChuTroRepository;
import com.trohub.backend.repository.HopDongRepository;
import com.trohub.backend.repository.NguoiThueRepository;
import com.trohub.backend.repository.PhongRepository;
import com.trohub.backend.repository.TaiKhoanRepository;
import com.trohub.backend.repository.ToaNhaRepository;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class AccessScope {

    private final TaiKhoanRepository taiKhoanRepository;
    private final ChuTroRepository chuTroRepository;
    private final NguoiThueRepository nguoiThueRepository;
    private final ToaNhaRepository toaNhaRepository;
    private final PhongRepository phongRepository;
    private final HopDongRepository hopDongRepository;

    public AccessScope(
            TaiKhoanRepository taiKhoanRepository,
            ChuTroRepository chuTroRepository,
            NguoiThueRepository nguoiThueRepository,
            ToaNhaRepository toaNhaRepository,
            PhongRepository phongRepository,
            HopDongRepository hopDongRepository
    ) {
        this.taiKhoanRepository = taiKhoanRepository;
        this.chuTroRepository = chuTroRepository;
        this.nguoiThueRepository = nguoiThueRepository;
        this.toaNhaRepository = toaNhaRepository;
        this.phongRepository = phongRepository;
        this.hopDongRepository = hopDongRepository;
    }

    public boolean hasRole(String role) {
        Authentication auth = auth();
        return auth != null && auth.getAuthorities().stream().anyMatch(a -> role.equals(a.getAuthority()));
    }

    public boolean isAdminOrLandlord() {
        return hasRole("ROLE_ADMIN") || hasRole("ROLE_LANDLORD");
    }

    public boolean isTenant() {
        return hasRole("ROLE_USER");
    }

    public Optional<Long> currentAccountId() {
        Authentication auth = auth();
        if (auth == null) {
            return Optional.empty();
        }
        return taiKhoanRepository.findByUsername(auth.getName()).map(t -> t.getId());
    }

    public Optional<Long> currentLandlordId() {
        return currentAccountId().flatMap(id -> chuTroRepository.findByTaiKhoanId(id).map(c -> c.getId()));
    }

    public Optional<NguoiThue> currentTenant() {
        return currentAccountId().flatMap(nguoiThueRepository::findByTaiKhoanId);
    }

    public Long currentTenantIdOrDeny() {
        return currentTenant().map(NguoiThue::getId).orElseThrow(() -> new AccessDeniedException("Tenant profile not found"));
    }

    public Set<Long> visibleBuildingIds() {
        Optional<Long> landlordId = currentLandlordId();
        if (landlordId.isPresent()) {
            return toaNhaRepository.findAllByChuTroId(landlordId.get()).stream()
                    .map(t -> t.getId())
                    .collect(Collectors.toCollection(LinkedHashSet::new));
        }

        Optional<NguoiThue> tenant = currentTenant();
        if (tenant.isPresent() && tenant.get().getSophong() != null) {
            return phongRepository.findById(tenant.get().getSophong())
                    .map(Phong::getToaNhaId)
                    .map(Set::of)
                    .orElse(Collections.emptySet());
        }

        if (hasRole("ROLE_ADMIN") || hasRole("ROLE_BILLING_STAFF")) {
            return toaNhaRepository.findAll().stream()
                    .map(t -> t.getId())
                    .collect(Collectors.toCollection(LinkedHashSet::new));
        }

        return Collections.emptySet();
    }

    public Set<Long> visibleLandlordIds() {
        Optional<Long> landlordId = currentLandlordId();
        if (landlordId.isPresent()) {
            return Set.of(landlordId.get());
        }
        Optional<NguoiThue> tenant = currentTenant();
        if (tenant.isPresent() && tenant.get().getSophong() != null) {
            return phongRepository.findById(tenant.get().getSophong())
                    .flatMap(room -> toaNhaRepository.findById(room.getToaNhaId()))
                    .map(building -> building.getChuTroId())
                    .filter(id -> id != null)
                    .map(Set::of)
                    .orElse(Collections.emptySet());
        }
        if (hasRole("ROLE_ADMIN") || hasRole("ROLE_BILLING_STAFF")) {
            return chuTroRepository.findAll().stream()
                    .map(c -> c.getId())
                    .collect(Collectors.toCollection(LinkedHashSet::new));
        }
        return Collections.emptySet();
    }

    public boolean canAccessLandlord(Long landlordId) {
        return landlordId != null && visibleLandlordIds().contains(landlordId);
    }

    public boolean canAccessBuilding(Long buildingId) {
        return buildingId != null && visibleBuildingIds().contains(buildingId);
    }

    public boolean canAccessRoom(Long roomId) {
        if (roomId == null) {
            return false;
        }
        Optional<NguoiThue> tenant = currentTenant();
        if (tenant.isPresent() && isTenant() && !isAdminOrLandlord() && !hasRole("ROLE_BILLING_STAFF")) {
            return roomId.equals(tenant.get().getSophong());
        }
        return phongRepository.findById(roomId)
                .map(p -> canAccessBuilding(p.getToaNhaId()))
                .orElse(false);
    }

    public boolean canAccessTenant(Long tenantId) {
        if (tenantId == null) {
            return false;
        }
        Optional<NguoiThue> currentTenant = currentTenant();
        if (currentTenant.isPresent() && tenantId.equals(currentTenant.get().getId())) {
            return true;
        }
        if (isTenant() && !isAdminOrLandlord() && !hasRole("ROLE_BILLING_STAFF")) {
            return false;
        }
        Optional<NguoiThue> tenant = nguoiThueRepository.findById(tenantId);
        if (tenant.isPresent() && tenant.get().getSophong() != null && canAccessRoom(tenant.get().getSophong())) {
            return true;
        }
        return hopDongRepository.findByNguoiId(tenantId).stream().anyMatch(h -> canAccessRoom(h.getPhongId()));
    }

    public boolean canListTenant(Long tenantId) {
        if (canAccessTenant(tenantId)) {
            return true;
        }
        Optional<NguoiThue> currentTenant = currentTenant();
        if (currentTenant.isPresent() && isTenant() && !isAdminOrLandlord() && !hasRole("ROLE_BILLING_STAFF")) {
            Long currentRoomId = currentTenant.get().getSophong();
            return currentRoomId != null
                    && nguoiThueRepository.findById(tenantId)
                    .map(NguoiThue::getSophong)
                    .map(currentRoomId::equals)
                    .orElse(false);
        }
        return false;
    }

    public boolean canAccessContract(Long contractId) {
        if (contractId == null) {
            return false;
        }
        return hopDongRepository.findById(contractId)
                .map(h -> canAccessRoom(h.getPhongId()) && canAccessTenant(h.getNguoiId()))
                .orElse(false);
    }

    public void denyUnlessBuilding(Long buildingId) {
        if (!canAccessBuilding(buildingId)) {
            throw new AccessDeniedException("Building is outside current scope");
        }
    }

    public void denyUnlessRoom(Long roomId) {
        if (!canAccessRoom(roomId)) {
            throw new AccessDeniedException("Room is outside current scope");
        }
    }

    public void denyUnlessTenant(Long tenantId) {
        if (!canAccessTenant(tenantId)) {
            throw new AccessDeniedException("Tenant is outside current scope");
        }
    }

    public void denyUnlessContract(Long contractId) {
        if (!canAccessContract(contractId)) {
            throw new AccessDeniedException("Contract is outside current scope");
        }
    }

    private Authentication auth() {
        return SecurityContextHolder.getContext().getAuthentication();
    }
}
