package com.trohub.backend.service;

import com.trohub.backend.dto.NguoiThueDto;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface NguoiThueService {
    NguoiThueDto create(NguoiThueDto dto);
    NguoiThueDto update(Long id, NguoiThueDto dto);
    void delete(Long id);
    NguoiThueDto getById(Long id);
    List<NguoiThueDto> listAll();
    NguoiThueDto addAttachment(Long id, MultipartFile file);
}

