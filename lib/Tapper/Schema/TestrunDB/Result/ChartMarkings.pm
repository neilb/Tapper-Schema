package Tapper::Schema::TestrunDB::Result::ChartMarkings;

# ABSTRACT: Tapper - Keep Chart Marking Areas for Charts

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/FilterColumn InflateColumn::DateTime Core/);
__PACKAGE__->table('chart_markings');
__PACKAGE__->add_columns(
    'chart_marking_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_auto_increment   => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'chart_version_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'chart_marking_name'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 128,
    },
    'chart_marking_color'   , {
        data_type           => 'CHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 6,
    },
    'chart_marking_x_from'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 1,
        size                => 512,
    },
    'chart_marking_x_to'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 1,
        size                => 512,
    },
    'chart_marking_x_format'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 1,
        size                => 64,
    },
    'chart_marking_y_from'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 1,
        size                => 512,
    },
    'chart_marking_y_to'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 1,
        size                => 512,
    },
    'chart_marking_y_format'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 1,
        size                => 64,
    },
    'created_at', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 0,
        set_on_create       => 1,
    },
);


(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key('chart_marking_id');

__PACKAGE__->belongs_to(
    chart_version => "${basepkg}::ChartVersions",
    { 'foreign.chart_version_id' => 'self.chart_version_id' },
);

1;