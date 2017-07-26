-- Simple script
-- to recreate DB schema

DROP TABLE IF EXISTS `user_interests`;
DROP TABLE IF EXISTS `stats`;

CREATE TABLE `user_interests` (
  `uuid` varchar(36) NOT NULL,
  `interests` text NOT NULL,
  `filter` varchar(20) NOT NULL,
  PRIMARY KEY(`uuid`)
);

CREATE TABLE `stats` (
  `query` text NOT NULL,
  `time` datetime NOT NULL
);
