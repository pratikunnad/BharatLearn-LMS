-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 02, 2026 at 03:28 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lms_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `badges`
--

CREATE TABLE `badges` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `icon` varchar(10) DEFAULT NULL,
  `rule_type` varchar(50) DEFAULT NULL,
  `rule_value` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `badges`
--

INSERT INTO `badges` (`id`, `name`, `description`, `icon`, `rule_type`, `rule_value`) VALUES
(1, 'First Course', 'Completed 1 course', '🎯', 'course_count', 1),
(2, 'Course Explorer', 'Completed 5 courses', '🚀', 'course_count', 5),
(3, 'Learning Champion', 'Completed 10 courses', '🏆', 'course_count', 10),
(4, 'Advanced Learner', 'Completed 1 advanced course', '💪', 'advanced_course', 1),
(5, '3 Day Streak', 'Maintain a 3-day learning streak', '🔥', 'streak_days', 3),
(6, '7 Day Streak', 'Maintain a 7-day learning streak', '⚡', 'streak_days', 7),
(7, '30 Day Streak', 'Maintain a 30-day learning streak', '🏆', 'streak_days', 30);

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `programming_language` varchar(100) DEFAULT NULL,
  `audio_language` varchar(50) DEFAULT NULL,
  `difficulty` varchar(50) DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL,
  `course_link` text NOT NULL,
  `image_url` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `title`, `description`, `programming_language`, `audio_language`, `difficulty`, `source`, `course_link`, `image_url`, `created_at`) VALUES
(1, 'Python Tutorial for Beginners - Full Course (with Notes & Practice Questions)', 'By Apna College', 'Python', 'Hindi', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=ERCMXc8x7mc', 'python_youtube_apnacollege.png', '2026-02-09 14:20:39'),
(2, 'C Language Tutorial for Beginners (with Notes & Practice Questions)', 'By Apna College', 'C', 'Hindi', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=irqbmMNs2Bo', 'c_youtube_apnacollege.png', '2026-02-09 07:27:23'),
(3, 'OOPs Tutorial in One Shot | Object Oriented Programming | in C++ Language | for Placement Interviews', 'By Apna College', 'C++', 'Hindi', 'Advanced', 'YouTube', 'https://www.youtube.com/watch?v=mlIUKyZIUUU&t=14s', 'cpp_advanced_youtube_apnacollege.png', '2026-02-09 10:24:31'),
(4, 'Java Tutorial for Beginners | Learn Java in 2 Hours', 'By Apna College', 'Java', 'Hindi', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=UmnCZ7-9yDY&pp=ygUWamF2YSBsYW5ndWFnZSBzaHJhZGRoYQ%3D%3D', 'java_youtube_apnacollege.png', '2026-02-09 10:24:39'),
(5, 'Python Tutorial For Beginners in Hindi | Complete Python Course', 'By CodeWithHarry', 'Python', 'Hindi', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=UrsmFxEIp5k', 'python_youtube_codewithharry.png', '2026-02-09 10:24:47'),
(6, 'C Language Tutorial for Beginners (With Notes + Surprise)', 'By CodeWithHarry', 'C', 'Hindi', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=aZb0iu4uGwA&pp=ygURQyBjb2RlIHdpdGggaGFycnk%3D', 'c_youtube_codewithharry.png', '2026-02-09 10:24:53'),
(7, 'C++ Tutorial For Beginners: Learn C Plus Plus In Hindi', 'By CodeWithHarry', 'C++', 'Hindi', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=yGB9jhsEsr8&t=806s&pp=ygUTQysrIGNvZGUgd2l0aCBoYXJyeQ%3D%3D', 'cpp_youtube_codewithharry.png', '2026-02-09 10:24:59'),
(8, 'C# Tutorial In Hindi', 'By CodeWithHarry', 'C#', 'Hindi', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=SuLiu5AK9Ps&pp=ygUSQyMgY29kZSB3aXRoIGhhcnJ5', 'csharp_youtube_codewithharry.png', '2026-02-09 10:25:29'),
(9, 'Python Full Course for Beginners', 'By Programming with Mosh', 'Python', 'English', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=K5KVEU3aaeQ&pp=ygUcUHl0aG9uIHByb2dyYW1taW5nIHdpdGggbW9zaA%3D%3D', 'python_youtube_mosh.png', '2026-02-09 10:26:15'),
(10, 'C++ Tutorial for Beginners - Learn C++ in 1 Hour', 'By Programming with Mosh', 'C++', 'Hindi', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=ZzaPdXTrSb8&t=1536s&pp=ygUZYysrIHByb2dyYW1taW5nIHdpdGggbW9zaA%3D%3D', 'cpp_youtube_mosh.png', '2025-12-28 10:26:41'),
(11, 'Java Full Course for Beginners', 'By Programming with Mosh', 'Java', 'Hindi', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=eIrMbAQSU34&t=2361s&pp=ygUaamF2YSBwcm9ncmFtbWluZyB3aXRoIG1vc2g%3D', 'java_youtube_mosh.png', '2025-12-28 10:34:08'),
(12, 'C# Tutorial For Beginners - Learn C# Basics in 1 Hour', 'By Programming with Mosh', 'C#', 'Hindi', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=gfkTfcpWqAY', 'csharp_youtube_mosh.png', '2025-12-30 15:07:26'),
(13, 'Python for Beginners | Full Course', 'By Telusko', 'Python', 'English', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=YfO28Ihehbk', 'python_youtube_telusko.png', '2026-01-05 06:53:29'),
(14, 'Java Tutorial for Beginners', 'By Telusko', 'Java', 'English', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=BGTx91t8q50&pp=ygUPamF2YSBieSB0ZWx1c2tv', 'java_youtube_telusko.png', '2026-02-08 08:29:38'),
(15, 'Go Tutorial Basic | Golang', 'By Telusko', 'GO', 'English', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=ty49_v1tV44&pp=ygUNR08gYnkgdGVsdXNrbw%3D%3D', 'go_youtube_telusko.png', '2026-02-08 08:40:25'),
(16, 'Python Certification for Beginner', 'This course teaches you the fundamentals of Python programming.', 'Python', 'English', 'Beginner', 'FreeCodeCamp', 'https://www.freecodecamp.org/learn/python-v9/', 'python_freecodecamp.png', '2026-02-10 09:06:18'),
(17, 'C Programming Tutorial for Beginners', 'By FreeCodeCamp', 'C', 'English', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=KJgsSFOSQv0&pp=ygUQZnJlZSBjb2RlIGNhbXAgYw%3D%3D', 'c_freecodecamp.png', '2026-02-10 09:16:40'),
(18, 'C++ Programming Course - Beginner to Advanced', 'By FreeCodeCamp', 'C++', 'English', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=8jLOx1hD3_o&pp=ygUSZnJlZSBjb2RlIGNhbXAgYysr', 'cpp_freecodecamp.png', '2026-02-10 09:18:47'),
(19, 'Learn C Programming and OOP with Dr. Chuck [feat. classic book by Kernighan and Ritchie]', 'By FreeCodeCamp', 'C', 'English', 'Advanced', 'YouTube', 'https://www.youtube.com/watch?v=PaPN51Mm5qQ&pp=ygUQZnJlZSBjb2RlIGNhbXAgYw%3D%3D', 'c_advanced_freecodecamp.png', '2026-02-10 09:21:08'),
(20, 'Object Oriented Programming (OOP) in C++ Course', 'By FreeCodeCamp', 'C++', 'English', 'Advanced', 'YouTube', 'https://www.youtube.com/watch?v=wN0x9eZLix4&pp=ygUSZnJlZSBjb2RlIGNhbXAgYysr', 'cpp_advance_freecodecamp.png', '2026-02-10 09:23:34'),
(21, 'Java Programming for Beginners – Full Course', 'By FreeCodeCamp', 'Java', 'English', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=A74TOX803D0&pp=ygUTZnJlZSBjb2RlIGNhbXAgamF2YQ%3D%3D', 'java_freecodecamp.png', '2026-02-10 09:26:40'),
(22, 'Functional Programming in Java - Full Course', 'By FreeCodeCamp', 'Java', 'English', 'Advanced', 'YouTube', 'https://www.youtube.com/watch?v=rPSL1alFIjI&pp=ygUTZnJlZSBjb2RlIGNhbXAgamF2YQ%3D%3D', 'java_advance_freecodecamp.png', '2026-02-10 09:28:23'),
(23, 'Free Foundational C# with Microsoft Certification', 'This course offers a comprehensive introduction to C# programming, covering its core concepts, syntax, and practical application in software development.', 'C#', 'English', 'Beginner', 'FreeCodeCamp', 'https://www.freecodecamp.org/learn/foundational-c-sharp-with-microsoft/', 'csharp_freecodecamp.png', '2026-02-10 09:31:20'),
(24, 'Go Programming – Golang Course with Bonus Projects', 'By FreeCodeCamp', 'GO', 'English', 'Beginner', 'YouTube', 'https://www.youtube.com/watch?v=un6ZyFkqFKo&pp=ygURZnJlZSBjb2RlIGNhbXAgZ2_SBwkJlAoBhyohjO8%3D', 'go_freecodecamp.png', '2026-02-10 09:33:15'),
(25, 'Python Tutorial', 'Learn Python', 'Python', 'English', 'Beginner', 'W3Schools', 'https://www.w3schools.com/python/', 'pyhton_w3schools.png', '2026-02-10 09:40:14'),
(26, 'C Tutorial', 'Learn C', 'C', 'English', 'Beginner', 'W3Schools', 'https://www.w3schools.com/c/', 'c_w3schools.png', '2026-02-10 09:45:30'),
(27, 'C++ Tutorial', 'Learn C++', 'C++', 'English', 'Beginner', 'W3Schools', 'https://www.w3schools.com/cpp/', 'cpp_w3schools.png', '2026-02-10 09:46:45'),
(28, 'Python Tutorial', 'By GeeksforGeeks', 'Python', 'English', 'Beginner', 'GeeksforGeeks', 'https://www.geeksforgeeks.org/python/python-programming-language-tutorial/', 'python_gfg.png.jpg', '2026-02-10 10:10:30'),
(29, 'C Programming Tutorial', 'By GeeksforGeeks', 'C', 'English', 'Beginner', 'GeeksforGeeks', 'https://www.geeksforgeeks.org/c/c-programming-language/', 'c_gfg.png', '2026-02-10 10:13:08'),
(30, 'C++ Programming Language', 'By GeeksforGeeks', 'C++', 'English', 'Beginner', 'GeeksforGeeks', 'https://www.geeksforgeeks.org/cpp/c-plus-plus/', 'cpp_gfg.png', '2026-02-10 10:15:35'),
(31, 'Java Tutorial', 'By GeeksforGeeks', 'Java', 'English', 'Beginner', 'GeeksforGeeks', 'https://www.geeksforgeeks.org/java/java/', 'java_gfg.png', '2026-02-10 10:17:11'),
(32, 'C# Tutorial', 'By GeeksforGeeks', 'C#', 'English', 'Beginner', 'GeeksforGeeks', 'https://www.geeksforgeeks.org/c-sharp/csharp-programming-language/', 'csharp_gfg.png', '2026-02-10 10:19:23'),
(33, 'Go Tutorial', 'By GeeksforGeeks', 'GO', 'English', 'Beginner', 'GeeksforGeeks', 'https://www.geeksforgeeks.org/go-language/go/', 'go_gfg.png', '2026-02-10 10:21:12');

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `enrolled_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `completed` tinyint(1) DEFAULT 0,
  `completed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`id`, `user_id`, `course_id`, `enrolled_at`, `completed`, `completed_at`) VALUES
(93, 2, 33, '2026-02-10 17:00:19', 1, '2026-02-13 20:31:25'),
(96, 12, 24, '2026-02-11 05:43:23', 0, NULL),
(97, 2, 32, '2026-02-13 15:01:21', 1, '2026-02-13 20:31:53'),
(98, 2, 29, '2026-02-13 15:01:46', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `learning_activity`
--

CREATE TABLE `learning_activity` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `activity_date` date NOT NULL,
  `is_frozen` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `learning_activity`
--

INSERT INTO `learning_activity` (`id`, `user_id`, `activity_date`, `is_frozen`) VALUES
(6, 2, '2026-02-09', 0),
(7, 1, '2026-02-10', 0),
(8, 2, '2026-02-10', 0),
(9, 2, '2026-02-11', 0),
(17, 12, '2026-02-11', 0),
(18, 2, '2026-02-13', 0);

-- --------------------------------------------------------

--
-- Table structure for table `learning_streaks`
--

CREATE TABLE `learning_streaks` (
  `user_id` int(11) NOT NULL,
  `current_streak` int(11) DEFAULT 0,
  `last_activity_date` date DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `learning_streaks`
--

INSERT INTO `learning_streaks` (`user_id`, `current_streak`, `last_activity_date`, `updated_at`) VALUES
(2, 1, '2026-02-13', '2026-02-13 14:58:34'),
(12, 1, '2026-02-11', '2026-02-11 05:46:09');

-- --------------------------------------------------------

--
-- Table structure for table `reference_books`
--

CREATE TABLE `reference_books` (
  `id` int(11) NOT NULL,
  `language` varchar(50) NOT NULL,
  `title` varchar(200) NOT NULL,
  `author` varchar(150) DEFAULT NULL,
  `pdf_path` varchar(255) DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reference_books`
--

INSERT INTO `reference_books` (`id`, `language`, `title`, `author`, `pdf_path`, `image_path`, `created_at`) VALUES
(2, 'Python', 'PYTHON PROGRAMMING', 'MALLA REDDY COLLEGE OF ENGINEERING & TECHNOLOGY', 'reference_books/pdfs/python_book.pdf', 'reference_books/images/python_book.png', '2026-02-06 13:28:13'),
(3, 'Java', 'INTRODUCTION TO JAVA PROGRAMMING', 'MALLA REDDY COLLEGE OF ENGINEERING & TECHNOLOGY', 'reference_books/pdfs/java_book.pdf', 'reference_books/images/java_book.png', '2026-02-06 13:48:34'),
(4, 'python', 'Introduction to Python Programming By Openstax', 'UDAYAN DAS, SAINT MARY\'S COLLEGE OF CALIFORNIA AUBREY LAWSON, WILEY CHRIS MAYFIELD, JAMES MADISON UNIVERSITY NARGES NOROUZI, UC BERKELEY', 'reference_books/pdfs/python_openstax.pdf', 'reference_books/images/pyhton_openstax.png', '2026-02-10 14:42:52'),
(5, 'cpp', 'Learn C++ Programming Language By tutorialspoint', 'tutorialspoint', 'reference_books/pdfs/cpp_iisc.pdf', 'reference_books/images/cpp_iisc.png', '2026-02-10 14:49:59'),
(6, 'cpp', 'Object Oriented Programming Using C++', 'Dr. Subasish Mohapatra', 'reference_books/pdfs/cpp_cetb.pdf', 'reference_books/images/cpp_cetb.png', '2026-02-10 14:52:47'),
(7, 'c', 'C PROGRAMMING', 'VARDHAMAN COLLEGE OF ENGINEERING', 'reference_books/pdfs/c_vces.pdf', 'reference_books/images/c_vces.png', '2026-02-10 14:55:32'),
(8, 'c', 'An Introduction to the C Programming Language and Software Design', 'Tim Bailey', 'reference_books/pdfs/c_tb.pdf', 'reference_books/images/c_tb.png', '2026-02-10 14:57:22'),
(9, 'java', 'JAVA The Complete Preference Ninth Edition', 'Herbert Schildt', 'reference_books/pdfs/java_hs.pdf', 'reference_books/images/java_hs.png', '2026-02-10 15:01:08'),
(10, 'csharp', 'C# Programming Yellow Book', 'Rob Miles', 'reference_books/pdfs/csharp_rm.pdf', 'reference_books/images/csharp_rm.png', '2026-02-10 15:04:30'),
(11, 'go', 'The Little GO Book', 'By Karl Seguin', 'reference_books/pdfs/go_book.pdf', 'reference_books/images/go_book.png', '2026-02-10 15:07:06');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` enum('admin','learner') DEFAULT 'learner',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `current_streak` int(11) DEFAULT 0,
  `last_activity_date` date DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT 'default.png',
  `dob` date DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `created_at`, `current_streak`, `last_activity_date`, `profile_image`, `dob`, `bio`, `phone`, `location`) VALUES
(1, 'Pratik', 'pratikunnad@gmail.com', 'scrypt:32768:8:1$Dg02lDM36xMpKhwv$f486a67beef5f65779db5b02a6ddbc87813340454f466c10a0eb4d3455da6279af5d871a24d8f97c8fe15e193dc115169cc4605c7a4c3de22f41e346f168e74d', 'admin', '2025-12-25 14:43:38', 0, NULL, 'default.png', NULL, NULL, NULL, NULL),
(2, 'Student', 'student@gmail.com', 'scrypt:32768:8:1$myEcCKQpXlSffrZt$19d4782815311b6929959567a7f8f5d216db0585c1803e6b6fc99209b980a492c4928cb20096b5658d2142bdc7fbb241b8826917e9ca075cf5d9aded46c15fbe', 'learner', '2025-12-25 14:43:38', 1, '2026-01-25', 'user_2.png', '2006-01-26', 'I am a Student just for testing the working of Website by Admins.', NULL, NULL),
(3, 'Akash Kusekar', 'akashkusekar2005@gmail.com', 'scrypt:32768:8:1$fHfpFECLhQONsOoe$a85f8c40fed6fd5d44f81492c774d1b46fef753c3bab13e71be92bbd851fad89a66ab1a8fea89f147d1c2e16aeedd6be0f8604dcff95cdc8b815b7c6a70bc2f5', 'admin', '2025-12-26 07:45:31', 0, NULL, 'default.png', NULL, NULL, NULL, NULL),
(12, 'Naval Nalla', 'navalnalla25@gmail.com', 'scrypt:32768:8:1$DNjy9JyPUPOoisE0$f5f9f945cf10c0820c0f893aca7e4f35a2181b6660698e95283732d5afe534b21df8ad4b9f39e0946d0a1b3be2344bdb12e1ff4ad07ac4da5316165b809f5ea3', 'learner', '2026-02-11 05:32:31', 0, NULL, 'user_12.png', '2003-02-10', 'Hello', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_badges`
--

CREATE TABLE `user_badges` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `badge_id` int(11) NOT NULL,
  `awarded_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_badges`
--

INSERT INTO `user_badges` (`id`, `user_id`, `badge_id`, `awarded_at`) VALUES
(4, 2, 1, '2026-02-09 18:16:08'),
(5, 2, 4, '2026-02-09 18:16:08'),
(6, 2, 2, '2026-02-09 18:17:32');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `badges`
--
ALTER TABLE `badges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_courses_filters` (`programming_language`,`difficulty`,`source`),
  ADD KEY `idx_courses_language` (`programming_language`),
  ADD KEY `idx_courses_difficulty` (`difficulty`),
  ADD KEY `idx_courses_source` (`source`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_enrollment` (`user_id`,`course_id`),
  ADD KEY `idx_enrollments_user` (`user_id`),
  ADD KEY `idx_enrollments_course` (`course_id`),
  ADD KEY `idx_enrollments_user_course` (`user_id`,`course_id`),
  ADD KEY `idx_enrollments_created_at` (`enrolled_at`),
  ADD KEY `idx_enrollments_course_user` (`course_id`,`user_id`);

--
-- Indexes for table `learning_activity`
--
ALTER TABLE `learning_activity`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_activity` (`user_id`,`activity_date`);

--
-- Indexes for table `learning_streaks`
--
ALTER TABLE `learning_streaks`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `reference_books`
--
ALTER TABLE `reference_books`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_badges`
--
ALTER TABLE `user_badges`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`badge_id`),
  ADD KEY `badge_id` (`badge_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `badges`
--
ALTER TABLE `badges`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT for table `learning_activity`
--
ALTER TABLE `learning_activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `reference_books`
--
ALTER TABLE `reference_books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `user_badges`
--
ALTER TABLE `user_badges`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_badges`
--
ALTER TABLE `user_badges`
  ADD CONSTRAINT `user_badges_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `user_badges_ibfk_2` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
