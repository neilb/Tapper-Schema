-- Convert schema 'upgrades/Artemis-Schema-TestrunDB-2.010026-MySQL.sql' to 'Artemis::Schema::TestrunDB v2.010027':;

BEGIN;

ALTER TABLE testrun_scheduling CHANGE COLUMN status status VARCHAR(255) DEFAULT 'prepare';


COMMIT;

