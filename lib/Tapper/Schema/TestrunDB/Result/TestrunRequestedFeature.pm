package Tapper::Schema::TestrunDB::Result::TestrunRequestedFeature;

# ABSTRACT: Tapper - Relate features and testruns

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("testrun_requested_feature");
__PACKAGE__->add_columns
    (
     "id",              { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11, is_auto_increment => 1, },
     "testrun_id",      { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11, is_foreign_key    => 1, },
     "feature",         { data_type => "VARCHAR", default_value => "",    is_nullable => 1, size => 255,                        },
    );

__PACKAGE__->set_primary_key(qw/id/);

__PACKAGE__->belongs_to( testrunscheduling => 'Tapper::Schema::TestrunDB::Result::Testrun', { 'foreign.id' => 'self.testrun_id' });

1;