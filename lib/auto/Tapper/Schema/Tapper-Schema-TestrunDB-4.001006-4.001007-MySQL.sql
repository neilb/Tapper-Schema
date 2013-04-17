-- Convert schema '/home/local/ANT/caldrin/perl5/perls/perl-5.16.2/lib/site_perl/5.16.2/auto/Tapper/Schema/Tapper-Schema-TestrunDB-4.001006-MySQL.sql' to 'Tapper::Schema::TestrunDB v4.001007':;

BEGIN;

ALTER TABLE message CHANGE COLUMN message message text NULL,
                    CHANGE COLUMN type type VARCHAR(255) NULL;

ALTER TABLE scenario ADD COLUMN options text NULL,
                     ADD COLUMN name VARCHAR NULL;

ALTER TABLE state CHANGE COLUMN state state text NULL;

ALTER TABLE testrun_scheduling CHANGE COLUMN status status VARCHAR(255) NULL DEFAULT 'prepare';


COMMIT;

