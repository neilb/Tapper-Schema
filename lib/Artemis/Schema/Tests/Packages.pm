package Artemis::Schema::Tests::Packages;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("packages");
__PACKAGE__->add_columns(
  "lid",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "type",
  { data_type => "ENUM", default_value => undef, is_nullable => 1, size => 3 },
  "filename",
  { data_type => "TEXT", default_value => "", is_nullable => 0, size => 65535 },
  "description",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "path",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "rebuild",
  { data_type => "TINYINT", default_value => undef, is_nullable => 1, size => 1 },
  "user",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "scm_url",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "scm_rev",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 255 },
  "scm_type",
  { data_type => "ENUM", default_value => undef, is_nullable => 1, size => 3 },
);
__PACKAGE__->set_primary_key("lid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-04-28 17:22:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:72iZHvGmR4L7fyr7vR6Ysw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
