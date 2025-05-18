-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 18, 2025 at 06:35 PM
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
-- Database: `post_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `ID` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `content` varchar(255) NOT NULL,
  `author` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`ID`, `title`, `content`, `author`) VALUES
(1, 'Why Rainy Days Are Good for the Soul', 'Rainy days slow us down and that’s a good thing. When the world outside is gray and quiet, we’re invited to pause and reflect. It’s a natural break from our go-go-go routines. Reading a book, journaling, or just listening to the rain can be surprisingly t', 'Liam Reed'),
(2, 'The Coffee Shop That Changed My Life', 'It wasn’t fancy. No marble countertops, no latte art, no Instagram-worthy corners. Just a small, worn-out place tucked between a laundromat and a bookstore, with the smell of burnt espresso and cinnamon rolls in the air.', 'Jared Thompson'),
(3, 'The Magic of Slow Mornings', 'In a world that celebrates hustle and urgency, we often forget the beauty of slow mornings. Taking time to sip your coffee, stretch, or simply breathe without a screen can transform your entire day. It’s not laziness — it’s intentional living. Slow mornin', 'Ava Lane');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `ID` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`ID`, `username`, `password`) VALUES
(2, 'James', '$2b$10$lKv2pRQiTVuuGUAByzoq3.frZUDS0PPAgU9NMW28P17'),
(3, 'Marty', '$2b$10$M9dSh5642qMxUzT1vKqkNuQPdgplFdH9puC8wluCmdO'),
(5, 'Marty11', '$2b$10$iEOuawjGtsqEFnLZu5u76e2hn.NZ5nABG2/o4XkK7Ko'),
(6, 'Edward', '$2b$10$pV0KUkogimOMpTH9xjhEv.jrPKjBssFjAXah5Jb0z1.AaTpsNcakW'),
(8, 'EdwardJohn', '$2b$10$TIUfT90UkZeFIZIshvjX6O/K/b9RKyyv6IBhQmz2UnGyPxOSoLd.e'),
(9, 'testuser', '$2b$10$sdyfI9iu3j3UAzvcPV6Xue2zbqR9xR7BZuP.vdk4iZ0pFtV4xiIZ6');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
