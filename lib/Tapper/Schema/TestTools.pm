package Tapper::Schema::TestTools;

# inspired by Test::Fixture::DBIC::Schema

use strict;
use warnings;

BEGIN {
        use Class::C3;
        use MRO::Compat;
        $DBD::SQLite::sqlite_version; # fix "used only once" warning
}

use Tapper::Config;
use Tapper::Schema::TestrunDB;

my $testrundb_schema;

=head2 setup_db

Setup and connect a test database using SQLite.

=cut

sub setup_db
{
        # explicitely prefix into {test} subhash of the config file,
        # to avoid painful mistakes with deploy

        my ($db, $cfgbase) = @_;

        my $cfg = $cfgbase->{$db};
        my $dsn = $cfg->{dsn};
        my ($tmpfname) = $dsn =~ m,dbi:SQLite:dbname=([\w./]+),i;
        unlink $tmpfname;
        my $schema = Tapper::Schema::TestrunDB->connect($dsn, $cfg->{username}, $cfg->{password}, { ignore_version => 1 });
        $schema->deploy;
        $schema->upgrade if $schema->schema_version > $schema->get_db_version;
        return $schema;
}

=head2 setup_testrundb

Setup and connect a test TestrunDB using SQLite.

=cut

sub setup_testrundb {
        $testrundb_schema = setup_db("TestrunDB", Tapper::Config->subconfig->{test}{database});
}


sub import {
        my $pkg = caller(0);
        no strict 'refs';       ## no critic.
        *{"$pkg\::testrundb_schema"}  = sub () { $testrundb_schema };
}

setup_testrundb;

1;