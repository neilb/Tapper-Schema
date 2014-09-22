package Tapper::Schema::TestrunDB::Result::Owner;

# ABSTRACT: Tapper - Containg Tapper users

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table("owner");
__PACKAGE__->add_columns
    (
     "id",       { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11, is_auto_increment => 1, },
     "name",     { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 255,                        },
     "login",    { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 255,                        },
     "password", { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 255,                        },
    );

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint( unique_login => [ qw/login/ ], );
__PACKAGE__->has_many( contacts => "${basepkg}::Contact", { 'foreign.owner_id' => 'self.id' });
__PACKAGE__->has_many( notifications => "${basepkg}::Notification", { 'foreign.owner_id' => 'self.id' });

1;