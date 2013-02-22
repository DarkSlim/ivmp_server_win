-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Время создания: Янв 03 2013 г., 08:06
-- Версия сервера: 5.5.25
-- Версия PHP: 5.3.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `ivmp_server`
--

-- --------------------------------------------------------

--
-- Структура таблицы `businesses`
--

CREATE TABLE IF NOT EXISTS `businesses` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `type` int(2) NOT NULL,
  `name` varchar(64) COLLATE cp1251_bin NOT NULL,
  `owner` varchar(24) COLLATE cp1251_bin NOT NULL,
  `price` int(15) NOT NULL,
  `blip_id` int(5) NOT NULL DEFAULT '-1',
  `blip_name` varchar(64) COLLATE cp1251_bin NOT NULL,
  `blip_pos_x` double NOT NULL,
  `blip_pos_y` double NOT NULL,
  `blip_pos_z` double NOT NULL,
  `cp_type` int(1) NOT NULL DEFAULT '-1',
  `cp_pos_x` double NOT NULL,
  `cp_pos_y` double NOT NULL,
  `cp_pos_z` double NOT NULL,
  `cp_nextpos_x` double NOT NULL,
  `cp_nextpos_y` double NOT NULL,
  `cp_nextpos_z` double NOT NULL,
  `cp_radius` double NOT NULL,
  `actor_name` varchar(24) COLLATE cp1251_bin NOT NULL,
  `actor_skin` int(3) NOT NULL DEFAULT '-1',
  `actor_pos_x` double NOT NULL,
  `actor_pos_y` double NOT NULL,
  `actor_pos_z` double NOT NULL,
  `actor_pos_fa` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `businesses`
--

INSERT INTO `businesses` (`id`, `type`, `name`, `owner`, `price`, `blip_id`, `blip_name`, `blip_pos_x`, `blip_pos_y`, `blip_pos_z`, `cp_type`, `cp_pos_x`, `cp_pos_y`, `cp_pos_z`, `cp_nextpos_x`, `cp_nextpos_y`, `cp_nextpos_z`, `cp_radius`, `actor_name`, `actor_skin`, `actor_pos_x`, `actor_pos_y`, `actor_pos_z`, `actor_pos_fa`) VALUES
(1, 2, 'Burger Shot', 'Jonathan_Rosewood', 450000, 21, 'Burger Shot', -429, 1195.5, 13, 3, -429, 1195.5, 11.5, -429, 1195.5, 100, 0.2, 'Jessica_McKelly', 111, -427, 1195.5, 13, 90);

-- --------------------------------------------------------

--
-- Структура таблицы `characters`
--

CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `nickname` varchar(24) COLLATE cp1251_bin NOT NULL,
  `password` varchar(64) COLLATE cp1251_bin NOT NULL,
  `email` varchar(64) COLLATE cp1251_bin NOT NULL,
  `reg_ip` varchar(16) COLLATE cp1251_bin NOT NULL,
  `last_ip` varchar(16) COLLATE cp1251_bin NOT NULL,
  `admin_level` int(5) NOT NULL,
  `faction` int(2) NOT NULL,
  `played_minutes` int(2) NOT NULL,
  `played_hours` int(5) NOT NULL,
  `phone` int(10) NOT NULL,
  `sex` int(1) NOT NULL,
  `age` int(3) NOT NULL,
  `skin` int(3) NOT NULL,
  `cash` int(15) NOT NULL,
  `bank` int(15) NOT NULL,
  `pos_x` double NOT NULL,
  `pos_y` double NOT NULL,
  `pos_z` double NOT NULL,
  `pos_fa` double NOT NULL,
  `pos_dimension` int(10) NOT NULL,
  `vehicle_key` int(10) NOT NULL,
  `business_key` int(10) NOT NULL,
  `gun` int(5) NOT NULL,
  `ammo` int(5) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `characters`
--

INSERT INTO `characters` (`id`, `nickname`, `password`, `email`, `reg_ip`, `last_ip`, `admin_level`, `faction`, `played_minutes`, `played_hours`, `phone`, `sex`, `age`, `skin`, `cash`, `bank`, `pos_x`, `pos_y`, `pos_z`, `pos_fa`, `pos_dimension`, `vehicle_key`, `business_key`, `gun`, `ammo`) VALUES
(1, 'Jonathan_Rosewood', 'password', 'no email', '127.0.0.1', '127.0.0.1', 10, 0, 22, 2, 100001, 0, 0, 53, 0, 0, -426.341, 1194.51, 13.0525, 3.0669, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `objects`
--

CREATE TABLE IF NOT EXISTS `objects` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `model_hash` varchar(32) COLLATE cp1251_bin NOT NULL,
  `dimension` int(10) NOT NULL,
  `pos_x` double NOT NULL,
  `pos_y` double NOT NULL,
  `pos_z` double NOT NULL,
  `pos_rx` double NOT NULL,
  `pos_ry` double NOT NULL,
  `pos_rz` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin AUTO_INCREMENT=7 ;

--
-- Дамп данных таблицы `objects`
--

INSERT INTO `objects` (`id`, `model_hash`, `dimension`, `pos_x`, `pos_y`, `pos_z`, `pos_rx`, `pos_ry`, `pos_rz`) VALUES
(1, '0xC626EA54', 0, 1, 2, 3, 4, 5, 6),
(2, '0xEC0430C4', 0, 1, 2, 3, 4, 5, 6),
(3, '0x9CE86163', 0, 1, 2, 3, 4, 5, 6),
(4, '0xC626EA54', 0, 1, 2, 3, 4, 5, 6),
(5, '0x9CE86163', 0, 1, 2, 3, 4, 5, 6),
(6, '0xEC0430C4', 0, 1, 2, 3, 4, 5, 6);

-- --------------------------------------------------------

--
-- Структура таблицы `phone_sms`
--

CREATE TABLE IF NOT EXISTS `phone_sms` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NOT NULL,
  `sender` int(10) NOT NULL,
  `taker` int(10) NOT NULL,
  `text` varchar(128) COLLATE cp1251_bin NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin AUTO_INCREMENT=3 ;

--
-- Дамп данных таблицы `phone_sms`
--

INSERT INTO `phone_sms` (`id`, `status`, `sender`, `taker`, `text`, `date`) VALUES
(1, 1, 100000, 100001, 'Hi, Jonathan ^^', '2013-01-02 06:53:57'),
(2, 0, 100001, 100000, 'Hello, what about sex after 9 O''Clock? :)', '2013-01-02 08:53:57');

-- --------------------------------------------------------

--
-- Структура таблицы `vehicles`
--

CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `owner` varchar(24) COLLATE cp1251_bin NOT NULL,
  `price` int(15) NOT NULL,
  `model` int(3) NOT NULL,
  `pos_x` double NOT NULL,
  `pos_y` double NOT NULL,
  `pos_z` double NOT NULL,
  `pos_rx` double NOT NULL,
  `pos_ry` double NOT NULL,
  `pos_rz` double NOT NULL,
  `pos_dimension` int(10) NOT NULL,
  `color1` int(3) NOT NULL,
  `color2` int(3) NOT NULL,
  `color3` int(3) NOT NULL,
  `color4` int(3) NOT NULL,
  `fuel` int(5) NOT NULL,
  `dirt` double NOT NULL,
  `health` int(4) NOT NULL,
  `lock` int(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin AUTO_INCREMENT=5 ;

--
-- Дамп данных таблицы `vehicles`
--

INSERT INTO `vehicles` (`id`, `owner`, `price`, `model`, `pos_x`, `pos_y`, `pos_z`, `pos_rx`, `pos_ry`, `pos_rz`, `pos_dimension`, `color1`, `color2`, `color3`, `color4`, `fuel`, `dirt`, `health`, `lock`) VALUES
(1, 'Jonathan_Rosewood', 120000, 90, -439.316, 1178.38, 12.1805, 359.429, 3.39368, 89.5367, 0, 0, 0, 99, 0, 100, 0, 1000, 0),
(2, 'Jonathan_Rosewood', 120000, 90, -428.628, 1156.93, 12.4035, 1.84296, 3.53821, 268.623, 0, 0, 0, 99, 0, 92, 9.09171e-39, 1000, 0),
(3, 'Jonathan_Rosewood', 120000, 110, -428.286, 1179.32, 12.4839, 359.273, 359.875, 90.9553, 0, 0, 0, 99, 0, 9962, 9.09171e-39, 1000, 0),
(4, 'Jonathan_Rosewood', 120000, 109, -424.664, 1179.36, 12.6582, 356.908, 359.968, 88.7393, 0, 0, 0, 99, 0, 9747, 9.09171e-39, 1000, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
