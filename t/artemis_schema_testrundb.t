#! /usr/bin/env perl

use lib '.';

use  strict;
use warnings;

use t::Tools;
use Data::Dumper;
use Test::Fixture::DBIC::Schema;
use Test::More tests => 51;

BEGIN {
        use_ok( 'Artemis::Schema::TestrunDB' );
}

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => testrundb_schema, fixture => 't/fixtures/testrundb/user.yml' );
# -----------------------------------------------------------------------------------------------------------------

ok( testrundb_schema->get_db_version,  "schema is versioned" );
diag testrundb_schema->get_db_version;

is( testrundb_schema->resultset('User')->count, 3,  "user count" );

my $user = testrundb_schema->resultset('User')->search->first;
is($user->name,     'affe',       "user value 1");
is($user->login,    'zomtec',     "user value 2");
is($user->password, 'verysecret', "user value 3");


$user = testrundb_schema->resultset('User')->search({ login => 'ss5'})->first;
is($user->name,     'Steffen Schwigon@bascha', 'user ss5 value 1');
is($user->login,    'ss5',                     'user ss5 value 2');
is($user->password, 'verysecret',              'user ss5 value 3');


# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => testrundb_schema, fixture => 't/fixtures/testrundb/topic.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( testrundb_schema->resultset('Topic')->count, 9,  "topic count" );

my %topic_descriptions = map { $_->name => $_->description } testrundb_schema->resultset('Topic')->search->all;
my @topics = sort keys %topic_descriptions;

is_deeply(\@topics, [qw/Benchmark Distribution Hardware KVM Kernel Misc Research Software Xen/], "topics");



# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => testrundb_schema, fixture => 't/fixtures/testrundb/testrun_with_preconditions.yml' );
# -----------------------------------------------------------------------------------------------------------------

is( testrundb_schema->resultset('Testrun')->count, 2,  "testrun count" );

my $perfmon_run = testrundb_schema->resultset('Testrun')->search({ shortname => 'perfmon' })->first;
is($perfmon_run->id, 23, "testrun id");
is($perfmon_run->notes, 'perfmon', "testrun notes");
is($perfmon_run->topic_name, 'Software', "testrun topic_name");
is($perfmon_run->topic->name, 'Software', "testrun topic->name");
is($perfmon_run->topic->description, 'any non-kernel software, e.g., libraries, programs', "testrun topic->description");
is($perfmon_run->test_program, '/usr/local/share/artemis/testsuites/perfmon/t/do_test.sh', "testrun test_program");

is($perfmon_run->owner->name, 'Steffen Schwigon', "testrun user->name");
is($perfmon_run->owner->login, 'sschwigo', "testrun user->login");

# --------------------------------------------------

my @testrun_preconditions =  testrundb_schema->resultset('TestrunPrecondition')->search({ testrun_id => $perfmon_run->id },
                                                                                        { order_by => 'succession' }
                                                                                       )->all;

is(scalar @testrun_preconditions, 2, "testrun_preconditions count");
is($testrun_preconditions[0]->precondition_id, 8, "1st testrun_precondition");
is($testrun_preconditions[1]->precondition_id, 7, "2nd testrun_precondition");
is($testrun_preconditions[0]->precondition->shortname, 'perl-5.10', "testrun_precondition->precondition->shortname 1");
is($testrun_preconditions[1]->precondition->shortname, 'artemis-tools', "testrun_precondition->precondition->shortname 2");

# --------------------------------------------------

my @preconditions = sort { $a->parent_testrun_precondition->succession <=> $b->parent_testrun_precondition->succession } $perfmon_run->preconditions;

is(scalar @preconditions, 2, "testrun->preconditions count");
is($preconditions[0]->id, 8, "1st precondition");
is($preconditions[1]->id, 7, "2nd precondition");
is($preconditions[0]->shortname, 'perl-5.10', "preconditions[0]->shortname 1");
is($preconditions[1]->shortname, 'artemis-tools', "preconditions[1]->shortname 2");
#is($preconditions[0]->repository_full_name, '/package/redhat/5.2/64bit/perl-5.10', "preconditions[0]->repository_full_name 1");
#is($preconditions[1]->repository_full_name, '/subdir/tools/64bit/artemis/tools', "preconditions[1]->repository_full_name 2");

# --------------------------------------------------

my $perl = $preconditions[0];

my @perl_preconditions = $perl->child_preconditions;
#@perl_preconditions = sort { $a->child_pre_precondition->succession <=> $b->child_pre_precondition->succession } $perl_precondition->preconditions;

is(scalar @perl_preconditions, 2, "perl pre-preconditions count");
is($perl_preconditions[0]->id, 9, "1st perl pre-precondition");
is($perl_preconditions[1]->id, 10, "2nd perl pre-precondition");
is($perl_preconditions[0]->shortname, 'gcc-4.2', "perl pre_preconditions[0]->shortname 1");
is($perl_preconditions[1]->shortname, 'glibc-2.1', "perl pre_preconditions[1]->shortname 2");
#is($perl_preconditions[0]->repository_full_name, '/package/redhat/5.2/64bit/gcc-4.2', "pre_preconditions[0]->repository_full_name 1");
#is($perl_preconditions[1]->repository_full_name, '/package/redhat/5.2/64bit/glibc-2.1', "pre_preconditions[1]->repository_full_name 2");

# --------------------------------------------------

# check for parents of any gcc preconditions
my @gcc_preconditions = testrundb_schema->resultset('Precondition')->search({ shortname => 'gcc-4.2' })->all;
is (scalar @gcc_preconditions, 2, "fuzzy gcc parents count");
my @gcc_parent_shortnames = sort map { $_->parent->shortname} map { $_->parent_pre_precondition } @gcc_preconditions;
is_deeply(\@gcc_parent_shortnames, [qw/artemis-tools perl-5.10/], "fuzzy gcc parents shortnames");

# same parent dependency check logic as before, but for one particular gcc precondition
@gcc_preconditions = testrundb_schema->resultset('Precondition')->search({ id => 9 })->all;
is (scalar @gcc_preconditions, 1, "specific gcc parents count");
@gcc_parent_shortnames = sort map { $_->parent->shortname} map { $_->parent_pre_precondition } @gcc_preconditions;
is_deeply(\@gcc_parent_shortnames, [qw/perl-5.10/], "specific gcc parents shortnames");

# --------------------------------------------------

# same checks for (any|specific) gcc preconditions, but with easier relations

# check for parents of any gcc preconditions
@gcc_preconditions = testrundb_schema->resultset('Precondition')->search({ shortname => 'gcc-4.2' })->all;
is (scalar @gcc_preconditions, 2, "fuzzy gcc parents count");
@gcc_parent_shortnames = sort map { $_->shortname} map { $_->parent_preconditions } @gcc_preconditions;
is_deeply(\@gcc_parent_shortnames, [qw/artemis-tools perl-5.10/], "fuzzy gcc parents shortnames");

# same parent dependency check logic as before, but for one particular gcc precondition
@gcc_preconditions = testrundb_schema->resultset('Precondition')->search({ id => 9 })->all;
is (scalar @gcc_preconditions, 1, "specific gcc parents count");
@gcc_parent_shortnames = sort map { $_->shortname} map { $_->parent_preconditions } @gcc_preconditions;
is_deeply(\@gcc_parent_shortnames, [qw/perl-5.10/], "specific gcc parents shortnames");

# --------------------------------------------------

my @gcc_testruns = testrundb_schema->resultset('Precondition')->search({ id => 9 })->all;
is (scalar @gcc_preconditions, 1, "specific gcc parents count");
@gcc_parent_shortnames = sort map { $_->shortname} map { $_->parent_preconditions } @gcc_preconditions;
is_deeply(\@gcc_parent_shortnames, [qw/perl-5.10/], "specific gcc parents shortnames");


# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => testrundb_schema, fixture => 't/fixtures/testrundb/testrun.yml' );
# -----------------------------------------------------------------------------------------------------------------

my $testruns;

$testruns = testrundb_schema->resultset('Testrun')->all_testruns;
is ($testruns->count, 7, "all_testruns count");

$testruns = testrundb_schema->resultset('Testrun')->queued_testruns;
is ($testruns->count, 4, "queued_testruns count");

$testruns = testrundb_schema->resultset('Testrun')->running_testruns;
is ($testruns->count, 2, "running_testruns count");

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => testrundb_schema, fixture => 't/fixtures/testrundb/precondition_structures.yml' );
# -----------------------------------------------------------------------------------------------------------------

my $lmbench_testrun = testrundb_schema->resultset('Testrun')->search({ shortname => 'lmbench' })->first;
my @ordered_preconditions = $lmbench_testrun->ordered_preconditions;

my @ordered_precondition_ids = map { $_->id } @ordered_preconditions;
is_deeply(\@ordered_precondition_ids, [ 9, 10, 8, 11, 12, 7 ], "ordered preconditions");

# same with readable names
my @ordered_precondition_shortnames = map { $_->shortname } @ordered_preconditions;
is_deeply(\@ordered_precondition_shortnames, [ qw/gcc-4.2
                                                  glibc-2.1
                                                  perl-5.10
                                                  mysql-5.1
                                                  sqlite-3.1.2
                                                  artemis-tools
                                                 / ], "ordered preconditions");


# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => testrundb_schema, fixture => 't/fixtures/testrundb/preconditions_with_yaml.yml' );
# -----------------------------------------------------------------------------------------------------------------

my $testrun2 = testrundb_schema->resultset('Testrun')->search({ shortname => 'lmbench' })->first;
@ordered_preconditions = $testrun2->ordered_preconditions;

my @filtered_precondition_ids = map { $_->id } grep { $_->precondition_as_hash->{precondition_type} =~ /^image|package$/ } @ordered_preconditions;
is_deeply(\@filtered_precondition_ids, [ 9, 10, 8, 11, 12 ], "filtered preconditions without artemis-tools");
