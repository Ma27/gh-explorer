DROP TABLE IF EXISTS `user_interests`;

CREATE TABLE IF NOT EXISTS `user_interests` (
  `uuid` varchar(36) NOT NULL,
  `interests` text NOT NULL, -- TODO maybe a more suitable data type
  PRIMARY KEY(`uuid`)
) ENGINE=InnoDB;

