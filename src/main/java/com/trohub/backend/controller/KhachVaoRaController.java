package com.trohub.backend.controller;

import com.trohub.backend.dto.GuestEntryReviewRequest;
import com.trohub.backend.dto.KhachVaoRaDto;
import com.trohub.backend.mapper.KhachVaoRaMapper;
import com.trohub.backend.modal.KhachVaoRa;
import com.trohub.backend.security.AccessScope;
import com.trohub.backend.repository.ChuTroRepository;
import com.trohub.backend.repository.KhachVaoRaRepository;
import com.trohub.backend.repository.PhongRepository;
import com.trohub.backend.repository.TaiKhoanRepository;
import com.trohub.backend.repository.ToaNhaRepository;
import com.trohub.backend.service.KhachVaoRaService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/guest-entries")
public class KhachVaoRaController {

    private final KhachVaoRaService khachVaoRaService;
    private final TaiKhoanRepository taiKhoanRepository;
    private final ChuTroRepository chuTroRepository;
    private final ToaNhaRepository toaNhaRepository;
    private final PhongRepository phongRepository;
    private final KhachVaoRaRepository khachVaoRaRepository;
    private final AccessScope accessScope;

    public KhachVaoRaController(
            KhachVaoRaService khachVaoRaService,
            TaiKhoanRepository taiKhoanRepository,
            ChuTroRepository chuTroRepository,
            ToaNhaRepository toaNhaRepository,
            PhongRepository phongRepository,
            KhachVaoRaRepository khachVaoRaRepository,
            AccessScope accessScope
    ) {
        this.khachVaoRaService = khachVaoRaService;
        this.taiKhoanRepository = taiKhoanRepository;
        this.chuTroRepository = chuTroRepository;
        this.toaNhaRepository = toaNhaRepository;
        this.phongRepository = phongRepository;
        this.khachVaoRaRepository = khachVaoRaRepository;
        this.accessScope = accessScope;
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD','ROLE_USER')")
    @PostMapping
    public ResponseEntity<KhachVaoRaDto> create(@jakarta.validation.Valid @RequestBody KhachVaoRaDto dto) {
        accessScope.denyUnlessRoom(dto.getPhongId());
        KhachVaoRaDto created = khachVaoRaService.create(dto);
        return ResponseEntity.created(URI.create("/api/guest-entries/" + created.getId())).body(created);
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD','ROLE_USER')")
    @GetMapping
    public ResponseEntity<List<KhachVaoRaDto>> listAll() {
        Set<Long> visibleRoomIds = accessScope.visibleRoomIds();
        return ResponseEntity.ok(khachVaoRaService.listAll().stream()
                .filter(item -> item.getPhongId() != null && visibleRoomIds.contains(item.getPhongId()))
                .toList());
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD')")
    @GetMapping("/review-items")
    public ResponseEntity<List<KhachVaoRaDto>> reviewItems() {
        List<Long> buildingIds = new ArrayList<>(accessScope.visibleBuildingIds());
        if (buildingIds.isEmpty()) {
            return ResponseEntity.ok(new ArrayList<>());
        }

        Set<Long> roomIds = phongRepository.findAllByToaNhaIdIn(buildingIds)
                .stream()
                .map(r -> r.getId())
                .filter(id -> id != null)
                .collect(Collectors.toSet());
        if (roomIds.isEmpty()) {
            return ResponseEntity.ok(new ArrayList<>());
        }

        List<KhachVaoRa> entries = khachVaoRaRepository.findAllByPhongIdIn(roomIds);
        List<KhachVaoRaDto> dtos = entries.stream().map(KhachVaoRaMapper::toDto).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<KhachVaoRaDto> getById(@PathVariable Long id) {
        KhachVaoRaDto dto = khachVaoRaService.getById(id);
        accessScope.denyUnlessRoom(dto.getPhongId());
        return ResponseEntity.ok(dto);
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD','ROLE_USER')")
    @PutMapping("/{id}")
    public ResponseEntity<KhachVaoRaDto> update(@PathVariable Long id, @jakarta.validation.Valid @RequestBody KhachVaoRaDto dto) {
        KhachVaoRaDto existing = khachVaoRaService.getById(id);
        accessScope.denyUnlessRoom(existing.getPhongId());
        accessScope.denyUnlessRoom(dto.getPhongId());
        if (accessScope.isTenant()) {
            String status = existing.getApprovalStatus() == null ? "" : existing.getApprovalStatus().trim();
            if (!"NEED_INFO".equalsIgnoreCase(status) && !"PENDING".equalsIgnoreCase(status)) {
                throw new org.springframework.security.access.AccessDeniedException("Tenant can only update pending or need-info guest entries");
            }
        }
        return ResponseEntity.ok(khachVaoRaService.update(id, dto));
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        KhachVaoRaDto existing = khachVaoRaService.getById(id);
        accessScope.denyUnlessRoom(existing.getPhongId());
        khachVaoRaService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD')")
    @PostMapping("/{id}/approve")
    public ResponseEntity<KhachVaoRaDto> approve(@PathVariable Long id) {
        KhachVaoRaDto existing = khachVaoRaService.getById(id);
        accessScope.denyUnlessRoom(existing.getPhongId());
        return ResponseEntity.ok(khachVaoRaService.approve(id));
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD')")
    @PostMapping("/{id}/reject")
    public ResponseEntity<KhachVaoRaDto> reject(@PathVariable Long id) {
        KhachVaoRaDto existing = khachVaoRaService.getById(id);
        accessScope.denyUnlessRoom(existing.getPhongId());
        return ResponseEntity.ok(khachVaoRaService.reject(id));
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD')")
    @PostMapping("/{id}/request-info")
    public ResponseEntity<KhachVaoRaDto> requestInfo(@PathVariable Long id, @RequestBody(required = false) GuestEntryReviewRequest req) {
        KhachVaoRaDto existing = khachVaoRaService.getById(id);
        accessScope.denyUnlessRoom(existing.getPhongId());
        String note = req == null ? null : req.getNote();
        return ResponseEntity.ok(khachVaoRaService.requestInfo(id, note));
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD','ROLE_USER')")
    @PostMapping(path = "/{id}/attachments", consumes = "multipart/form-data")
    public ResponseEntity<KhachVaoRaDto> uploadAttachment(
            @PathVariable Long id,
            @RequestParam("file") org.springframework.web.multipart.MultipartFile file
    ) {
        KhachVaoRaDto existing = khachVaoRaService.getById(id);
        accessScope.denyUnlessRoom(existing.getPhongId());
        return ResponseEntity.ok(khachVaoRaService.addAttachment(id, file));
    }
}

