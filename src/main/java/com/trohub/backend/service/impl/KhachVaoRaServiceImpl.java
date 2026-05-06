package com.trohub.backend.service.impl;

import com.trohub.backend.config.UploadProperties;
import com.trohub.backend.exception.BadRequestException;
import com.trohub.backend.dto.KhachVaoRaDto;
import com.trohub.backend.exception.ResourceNotFoundException;
import com.trohub.backend.mapper.KhachVaoRaMapper;
import com.trohub.backend.modal.KhachVaoRa;
import com.trohub.backend.repository.KhachVaoRaRepository;
import com.trohub.backend.service.KhachVaoRaService;
import com.trohub.backend.util.ServiceUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class KhachVaoRaServiceImpl implements KhachVaoRaService {

    private final KhachVaoRaRepository khachVaoRaRepository;
    private final UploadProperties uploadProperties;

    public KhachVaoRaServiceImpl(KhachVaoRaRepository khachVaoRaRepository, UploadProperties uploadProperties) {
        this.khachVaoRaRepository = khachVaoRaRepository;
        this.uploadProperties = uploadProperties;
    }

    @Override
    public KhachVaoRaDto create(KhachVaoRaDto dto) {
        return ServiceUtils.exec(() -> doCreate(dto), "create KhachVaoRa");
    }

    private KhachVaoRaDto doCreate(KhachVaoRaDto dto) {
        KhachVaoRa e = KhachVaoRaMapper.toEntity(dto);
        if (e.getApprovalStatus() == null || e.getApprovalStatus().isBlank()) {
            e.setApprovalStatus("PENDING");
        }
        KhachVaoRa saved = khachVaoRaRepository.save(e);
        return KhachVaoRaMapper.toDto(saved);
    }

    @Override
    public KhachVaoRaDto update(Long id, KhachVaoRaDto dto) {
        return ServiceUtils.exec(() -> doUpdate(id, dto), "update KhachVaoRa id=" + id);
    }

    private KhachVaoRaDto doUpdate(Long id, KhachVaoRaDto dto) {
        KhachVaoRa exist = khachVaoRaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("KhachVaoRa not found"));
        exist.setTen(dto.getTen());
        exist.setCmnd(dto.getCmnd());
        exist.setSdt(dto.getSdt());
        exist.setPhongId(dto.getPhongId());
        exist.setLoai(dto.getLoai());
        exist.setGhiChu(dto.getGhiChu());
        KhachVaoRa saved = khachVaoRaRepository.save(exist);
        return KhachVaoRaMapper.toDto(saved);
    }

    @Override
    public void delete(Long id) {
        ServiceUtils.exec(() -> { khachVaoRaRepository.deleteById(id); return null; }, "delete KhachVaoRa id=" + id);
    }

    @Override
    public KhachVaoRaDto getById(Long id) {
        return ServiceUtils.exec(() -> khachVaoRaRepository.findById(id).map(KhachVaoRaMapper::toDto).orElseThrow(() -> new ResourceNotFoundException("KhachVaoRa not found")), "get KhachVaoRa id=" + id);
    }

    @Override
    public List<KhachVaoRaDto> listAll() {
        return ServiceUtils.exec(() -> khachVaoRaRepository.findAll().stream().map(KhachVaoRaMapper::toDto).collect(Collectors.toList()), "list all KhachVaoRa");
    }

    @Override
    public KhachVaoRaDto approve(Long id) {
        return ServiceUtils.exec(() -> doApprove(id), "approve KhachVaoRa id=" + id);
    }

    private KhachVaoRaDto doApprove(Long id) {
        KhachVaoRa exist = khachVaoRaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("KhachVaoRa not found"));
        exist.setApprovalStatus("APPROVED");
        KhachVaoRa saved = khachVaoRaRepository.save(exist);
        return KhachVaoRaMapper.toDto(saved);
    }

    @Override
    public KhachVaoRaDto reject(Long id) {
        return ServiceUtils.exec(() -> doReject(id), "reject KhachVaoRa id=" + id);
    }

    private KhachVaoRaDto doReject(Long id) {
        KhachVaoRa exist = khachVaoRaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("KhachVaoRa not found"));
        exist.setApprovalStatus("REJECTED");
        KhachVaoRa saved = khachVaoRaRepository.save(exist);
        return KhachVaoRaMapper.toDto(saved);
    }

    @Override
    public KhachVaoRaDto requestInfo(Long id, String note) {
        return ServiceUtils.exec(() -> doRequestInfo(id, note), "request info KhachVaoRa id=" + id);
    }

    private KhachVaoRaDto doRequestInfo(Long id, String note) {
        KhachVaoRa exist = khachVaoRaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("KhachVaoRa not found"));
        exist.setApprovalStatus("NEED_INFO");
        String trimmed = note == null ? "" : note.trim();
        if (!trimmed.isEmpty()) {
            String old = exist.getGhiChu() == null ? "" : exist.getGhiChu().trim();
            String prefix = "Yêu cầu bổ sung: " + trimmed;
            exist.setGhiChu(old.isEmpty() ? prefix : old + "\n" + prefix);
        }
        KhachVaoRa saved = khachVaoRaRepository.save(exist);
        return KhachVaoRaMapper.toDto(saved);
    }

    @Override
    public KhachVaoRaDto addAttachment(Long id, MultipartFile file) {
        return ServiceUtils.exec(() -> doAddAttachment(id, file), "add attachment to KhachVaoRa id=" + id);
    }

    private KhachVaoRaDto doAddAttachment(Long id, MultipartFile file) {
        KhachVaoRa exist = khachVaoRaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("KhachVaoRa not found"));
        validateUpload(file);

        Path baseDir = Paths.get(uploadProperties.getBaseDir(), uploadProperties.getGuestEntriesDir(), String.valueOf(id));
        try {
            Files.createDirectories(baseDir);
            String filename = UUID.randomUUID() + "_" + sanitizeFilename(file.getOriginalFilename());
            Path target = baseDir.resolve(filename);
            Files.copy(file.getInputStream(), target, java.nio.file.StandardCopyOption.REPLACE_EXISTING);

            String relPath = "/uploads/" + uploadProperties.getGuestEntriesDir() + "/" + id + "/" + filename;
            String existing = exist.getImagePaths();
            exist.setImagePaths(existing == null || existing.isBlank() ? relPath : existing + "," + relPath);
            return KhachVaoRaMapper.toDto(khachVaoRaRepository.save(exist));
        } catch (java.io.IOException e) {
            throw new RuntimeException("Failed to store uploaded file: " + e.getMessage(), e);
        }
    }

    private void validateUpload(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new BadRequestException("No file uploaded");
        }
        java.util.Set<String> allowedTypes = uploadProperties.getAllowedTypes().stream()
                .map(String::trim)
                .map(String::toLowerCase)
                .collect(java.util.stream.Collectors.toSet());
        String contentType = file.getContentType();
        if (contentType == null || !allowedTypes.contains(contentType.toLowerCase())) {
            throw new BadRequestException("Unsupported file type: " + contentType);
        }
        if (file.getSize() > uploadProperties.getMaxSize()) {
            throw new BadRequestException("File too large: " + file.getSize());
        }
    }

    private String sanitizeFilename(String original) {
        String name = original == null || original.isBlank() ? "guest.jpg" : original.trim();
        return name.replaceAll("[^a-zA-Z0-9._-]", "_");
    }
}

