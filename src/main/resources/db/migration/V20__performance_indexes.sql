-- Indexes for common mobile/API queries. Kept idempotent for existing local databases.
SET @schema_name = DATABASE();

SET @exists = (SELECT COUNT(1) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@schema_name AND TABLE_NAME='hoa_don' AND INDEX_NAME='idx_hoa_don_period');
SET @sql = IF(@exists=0, 'CREATE INDEX idx_hoa_don_period ON hoa_don(period_year, period_month);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(1) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@schema_name AND TABLE_NAME='hoa_don' AND INDEX_NAME='idx_hoa_don_tenant_period');
SET @sql = IF(@exists=0, 'CREATE INDEX idx_hoa_don_tenant_period ON hoa_don(tenant_id, period_year, period_month);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(1) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@schema_name AND TABLE_NAME='chi_so' AND INDEX_NAME='idx_chi_so_tenant_period');
SET @sql = IF(@exists=0, 'CREATE INDEX idx_chi_so_tenant_period ON chi_so(tenant_id, period_year, period_month);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(1) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@schema_name AND TABLE_NAME='chi_so' AND INDEX_NAME='idx_chi_so_period');
SET @sql = IF(@exists=0, 'CREATE INDEX idx_chi_so_period ON chi_so(period_year, period_month);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(1) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@schema_name AND TABLE_NAME='hop_dong' AND INDEX_NAME='idx_hop_dong_nguoi_period');
SET @sql = IF(@exists=0, 'CREATE INDEX idx_hop_dong_nguoi_period ON hop_dong(nguoi_id, ngay_bat_dau, ngay_ket_thuc, trang_thai);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(1) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@schema_name AND TABLE_NAME='hop_dong' AND INDEX_NAME='idx_hop_dong_phong_period');
SET @sql = IF(@exists=0, 'CREATE INDEX idx_hop_dong_phong_period ON hop_dong(phong_id, ngay_bat_dau, ngay_ket_thuc, trang_thai);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(1) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@schema_name AND TABLE_NAME='khach_vaora' AND INDEX_NAME='idx_khach_vaora_phong_status');
SET @sql = IF(@exists=0, 'CREATE INDEX idx_khach_vaora_phong_status ON khach_vaora(phong_id, approval_status);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(1) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@schema_name AND TABLE_NAME='su_co' AND INDEX_NAME='idx_su_co_phong_status');
SET @sql = IF(@exists=0, 'CREATE INDEX idx_su_co_phong_status ON su_co(phong_id, status);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(1) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@schema_name AND TABLE_NAME='su_co' AND INDEX_NAME='idx_su_co_reported_by');
SET @sql = IF(@exists=0, 'CREATE INDEX idx_su_co_reported_by ON su_co(reported_by);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(1) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@schema_name AND TABLE_NAME='phong' AND INDEX_NAME='idx_phong_toa_nha_status');
SET @sql = IF(@exists=0, 'CREATE INDEX idx_phong_toa_nha_status ON phong(toa_nha_id, trang_thai);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(1) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@schema_name AND TABLE_NAME='nguoithue' AND INDEX_NAME='idx_nguoithue_sophong');
SET @sql = IF(@exists=0, 'CREATE INDEX idx_nguoithue_sophong ON nguoithue(sophong);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(1) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@schema_name AND TABLE_NAME='toa_nha' AND INDEX_NAME='idx_toa_nha_chu_tro');
SET @sql = IF(@exists=0, 'CREATE INDEX idx_toa_nha_chu_tro ON toa_nha(chu_tro_id);', 'SELECT 1;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
