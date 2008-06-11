package Artemis::Schema::TestsDB::TestsPerRun;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("tests_per_run");
__PACKAGE__->add_columns(
  "lid",
  {
    data_type => "MEDIUMINT",
    default_value => undef,
    is_nullable => 0,
    size => 8,
  },
  "id_testrun",
  { data_type => "INT", default_value => "", is_nullable => 0, size => 10 },
  "test_program",
  { data_type => "INT", default_value => "", is_nullable => 0, size => 10 },
  "runtime",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 10 },
  "succession",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 5,
  },
  "timeout",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 10 },
  "output",
  { data_type => "TEXT", default_value => "", is_nullable => 0, size => 65535 },
  "parameter",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "return_value",
  { data_type => "TINYINT", default_value => undef, is_nullable => 1, size => 4 },
  "return_value_description",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
);
__PACKAGE__->set_primary_key("lid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-04-28 17:22:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xAXZBizs5igVx6cRr6/MCw


# You can replace this text with custom content, and it will be preserved on regeneration

1;

=head1 NAME

Artemis::Schema::TestsDB::TestsPerRun - A ResultSet description


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

