-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010017-SQLite.sql' to 'upgrades/Artemis-Schema-ReportsDB-2.010018-SQLite.sql':

BEGIN;





ALTER TABLE reportgrouparbitrary ADD COLUMN primaryreport INT(11);
ALTER TABLE reportgrouptestrun ADD COLUMN primaryreport INT(11);





COMMIT;
