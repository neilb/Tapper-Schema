package Artemis::Schema::TestrunDB::ResultSet::Precondition;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';
use Artemis::Exception::Param;
use YAML::Syck;


sub add {
        my ($self, $yaml) = @_;

        $yaml .= "\n" unless $yaml =~ /\n$/;
        my $yaml_error = Artemis::Schema::TestrunDB::_yaml_ok($yaml);
        die Artemis::Exception::Param->new($yaml_error) if $yaml_error;

        my @precond_list = Load($yaml);
        my @precond_ids;

        foreach my $precond_data (@precond_list) {
                # (XXX) decide how to handle empty preconditions
                next if not (ref($precond_data) eq 'HASH');
                my $shortname    = $precond_data->{shortname} || '';
                my $timeout      = $precond_data->{timeout};
                my $precondition = $self->result_source->schema->resultset('Precondition')->new
                    ({
                      shortname    => $shortname,
                      precondition => Dump($precond_data),
                      timeout      => $timeout,
                     });
                $precondition->insert;
                push @precond_ids, $precondition->id;
        }
        return @precond_ids;
}

1;
