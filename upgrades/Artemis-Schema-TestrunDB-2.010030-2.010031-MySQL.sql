-- Convert schema 'upgrades/Artemis-Schema-TestrunDB-2.010030-MySQL.sql' to 'Artemis::Schema::TestrunDB v2.010031':;

BEGIN;

ALTER TABLE testrun CHANGE COLUMN topic_name topic_name VARCHAR(255) NOT NULL DEFAULT '';

ALTER TABLE testrun_scheduling CHANGE COLUMN status status VARCHAR(255) DEFAULT 'prepare';


COMMIT;

