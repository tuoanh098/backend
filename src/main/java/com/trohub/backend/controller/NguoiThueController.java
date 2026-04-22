package com.trohub.backend.controller;

import com.trohub.backend.dto.NguoiThueDto;
import com.trohub.backend.security.AccessScope;
import com.trohub.backend.service.NguoiThueService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/tenants")
public class NguoiThueController {

    private final NguoiThueService nguoiThueService;
    private final AccessScope accessScope;

    public NguoiThueController(NguoiThueService nguoiThueService, AccessScope accessScope) {
        this.nguoiThueService = nguoiThueService;
        this.accessScope = accessScope;
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD')")
    @PostMapping
    public ResponseEntity<NguoiThueDto> create(@jakarta.validation.Valid @RequestBody NguoiThueDto dto) {
        if (dto.getSophong() != null) {
            accessScope.denyUnlessRoom(dto.getSophong());
        }
        NguoiThueDto created = nguoiThueService.create(dto);
        return ResponseEntity.created(URI.create("/api/tenants/" + created.getId())).body(created);
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD','ROLE_USER')")
    @GetMapping
    public ResponseEntity<List<NguoiThueDto>> listAll(@RequestParam(value = "q", required = false) String q) {
        List<NguoiThueDto> all = nguoiThueService.listAll().stream()
                .filter(item -> accessScope.canListTenant(item.getId()))
                .collect(Collectors.toList());
        if (q == null || q.trim().isEmpty()) {
            return ResponseEntity.ok(all);
        }
        String keyword = q.trim().toLowerCase(Locale.ROOT);
        List<NguoiThueDto> filtered = all.stream()
                .filter(item -> contains(item.getHoTen(), keyword)
                        || contains(item.getCccd(), keyword)
                        || contains(item.getSdt(), keyword)
                        || contains(String.valueOf(item.getId()), keyword))
                .collect(Collectors.toList());
        return ResponseEntity.ok(filtered);
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD','ROLE_USER')")
    @GetMapping("/{id}")
    public ResponseEntity<NguoiThueDto> getById(@PathVariable Long id) {
        accessScope.denyUnlessTenant(id);
        return ResponseEntity.ok(nguoiThueService.getById(id));
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD')")
    @PutMapping("/{id}")
    public ResponseEntity<NguoiThueDto> update(@PathVariable Long id, @jakarta.validation.Valid @RequestBody NguoiThueDto dto) {
        accessScope.denyUnlessTenant(id);
        if (dto.getSophong() != null) {
            accessScope.denyUnlessRoom(dto.getSophong());
        }
        return ResponseEntity.ok(nguoiThueService.update(id, dto));
    }

    @PreAuthorize("hasAnyAuthority('ROLE_ADMIN','ROLE_LANDLORD')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        accessScope.denyUnlessTenant(id);
        nguoiThueService.delete(id);
        return ResponseEntity.noContent().build();
    }

    private boolean contains(String value, String keyword) {
        return value != null && value.toLowerCase(Locale.ROOT).contains(keyword);
    }
}

