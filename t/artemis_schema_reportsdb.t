#! /usr/bin/env perl

use lib '.';

use strict;
use warnings;

use Data::Dumper;
use Artemis::Schema::TestTools;
use Test::Fixture::DBIC::Schema;
use Test::More;
use Test::Deep;
use Scalar::Util;

BEGIN {
        plan tests => 25;
        use_ok( 'Artemis::Schema::ReportsDB' );
}

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/report.yml' );
# -----------------------------------------------------------------------------------------------------------------

ok( reportsdb_schema->get_db_version, "schema is versioned" );
diag reportsdb_schema->get_db_version;

is( reportsdb_schema->resultset('Report')->count, 3,  "report count" );

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/reportsection.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( reportsdb_schema->resultset('ReportSection')->count, 8,  "reportsection count" );

my @reportsections = reportsdb_schema->resultset('ReportSection')->search({report_id => 21})->all;
is( scalar @reportsections, 8,  "reportsection count" );

is( $reportsections[0]->some_meta_available, 1, "section - some meta available 0");
is( $reportsections[1]->some_meta_available, 1, "section - some meta available 1");
is( $reportsections[2]->some_meta_available, 1, "section - some meta available 2");
is( $reportsections[3]->some_meta_available, 1, "section - some meta available 3");
is( $reportsections[4]->some_meta_available, 1, "section - some meta available 4");
is( $reportsections[5]->some_meta_available, 0, "section - some meta available 5");
is( $reportsections[6]->some_meta_available, 1, "section - some meta available 6");
is( $reportsections[7]->some_meta_available, 1, "section - some meta available 7");

is( reportsdb_schema->resultset('Report')->find(20)->some_meta_available, 0, "report - some_meta_available 0");
is( reportsdb_schema->resultset('Report')->find(21)->some_meta_available, 1, "report - some_meta_available 1");


# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/reportgroups.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( reportsdb_schema->resultset('ReportgroupTestrun')->count,   3, "reportgrouptestrun count" );
is( reportsdb_schema->resultset('ReportgroupArbitrary')->count, 3, "reportgrouparbitrary count" );

my $report = reportsdb_schema->resultset('Report')->find(24);
like($report->tap, qr/OK 2 bar DDD/ms, "found report");
my $reportgroup_arbitrary = $report->reportgrouparbitrary;
ok(defined $reportgroup_arbitrary, "has according reportgroup arbitrary");

$report = reportsdb_schema->resultset('Report')->find(23);
like($report->tap, qr/OK 2 bar CCC/ms, "found report");
my $reportgroup_testrun = $report->reportgrouptestrun;
ok(defined $reportgroup_testrun, "has according reportgroup testrun");

unlike($report->tapdom, qr/\$VAR1/, "no tapdom yet");
my $tapdom = $report->get_cached_tapdom;
is(Scalar::Util::reftype($tapdom), "ARRAY", "got tapdom");

# get it again
$report = reportsdb_schema->resultset('Report')->find(23);
like($report->tapdom, qr/\$VAR1/, "tapdom created on demand looks like Data::Dumper string");
#diag "tapdom: ".$report->tapdom;
my $VAR1;
eval $report->tapdom;
my $tapdom2 = $VAR1;
#diag "tapdom2: ".Dumper($tapdom2);
cmp_bag($tapdom2, $tapdom, "stored tapdom keeps constant");
