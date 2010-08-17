-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Wed Jun  2 15:13:30 2010
-- 


BEGIN TRANSACTION;

--
-- Table: reportgroup
--
DROP TABLE reportgroup;

CREATE TABLE reportgroup (
  id INTEGER PRIMARY KEY NOT NULL,
  group_id INT(11) NOT NULL,
  report_id INT(11) NOT NULL
);

--
-- Table: reportgrouparbitrary
--
DROP TABLE reportgrouparbitrary;

CREATE TABLE reportgrouparbitrary (
  arbitrary_id VARCHAR(255) NOT NULL,
  report_id INT(11) NOT NULL,
  primaryreport INT(11),
  PRIMARY KEY (arbitrary_id, report_id)
);

--
-- Table: reportgrouptestrun
--
DROP TABLE reportgrouptestrun;

CREATE TABLE reportgrouptestrun (
  testrun_id INT(11) NOT NULL,
  report_id INT(11) NOT NULL,
  primaryreport INT(11),
  PRIMARY KEY (testrun_id, report_id)
);

--
-- Table: reportgrouptestrunstats
--
DROP TABLE reportgrouptestrunstats;

CREATE TABLE reportgrouptestrunstats (
  testrun_id INTEGER PRIMARY KEY NOT NULL,
  total INT(10),
  failed INT(10),
  passed INT(10),
  parse_errors INT(10),
  skipped INT(10),
  todo INT(10),
  todo_passed INT(10),
  wait INT(10),
  success_ratio VARCHAR(20)
);

--
-- Table: reportsection
--
DROP TABLE reportsection;

CREATE TABLE reportsection (
  id INTEGER PRIMARY KEY NOT NULL,
  report_id INT(11) NOT NULL,
  succession INT(10),
  name VARCHAR(255),
  osname VARCHAR(255),
  uname VARCHAR(255),
  flags VARCHAR(255),
  changeset VARCHAR(255),
  kernel VARCHAR(255),
  description VARCHAR(255),
  language_description TEXT,
  cpuinfo TEXT,
  bios TEXT,
  ram VARCHAR(50),
  uptime VARCHAR(50),
  lspci TEXT,
  lsusb TEXT,
  xen_changeset VARCHAR(255),
  xen_hvbits VARCHAR(10),
  xen_dom0_kernel TEXT,
  xen_base_os_description TEXT,
  xen_guest_description TEXT,
  xen_guest_flags VARCHAR(255),
  xen_version VARCHAR(255),
  xen_guest_test VARCHAR(255),
  xen_guest_start VARCHAR(255),
  kvm_kernel TEXT,
  kvm_base_os_description TEXT,
  kvm_guest_description TEXT,
  kvm_module_version VARCHAR(255),
  kvm_userspace_version VARCHAR(255),
  kvm_guest_flags VARCHAR(255),
  kvm_guest_test VARCHAR(255),
  kvm_guest_start VARCHAR(255),
  simnow_svn_version VARCHAR(255),
  simnow_version VARCHAR(255),
  simnow_svn_repository VARCHAR(255),
  simnow_device_interface_version VARCHAR(255),
  simnow_bsd_file VARCHAR(255),
  simnow_image_file VARCHAR(255)
);

--
-- Table: suite
--
DROP TABLE suite;

CREATE TABLE suite (
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL,
  description TEXT NOT NULL
);

CREATE INDEX suite_idx_name ON suite (name);

--
-- Table: user
--
DROP TABLE user;

CREATE TABLE user (
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL,
  login VARCHAR(255) NOT NULL,
  password VARCHAR(255)
);

--
-- Table: report
--
DROP TABLE report;

CREATE TABLE report (
  id INTEGER PRIMARY KEY NOT NULL,
  suite_id INT(11),
  suite_version VARCHAR(11),
  reportername VARCHAR(100) DEFAULT '',
  peeraddr VARCHAR(20) DEFAULT '',
  peerport VARCHAR(20) DEFAULT '',
  peerhost VARCHAR(255) DEFAULT '',
  tap LONGBLOB NOT NULL DEFAULT '',
  tapdom LONGBLOB DEFAULT '',
  successgrade VARCHAR(10) DEFAULT '',
  reviewed_successgrade VARCHAR(10) DEFAULT '',
  total INT(10),
  failed INT(10),
  parse_errors INT(10),
  passed INT(10),
  skipped INT(10),
  todo INT(10),
  todo_passed INT(10),
  wait INT(10),
  exit INT(10),
  success_ratio VARCHAR(20),
  starttime_test_program DATETIME,
  endtime_test_program DATETIME,
  hardwaredb_systems_id INT(11),
  machine_name VARCHAR(50) DEFAULT '',
  machine_description TEXT DEFAULT '',
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);

CREATE INDEX report_idx_id ON report (id);

CREATE INDEX report_idx_suite_id ON report (suite_id);

CREATE INDEX report_idx_machine_name ON report (machine_name);

--
-- Table: reportfile
--
DROP TABLE reportfile;

CREATE TABLE reportfile (
  id INTEGER PRIMARY KEY NOT NULL,
  report_id INT(11) NOT NULL,
  filename VARCHAR(255) DEFAULT '',
  contenttype VARCHAR(255) DEFAULT '',
  filecontent LONGBLOB NOT NULL DEFAULT '',
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);

CREATE INDEX reportfile_idx_report_id ON reportfile (report_id);

--
-- Table: reporttopic
--
DROP TABLE reporttopic;

CREATE TABLE reporttopic (
  id INTEGER PRIMARY KEY NOT NULL,
  report_id INT(11) NOT NULL,
  name VARCHAR(50) DEFAULT '',
  details TEXT NOT NULL DEFAULT ''
);

CREATE INDEX reporttopic_idx_report_id ON reporttopic (report_id);

--
-- Table: reportcomment
--
DROP TABLE reportcomment;

CREATE TABLE reportcomment (
  id INTEGER PRIMARY KEY NOT NULL,
  report_id INT(11) NOT NULL,
  user_id INT(11),
  succession INT(10),
  comment TEXT NOT NULL DEFAULT '',
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);

CREATE INDEX reportcomment_idx_report_id ON reportcomment (report_id);

CREATE INDEX reportcomment_idx_user_id ON reportcomment (user_id);

--
-- View: view_testrun_overview_reports
--
DROP VIEW IF EXISTS view_testrun_overview_reports;
CREATE VIEW view_testrun_overview_reports AS
    select rgts.testrun_id    as rgt_testrun_id,        max(rgt.report_id) as primary_report_id,        rgts.success_ratio as rgts_success_ratio from reportgrouptestrun rgt, reportgrouptestrunstats rgts where rgt.testrun_id=rgts.testrun_id group by rgt.testrun_id;

--
-- View: view_testrun_overview
--
DROP VIEW IF EXISTS view_testrun_overview;
CREATE VIEW view_testrun_overview AS
    select vtor.*,        r.machine_name,        r.created_at,        r.suite_id,        s.name as suite_name from view_testrun_overview_reports vtor,      report r,      suite s where vtor.primary_report_id=r.id and       r.suite_id=s.id;

COMMIT;
