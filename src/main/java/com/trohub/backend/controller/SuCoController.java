package com.trohub.backend.controller;

import com.trohub.backend.dto.SuCoDto;
import com.trohub.backend.security.AccessScope;
import com.trohub.backend.service.SuCoService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/api/incidents")
public class SuCoController {

    private final SuCoService suCoService;
    private final AccessScope accessScope;

    public SuCoController(SuCoService suCoService, AccessScope accessScope) {
        this.suCoService = suCoService;
        this.accessScope = accessScope;
    }

    @PreAuthorize("hasAnyAuthority('ROLE_USER','ROLE_BILLING_STAFF','ROLE_ADMIN','ROLE_LANDLORD')")
    @PostMapping
    public ResponseEntity<SuCoDto> create(@jakarta.validation.Valid @RequestBody SuCoDto dto) {
        if (accessScope.isTenant()) {
            Long tenantId = accessScope.currentTenantIdOrDeny();
            dto.setReportedBy(tenantId);
        }
        accessScope.denyUnlessRoom(dto.getPhongId());
        SuCoDto created = suCoService.create(dto);
        return ResponseEntity.created(URI.create("/api/incidents/" + created.getId())).body(created);
    }

    @PreAuthorize("hasAnyAuthority('ROLE_USER','ROLE_BILLING_STAFF','ROLE_ADMIN','ROLE_LANDLORD')")
    @GetMapping
    public ResponseEntity<List<SuCoDto>> listAll() {
        Long tenantId = accessScope.isTenant() ? accessScope.currentTenantIdOrDeny() : null;
        Set<Long> visibleRoomIds = accessScope.visibleRoomIds();
        return ResponseEntity.ok(suCoService.listAll().stream()
                .filter(item -> tenantId == null || tenantId.equals(item.getReportedBy()))
                .filter(item -> item.getPhongId() != null && visibleRoomIds.contains(item.getPhongId()))
                .toList());
    }

    @PreAuthorize("hasAnyAuthority('ROLE_USER','ROLE_BILLING_STAFF','ROLE_ADMIN','ROLE_LANDLORD')")
    @GetMapping("/{id}")
    public ResponseEntity<SuCoDto> getById(@PathVariable Long id) {
        SuCoDto dto = suCoService.getById(id);
        accessScope.denyUnlessRoom(dto.getPhongId());
        if (accessScope.isTenant() && !accessScope.currentTenantIdOrDeny().equals(dto.getReportedBy())) {
            throw new org.springframework.security.access.AccessDeniedException("Cannot view another tenant incident");
        }
        return ResponseEntity.ok(dto);
    }

    @PreAuthorize("hasAnyAuthority('ROLE_USER','ROLE_BILLING_STAFF','ROLE_ADMIN','ROLE_LANDLORD')")
    @PutMapping("/{id}")
    public ResponseEntity<SuCoDto> update(@PathVariable Long id, @jakarta.validation.Valid @RequestBody SuCoDto dto) {
        SuCoDto existing = suCoService.getById(id);
        accessScope.denyUnlessRoom(existing.getPhongId());
        if (accessScope.isTenant()) {
            Long tenantId = accessScope.currentTenantIdOrDeny();
            if (!tenantId.equals(existing.getReportedBy())) {
                throw new org.springframework.security.access.AccessDeniedException("Cannot edit another tenant incident");
            }
            dto.setReportedBy(existing.getReportedBy());
            dto.setStatus(existing.getStatus());
            dto.setToaNhaId(existing.getToaNhaId());
            if (dto.getPhongId() == null) {
                dto.setPhongId(existing.getPhongId());
            }
        }
        accessScope.denyUnlessRoom(dto.getPhongId());
        return ResponseEntity.ok(suCoService.update(id, dto));
    }

    @PreAuthorize("hasAnyAuthority('ROLE_USER','ROLE_BILLING_STAFF','ROLE_ADMIN','ROLE_LANDLORD')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        SuCoDto existing = suCoService.getById(id);
        accessScope.denyUnlessRoom(existing.getPhongId());
        if (accessScope.isTenant() && !accessScope.currentTenantIdOrDeny().equals(existing.getReportedBy())) {
            throw new org.springframework.security.access.AccessDeniedException("Cannot delete another tenant incident");
        }
        suCoService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PreAuthorize("hasAnyAuthority('ROLE_BILLING_STAFF','ROLE_ADMIN','ROLE_LANDLORD')")
    @PostMapping("/{id}/resolve")
    public ResponseEntity<SuCoDto> resolve(@PathVariable Long id) {
        SuCoDto existing = suCoService.getById(id);
        accessScope.denyUnlessRoom(existing.getPhongId());
        return ResponseEntity.ok(suCoService.resolve(id));
    }

    @PreAuthorize("hasAnyAuthority('ROLE_USER','ROLE_BILLING_STAFF','ROLE_ADMIN','ROLE_LANDLORD')")
    @PostMapping(path = "/{id}/attachments", consumes = "multipart/form-data")
    public ResponseEntity<SuCoDto> uploadAttachment(@PathVariable Long id, @RequestParam("file") org.springframework.web.multipart.MultipartFile file) {
        SuCoDto existing = suCoService.getById(id);
        accessScope.denyUnlessRoom(existing.getPhongId());
        if (accessScope.isTenant() && !accessScope.currentTenantIdOrDeny().equals(existing.getReportedBy())) {
            throw new org.springframework.security.access.AccessDeniedException("Cannot upload to another tenant incident");
        }
        SuCoDto dto = suCoService.addAttachment(id, file);
        return ResponseEntity.ok(dto);
    }
}

