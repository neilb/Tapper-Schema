-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010023-SQLite.sql' to 'upgrades/Artemis-Schema-ReportsDB-2.010025-SQLite.sql':;

BEGIN;

ALTER TABLE report ADD COLUMN hardwaredb_systems_id INT(11);

CREATE INDEX report_idx_id02 ON report (id);

CREATE INDEX report_idx_machine_name02 ON report (machine_name);

DROP INDEX reportgroup_idx_report_id_repo;

DROP INDEX reportgrouparbitrary_idx_report_id_reportgrouparbi;

DROP INDEX reportgrouptestrun_idx_report_id_reportgrouptest;

DROP INDEX reportsection_idx_report_id_re;


COMMIT;

