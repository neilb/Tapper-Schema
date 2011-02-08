-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Mon Jun 30 11:06:46 2008
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `report`;
--
-- Table: `report`
--
CREATE TABLE `report` (
  `id` integer(11) NOT NULL auto_increment,
  `suite_id` integer(11),
  `suite_version` VARCHAR(11),
  `reportername` VARCHAR(100) DEFAULT '',
  `tap` text NOT NULL DEFAULT '',
  `successgrade` VARCHAR(10) DEFAULT '',
  `reviewed_successgrade` VARCHAR(10) DEFAULT '',
  `total` integer(10),
  `failed` integer(10),
  `parse_errors` integer(10),
  `passed` integer(10),
  `skipped` integer(10),
  `todo` integer(10),
  `todo_passed` integer(10),
  `wait` integer(10),
  `exit` integer(10),
  `success_ratio` VARCHAR(20),
  `starttime_test_program` datetime,
  `endtime_test_program` datetime,
  `machine_name` VARCHAR(50) DEFAULT '',
  `machine_description` text DEFAULT '',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  INDEX (`suite_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_suite_id` FOREIGN KEY (`suite_id`) REFERENCES `suite` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `reportcomment`;
--
-- Table: `reportcomment`
--
CREATE TABLE `reportcomment` (
  `id` integer(11) NOT NULL auto_increment,
  `report_id` integer(11) NOT NULL,
  `user_id` integer(11),
  `comment` text NOT NULL DEFAULT '',
  `created_at` datetime,
  `updated_at` datetime,
  INDEX (`report_id`),
  INDEX (`user_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_report_id` FOREIGN KEY (`report_id`) REFERENCES `report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `reportfile`;
--
-- Table: `reportfile`
--
CREATE TABLE `reportfile` (
  `id` integer(11) NOT NULL auto_increment,
  `report_id` integer(11) NOT NULL,
  `filename` VARCHAR(255) DEFAULT '',
  `filecontent` text NOT NULL DEFAULT '',
  INDEX (`report_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_report_id_1` FOREIGN KEY (`report_id`) REFERENCES `report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `reportgroup`;
--
-- Table: `reportgroup`
--
CREATE TABLE `reportgroup` (
  `id` integer(11) NOT NULL auto_increment,
  `group_id` integer(11) NOT NULL,
  `report_id` integer(11) NOT NULL,
  INDEX (`report_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_report_id_2` FOREIGN KEY (`report_id`) REFERENCES `report` (`id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `reportsection`;
--
-- Table: `reportsection`
--
CREATE TABLE `reportsection` (
  `id` integer(11) NOT NULL auto_increment,
  `report_id` integer(11) NOT NULL,
  `succession` integer(10),
  `name` VARCHAR(255),
  `osname` VARCHAR(255),
  `uname` VARCHAR(255),
  `language_description` text,
  `cpuinfo` text,
  `ram` VARCHAR(50),
  `lspci` text,
  `lsusb` text,
  `flags` VARCHAR(255),
  `xen_changeset` VARCHAR(255),
  `xen_hvbits` VARCHAR(10),
  `xen_dom0_kernel` text,
  `xen_base_os_description` text,
  `xen_guest_description` text,
  `test_was_on_guest` integer(1),
  `test_was_on_hv` integer(1),
  `xen_guest_flags` VARCHAR(255),
  INDEX (`report_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_report_id_3` FOREIGN KEY (`report_id`) REFERENCES `report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `reporttopic`;
--
-- Table: `reporttopic`
--
CREATE TABLE `reporttopic` (
  `id` integer(11) NOT NULL auto_increment,
  `report_id` integer(11) NOT NULL,
  `name` VARCHAR(50) DEFAULT '',
  `details` text NOT NULL DEFAULT '',
  INDEX (`report_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_report_id_4` FOREIGN KEY (`report_id`) REFERENCES `report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `suite`;
--
-- Table: `suite`
--
CREATE TABLE `suite` (
  `id` integer(11) NOT NULL auto_increment,
  `name` VARCHAR(255) NOT NULL,
  `type` VARCHAR(50) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `user`;
--
-- Table: `user`
--
CREATE TABLE `user` (
  `id` integer(11) NOT NULL auto_increment,
  `name` VARCHAR(255) NOT NULL,
  `login` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

SET foreign_key_checks=1;

