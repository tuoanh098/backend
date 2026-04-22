package com.trohub.backend.controller;

import com.trohub.backend.dto.HopDongDto;
import com.trohub.backend.security.AccessScope;
import com.trohub.backend.service.HopDongService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/contracts")
public class HopDongController {

    private final HopDongService hopDongService;
    private final AccessScope accessScope;

    public HopDongController(HopDongService hopDongService, AccessScope accessScope) {
        this.hopDongService = hopDongService;
        this.accessScope = accessScope;
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD')")
    @PostMapping
    public ResponseEntity<HopDongDto> create(@jakarta.validation.Valid @RequestBody HopDongDto dto) {
        accessScope.denyUnlessRoom(dto.getPhongId());
        accessScope.denyUnlessTenant(dto.getNguoiId());
        HopDongDto created = hopDongService.create(dto);
        return ResponseEntity.created(URI.create("/api/contracts/" + created.getId())).body(created);
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD')")
    @PutMapping("/{id}")
    public ResponseEntity<HopDongDto> update(@PathVariable Long id, @jakarta.validation.Valid @RequestBody HopDongDto dto) {
        accessScope.denyUnlessContract(id);
        if (dto.getPhongId() != null) {
            accessScope.denyUnlessRoom(dto.getPhongId());
        }
        if (dto.getNguoiId() != null) {
            accessScope.denyUnlessTenant(dto.getNguoiId());
        }
        HopDongDto updated = hopDongService.update(id, dto);
        return ResponseEntity.ok(updated);
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD','ROLE_USER')")
    @GetMapping
    public ResponseEntity<List<HopDongDto>> listAll() {
        return ResponseEntity.ok(hopDongService.listAll().stream()
                .filter(item -> accessScope.canAccessContract(item.getId()))
                .toList());
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD','ROLE_USER')")
    @GetMapping("/{id}")
    public ResponseEntity<HopDongDto> getById(@PathVariable Long id) {
        accessScope.denyUnlessContract(id);
        return ResponseEntity.ok(hopDongService.getById(id));
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD','ROLE_USER')")
    @GetMapping("/tenant/{tenantId}")
    public ResponseEntity<List<HopDongDto>> listByTenant(@PathVariable Long tenantId) {
        accessScope.denyUnlessTenant(tenantId);
        return ResponseEntity.ok(hopDongService.listByNguoiId(tenantId));
    }
}

