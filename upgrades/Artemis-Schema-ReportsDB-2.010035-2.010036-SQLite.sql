-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010035-SQLite.sql' to 'upgrades/Artemis-Schema-ReportsDB-2.010036-SQLite.sql':;

BEGIN;

ALTER TABLE reportsection ADD COLUMN ticket_url VARCHAR(255) DEFAULT '';

ALTER TABLE reportsection ADD COLUMN wiki_url VARCHAR(255) DEFAULT '';

ALTER TABLE reportsection ADD COLUMN planning_id VARCHAR(255) DEFAULT '';


COMMIT;

