use strict;
use warnings;

# get rid of warnings
use Class::C3;
use MRO::Compat;

use 5.010;

use Artemis::Config;
use Artemis::Schema;

use Data::Dumper;
use Test::Fixture::DBIC::Schema;
use Artemis::Schema::TestTools;

use Test::More;
use Test::Deep;

# --------------------------------------------------------------------------------
construct_fixture( schema  => testrundb_schema,  fixture => 't/fixtures/testrundb/simple_testrun.yml' );
# --------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => hardwaredb_schema, fixture => 't/fixtures/hardwaredb/systems.yml' );
# -----------------------------------------------------------------------------------------------------------------


sub model
{
        my ($schema_basename) = @_;

        $schema_basename ||= 'TestrunDB';

        my $schema_class = "Artemis::Schema::$schema_basename";

        # lazy load class
        eval "use $schema_class";
        if ($@) {
                print STDERR $@;
                return undef;
        }
        return $schema_class->connect(Artemis::Config->subconfig->{database}{$schema_basename}{dsn},
                                      Artemis::Config->subconfig->{database}{$schema_basename}{username},
                                      Artemis::Config->subconfig->{database}{$schema_basename}{password});
}


my $testrun = model->resultset('Testrun')->find(23);
my @ids;
my $all_preconditions = $testrun->preconditions->search({});
while ( my $precondition = $all_preconditions->next ) {
        push @ids, $precondition->id;
}
cmp_bag(\@ids, [ 8, 7 ], 'Preconditions before disassign');



$testrun->disassign_preconditions();
my @new_ids;
$all_preconditions = $testrun->preconditions->search({});
while ( my $precondition = $all_preconditions->next ) {
        push @new_ids, $precondition->id;
}
cmp_bag(\@new_ids, [ ], 'Preconditions after disassign');

$testrun->assign_preconditions(@ids);
@new_ids=();
$all_preconditions = $testrun->preconditions->search({});
while ( my $precondition = $all_preconditions->next ) {
        push @new_ids, $precondition->id;
}
cmp_bag(\@new_ids, [ @ids ], 'Preconditions after assign');


my $testrun_id = $testrun = model->resultset('Testrun')->add({
                                                              notes                 => 'Noted',
                                                              shortname             => 'Short name',
                                                              topic_name            => 'SomeTopic',
                                                              owner_user_id         => 10,
                                                              hardwaredb_systems_id => 15,
                                                              scenario_id           => 1,
                                                              requested_host_ids    => [ 5, 6, 8,],
                                                             });

$testrun = model->resultset('Testrun')->find($testrun_id);
is($testrun->notes, 'Noted', 'Setting notes for new testrun');
my @host = map {$_->host->name} $testrun->testrun_scheduling->requested_hosts->all;
cmp_bag( \@host , [ 'iring','bullock','athene'], 'Requested hosts');
is($testrun->scenario_element->scenario->type, 'interdep', 'Setting scenario');

my $new_testrun_id = $testrun->rerun();
my $new_testrun = model->resultset('Testrun')->find($new_testrun_id);


my @new_host = map {$_->host->name} $new_testrun->testrun_scheduling->requested_hosts->all;
cmp_bag( \@new_host , \@host, 'Requested hosts of rerun test');
is($new_testrun->testrun_scheduling->status, 'schedule','State of rerun test');

done_testing();

