package Tapper::Schema::TestrunDB::ResultSet::Testrun;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

=head2 queued_testruns

Search for queued testruns.

=cut

sub queued_testruns
{
        shift->search({
                       starttime_testrun => undef,
                      }
                     );
}

=head2 running_testruns

Search for running testruns.

=cut

sub running_testruns
{
        shift->search({
                       starttime_testrun    => { '!=' => undef },
                       endtime_test_program => undef,
                      }
                     );
}

=head2 finished_testruns

Search for finished testruns.

=cut

sub finished_testruns
{
        shift->search({
                       endtime_test_program => { '!=' => undef },
                      }
                     );
}

=head2 due_testruns

Search for due testruns.

=cut

sub due_testruns
{
        my ($self) = @_;

        require DateTime;
        my $now = $self->result_source->storage->datetime_parser->format_datetime(DateTime->now);
        return $self->search(
                             {
                              starttime_earliest => { '<', $now},
                              starttime_testrun  => undef,
                             },
                             {
                              order_by => [qw/starttime_earliest/]
                             }
                            );
}

=head2 all_testruns

Search for all testruns.

=cut

sub all_testruns {
        shift->search({});
}

=head2 status

Search for testrun with given status.

=cut

sub status {
        shift->search({'testrun_scheduling.status' => $_[0]}, {join => 'testrun_scheduling'});
}

=head2 add

Insert (add) a new testrun into DB, assign it with other typical also
inserted db rows, and return it.

=cut

sub add {
        my ($self, $args) = @_;

        my $testrun =  $self->new
            ({
              testplan_id           => $args->{testplan_id},
              notes                 => $args->{notes},
              shortname             => $args->{shortname},
              topic_name            => $args->{topic_name},
              starttime_earliest    => $args->{earliest},
              owner_id              => $args->{owner_id},
              rerun_on_error        => $args->{rerun_on_error},
              wait_after_tests      => $args->{wait_after_tests},
             });

        $testrun->insert;


        my $testrunscheduling = $self->result_source->schema->resultset('TestrunScheduling')->new
            ({
              testrun_id => $testrun->id,
              queue_id   => $args->{queue_id},
              host_id    => $args->{host_id},
              status     => $args->{status} || "schedule",
              auto_rerun => $args->{auto_rerun} || 0,
             });
        if ($args->{priority}) {
                $testrunscheduling->prioqueue_seq($self->result_source->schema->resultset('TestrunScheduling')->max_priority_seq()+1);
        }

        $testrunscheduling->insert;

        if ($args->{scenario_id}) {
                my $scenario_element = $self->result_source->schema->resultset('ScenarioElement')->new
                  ({
                    scenario_id => $args->{scenario_id},
                    testrun_id  => $testrun->id,
                   });
                $scenario_element->insert;
        }

        foreach my $host_id(@{$args->{requested_host_ids}}) {
                my $requested_host = $self->result_source->schema->resultset('TestrunRequestedHost')->new
                  ({
                    host_id => $host_id,
                    testrun_id  => $testrun->id,
                   });
                $requested_host->insert;
        }

        return $testrun->id;
}

1;
