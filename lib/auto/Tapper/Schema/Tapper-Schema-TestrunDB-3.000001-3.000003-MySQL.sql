-- Convert schema 'lib/auto/Tapper/Schema/Tapper-Schema-TestrunDB-3.000001-MySQL.sql' to 'Tapper::Schema::TestrunDB v3.000003':;

BEGIN;

ALTER TABLE message CHANGE COLUMN testrun_id testrun_id integer(11),
                    CHANGE COLUMN message message text,
                    CHANGE COLUMN type type VARCHAR(255);

ALTER TABLE queue_host CHANGE COLUMN host_id host_id integer(11) NOT NULL;

ALTER TABLE state DROP FOREIGN KEY state_fk_testrun_id;

ALTER TABLE state CHANGE COLUMN state state text,
                  ADD CONSTRAINT state_fk_testrun_id FOREIGN KEY (testrun_id) REFERENCES testrun (id) ON DELETE CASCADE;

ALTER TABLE testrun_requested_host CHANGE COLUMN host_id host_id integer(11) NOT NULL;

ALTER TABLE testrun_scheduling CHANGE COLUMN status status VARCHAR(255) DEFAULT 'prepare';

ALTER TABLE user CHANGE COLUMN name name VARCHAR(255);


COMMIT;

