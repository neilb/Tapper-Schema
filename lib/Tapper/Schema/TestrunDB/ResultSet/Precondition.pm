package Tapper::Schema::TestrunDB::ResultSet::Precondition;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

=head2 add

Create (add) a list of preconditions and return them with their now
associated db data (eg. ID).

=cut

sub add {
        my ($self, $preconditions) = @_;

        my @precond_list = @$preconditions;
        my @precond_ids;

        require YAML::Syck;
        foreach my $precond_data (@precond_list) {
                # (XXX) decide how to handle empty preconditions
                next if not (ref($precond_data) eq 'HASH');
                my $shortname    = $precond_data->{shortname} || '';
                my $timeout      = $precond_data->{timeout};
                my $precondition = $self->result_source->schema->resultset('Precondition')->new
                    ({
                      shortname    => $shortname,
                      precondition => YAML::Syck::Dump($precond_data),
                      timeout      => $timeout,
                     });
                $precondition->insert;
                push @precond_ids, $precondition->id;
        }
        return @precond_ids;
}

1;
