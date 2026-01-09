-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: lablink_eksperimen
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `tb_activity_log`
--

DROP TABLE IF EXISTS `tb_activity_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_activity_log` (
  `log_id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `action` varchar(20) NOT NULL,
  `target_type` varchar(50) NOT NULL,
  `target_id` varchar(50) DEFAULT NULL,
  `target_name` varchar(200) DEFAULT NULL,
  `description` text,
  `ip_address` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_action` (`action`),
  KEY `idx_target_type` (`target_type`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_activity_log`
--

LOCK TABLES `tb_activity_log` WRITE;
/*!40000 ALTER TABLE `tb_activity_log` DISABLE KEYS */;
INSERT INTO `tb_activity_log` VALUES ('LOG-09CA5E85','ADMIN01','Super Power','UPDATE','PROJECT','PKM-0002','Default pengabdian masyarakat Completed','Mengupdate proyek: Default pengabdian masyarakat Completed',NULL,'2026-01-09 06:45:56'),('LOG-0B1CBAFE','ADMIN01','Super Power','CREATE','PROJECT','PKM-0001','Default pengmas','Membuat proyek baru: Default pengmas',NULL,'2026-01-09 06:37:19'),('LOG-0B7E79CF','ADMIN01','Super Power','UPDATE','EVENT','EVT_0003','FEEDs','Mengupdate kegiatan: FEEDs',NULL,'2026-01-08 19:37:56'),('LOG-0BF0C61D','ADMIN01','Super Power','CREATE','PROJECT','RST-002','Tugas Sebesar Itu','Membuat proyek baru: Tugas Sebesar Itu',NULL,'2026-01-08 16:59:13'),('LOG-194840D2','ADMIN01','Super Power','DELETE','EVENT','EVT-01','Company Visit','Menghapus kegiatan: Company Visit',NULL,'2026-01-09 06:37:34'),('LOG-19A8E532','ADMIN01','Super Power','CREATE','PROJECT','RST-0002','demo','Membuat proyek baru: demo',NULL,'2026-01-08 19:34:55'),('LOG-1C180C29','ADMIN01','Super Power','UPDATE','PROJECT','HKI-0001','Default project','Mengupdate proyek: Default project',NULL,'2026-01-09 06:37:57'),('LOG-25ED1920','ADMIN01','Super Power','DELETE','EVENT','EVT-00009','Studi Banding','Menghapus kegiatan: Studi Banding',NULL,'2026-01-09 06:37:31'),('LOG-2700EF1D','ADMIN01','Super Power','CREATE','PROJECT','PKM-001','Default Pengmas','Membuat proyek baru: Default Pengmas',NULL,'2026-01-08 17:01:24'),('LOG-27638C88','ADMIN01','Super Power','DELETE','EVENT','EVT-0001','Digital Learning','Menghapus kegiatan: Digital Learning',NULL,'2026-01-09 09:01:27'),('LOG-2D157B3E','ADMIN01','Super Power','UPDATE','EVENT','EVT-0001','Digital Learning','Mengupdate kegiatan: Digital Learning',NULL,'2026-01-09 06:39:55'),('LOG-2DD98DAE','ADMIN01','Super Power','CREATE','PROJECT','HKI-0001','Default project','Membuat proyek baru: Default project',NULL,'2026-01-08 18:23:48'),('LOG-33317C7D','ADMIN01','Super Power','DELETE','EVENT','EVT-03','Apa saja','Menghapus kegiatan: Apa saja',NULL,'2026-01-09 06:37:30'),('LOG-354B1E40','ADMIN01','Super Power','DELETE','PROJECT','RST-0002','Default riset','Menghapus proyek: Default riset',NULL,'2026-01-09 06:33:58'),('LOG-35BFDC99','ADMIN01','Super Power','UPDATE','PROJECT','71587919','Tugas Besar Keamanan Data Enkripsi','Mengupdate proyek: Tugas Besar Keamanan Data Enkripsi',NULL,'2026-01-08 16:49:11'),('LOG-371554FD','103052300064','Rudi Firdaus','CREATE','PROJECT','RST-0003','default project cyber','Membuat proyek baru: default project cyber',NULL,'2026-01-09 08:57:16'),('LOG-3F7C8675','ADMIN01','Super Power','DELETE','PROJECT','4cb76dc7','apaya','Menghapus proyek: apaya',NULL,'2026-01-09 06:34:03'),('LOG-418054A7','ADMIN01','Super Power','CREATE','PROJECT','RST-0002','Default riset Image Segmentetation Completed','Membuat proyek baru: Default riset Image Segmentetation Completed',NULL,'2026-01-09 06:44:45'),('LOG-421054ED','ADMIN01','Super Power','CREATE','EVENT','EVT_0003','FEEDS','Membuat event baru: FEEDS',NULL,'2026-01-08 16:50:05'),('LOG-428B3C7B','ADMIN01','Super Power','UPDATE','EVENT','EVT_0003','FEED','Mengupdate kegiatan: FEED',NULL,'2026-01-08 18:10:20'),('LOG-429E4F02','ADMIN01','Super Power','DELETE','PROJECT','HKI-0001','Default project','Menghapus proyek: Default project',NULL,'2026-01-09 06:33:56'),('LOG-45AFCA92','ADMIN01','Super Power','CREATE','PROJECT','HKI-001','Default project','Membuat proyek baru: Default project',NULL,'2026-01-08 16:59:53'),('LOG-46044D5D','ADMIN01','Super Power','DELETE','PROJECT','RST-002','Tugas Sebesar Itu','Menghapus proyek: Tugas Sebesar Itu',NULL,'2026-01-08 18:23:18'),('LOG-486F6188','ADMIN01','Super Power','DELETE','EVENT','EVT_0003','FEEDs','Menghapus kegiatan: FEEDs',NULL,'2026-01-09 06:37:25'),('LOG-4CF62C73','ADMIN01','Super Power','CREATE','EVENT','EVT-0004','default event','Menambah kegiatan baru: default event',NULL,'2026-01-08 18:25:59'),('LOG-51CAEEED','ADMIN01','Super Power','UPDATE','PROJECT','HKI-0001','Default project','Mengupdate proyek: Default project',NULL,'2026-01-08 18:26:38'),('LOG-53652C73','ADMIN01','Super Power','CREATE','PROJECT','PKM-0002','Default pengabdian masyarakat Completed','Membuat proyek baru: Default pengabdian masyarakat Completed',NULL,'2026-01-09 06:45:47'),('LOG-5BA4BE6D','ADMIN01','Super Power','DELETE','EVENT','EVT-0004','default event','Menghapus kegiatan: default event',NULL,'2026-01-09 06:37:28'),('LOG-61B071F7','ADMIN01','Super Power','DELETE','PROJECT','71587919','Tugas Besar Keamanan Data Enkri','Menghapus proyek: Tugas Besar Keamanan Data Enkri',NULL,'2026-01-08 19:36:07'),('LOG-631C07F0','103052300064','Rudi Firdaus','UPDATE','PROJECT','RST-0003','default project cyber','Mengupdate proyek: default project cyber',NULL,'2026-01-09 08:57:47'),('LOG-63EEAA89','ADMIN01','Super Power','CREATE','PROJECT','RST-0002','demo','Membuat proyek baru: demo',NULL,'2026-01-08 19:36:20'),('LOG-667FC019','ADMIN01','Super Power','CREATE','PROJECT','RST-0002','demo','Membuat proyek baru: demo',NULL,'2026-01-08 19:34:05'),('LOG-680088A8','ADMIN01','Super Power','CREATE','PROJECT','RST-0002','asdsa','Membuat proyek baru: asdsa',NULL,'2026-01-08 19:33:17'),('LOG-6D4D64F6','ADMIN01','Super Power','DELETE','PROJECT','45d7317a','nyanyanya','Menghapus proyek: nyanyanya',NULL,'2026-01-09 06:33:54'),('LOG-6D67204E','ADMIN01','Super Power','DELETE','PROJECT','18d72ef9','saddsa','Menghapus proyek: saddsa',NULL,'2026-01-09 06:34:01'),('LOG-6E5BC60C','ADMIN01','Super Power','CREATE','EVENT','EVT-0004','hjb','Menambah kegiatan baru: hjb',NULL,'2026-01-08 19:37:42'),('LOG-72DF3B14','ADMIN01','Super Power','DELETE','MEMBER','103052300002','gatau','Menghapus anggota: gatau',NULL,'2026-01-09 06:40:15'),('LOG-764CFFF5','ADMIN01','Super Power','CREATE','EVENT','EVT-0002','Recruitment Lab','Menambah kegiatan baru: Recruitment Lab',NULL,'2026-01-09 09:01:00'),('LOG-7C9E7A0D','ADMIN01','Super Power','DELETE','PROJECT','RST-01','Image h','Menghapus proyek: Image h',NULL,'2026-01-09 06:33:52'),('LOG-803D6AA5','ADMIN01','Super Power','CREATE','PROJECT','HKI-0002','Default project game Completed','Membuat proyek baru: Default project game Completed',NULL,'2026-01-09 06:43:35'),('LOG-804480C7','ADMIN01','Super Power','UPDATE','MEMBER','103052300001','Muhammad Karov Ardava Barus','Mengupdate anggota: Muhammad Karov Ardava Barus',NULL,'2026-01-08 19:37:28'),('LOG-808B834B','ADMIN01','Super Power','CREATE','PROJECT','RST-0002','default untuk dihapus','Membuat proyek baru: default untuk dihapus',NULL,'2026-01-09 06:38:24'),('LOG-8208FD7C','ADMIN01','Super Power','CREATE','MEMBER','103052300001','Muhammad Karov Ardava Barus','Menambah anggota baru: Muhammad Karov Ardava Barus',NULL,'2026-01-08 18:11:20'),('LOG-84F24A81','ADMIN01','Super Power','UPDATE','PROJECT','HKI-0002','Default project game Completed','Mengupdate proyek: Default project game Completed',NULL,'2026-01-09 06:43:41'),('LOG-85A9D65B','ADMIN01','Super Power','UPDATE','PROJECT','RST-0002','Default riset','Mengupdate proyek: Default riset',NULL,'2026-01-08 18:27:36'),('LOG-93692537','ADMIN01','Super Power','DELETE','PROJECT','HKI-0001','Default project','Menghapus proyek: Default project',NULL,'2026-01-09 09:01:35'),('LOG-952D9819','ADMIN01','Super Power','DELETE','PROJECT','HKI-001','Default project','Menghapus proyek: Default project',NULL,'2026-01-08 18:23:14'),('LOG-96833343','ADMIN01','Super Power','CREATE','EVENT','EVT-0001','Digital Learning','Menambah kegiatan baru: Digital Learning',NULL,'2026-01-09 06:39:05'),('LOG-98FBF403','ADMIN01','Super Power','CREATE','MEMBER','103052300112','M. Agung Ramadhan','Menambah anggota baru: M. Agung Ramadhan',NULL,'2026-01-09 06:41:45'),('LOG-9DE7CC47','ADMIN01','Super Power','DELETE','EVENT','EVT-02','Digilearn','Menghapus kegiatan: Digilearn',NULL,'2026-01-09 06:37:32'),('LOG-A9A6A52D','ADMIN01','Super Power','DELETE','PROJECT','PRJ-02','Web 3','Menghapus proyek: Web 3',NULL,'2026-01-09 06:34:05'),('LOG-AB3822FE','ADMIN01','Super Power','UPDATE','PROJECT','RST-01','Image h','Mengupdate proyek: Image h',NULL,'2026-01-08 19:37:13'),('LOG-B22FC6C5','ADMIN01','Super Power','UPDATE','MEMBER','103052300112','M. Agung R','Mengupdate anggota: M. Agung R',NULL,'2026-01-09 06:41:55'),('LOG-B600CD09','ADMIN01','Super Power','DELETE','EVENT','EVT-0002','market day','Menghapus kegiatan: market day',NULL,'2026-01-09 06:37:27'),('LOG-BAA3D2BB','ADMIN01','Super Power','DELETE','PROJECT','PKM-001','Default Pengmas','Menghapus proyek: Default Pengmas',NULL,'2026-01-08 18:25:00'),('LOG-BEA77628','ADMIN01','Super Power','CREATE','EVENT','EVT-0004','sad','Menambah kegiatan baru: sad',NULL,'2026-01-09 06:28:42'),('LOG-C592C5AC','ADMIN01','Super Power','CREATE','PROJECT','HKI-0001','Default project','Membuat proyek baru: Default project',NULL,'2026-01-09 06:36:25'),('LOG-C9F47941','ADMIN01','Super Power','UPDATE','PROJECT','RST-0002','Default riset Image Segmentetation Completed','Mengupdate proyek: Default riset Image Segmentetation Completed',NULL,'2026-01-09 06:44:51'),('LOG-CACAA039','ADMIN01','Super Power','CREATE','PROJECT','RST-0002','Object Detection','Membuat proyek baru: Object Detection',NULL,'2026-01-08 19:32:19'),('LOG-CFBC0329','ADMIN01','Super Power','UPDATE','PROJECT','PKM-0001','Default pengmas','Mengupdate proyek: Default pengmas',NULL,'2026-01-08 18:28:11'),('LOG-D2BB7166','ADMIN01','Super Power','CREATE','PROJECT','RST-0002','Default riset','Membuat proyek baru: Default riset',NULL,'2026-01-08 18:24:46'),('LOG-D63E3D26','ADMIN01','Super Power','CREATE','EVENT','EVT-0004','ojk ','Menambah kegiatan baru: ojk ',NULL,'2026-01-08 19:38:27'),('LOG-DCC96A8F','ADMIN01','Super Power','DELETE','PROJECT','RST-0002','default untuk dihapus','Menghapus proyek: default untuk dihapus',NULL,'2026-01-09 06:38:35'),('LOG-E4D7C332','ADMIN01','Super Power','CREATE','PROJECT','PKM-0001','Default pengmas','Membuat proyek baru: Default pengmas',NULL,'2026-01-08 18:25:24'),('LOG-E5000B89','ADMIN01','Super Power','DELETE','PROJECT','PKM-0001','Default pengmas','Menghapus proyek: Default pengmas',NULL,'2026-01-09 06:33:57'),('LOG-ECE8FCE7','ADMIN01','Super Power','DELETE','PROJECT','cca4c94d','ZTNA','Menghapus proyek: ZTNA',NULL,'2026-01-09 06:34:00'),('LOG-F3F4AAF5','ADMIN01','Super Power','UPDATE','PROJECT','71587919','Tugas Besar Keamanan Data Enkri','Mengupdate proyek: Tugas Besar Keamanan Data Enkri',NULL,'2026-01-08 18:10:08'),('LOG-F655E3C3','ADMIN01','Super Power','CREATE','MEMBER','103052300002','gatau','Menambah anggota baru: gatau',NULL,'2026-01-09 06:28:27'),('LOG-FB8670FC','ADMIN01','Super Power','CREATE','PROJECT','RST-0001','Default riset','Membuat proyek baru: Default riset',NULL,'2026-01-09 06:36:58');
/*!40000 ALTER TABLE `tb_activity_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_archive`
--

DROP TABLE IF EXISTS `tb_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_archive` (
  `archive_id` varchar(20) NOT NULL,
  `project_id` varchar(20) DEFAULT NULL,
  `title` varchar(150) DEFAULT NULL,
  `archive_type` varchar(20) DEFAULT NULL,
  `publish_location` varchar(100) DEFAULT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `publish_date` date DEFAULT NULL,
  PRIMARY KEY (`archive_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `tb_archive_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `tb_project` (`project_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_archive`
--

LOCK TABLES `tb_archive` WRITE;
/*!40000 ALTER TABLE `tb_archive` DISABLE KEYS */;
INSERT INTO `tb_archive` VALUES ('ABD-0001','PKM-0002','Default pengabdian masyarakat Completed','Pengabdian','Telkom University','78912','2026-03-07'),('ARH-0001','HKI-0002','Default project game Completed','HKI','DJKI','IDM123789','2026-02-04'),('PUB-0001','RST-0002','Default riset Image Segmentetation Completed','Publikasi','IEEE Access','78912323789','2026-02-04'),('PUB-0002','RST-0003','default project cyber','Publikasi','IEEE Access','912387','2026-02-27');
/*!40000 ALTER TABLE `tb_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_event`
--

DROP TABLE IF EXISTS `tb_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_event` (
  `event_id` varchar(20) NOT NULL,
  `event_name` varchar(100) NOT NULL,
  `event_date` date NOT NULL,
  `pic_id` varchar(20) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`event_id`),
  KEY `pic_id` (`pic_id`),
  CONSTRAINT `tb_event_ibfk_1` FOREIGN KEY (`pic_id`) REFERENCES `tb_member` (`member_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_event`
--

LOCK TABLES `tb_event` WRITE;
/*!40000 ALTER TABLE `tb_event` DISABLE KEYS */;
INSERT INTO `tb_event` VALUES ('EVT-0002','Recruitment Lab','2026-03-19','103052300064','Recruitment');
/*!40000 ALTER TABLE `tb_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_event_committee`
--

DROP TABLE IF EXISTS `tb_event_committee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_event_committee` (
  `event_id` varchar(20) NOT NULL,
  `member_id` varchar(20) NOT NULL,
  `committee_role` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`event_id`,`member_id`),
  KEY `member_id` (`member_id`),
  CONSTRAINT `tb_event_committee_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `tb_event` (`event_id`) ON DELETE CASCADE,
  CONSTRAINT `tb_event_committee_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `tb_member` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_event_committee`
--

LOCK TABLES `tb_event_committee` WRITE;
/*!40000 ALTER TABLE `tb_event_committee` DISABLE KEYS */;
INSERT INTO `tb_event_committee` VALUES ('EVT-0002','103052300029','Acara'),('EVT-0002','103052300098','Humas');
/*!40000 ALTER TABLE `tb_event_committee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_member`
--

DROP TABLE IF EXISTS `tb_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_member` (
  `member_id` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `division` varchar(50) DEFAULT NULL,
  `department` varchar(50) DEFAULT NULL,
  `role_title` varchar(50) DEFAULT NULL,
  `member_type` varchar(20) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `access_role` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_member`
--

LOCK TABLES `tb_member` WRITE;
/*!40000 ALTER TABLE `tb_member` DISABLE KEYS */;
INSERT INTO `tb_member` VALUES ('103052300001','Muhammad Karov Ardava Barus','Big Data','Eksternal','','RA','103052300001','103052300001','RESEARCH_ASSISTANT'),('103052300029','Muh. Fathier Al-Farezi','Big Data','Eksternal','Staff','RA','103052300029','103052300029','RESEARCH_ASSISTANT'),('103052300064','Rudi Firdaus','Big Data','Internal','Head of Division','RA','103052300064','admin123','HEAD_OF_INTERNAL'),('103052300098','Muh. Shafwan Faiq Rizal','Cyber Security','Eksternal','Research Assistant','RA','103052300098','103052300098','RESEARCH_ASSISTANT'),('103052300112','M. Agung R','Game Tech','Eksternal','','RA','103052300112','103052300112','RESEARCH_ASSISTANT'),('ADMIN01','Super Power','Game Tech','Eksternal','Head of Laboratory','RA','admin','kdm','HEAD_OF_LAB');
/*!40000 ALTER TABLE `tb_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_project`
--

DROP TABLE IF EXISTS `tb_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_project` (
  `project_id` varchar(20) NOT NULL,
  `project_name` varchar(100) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `activity_type` varchar(20) DEFAULT NULL,
  `division` varchar(50) DEFAULT NULL,
  `leader_id` varchar(20) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`project_id`),
  KEY `leader_id` (`leader_id`),
  CONSTRAINT `tb_project_ibfk_1` FOREIGN KEY (`leader_id`) REFERENCES `tb_member` (`member_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_project`
--

LOCK TABLES `tb_project` WRITE;
/*!40000 ALTER TABLE `tb_project` DISABLE KEYS */;
INSERT INTO `tb_project` VALUES ('HKI-0002','Default project game Completed','Completed','HKI','Game Tech','103052300112','2026-01-09','2026-01-30','Riset Selesai'),('PKM-0001','Default pengmas','Ongoing','Pengabdian','GIS','ADMIN01','2026-01-09','2026-01-25',''),('PKM-0002','Default pengabdian masyarakat Completed','Completed','Pengabdian','Cyber Security','103052300098','2026-01-09','2026-02-07',''),('RST-0001','Default riset','Ongoing','Riset','Big Data','103052300001','2026-01-09','2026-01-20',''),('RST-0002','Default riset Image Segmentetation Completed','Completed','Riset','Big Data','103052300064','2026-01-09','2026-01-20',''),('RST-0003','default project cyber','Completed','Riset','Cyber Security','103052300064','2026-01-23','2026-02-20','deskripsi');
/*!40000 ALTER TABLE `tb_project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_project_member`
--

DROP TABLE IF EXISTS `tb_project_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_project_member` (
  `project_id` varchar(20) NOT NULL,
  `member_id` varchar(20) NOT NULL,
  PRIMARY KEY (`project_id`,`member_id`),
  KEY `member_id` (`member_id`),
  CONSTRAINT `tb_project_member_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `tb_project` (`project_id`) ON DELETE CASCADE,
  CONSTRAINT `tb_project_member_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `tb_member` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_project_member`
--

LOCK TABLES `tb_project_member` WRITE;
/*!40000 ALTER TABLE `tb_project_member` DISABLE KEYS */;
INSERT INTO `tb_project_member` VALUES ('PKM-0002','103052300029'),('RST-0001','103052300029'),('RST-0002','103052300029'),('RST-0001','103052300064'),('HKI-0002','103052300098'),('PKM-0001','103052300098'),('RST-0003','103052300098'),('PKM-0002','103052300112'),('RST-0003','103052300112'),('HKI-0002','ADMIN01'),('RST-0003','ADMIN01');
/*!40000 ALTER TABLE `tb_project_member` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-09 17:11:35
