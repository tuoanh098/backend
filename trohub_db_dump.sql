-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: trohub_db
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bank_info`
--

DROP TABLE IF EXISTS `bank_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_info` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `account_number` varchar(255) DEFAULT NULL,
  `owner_name` varchar(255) DEFAULT NULL,
  `bank_name` varchar(255) DEFAULT NULL,
  `image_base64` tinytext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_info`
--

LOCK TABLES `bank_info` WRITE;
/*!40000 ALTER TABLE `bank_info` DISABLE KEYS */;
INSERT INTO `bank_info` VALUES (2,'123456789','ONG CHU 1','Vietcombank',NULL,'2026-04-21 21:42:34','2026-04-21 21:42:34',NULL);
/*!40000 ALTER TABLE `bank_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chi_so`
--

DROP TABLE IF EXISTS `chi_so`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chi_so` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `meter_type` varchar(32) NOT NULL,
  `meter_id` varchar(255) DEFAULT NULL,
  `tenant_id` bigint DEFAULT NULL,
  `reading_value` bigint NOT NULL,
  `recorded_at` date NOT NULL,
  `period_year` int NOT NULL,
  `period_month` int NOT NULL,
  `recorded_by` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_chi_so_meter_period` (`meter_id`,`period_year`,`period_month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chi_so`
--

LOCK TABLES `chi_so` WRITE;
/*!40000 ALTER TABLE `chi_so` DISABLE KEYS */;
/*!40000 ALTER TABLE `chi_so` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chu_tro`
--

DROP TABLE IF EXISTS `chu_tro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chu_tro` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `dia_chi` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `sdt` varchar(255) DEFAULT NULL,
  `ten` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `tai_khoan_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_chu_tro_tai_khoan` (`tai_khoan_id`),
  CONSTRAINT `fk_chu_tro_tai_khoan` FOREIGN KEY (`tai_khoan_id`) REFERENCES `tai_khoan` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chu_tro`
--

LOCK TABLES `chu_tro` WRITE;
/*!40000 ALTER TABLE `chu_tro` DISABLE KEYS */;
INSERT INTO `chu_tro` VALUES (1,'2026-04-21 20:35:06.000000','Dia chi Ong Chu 1','ongchu1@example.com','0900000001','Ong Chu 1','2026-04-21 20:35:06.000000',1),(2,'2026-04-21 20:35:06.000000','Dia chi Ong Chu 2','ongchu2@example.com','0900000002','Ong Chu 2','2026-04-21 20:35:06.000000',2);
/*!40000 ALTER TABLE `chu_tro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `don_gia`
--

DROP TABLE IF EXISTS `don_gia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `don_gia` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `meter_type` varchar(32) NOT NULL,
  `effective_from` date NOT NULL,
  `effective_to` date DEFAULT NULL,
  `price_per_unit` decimal(38,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `don_gia`
--

LOCK TABLES `don_gia` WRITE;
/*!40000 ALTER TABLE `don_gia` DISABLE KEYS */;
/*!40000 ALTER TABLE `don_gia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flyway_schema_history`
--

DROP TABLE IF EXISTS `flyway_schema_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flyway_schema_history` (
  `installed_rank` int NOT NULL,
  `version` varchar(50) DEFAULT NULL,
  `description` varchar(200) NOT NULL,
  `type` varchar(20) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `checksum` int DEFAULT NULL,
  `installed_by` varchar(100) NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`),
  KEY `flyway_schema_history_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flyway_schema_history`
--

LOCK TABLES `flyway_schema_history` WRITE;
/*!40000 ALTER TABLE `flyway_schema_history` DISABLE KEYS */;
INSERT INTO `flyway_schema_history` VALUES (1,'1','create billing tables','SQL','V1__create_billing_tables.sql',-259010020,'root','2026-04-20 17:14:25',314,1),(2,'2','create nguoithue table','SQL','V2__create_nguoithue_table.sql',-1147185248,'root','2026-04-20 17:14:25',134,1),(3,'3','create nguoithue table','SQL','V3__create_nguoithue_table.sql',-1913280571,'root','2026-04-20 17:14:25',46,1),(4,'4','create phong table','SQL','V4__create_phong_table.sql',-1688106113,'root','2026-04-20 17:14:25',45,1),(5,'5','create hop dong table','SQL','V5__create_hop_dong_table.sql',-670309162,'root','2026-04-20 17:14:25',46,1),(6,'6','indexes for reports','SQL','V6__indexes_for_reports.sql',-1094995998,'root','2026-04-20 17:14:25',36,1),(7,'7','create su co table','SQL','V7__create_su_co_table.sql',-1424296043,'root','2026-04-20 17:14:25',52,1),(8,'8','create khach vaora table','SQL','V8__create_khach_vaora_table.sql',-1513879810,'root','2026-04-20 17:14:25',42,1),(9,'9','add hopdong utilities','SQL','V9__add_hopdong_utilities.sql',-19509904,'root','2026-04-20 17:40:23',37,1),(10,'10','create bank info','SQL','V10__create_bank_info.sql',-59480027,'root','2026-04-20 17:40:23',40,1),(11,'12','create remaining tables','SQL','V12__create_remaining_tables.sql',506282871,'root','2026-04-20 17:40:23',121,1),(12,'13','create toa nha table','SQL','V13__create_toa_nha_table.sql',-1609624453,'root','2026-04-21 12:05:32',150,1),(13,'14','create chu tro table','SQL','V14__create_chu_tro_table.sql',2082047521,'root','2026-04-21 12:05:32',266,1),(14,'15','add tai khoan id to chu tro','SQL','V15__add_tai_khoan_id_to_chu_tro.sql',-2110373910,'root','2026-04-21 12:45:12',272,1),(15,'16','add fk chu tro tai khoan','SQL','V16__add_fk_chu_tro_tai_khoan.sql',451660994,'root','2026-04-21 12:45:12',370,1),(16,'17','add fields to nguoithue','SQL','V17__add_fields_to_nguoithue.sql',-1532843521,'root','2026-04-21 13:32:22',229,1),(17,'18','seed initial data','SQL','V18__seed_initial_data.sql',-122154951,'root','2026-04-21 13:35:06',30,1);
/*!40000 ALTER TABLE `flyway_schema_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hoa_don`
--

DROP TABLE IF EXISTS `hoa_don`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hoa_don` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `invoice_number` varchar(255) DEFAULT NULL,
  `tenant_id` bigint DEFAULT NULL,
  `period_year` int NOT NULL,
  `period_month` int NOT NULL,
  `issue_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `total_amount` decimal(38,2) DEFAULT NULL,
  `penalty_amount` decimal(38,2) DEFAULT NULL,
  `status` varchar(32) DEFAULT 'UNPAID',
  `created_by` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice_number` (`invoice_number`),
  KEY `idx_hoa_don_tenant` (`tenant_id`),
  KEY `idx_hoa_don_status_due` (`status`,`due_date`),
  KEY `idx_hoa_don_issue_date` (`issue_date`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hoa_don`
--

LOCK TABLES `hoa_don` WRITE;
/*!40000 ALTER TABLE `hoa_don` DISABLE KEYS */;
INSERT INTO `hoa_don` VALUES (6,NULL,5,2026,4,'2026-04-22','2026-05-15',0.00,NULL,'DRAFT',NULL,'2026-04-21 15:07:12','2026-04-21 15:07:12'),(7,NULL,6,2026,4,'2026-04-22','2026-05-15',0.00,NULL,'DRAFT',NULL,'2026-04-21 15:07:12','2026-04-21 15:07:12'),(8,NULL,3,2026,3,'2026-04-22','2026-04-15',0.00,NULL,'DRAFT',NULL,'2026-04-21 19:53:31','2026-04-21 19:53:31'),(9,NULL,4,2026,3,'2026-04-22','2026-04-15',0.00,NULL,'DRAFT',NULL,'2026-04-21 19:53:31','2026-04-21 19:53:31'),(10,NULL,5,2026,3,'2026-04-22','2026-04-15',0.00,NULL,'DRAFT',NULL,'2026-04-21 19:53:31','2026-04-21 19:53:31'),(11,NULL,6,2026,3,'2026-04-22','2026-04-15',0.00,NULL,'DRAFT',NULL,'2026-04-21 19:53:31','2026-04-21 19:53:31'),(12,NULL,3,2026,5,'2026-04-22','2026-06-15',0.00,NULL,'DRAFT',NULL,'2026-04-21 19:53:38','2026-04-21 19:53:38'),(13,NULL,4,2026,5,'2026-04-22','2026-06-15',0.00,NULL,'DRAFT',NULL,'2026-04-21 19:53:38','2026-04-21 19:53:38'),(14,NULL,5,2026,5,'2026-04-22','2026-06-15',0.00,NULL,'DRAFT',NULL,'2026-04-21 19:53:38','2026-04-21 19:53:38'),(15,NULL,6,2026,5,'2026-04-22','2026-06-15',0.00,NULL,'DRAFT',NULL,'2026-04-21 19:53:38','2026-04-21 19:53:38'),(41,NULL,4,2026,4,'2026-04-22','2026-05-15',3700000.00,1400000.00,'OVERDUE',NULL,'2026-04-21 23:58:09','2026-04-21 23:58:24'),(51,NULL,1,2026,4,'2026-04-22','2026-05-15',2100000.00,NULL,'PAID',NULL,'2026-04-22 01:28:40','2026-04-22 01:30:47'),(52,NULL,2,2026,4,'2026-04-22','2026-05-15',2100000.00,NULL,'UNPAID',NULL,'2026-04-22 01:28:40','2026-04-22 01:28:40'),(53,NULL,3,2026,4,'2026-04-22','2026-05-15',2600000.00,NULL,'UNPAID',NULL,'2026-04-22 01:28:40','2026-04-22 01:28:40');
/*!40000 ALTER TABLE `hoa_don` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hoa_don_dien`
--

DROP TABLE IF EXISTS `hoa_don_dien`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hoa_don_dien` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `hoa_don_id` bigint NOT NULL,
  `meter_id` varchar(255) DEFAULT NULL,
  `start_reading` bigint DEFAULT NULL,
  `end_reading` bigint DEFAULT NULL,
  `consumption` bigint DEFAULT NULL,
  `unit_price` decimal(38,2) DEFAULT NULL,
  `amount` decimal(38,2) DEFAULT NULL,
  `period_year` int NOT NULL,
  `period_month` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_hd_dien_hoa_don` (`hoa_don_id`),
  CONSTRAINT `FKc39g8d2rcqvt93a8kgaxy81ls` FOREIGN KEY (`hoa_don_id`) REFERENCES `hoa_don` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hoa_don_dien`
--

LOCK TABLES `hoa_don_dien` WRITE;
/*!40000 ALTER TABLE `hoa_don_dien` DISABLE KEYS */;
/*!40000 ALTER TABLE `hoa_don_dien` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hoa_don_nuoc`
--

DROP TABLE IF EXISTS `hoa_don_nuoc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hoa_don_nuoc` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `hoa_don_id` bigint NOT NULL,
  `meter_id` varchar(255) DEFAULT NULL,
  `start_reading` bigint DEFAULT NULL,
  `end_reading` bigint DEFAULT NULL,
  `consumption` bigint DEFAULT NULL,
  `unit_price` decimal(38,2) DEFAULT NULL,
  `amount` decimal(38,2) DEFAULT NULL,
  `period_year` int NOT NULL,
  `period_month` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_hd_nuoc_hoa_don` (`hoa_don_id`),
  CONSTRAINT `FKj2bo1t3bfx9lvsjmbtm98wutm` FOREIGN KEY (`hoa_don_id`) REFERENCES `hoa_don` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hoa_don_nuoc`
--

LOCK TABLES `hoa_don_nuoc` WRITE;
/*!40000 ALTER TABLE `hoa_don_nuoc` DISABLE KEYS */;
INSERT INTO `hoa_don_nuoc` VALUES (27,41,'FIXED_WATER',0,0,1,100000.00,100000.00,2026,4,'2026-04-21 23:58:09'),(37,51,'FIXED_WATER',0,0,1,100000.00,100000.00,2026,4,'2026-04-22 01:28:40'),(38,52,'FIXED_WATER',0,0,1,100000.00,100000.00,2026,4,'2026-04-22 01:28:40'),(39,53,'FIXED_WATER',0,0,1,100000.00,100000.00,2026,4,'2026-04-22 01:28:40');
/*!40000 ALTER TABLE `hoa_don_nuoc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hop_dong`
--

DROP TABLE IF EXISTS `hop_dong`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hop_dong` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ma_hop_dong` varchar(255) NOT NULL,
  `phong_id` bigint DEFAULT NULL,
  `nguoi_id` bigint DEFAULT NULL,
  `ngay_bat_dau` date DEFAULT NULL,
  `ngay_ket_thuc` date DEFAULT NULL,
  `tien_coc` decimal(38,2) DEFAULT NULL,
  `tien_thue` decimal(38,2) DEFAULT NULL,
  `tien_dien_per_unit` decimal(38,2) DEFAULT NULL,
  `tien_nuoc_fixed` decimal(38,2) DEFAULT NULL,
  `trang_thai` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ma_hop_dong` (`ma_hop_dong`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hop_dong`
--

LOCK TABLES `hop_dong` WRITE;
/*!40000 ALTER TABLE `hop_dong` DISABLE KEYS */;
INSERT INTO `hop_dong` VALUES (1,'HD-001',1,1,'2026-04-21','2027-04-21',0.00,2000000.00,3000.00,100000.00,'ACTIVE','2026-04-21 13:35:06','2026-04-21 21:41:26'),(2,'HD-002',1,2,'2026-04-21','2026-09-21',0.00,2000000.00,3000.00,100000.00,'ACTIVE','2026-04-21 13:35:06','2026-04-21 21:41:40'),(3,'HD-003',2,3,'2026-04-21','2026-05-21',0.00,2500000.00,3000.00,100000.00,'ACTIVE','2026-04-21 13:35:06','2026-04-21 21:41:55'),(4,'HD-004',4,4,'2026-04-21',NULL,0.00,2200000.00,3000.00,100000.00,'ACTIVE','2026-04-21 13:35:06','2026-04-21 13:35:06'),(5,'HD-006',6,1,'2026-04-21','2027-04-21',NULL,12000000.00,3000.00,100000.00,'ACTIVE','2026-04-21 21:43:08','2026-04-21 21:43:08');
/*!40000 ALTER TABLE `hop_dong` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `khach_vaora`
--

DROP TABLE IF EXISTS `khach_vaora`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `khach_vaora` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ten` varchar(255) DEFAULT NULL,
  `cmnd` varchar(255) DEFAULT NULL,
  `sdt` varchar(255) DEFAULT NULL,
  `phong_id` bigint DEFAULT NULL,
  `loai` varchar(255) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ghi_chu` text,
  `approval_status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `khach_vaora`
--

LOCK TABLES `khach_vaora` WRITE;
/*!40000 ALTER TABLE `khach_vaora` DISABLE KEYS */;
INSERT INTO `khach_vaora` VALUES (2,'Nghi','12312341234','12312312',1,'IN','2026-04-22 01:31:12','','APPROVED');
/*!40000 ALTER TABLE `khach_vaora` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nguoithue`
--

DROP TABLE IF EXISTS `nguoithue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nguoithue` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cccd` varchar(255) DEFAULT NULL,
  `ho_ten` varchar(255) DEFAULT NULL,
  `ngay_sinh` date DEFAULT NULL,
  `gioi_tinh` varchar(255) DEFAULT NULL,
  `dia_chi` varchar(255) DEFAULT NULL,
  `sdt` varchar(255) DEFAULT NULL,
  `tai_khoan_id` bigint DEFAULT NULL,
  `sophong` bigint DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `que_quan` varchar(255) DEFAULT NULL,
  `nghe_nghiep` varchar(255) DEFAULT NULL,
  `thong_tin_lien_lac` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tai_khoan_id` (`tai_khoan_id`),
  CONSTRAINT `fk_nguoithue_taikhoan` FOREIGN KEY (`tai_khoan_id`) REFERENCES `tai_khoan` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nguoithue`
--

LOCK TABLES `nguoithue` WRITE;
/*!40000 ALTER TABLE `nguoithue` DISABLE KEYS */;
INSERT INTO `nguoithue` VALUES (1,'CITIZEN001','Khach Thue 1',NULL,NULL,'Dia chi KT1','0910000001',3,1,'2026-04-21 13:35:06','2026-04-21 22:48:55','Dinh Quan','',''),(2,'CITIZEN002','Khach Thue 2',NULL,NULL,'Dia chi KT2','0910000002',4,1,'2026-04-21 13:35:06','2026-04-21 13:35:06',NULL,NULL,NULL),(3,'CITIZEN003','Khach Thue 3',NULL,NULL,'Dia chi KT3','0910000003',5,2,'2026-04-21 13:35:06','2026-04-21 13:35:06',NULL,NULL,NULL),(4,'CITIZEN004','Khach Thue 4',NULL,NULL,'Dia chi KT4','0910000004',6,4,'2026-04-21 13:35:06','2026-04-21 13:35:06',NULL,NULL,NULL),(5,'3273273247327','Vu Tu Oanh',NULL,NULL,NULL,'12375812312',7,6,'2026-04-22 01:42:28','2026-04-22 01:42:28',NULL,NULL,NULL);
/*!40000 ALTER TABLE `nguoithue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phieu_thu`
--

DROP TABLE IF EXISTS `phieu_thu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phieu_thu` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `hoa_don_id` bigint NOT NULL,
  `amount_paid` decimal(38,2) DEFAULT NULL,
  `payment_method` varchar(32) NOT NULL,
  `payment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `transaction_id` varchar(255) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_phieu_thu_txn` (`transaction_id`),
  KEY `idx_phieu_thu_hoa_don` (`hoa_don_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phieu_thu`
--

LOCK TABLES `phieu_thu` WRITE;
/*!40000 ALTER TABLE `phieu_thu` DISABLE KEYS */;
INSERT INTO `phieu_thu` VALUES (2,30,2100000.00,'QR','2026-04-21 22:47:06','txn-app-1776836850239',NULL,'2026-04-21 22:47:06'),(3,32,2600000.00,'QR','2026-04-21 22:50:36','txn-app-1776837060348',NULL,'2026-04-21 22:50:36'),(4,40,2600000.00,'QR','2026-04-21 23:58:17','txn-app-1776841121495',NULL,'2026-04-21 23:58:17'),(5,51,2100000.00,'QR','2026-04-22 01:30:47','txn-app-1776846671863',NULL,'2026-04-22 01:30:47');
/*!40000 ALTER TABLE `phieu_thu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phong`
--

DROP TABLE IF EXISTS `phong`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phong` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ma_phong` varchar(255) NOT NULL,
  `toa_nha_id` bigint DEFAULT NULL,
  `khu_id` bigint DEFAULT NULL,
  `loai_phong_id` bigint DEFAULT NULL,
  `so_giuong` int DEFAULT NULL,
  `trang_thai` varchar(255) DEFAULT NULL,
  `mo_ta` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ma_phong` (`ma_phong`),
  KEY `fk_phong_toa_nha` (`toa_nha_id`),
  CONSTRAINT `fk_phong_toa_nha` FOREIGN KEY (`toa_nha_id`) REFERENCES `toa_nha` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phong`
--

LOCK TABLES `phong` WRITE;
/*!40000 ALTER TABLE `phong` DISABLE KEYS */;
INSERT INTO `phong` VALUES (1,'A101',1,NULL,NULL,2,'DA_THUE','Phong A101','2026-04-21 13:35:06','2026-04-21 13:35:06'),(2,'A102',1,NULL,NULL,2,'DA_THUE','Phong A102','2026-04-21 13:35:06','2026-04-21 13:35:06'),(3,'A103',1,NULL,NULL,2,'TRONG','Phong A103','2026-04-21 13:35:06','2026-04-21 13:35:06'),(4,'B201',2,NULL,NULL,1,'DA_THUE','Phong B201','2026-04-21 13:35:06','2026-04-21 13:35:06'),(6,'A104',1,NULL,NULL,1,'TRONG','Phong con trong','2026-04-21 21:35:32','2026-04-21 21:36:04');
/*!40000 ALTER TABLE `phong` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qr_payment_log`
--

DROP TABLE IF EXISTS `qr_payment_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qr_payment_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `hoa_don_id` bigint NOT NULL,
  `qr_code` varchar(255) DEFAULT NULL,
  `qr_payload` tinytext,
  `expected_amount` decimal(38,2) DEFAULT NULL,
  `status` varchar(32) DEFAULT 'CREATED',
  `generated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NULL DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_qr_code` (`qr_code`),
  KEY `idx_qr_status_expires` (`status`,`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qr_payment_log`
--

LOCK TABLES `qr_payment_log` WRITE;
/*!40000 ALTER TABLE `qr_payment_log` DISABLE KEYS */;
INSERT INTO `qr_payment_log` VALUES (2,5,'QR-2d37974a-1950-4861-8be6-5b2756fe0a15','{\"type\":\"VIETQR\",\"account\":\"123456789\",\"name\":\"ONG CHU 1\",\"bank\":\"Vietcombank\",\"tenantName\":\"Khach Thue 4\",\"room\":\"4\",\"invoice\":5,\"amt\":0.00}',0.00,'EXPIRED','2026-04-21 15:37:29','2026-04-21 16:07:29',NULL,NULL),(3,3,'QR-4fdaf6d1-f103-435b-b29d-614f5e871be3','{\"type\":\"VIETQR\",\"account\":\"123456789\",\"name\":\"ONG CHU 1\",\"bank\":\"Vietcombank\",\"tenantName\":\"Khach Thue 3\",\"room\":\"2\",\"invoice\":3,\"amt\":0.00}',0.00,'EXPIRED','2026-04-21 21:39:44','2026-04-21 22:09:44',NULL,NULL),(4,30,'QR-ade2533a-6e00-4f5b-a829-31c098ff289c','{\"type\":\"VIETQR\",\"account\":\"123456789\",\"name\":\"ONG CHU 1\",\"bank\":\"Vietcombank\",\"tenantName\":\"Khach Thue 1\",\"room\":\"1\",\"invoice\":30,\"amt\":2100000.00}',2100000.00,'EXPIRED','2026-04-21 22:46:17','2026-04-21 23:16:17',NULL,NULL),(5,30,'QR-f1a35ff3-e556-416e-b3be-23625413b3a9','{\"type\":\"VIETQR\",\"account\":\"123456789\",\"name\":\"ONG CHU 1\",\"bank\":\"Vietcombank\",\"tenantName\":\"Khach Thue 1\",\"room\":\"1\",\"invoice\":30,\"amt\":2100000.00}',2100000.00,'PAID','2026-04-21 22:47:04','2026-04-21 23:17:04','2026-04-21 22:47:06','txn-app-1776836850239'),(6,32,'QR-fab53fd6-d9d0-4c4d-824a-4c46d199c4e1','{\"type\":\"VIETQR\",\"account\":\"123456789\",\"name\":\"ONG CHU 1\",\"bank\":\"Vietcombank\",\"tenantName\":\"Khach Thue 3\",\"room\":\"2\",\"invoice\":32,\"amt\":2600000.00}',2600000.00,'PAID','2026-04-21 22:50:35','2026-04-21 23:20:35','2026-04-21 22:50:36','txn-app-1776837060348'),(7,40,'QR-c2c5202b-0131-405e-ab62-9632208854d3','{\"type\":\"VIETQR\",\"account\":\"123456789\",\"name\":\"ONG CHU 1\",\"bank\":\"Vietcombank\",\"tenantName\":\"Khach Thue 3\",\"room\":\"2\",\"invoice\":40,\"amt\":2600000.00}',2600000.00,'PAID','2026-04-21 23:58:14','2026-04-22 00:28:14','2026-04-21 23:58:17','txn-app-1776841121495'),(8,51,'QR-549cf53a-bfd6-4e13-a884-451148da6ef6','{\"type\":\"VIETQR\",\"account\":\"123456789\",\"name\":\"ONG CHU 1\",\"bank\":\"Vietcombank\",\"tenantName\":\"Khach Thue 1\",\"room\":\"1\",\"invoice\":51,\"amt\":2100000.00}',2100000.00,'PAID','2026-04-22 01:30:46','2026-04-22 02:00:46','2026-04-22 01:30:47','txn-app-1776846671863');
/*!40000 ALTER TABLE `qr_payment_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `su_co`
--

DROP TABLE IF EXISTS `su_co`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `su_co` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `loai` varchar(255) DEFAULT NULL,
  `mo_ta` text,
  `toa_nha_id` bigint DEFAULT NULL,
  `phong_id` bigint DEFAULT NULL,
  `reported_by` bigint DEFAULT NULL,
  `reported_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `image_paths` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `su_co`
--

LOCK TABLES `su_co` WRITE;
/*!40000 ALTER TABLE `su_co` DISABLE KEYS */;
INSERT INTO `su_co` VALUES (1,'NUOC','Test API incident from local',1,1,1,'2026-04-21 14:13:32','2026-04-22 03:13:14','RESOLVED',NULL),(2,'DIEN','Hu may lanh',1,1,1,'2026-04-21 22:59:00','2026-04-22 03:13:19','RESOLVED',NULL),(3,'THIET_BI','',1,1,1,'2026-04-22 00:01:00',NULL,'OPEN',NULL);
/*!40000 ALTER TABLE `su_co` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tai_khoan`
--

DROP TABLE IF EXISTS `tai_khoan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tai_khoan` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tai_khoan`
--

LOCK TABLES `tai_khoan` WRITE;
/*!40000 ALTER TABLE `tai_khoan` DISABLE KEYS */;
INSERT INTO `tai_khoan` VALUES (1,'ongchu1','$2b$12$2krAsFFDflCu0pFc0sRm/eRGQMJsflIeF4f6ugnDua7psHP2ta6X6','ongchu1@example.com','Ong Chu 1',1,'2026-04-21 13:35:06','2026-04-21 13:35:06'),(2,'ongchu2','$2b$12$2krAsFFDflCu0pFc0sRm/eRGQMJsflIeF4f6ugnDua7psHP2ta6X6','ongchu2@example.com','Ong Chu 2',1,'2026-04-21 13:35:06','2026-04-21 13:35:06'),(3,'khachthue1','$2b$12$2krAsFFDflCu0pFc0sRm/eRGQMJsflIeF4f6ugnDua7psHP2ta6X6','kh1@example.com','Khach Thue 1',1,'2026-04-21 13:35:06','2026-04-21 13:35:06'),(4,'khachthue2','$2b$12$2krAsFFDflCu0pFc0sRm/eRGQMJsflIeF4f6ugnDua7psHP2ta6X6','kh2@example.com','Khach Thue 2',1,'2026-04-21 13:35:06','2026-04-21 13:35:06'),(5,'khachthue3','$2b$12$2krAsFFDflCu0pFc0sRm/eRGQMJsflIeF4f6ugnDua7psHP2ta6X6','kh3@example.com','Khach Thue 3',1,'2026-04-21 13:35:06','2026-04-21 13:35:06'),(6,'khachthue4','$2b$12$2krAsFFDflCu0pFc0sRm/eRGQMJsflIeF4f6ugnDua7psHP2ta6X6','kh4@example.com','Khach Thue 4',1,'2026-04-21 13:35:06','2026-04-21 13:35:06'),(7,'tuoanh','$2a$10$q3Qdmb3VtFIt18wIO3dd8Oj0AzYKP6ULgawm7lOsR2L3PEzekENM6','tuoanhvu98@gmail.com','Vu Tu Oanh',1,'2026-04-22 01:42:28','2026-04-22 01:42:28');
/*!40000 ALTER TABLE `tai_khoan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tai_khoan_vai_tro`
--

DROP TABLE IF EXISTS `tai_khoan_vai_tro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tai_khoan_vai_tro` (
  `tai_khoan_id` bigint NOT NULL,
  `vai_tro_id` bigint NOT NULL,
  PRIMARY KEY (`tai_khoan_id`,`vai_tro_id`),
  KEY `fk_tkv_vaitro` (`vai_tro_id`),
  CONSTRAINT `fk_tkv_taikhoan` FOREIGN KEY (`tai_khoan_id`) REFERENCES `tai_khoan` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_tkv_vaitro` FOREIGN KEY (`vai_tro_id`) REFERENCES `vai_tro` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tai_khoan_vai_tro`
--

LOCK TABLES `tai_khoan_vai_tro` WRITE;
/*!40000 ALTER TABLE `tai_khoan_vai_tro` DISABLE KEYS */;
INSERT INTO `tai_khoan_vai_tro` VALUES (1,1),(2,1),(3,2),(4,2),(5,2),(6,2),(7,2),(1,4),(2,4);
/*!40000 ALTER TABLE `tai_khoan_vai_tro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `toa_nha`
--

DROP TABLE IF EXISTS `toa_nha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `toa_nha` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ten` varchar(255) NOT NULL,
  `dia_chi` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `chu_tro_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_toa_nha_chu_tro` (`chu_tro_id`),
  CONSTRAINT `fk_toa_nha_chu_tro` FOREIGN KEY (`chu_tro_id`) REFERENCES `chu_tro` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `toa_nha`
--

LOCK TABLES `toa_nha` WRITE;
/*!40000 ALTER TABLE `toa_nha` DISABLE KEYS */;
INSERT INTO `toa_nha` VALUES (1,'Toa A','Dia chi Toa A','2026-04-21 20:35:06','2026-04-21 20:35:06',1),(2,'Toa B','Dia chi Toa B','2026-04-21 20:35:06','2026-04-21 20:35:06',2);
/*!40000 ALTER TABLE `toa_nha` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vai_tro`
--

DROP TABLE IF EXISTS `vai_tro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vai_tro` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vai_tro`
--

LOCK TABLES `vai_tro` WRITE;
/*!40000 ALTER TABLE `vai_tro` DISABLE KEYS */;
INSERT INTO `vai_tro` VALUES (1,'ROLE_ADMIN'),(3,'ROLE_BILLING_STAFF'),(4,'ROLE_LANDLORD'),(2,'ROLE_USER');
/*!40000 ALTER TABLE `vai_tro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'trohub_db'
--

--
-- Dumping routines for database 'trohub_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-22 18:50:36
