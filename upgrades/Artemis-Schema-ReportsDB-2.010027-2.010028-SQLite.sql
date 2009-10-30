-- Convert schema 'upgrades/Artemis-Schema-ReportsDB-2.010027-SQLite.sql' to 'upgrades/Artemis-Schema-ReportsDB-2.010028-SQLite.sql':;

BEGIN;

CREATE TABLE reportgrouptestrunstats (
  testrun_id INTEGER PRIMARY KEY NOT NULL,
  total INT(10),
  failed INT(10),
  passed INT(10),
  parse_errors INT(10),
  skipped INT(10),
  todo INT(10),
  todo_passed INT(10),
  wait INT(10)
);


COMMIT;

