package Tapper::Schema::TestrunDB::Result::Contact;

# ABSTRACT: Tapper - Keep contact information for owners

use strict;
use warnings;

use parent 'DBIx::Class';
use YAML::Syck;

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("contact");
__PACKAGE__->add_columns
    ( "id",        { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11, is_auto_increment => 1, },
     "owner_id",   { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11, is_foreign_key    => 1, extra => { renamed_from => 'user_id'  }, },
     "address",    { data_type => "VARCHAR",   default_value => undef,                is_nullable => 0, size => 255, },
     "protocol",   { data_type => "VARCHAR",   default_value => undef,                is_nullable => 0, size => 255, },
     "created_at", { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1, },
     "updated_at", { data_type => "DATETIME",  default_value => undef,                is_nullable => 1, },
    );


(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to( owner => "${basepkg}::Owner", { 'foreign.id' => 'self.owner_id' });

1;