package com.trohub.backend.controller;

import com.trohub.backend.dto.ToaNhaDto;
import com.trohub.backend.security.AccessScope;
import com.trohub.backend.service.ToaNhaService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/buildings")
public class ToaNhaController {

    private final ToaNhaService toaNhaService;
    private final AccessScope accessScope;

    public ToaNhaController(ToaNhaService toaNhaService, AccessScope accessScope) {
        this.toaNhaService = toaNhaService;
        this.accessScope = accessScope;
    }

    @GetMapping
    public ResponseEntity<List<ToaNhaDto>> listAll(@RequestParam(value = "q", required = false) String q) {
        java.util.Set<Long> allowedBuildingIds = accessScope.visibleBuildingIds();
        List<ToaNhaDto> all = toaNhaService.listAll().stream()
                .filter(item -> allowedBuildingIds.contains(item.getId()))
                .collect(Collectors.toList());
        if (q == null || q.trim().isEmpty()) {
            return ResponseEntity.ok(all);
        }
        String keyword = q.trim().toLowerCase(Locale.ROOT);
        List<ToaNhaDto> filtered = all.stream()
                .filter(item -> contains(item.getTen(), keyword)
                        || contains(item.getDiaChi(), keyword)
                        || contains(String.valueOf(item.getId()), keyword))
                .collect(Collectors.toList());
        return ResponseEntity.ok(filtered);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ToaNhaDto> getById(@PathVariable Long id) {
        accessScope.denyUnlessBuilding(id);
        return ResponseEntity.ok(toaNhaService.getById(id));
    }

    @PostMapping
    public ResponseEntity<ToaNhaDto> create(@RequestBody ToaNhaDto dto) {
        var auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        boolean isAdminOrLandlord = auth.getAuthorities().stream().anyMatch(a ->
                a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_LANDLORD"));
        if (!isAdminOrLandlord) {
            return ResponseEntity.status(403).build();
        }

        accessScope.currentLandlordId().ifPresent(dto::setChuTroId);
        if (dto.getChuTroId() != null) {
            accessScope.currentLandlordId().ifPresent(landlordId -> {
                if (!landlordId.equals(dto.getChuTroId())) {
                    throw new org.springframework.security.access.AccessDeniedException("Cannot create building for another landlord");
                }
            });
        }
        ToaNhaDto created = toaNhaService.create(dto);
        return ResponseEntity.created(URI.create("/api/buildings/" + created.getId())).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ToaNhaDto> update(@PathVariable Long id, @RequestBody ToaNhaDto dto) {
        var auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        boolean isAdminOrLandlord = auth.getAuthorities().stream().anyMatch(a ->
                a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_LANDLORD"));
        if (!isAdminOrLandlord) {
            return ResponseEntity.status(403).build();
        }
        accessScope.denyUnlessBuilding(id);
        accessScope.currentLandlordId().ifPresent(dto::setChuTroId);
        return ResponseEntity.ok(toaNhaService.update(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        var auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        boolean isAdminOrLandlord = auth.getAuthorities().stream().anyMatch(a ->
                a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_LANDLORD"));
        if (!isAdminOrLandlord) {
            return ResponseEntity.status(403).build();
        }
        accessScope.denyUnlessBuilding(id);
        toaNhaService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/stats")
    public ResponseEntity<ToaNhaDto> stats(@PathVariable Long id) {
        accessScope.denyUnlessBuilding(id);
        return ResponseEntity.ok(toaNhaService.stats(id));
    }

    private boolean contains(String value, String keyword) {
        return value != null && value.toLowerCase(Locale.ROOT).contains(keyword);
    }
}

