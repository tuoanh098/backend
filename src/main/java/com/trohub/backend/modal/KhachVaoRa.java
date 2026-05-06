package com.trohub.backend.modal;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "khach_vaora")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KhachVaoRa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String ten;
    private String cmnd;
    private String sdt;

    @Column(name = "phong_id")
    private Long phongId;

    private String loai; // IN or OUT

    private LocalDateTime timestamp;

    @Column(columnDefinition = "TEXT")
    private String ghiChu;

    @Column(name = "approval_status")
    private String approvalStatus; // PENDING, APPROVED, REJECTED

    @Column(name = "image_paths", columnDefinition = "TEXT")
    private String imagePaths; // comma-separated paths

    @PrePersist
    public void prePersist() {
        if (timestamp == null) timestamp = LocalDateTime.now();
    }
}

