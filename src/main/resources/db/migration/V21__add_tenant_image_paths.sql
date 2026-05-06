SET @schema_name = DATABASE();

SET @col_exists = (
  SELECT COUNT(1)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name
    AND TABLE_NAME = 'nguoithue'
    AND COLUMN_NAME = 'image_paths'
);
SET @sql = IF(@col_exists = 0, 'ALTER TABLE nguoithue ADD COLUMN image_paths TEXT NULL;', 'SELECT 1;');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
