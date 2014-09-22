package Tapper::Schema::TestrunDB::Result::ChartTagRelations;

# ABSTRACT: Tapper - Keep relations between charts and chart tags

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/FilterColumn InflateColumn::DateTime Core/);
__PACKAGE__->table('chart_tag_relations');
__PACKAGE__->add_columns(
    'chart_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'chart_tag_id', {
        data_type           => 'SMALLINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 6,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'created_at', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 0,
        set_on_create       => 1,
    },
);


(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key('chart_id','chart_tag_id');

__PACKAGE__->belongs_to(
    chart => "${basepkg}::Charts",
    { 'foreign.chart_id' => 'self.chart_id' },
);
__PACKAGE__->belongs_to(
    chart_tag => "${basepkg}::ChartTags",
    { 'foreign.chart_tag_id' => 'self.chart_tag_id' },
);

1;