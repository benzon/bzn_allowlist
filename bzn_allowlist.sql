CREATE TABLE IF NOT EXISTS `bzn_allowlist` (
  `identifier` varchar(75) DEFAULT NULL,
  `priority` int(11) DEFAULT 0,
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
