-- Convert schema './Artemis-Schema-ReportsDB-2.010013-MySQL.sql' to 'Artemis::Schema::ReportsDB v2.010015':

BEGIN;

ALTER TABLE reportfile CHANGE COLUMN filecontent filecontent LONGBLOB NOT NULL DEFAULT '';
ALTER TABLE reportsection CHANGE COLUMN language_description language_description text;

COMMIT;
