-- Simple script
-- to recreate DB schema

DROP TABLE IF EXISTS `user_interests`;

CREATE TABLE `user_interests` (
  `uuid` varchar(36) NOT NULL,
  `interests` text NOT NULL,
  PRIMARY KEY(`uuid`)
);
