package Tapper::Schema::TestrunDB::Result::ChartLineAdditionals;

# ABSTRACT: Tapper - Keep additional columns for chart line popup

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table('chart_line_additionals');
__PACKAGE__->add_columns(
    'chart_line_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        extra               => {
            unsigned => 1,
        },
    },
    'chart_line_additional_column', {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 512,
    },
    'chart_line_additional_url', {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 1,
        size                => 1024,
    },
    'created_at', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 0,
        set_on_create       => 1,
    },
);


(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key('chart_line_id','chart_line_additional_column');
__PACKAGE__->belongs_to(
    chart_line => "${basepkg}::ChartLines", { 'foreign.chart_line_id' => 'self.chart_line_id' },
);

1;