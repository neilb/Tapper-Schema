package Artemis::Schema::TestrunDB::Result::Message;

use strict;
use warnings;

use parent 'DBIx::Class';
use YAML::XS;

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core InflateColumn/);
__PACKAGE__->table("message");
__PACKAGE__->add_columns
    ( "id",        { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11, is_auto_increment => 1, },
     "testrun_id", { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11, is_foreign_key    => 1, },
     "message",    { data_type => "VARCHAR",   default_value => undef,                is_nullable => 1, },
     "created_at", { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1, },
     "updated_at", { data_type => "DATETIME",  default_value => undef,                is_nullable => 1, },
    );
__PACKAGE__->inflate_column( message => {
                                        inflate => sub { YAML::XS::Load(shift) },
                                        deflate => sub { YAML::XS::Dump(shift)},
 });

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to( testrun => "${basepkg}::Testrun", { 'foreign.id' => 'self.testrun_id' });

=head1 NAME

Artemis::Schema::TestrunDB::Result::Message - Keep messages received for testruns.


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::TestrunDB;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2011 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

=cut

1;
