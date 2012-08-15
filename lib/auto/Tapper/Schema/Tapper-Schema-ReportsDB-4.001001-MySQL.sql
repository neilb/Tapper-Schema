-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Wed Aug 15 14:58:42 2012
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `notification_event`;

--
-- Table: `notification_event`
--
CREATE TABLE `notification_event` (
  `id` integer(11) NOT NULL auto_increment,
  `message` VARCHAR(255),
  `type` VARCHAR(255),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `owner`;

--
-- Table: `owner`
--
CREATE TABLE `owner` (
  `id` integer(11) NOT NULL auto_increment,
  `name` VARCHAR(255) NOT NULL,
  `login` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255),
  PRIMARY KEY (`id`),
  UNIQUE `unique_login` (`login`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `reportgrouptestrunstats`;

--
-- Table: `reportgrouptestrunstats`
--
CREATE TABLE `reportgrouptestrunstats` (
  `testrun_id` integer(11) NOT NULL,
  `total` integer(10),
  `failed` integer(10),
  `passed` integer(10),
  `parse_errors` integer(10),
  `skipped` integer(10),
  `todo` integer(10),
  `todo_passed` integer(10),
  `wait` integer(10),
  `success_ratio` VARCHAR(20),
  PRIMARY KEY (`testrun_id`)
);

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
  `flags` VARCHAR(255),
  `changeset` VARCHAR(255),
  `kernel` VARCHAR(255),
  `description` VARCHAR(255),
  `language_description` text,
  `cpuinfo` text,
  `bios` text,
  `ram` VARCHAR(50),
  `uptime` VARCHAR(50),
  `lspci` text,
  `lsusb` text,
  `ticket_url` VARCHAR(255),
  `wiki_url` VARCHAR(255),
  `planning_id` VARCHAR(255),
  `moreinfo_url` VARCHAR(255),
  `tags` VARCHAR(255),
  `xen_changeset` VARCHAR(255),
  `xen_hvbits` VARCHAR(10),
  `xen_dom0_kernel` text,
  `xen_base_os_description` text,
  `xen_guest_description` text,
  `xen_guest_flags` VARCHAR(255),
  `xen_version` VARCHAR(255),
  `xen_guest_test` VARCHAR(255),
  `xen_guest_start` VARCHAR(255),
  `kvm_kernel` text,
  `kvm_base_os_description` text,
  `kvm_guest_description` text,
  `kvm_module_version` VARCHAR(255),
  `kvm_userspace_version` VARCHAR(255),
  `kvm_guest_flags` VARCHAR(255),
  `kvm_guest_test` VARCHAR(255),
  `kvm_guest_start` VARCHAR(255),
  `simnow_svn_version` VARCHAR(255),
  `simnow_version` VARCHAR(255),
  `simnow_svn_repository` VARCHAR(255),
  `simnow_device_interface_version` VARCHAR(255),
  `simnow_bsd_file` VARCHAR(255),
  `simnow_image_file` VARCHAR(255),
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `suite`;

--
-- Table: `suite`
--
CREATE TABLE `suite` (
  `id` integer(11) NOT NULL auto_increment,
  `name` VARCHAR(255) NOT NULL,
  `type` VARCHAR(50) NOT NULL,
  `description` text NOT NULL,
  INDEX `suite_idx_name` (`name`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `contact`;

--
-- Table: `contact`
--
CREATE TABLE `contact` (
  `id` integer(11) NOT NULL auto_increment,
  `owner_id` integer(11) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `protocol` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime,
  INDEX `contact_idx_owner_id` (`owner_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `contact_fk_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `owner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `notification`;

--
-- Table: `notification`
--
CREATE TABLE `notification` (
  `id` integer(11) NOT NULL auto_increment,
  `owner_id` integer(11),
  `persist` integer(1),
  `event` VARCHAR(255) NOT NULL,
  `filter` text NOT NULL,
  `comment` VARCHAR(255),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime,
  INDEX `notification_idx_owner_id` (`owner_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `notification_fk_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `owner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `report`;

--
-- Table: `report`
--
CREATE TABLE `report` (
  `id` integer(11) NOT NULL auto_increment,
  `suite_id` integer(11),
  `suite_version` VARCHAR(11),
  `reportername` VARCHAR(100) DEFAULT '',
  `peeraddr` VARCHAR(20) DEFAULT '',
  `peerport` VARCHAR(20) DEFAULT '',
  `peerhost` VARCHAR(255) DEFAULT '',
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
  INDEX `report_idx_suite_id` (`suite_id`),
  INDEX `report_idx_machine_name` (`machine_name`),
  PRIMARY KEY (`id`),
  CONSTRAINT `report_fk_suite_id` FOREIGN KEY (`suite_id`) REFERENCES `suite` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `reportfile`;

--
-- Table: `reportfile`
--
CREATE TABLE `reportfile` (
  `id` integer(11) NOT NULL auto_increment,
  `report_id` integer(11) NOT NULL,
  `filename` VARCHAR(255) DEFAULT '',
  `contenttype` VARCHAR(255) DEFAULT '',
  `filecontent` LONGBLOB NOT NULL DEFAULT '',
  `is_compressed` integer NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  INDEX `reportfile_idx_report_id` (`report_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `reportfile_fk_report_id` FOREIGN KEY (`report_id`) REFERENCES `report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `reportgrouparbitrary`;

--
-- Table: `reportgrouparbitrary`
--
CREATE TABLE `reportgrouparbitrary` (
  `arbitrary_id` VARCHAR(255) NOT NULL,
  `report_id` integer(11) NOT NULL,
  `primaryreport` integer(11),
  `owner` VARCHAR(255),
  INDEX `reportgrouparbitrary_idx_report_id` (`report_id`),
  PRIMARY KEY (`arbitrary_id`, `report_id`),
  CONSTRAINT `reportgrouparbitrary_fk_report_id` FOREIGN KEY (`report_id`) REFERENCES `report` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `reportgrouptestrun`;

--
-- Table: `reportgrouptestrun`
--
CREATE TABLE `reportgrouptestrun` (
  `testrun_id` integer(11) NOT NULL,
  `report_id` integer(11) NOT NULL,
  `primaryreport` integer(11),
  `owner` VARCHAR(255),
  INDEX `reportgrouptestrun_idx_report_id` (`report_id`),
  PRIMARY KEY (`testrun_id`, `report_id`),
  CONSTRAINT `reportgrouptestrun_fk_report_id` FOREIGN KEY (`report_id`) REFERENCES `report` (`id`) ON DELETE CASCADE
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
  INDEX `reporttopic_idx_report_id` (`report_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `reporttopic_fk_report_id` FOREIGN KEY (`report_id`) REFERENCES `report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `tap`;

--
-- Table: `tap`
--
CREATE TABLE `tap` (
  `id` integer(11) NOT NULL auto_increment,
  `report_id` integer(11) NOT NULL,
  `tap` LONGBLOB NOT NULL DEFAULT '',
  `tap_is_archive` integer(11),
  `tapdom` LONGBLOB DEFAULT '',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  INDEX `tap_idx_report_id` (`report_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `tap_fk_report_id` FOREIGN KEY (`report_id`) REFERENCES `report` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `reportcomment`;

--
-- Table: `reportcomment`
--
CREATE TABLE `reportcomment` (
  `id` integer(11) NOT NULL auto_increment,
  `report_id` integer(11) NOT NULL,
  `owner_id` integer(11),
  `succession` integer(10),
  `comment` text NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  INDEX `reportcomment_idx_owner_id` (`owner_id`),
  INDEX `reportcomment_idx_report_id` (`report_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `reportcomment_fk_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `owner` (`id`),
  CONSTRAINT `reportcomment_fk_report_id` FOREIGN KEY (`report_id`) REFERENCES `report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

SET foreign_key_checks=1;

