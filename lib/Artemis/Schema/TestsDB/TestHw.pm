package Artemis::Schema::TestsDB::TestHw;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("test_hw");
__PACKAGE__->add_columns(
  "id_testrun",
  { data_type => "MEDIUMINT", default_value => "", is_nullable => 0, size => 9 },
  "id_hw",
  { data_type => "MEDIUMINT", default_value => "", is_nullable => 0, size => 9 },
);
__PACKAGE__->set_primary_key("id_testrun");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-04-28 17:22:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VoHtFUkxsUvwgNLfNHFQgA


# You can replace this text with custom content, and it will be preserved on regeneration

1;

=head1 NAME

Artemis::Schema::TestsDB::TestHw - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::TestsDB;


=head1 EXPORT

A list of functions that can be exported.  


=head1 FUNCTIONS


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

