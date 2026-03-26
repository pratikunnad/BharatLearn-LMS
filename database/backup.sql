-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: turntable.proxy.rlwy.net    Database: railway
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


--
-- GTID state at the beginning of the backup 
--

--
-- Table structure for table `badges`
--

DROP TABLE IF EXISTS `badges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `badges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `icon` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rule_type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rule_value` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `badges`
--

LOCK TABLES `badges` WRITE;
/*!40000 ALTER TABLE `badges` DISABLE KEYS */;
INSERT INTO `badges` VALUES (1,'First Course','Completed 1 course','🎯','course_count',1),(2,'Course Explorer','Completed 5 courses','🚀','course_count',5),(3,'Learning Champion','Completed 10 courses','🏆','course_count',10),(4,'Advanced Learner','Completed 1 advanced course','💪','advanced_course',1),(5,'3 Day Streak','Maintain a 3-day learning streak','🔥','streak_days',3),(6,'7 Day Streak','Maintain a 7-day learning streak','⚡','streak_days',7),(7,'30 Day Streak','Maintain a 30-day learning streak','🏆','streak_days',30);
/*!40000 ALTER TABLE `badges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci NOT NULL,
  `programming_language` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `audio_language` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `difficulty` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `source` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `course_link` text COLLATE utf8mb4_general_ci NOT NULL,
  `image_url` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_courses_filters` (`programming_language`,`difficulty`,`source`),
  KEY `idx_courses_language` (`programming_language`),
  KEY `idx_courses_difficulty` (`difficulty`),
  KEY `idx_courses_source` (`source`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'Python Tutorial for Beginners - Full Course (with Notes & Practice Questions)','By Apna College','Python','Hindi','Beginner','YouTube','https://www.youtube.com/watch?v=ERCMXc8x7mc','python_youtube_apnacollege.png','2026-02-09 14:20:39'),(2,'C Language Tutorial for Beginners (with Notes & Practice Questions)','By Apna College','C','Hindi','Beginner','YouTube','https://www.youtube.com/watch?v=irqbmMNs2Bo','c_youtube_apnacollege.png','2026-02-09 07:27:23'),(3,'OOPs Tutorial in One Shot | Object Oriented Programming | in C++ Language | for Placement Interviews','By Apna College','C++','Hindi','Advanced','YouTube','https://www.youtube.com/watch?v=mlIUKyZIUUU&t=14s','cpp_advanced_youtube_apnacollege.png','2026-02-09 10:24:31'),(4,'Java Tutorial for Beginners | Learn Java in 2 Hours','By Apna College','Java','Hindi','Beginner','YouTube','https://www.youtube.com/watch?v=UmnCZ7-9yDY&pp=ygUWamF2YSBsYW5ndWFnZSBzaHJhZGRoYQ%3D%3D','java_youtube_apnacollege.png','2026-02-09 10:24:39'),(5,'Python Tutorial For Beginners in Hindi | Complete Python Course','By CodeWithHarry','Python','Hindi','Beginner','YouTube','https://www.youtube.com/watch?v=UrsmFxEIp5k','python_youtube_codewithharry.png','2026-02-09 10:24:47'),(6,'C Language Tutorial for Beginners (With Notes + Surprise)','By CodeWithHarry','C','Hindi','Beginner','YouTube','https://www.youtube.com/watch?v=aZb0iu4uGwA&pp=ygURQyBjb2RlIHdpdGggaGFycnk%3D','c_youtube_codewithharry.png','2026-02-09 10:24:53'),(7,'C++ Tutorial For Beginners: Learn C Plus Plus In Hindi','By CodeWithHarry','C++','Hindi','Beginner','YouTube','https://www.youtube.com/watch?v=yGB9jhsEsr8&t=806s&pp=ygUTQysrIGNvZGUgd2l0aCBoYXJyeQ%3D%3D','cpp_youtube_codewithharry.png','2026-02-09 10:24:59'),(8,'C# Tutorial In Hindi','By CodeWithHarry','C#','Hindi','Beginner','YouTube','https://www.youtube.com/watch?v=SuLiu5AK9Ps&pp=ygUSQyMgY29kZSB3aXRoIGhhcnJ5','csharp_youtube_codewithharry.png','2026-02-09 10:25:29'),(9,'Python Full Course for Beginners','By Programming with Mosh','Python','English','Beginner','YouTube','https://www.youtube.com/watch?v=K5KVEU3aaeQ&pp=ygUcUHl0aG9uIHByb2dyYW1taW5nIHdpdGggbW9zaA%3D%3D','python_youtube_mosh.png','2026-02-09 10:26:15'),(10,'C++ Tutorial for Beginners - Learn C++ in 1 Hour','By Programming with Mosh','C++','Hindi','Beginner','YouTube','https://www.youtube.com/watch?v=ZzaPdXTrSb8&t=1536s&pp=ygUZYysrIHByb2dyYW1taW5nIHdpdGggbW9zaA%3D%3D','cpp_youtube_mosh.png','2025-12-28 10:26:41'),(11,'Java Full Course for Beginners','By Programming with Mosh','Java','Hindi','Beginner','YouTube','https://www.youtube.com/watch?v=eIrMbAQSU34&t=2361s&pp=ygUaamF2YSBwcm9ncmFtbWluZyB3aXRoIG1vc2g%3D','java_youtube_mosh.png','2025-12-28 10:34:08'),(12,'C# Tutorial For Beginners - Learn C# Basics in 1 Hour','By Programming with Mosh','C#','Hindi','Beginner','YouTube','https://www.youtube.com/watch?v=gfkTfcpWqAY','csharp_youtube_mosh.png','2025-12-30 15:07:26'),(13,'Python for Beginners | Full Course','By Telusko','Python','English','Beginner','YouTube','https://www.youtube.com/watch?v=YfO28Ihehbk','python_youtube_telusko.png','2026-01-05 06:53:29'),(14,'Java Tutorial for Beginners','By Telusko','Java','English','Beginner','YouTube','https://www.youtube.com/watch?v=BGTx91t8q50&pp=ygUPamF2YSBieSB0ZWx1c2tv','java_youtube_telusko.png','2026-02-08 08:29:38'),(15,'Go Tutorial Basic | Golang','By Telusko','GO','English','Beginner','YouTube','https://www.youtube.com/watch?v=ty49_v1tV44&pp=ygUNR08gYnkgdGVsdXNrbw%3D%3D','go_youtube_telusko.png','2026-02-08 08:40:25'),(16,'Python Certification for Beginner','This course teaches you the fundamentals of Python programming.','Python','English','Beginner','FreeCodeCamp','https://www.freecodecamp.org/learn/python-v9/','python_freecodecamp.png','2026-02-10 09:06:18'),(17,'C Programming Tutorial for Beginners','By FreeCodeCamp','C','English','Beginner','YouTube','https://www.youtube.com/watch?v=KJgsSFOSQv0&pp=ygUQZnJlZSBjb2RlIGNhbXAgYw%3D%3D','c_freecodecamp.png','2026-02-10 09:16:40'),(18,'C++ Programming Course - Beginner to Advanced','By FreeCodeCamp','C++','English','Beginner','YouTube','https://www.youtube.com/watch?v=8jLOx1hD3_o&pp=ygUSZnJlZSBjb2RlIGNhbXAgYysr','cpp_freecodecamp.png','2026-02-10 09:18:47'),(19,'Learn C Programming and OOP with Dr. Chuck [feat. classic book by Kernighan and Ritchie]','By FreeCodeCamp','C','English','Advanced','YouTube','https://www.youtube.com/watch?v=PaPN51Mm5qQ&pp=ygUQZnJlZSBjb2RlIGNhbXAgYw%3D%3D','c_advanced_freecodecamp.png','2026-02-10 09:21:08'),(20,'Object Oriented Programming (OOP) in C++ Course','By FreeCodeCamp','C++','English','Advanced','YouTube','https://www.youtube.com/watch?v=wN0x9eZLix4&pp=ygUSZnJlZSBjb2RlIGNhbXAgYysr','cpp_advance_freecodecamp.png','2026-02-10 09:23:34'),(21,'Java Programming for Beginners – Full Course','By FreeCodeCamp','Java','English','Beginner','YouTube','https://www.youtube.com/watch?v=A74TOX803D0&pp=ygUTZnJlZSBjb2RlIGNhbXAgamF2YQ%3D%3D','java_freecodecamp.png','2026-02-10 09:26:40'),(22,'Functional Programming in Java - Full Course','By FreeCodeCamp','Java','English','Advanced','YouTube','https://www.youtube.com/watch?v=rPSL1alFIjI&pp=ygUTZnJlZSBjb2RlIGNhbXAgamF2YQ%3D%3D','java_advance_freecodecamp.png','2026-02-10 09:28:23'),(23,'Free Foundational C# with Microsoft Certification','This course offers a comprehensive introduction to C# programming, covering its core concepts, syntax, and practical application in software development.','C#','English','Beginner','FreeCodeCamp','https://www.freecodecamp.org/learn/foundational-c-sharp-with-microsoft/','csharp_freecodecamp.png','2026-02-10 09:31:20'),(24,'Go Programming – Golang Course with Bonus Projects','By FreeCodeCamp','GO','English','Beginner','YouTube','https://www.youtube.com/watch?v=un6ZyFkqFKo&pp=ygURZnJlZSBjb2RlIGNhbXAgZ2_SBwkJlAoBhyohjO8%3D','go_freecodecamp.png','2026-02-10 09:33:15'),(25,'Python Tutorial','Learn Python','Python','English','Beginner','W3Schools','https://www.w3schools.com/python/','pyhton_w3schools.png','2026-02-10 09:40:14'),(26,'C Tutorial','Learn C','C','English','Beginner','W3Schools','https://www.w3schools.com/c/','c_w3schools.png','2026-02-10 09:45:30'),(27,'C++ Tutorial','Learn C++','C++','English','Beginner','W3Schools','https://www.w3schools.com/cpp/','cpp_w3schools.png','2026-02-10 09:46:45'),(28,'Python Tutorial','By GeeksforGeeks','Python','English','Beginner','GeeksforGeeks','https://www.geeksforgeeks.org/python/python-programming-language-tutorial/','python_gfg.png.jpg','2026-02-10 10:10:30'),(29,'C Programming Tutorial','By GeeksforGeeks','C','English','Beginner','GeeksforGeeks','https://www.geeksforgeeks.org/c/c-programming-language/','c_gfg.png','2026-02-10 10:13:08'),(30,'C++ Programming Language','By GeeksforGeeks','C++','English','Beginner','GeeksforGeeks','https://www.geeksforgeeks.org/cpp/c-plus-plus/','cpp_gfg.png','2026-02-10 10:15:35'),(31,'Java Tutorial','By GeeksforGeeks','Java','English','Beginner','GeeksforGeeks','https://www.geeksforgeeks.org/java/java/','java_gfg.png','2026-02-10 10:17:11'),(32,'C# Tutorial','By GeeksforGeeks','C#','English','Beginner','GeeksforGeeks','https://www.geeksforgeeks.org/c-sharp/csharp-programming-language/','csharp_gfg.png','2026-02-10 10:19:23'),(33,'Go Tutorial','By GeeksforGeeks','GO','English','Beginner','GeeksforGeeks','https://www.geeksforgeeks.org/go-language/go/','go_gfg.png','2026-02-10 10:21:12');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `course_id` int NOT NULL,
  `enrolled_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed` tinyint(1) DEFAULT '0',
  `completed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_enrollment` (`user_id`,`course_id`),
  KEY `idx_enrollments_user` (`user_id`),
  KEY `idx_enrollments_course` (`course_id`),
  KEY `idx_enrollments_user_course` (`user_id`,`course_id`),
  KEY `idx_enrollments_created_at` (`enrolled_at`),
  KEY `idx_enrollments_course_user` (`course_id`,`user_id`),
  CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollments`
--

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;
INSERT INTO `enrollments` VALUES (93,2,33,'2026-02-10 17:00:19',1,'2026-02-13 20:31:25'),(97,2,32,'2026-02-13 15:01:21',1,'2026-02-13 20:31:53'),(98,2,29,'2026-02-13 15:01:46',0,NULL),(99,13,11,'2026-03-10 06:38:19',0,NULL),(100,2,4,'2026-03-11 07:04:49',0,NULL),(101,19,33,'2026-03-17 10:48:53',1,'2026-03-17 10:49:16');
/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `learning_activity`
--

DROP TABLE IF EXISTS `learning_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `learning_activity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `activity_date` date NOT NULL,
  `is_frozen` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_activity` (`user_id`,`activity_date`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `learning_activity`
--

LOCK TABLES `learning_activity` WRITE;
/*!40000 ALTER TABLE `learning_activity` DISABLE KEYS */;
INSERT INTO `learning_activity` VALUES (6,2,'2026-02-09',0),(7,1,'2026-02-10',0),(8,2,'2026-02-10',0),(9,2,'2026-02-11',0),(17,12,'2026-02-11',0),(18,2,'2026-02-13',0),(19,13,'2026-03-10',0),(20,2,'2026-03-11',0),(21,2,'2026-03-16',0),(22,19,'2026-03-17',0);
/*!40000 ALTER TABLE `learning_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `learning_streaks`
--

DROP TABLE IF EXISTS `learning_streaks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `learning_streaks` (
  `user_id` int NOT NULL,
  `current_streak` int DEFAULT '0',
  `last_activity_date` date DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `learning_streaks`
--

LOCK TABLES `learning_streaks` WRITE;
/*!40000 ALTER TABLE `learning_streaks` DISABLE KEYS */;
INSERT INTO `learning_streaks` VALUES (2,1,'2026-03-16','2026-03-16 13:50:37'),(12,1,'2026-02-11','2026-02-11 05:46:09'),(13,1,'2026-03-10','2026-03-10 06:38:28'),(19,1,'2026-03-17','2026-03-17 10:48:58');
/*!40000 ALTER TABLE `learning_streaks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reference_books`
--

DROP TABLE IF EXISTS `reference_books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reference_books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `language` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `author` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pdf_path` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image_path` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reference_books`
--

LOCK TABLES `reference_books` WRITE;
/*!40000 ALTER TABLE `reference_books` DISABLE KEYS */;
INSERT INTO `reference_books` VALUES (2,'Python','PYTHON PROGRAMMING','MALLA REDDY COLLEGE OF ENGINEERING & TECHNOLOGY','reference_books/pdfs/python_book.pdf','reference_books/images/python_book.png','2026-02-06 13:28:13'),(3,'Java','INTRODUCTION TO JAVA PROGRAMMING','MALLA REDDY COLLEGE OF ENGINEERING & TECHNOLOGY','reference_books/pdfs/java_book.pdf','reference_books/images/java_book.png','2026-02-06 13:48:34'),(4,'python','Introduction to Python Programming By Openstax','UDAYAN DAS, SAINT MARY\'S COLLEGE OF CALIFORNIA AUBREY LAWSON, WILEY CHRIS MAYFIELD, JAMES MADISON UNIVERSITY NARGES NOROUZI, UC BERKELEY','reference_books/pdfs/python_openstax.pdf','reference_books/images/pyhton_openstax.png','2026-02-10 14:42:52'),(5,'cpp','Learn C++ Programming Language By tutorialspoint','tutorialspoint','reference_books/pdfs/cpp_iisc.pdf','reference_books/images/cpp_iisc.png','2026-02-10 14:49:59'),(6,'cpp','Object Oriented Programming Using C++','Dr. Subasish Mohapatra','reference_books/pdfs/cpp_cetb.pdf','reference_books/images/cpp_cetb.png','2026-02-10 14:52:47'),(7,'c','C PROGRAMMING','VARDHAMAN COLLEGE OF ENGINEERING','reference_books/pdfs/c_vces.pdf','reference_books/images/c_vces.png','2026-02-10 14:55:32'),(8,'c','An Introduction to the C Programming Language and Software Design','Tim Bailey','reference_books/pdfs/c_tb.pdf','reference_books/images/c_tb.png','2026-02-10 14:57:22'),(9,'java','JAVA The Complete Preference Ninth Edition','Herbert Schildt','reference_books/pdfs/java_hs.pdf','reference_books/images/java_hs.png','2026-02-10 15:01:08'),(10,'csharp','C# Programming Yellow Book','Rob Miles','reference_books/pdfs/csharp_rm.pdf','reference_books/images/csharp_rm.png','2026-02-10 15:04:30'),(11,'go','The Little GO Book','By Karl Seguin','reference_books/pdfs/go_book.pdf','reference_books/images/go_book.png','2026-02-10 15:07:06');
/*!40000 ALTER TABLE `reference_books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_badges`
--

DROP TABLE IF EXISTS `user_badges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_badges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `badge_id` int NOT NULL,
  `awarded_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`badge_id`),
  KEY `badge_id` (`badge_id`),
  CONSTRAINT `user_badges_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_badges_ibfk_2` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_badges`
--

LOCK TABLES `user_badges` WRITE;
/*!40000 ALTER TABLE `user_badges` DISABLE KEYS */;
INSERT INTO `user_badges` VALUES (4,2,1,'2026-02-09 18:16:08'),(5,2,4,'2026-02-09 18:16:08'),(6,2,2,'2026-02-09 18:17:32'),(7,19,1,'2026-03-17 10:49:16');
/*!40000 ALTER TABLE `user_badges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` enum('admin','learner') COLLATE utf8mb4_general_ci DEFAULT 'learner',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `current_streak` int DEFAULT '0',
  `last_activity_date` date DEFAULT NULL,
  `profile_image` varchar(255) COLLATE utf8mb4_general_ci DEFAULT 'default.png',
  `dob` date DEFAULT NULL,
  `bio` text COLLATE utf8mb4_general_ci,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `location` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Pratik','pratikunnad@gmail.com','scrypt:32768:8:1$Dg02lDM36xMpKhwv$f486a67beef5f65779db5b02a6ddbc87813340454f466c10a0eb4d3455da6279af5d871a24d8f97c8fe15e193dc115169cc4605c7a4c3de22f41e346f168e74d','admin','2025-12-25 14:43:38',0,NULL,'default.png',NULL,NULL,NULL,NULL),(2,'Student','student@gmail.com','scrypt:32768:8:1$myEcCKQpXlSffrZt$19d4782815311b6929959567a7f8f5d216db0585c1803e6b6fc99209b980a492c4928cb20096b5658d2142bdc7fbb241b8826917e9ca075cf5d9aded46c15fbe','learner','2025-12-25 14:43:38',1,'2026-01-25','user_2.jpg','2006-01-26','I am a Student just for testing the working of Website by Admins.',NULL,NULL),(3,'Akash Kusekar','akashkusekar2005@gmail.com','scrypt:32768:8:1$fHfpFECLhQONsOoe$a85f8c40fed6fd5d44f81492c774d1b46fef753c3bab13e71be92bbd851fad89a66ab1a8fea89f147d1c2e16aeedd6be0f8604dcff95cdc8b815b7c6a70bc2f5','admin','2025-12-26 07:45:31',0,NULL,'default.png',NULL,NULL,NULL,NULL),(13,'Mahesh Patil','mp1762377@gmail.com','scrypt:32768:8:1$PYutVWdmQ4ZwDteg$09bda6c48d08e8d8629c8c1e74a1144a4eb034574a7d24fdced3235796175ada291e88f6a148fd5201245d8d69ce7032cf8f61f4b06912fc0e4b03443c7f6bc5','learner','2026-03-10 06:35:23',0,NULL,'default.png',NULL,NULL,NULL,NULL),(14,'Atharva kinagi','kinagivirbhadra7327@gmail.com','scrypt:32768:8:1$AvUxkXw54vxMKfds$52b2270ce8fa3ea944032e2c234dc2ff4b11052be46df30b7a9679a85034f2735ebeaf4afde7c36f2568fa7c286cef49f9932efe5eaf9fdbdfdb5de33b34167c','learner','2026-03-10 06:41:37',0,NULL,'default.png',NULL,NULL,NULL,NULL),(15,'Ritesh kambale','rak10102004@gmail.com','scrypt:32768:8:1$tobQ0WrPe2pajEJ9$d59e1e6fdb874650dcdff4370c2c5171f77c2c9bc9b93a6b0248174ec6052f9f7857f2cc0125e2b59daf5b1c235e44e962074bee0a8aa716d2729fd70c441fef','learner','2026-03-11 07:00:29',0,NULL,'default.png',NULL,NULL,NULL,NULL),(16,'Kiran Mani','cmnk2815@gmail.com','scrypt:32768:8:1$vsvYpb6dXUOmphSe$89fbc318d215b9ce9a04fff0ec2ee3a166749472d42eacc6f5610688d1cb5162b4aa2471166dd4ae8c4dacd8a08e40ff9555dcafc99a813b258f67da68fcb863','learner','2026-03-11 09:25:23',0,NULL,'default.png',NULL,NULL,NULL,NULL),(18,'Harsh Mane','harshmane0348@gmail.com','scrypt:32768:8:1$XAOxinqePOSjgfkd$5d7a586d63718b8209333fb14f29743d93ab0ef5f3855c61a6f6cf5f1df14bbdefed08f57e74fce89c7c48d2a1b2fbb9c63225ffd69c2867640e899aea0cc919','learner','2026-03-12 09:37:40',0,NULL,'default.png',NULL,NULL,NULL,NULL),(19,'raj','raj@gmail.com','scrypt:32768:8:1$IHNuobfXNBTPXt7d$33d0179996ef576e79d6a3f06934ee5ba0afd56787e363b8d417c4eff1ac658f9a9626061ec0e3b82c07e2aae984456d0795c6d05ea60d2a569ae553b1010f45','learner','2026-03-17 10:48:26',0,NULL,'default.png',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-26 19:24:40
