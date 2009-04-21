package Artemis::Schema::ReportsDB::Result::Report;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';
use parent 'Artemis::Schema::Printable';

use Data::Dumper;

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp Core));
__PACKAGE__->table("report");
__PACKAGE__->add_columns
    (
     "id",                      { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_auto_increment => 1,     },
     "suite_id",                { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 11, is_foreign_key => 1,        },
     "suite_version",           { data_type => "VARCHAR",  default_value => undef,  is_nullable => 1, size => 11,                             },
     "reportername",            { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 100,                            },
     "peeraddr",                { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 20,                             },
     "peerport",                { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 20,                             },
     "peerhost",                { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 255,                            },
     #
     # raw tap
     #
     #"tap",                    { data_type => "TEXT",     default_value => "",     is_nullable => 0,                                         },
     "tap",                     { data_type => "LONGBLOB", default_value => "",     is_nullable => 0,                                         },
     "tapdom",                  { data_type => "LONGBLOB", default_value => "",     is_nullable => 1,                                         },
     #
     # tap parse result and its human interpretation
     #
     "successgrade",            { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 10,                             },
     "reviewed_successgrade",   { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 10,                             },
     #
     # tap parse results
     #
     "total",                   { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "failed",                  { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "parse_errors",            { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "passed",                  { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "skipped",                 { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "todo",                    { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "todo_passed",             { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "wait",                    { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "exit",                    { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "success_ratio",           { data_type => "VARCHAR",  default_value => undef,  is_nullable => 1, size => 20,                             },
     #
     "starttime_test_program",  { data_type => "DATETIME", default_value => undef,  is_nullable => 1,                                         },
     "endtime_test_program",    { data_type => "DATETIME", default_value => undef,  is_nullable => 1,                                         },
     #
     "machine_name",            { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 50,                             },
     "machine_description",     { data_type => "TEXT",     default_value => "",     is_nullable => 1,                                         },
     #
     "created_at",              { data_type => "DATETIME", default_value => undef,  is_nullable => 0, set_on_create => 1,                     },
     "updated_at",              { data_type => "DATETIME", default_value => undef,  is_nullable => 0, set_on_create => 1, set_on_update => 1, },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to   ( suite                => 'Artemis::Schema::ReportsDB::Result::Suite',                { 'foreign.id'        => 'self.suite_id' }, { 'join_type' => 'LEFT OUTER' });
__PACKAGE__->belongs_to   ( reportgrouparbitrary => 'Artemis::Schema::ReportsDB::Result::ReportgroupArbitrary', { 'foreign.report_id' => 'self.id'       }, { 'join_type' => 'LEFT OUTER' });
__PACKAGE__->belongs_to   ( reportgrouptestrun   => 'Artemis::Schema::ReportsDB::Result::ReportgroupTestrun',   { 'foreign.report_id' => 'self.id'       }, { 'join_type' => 'LEFT OUTER' });

__PACKAGE__->has_many     ( comments       => 'Artemis::Schema::ReportsDB::Result::ReportComment', { 'foreign.report_id' => 'self.id' });
__PACKAGE__->has_many     ( topics         => 'Artemis::Schema::ReportsDB::Result::ReportTopic',   { 'foreign.report_id' => 'self.id' });
__PACKAGE__->has_many     ( files          => 'Artemis::Schema::ReportsDB::Result::ReportFile',    { 'foreign.report_id' => 'self.id' });
__PACKAGE__->has_many     ( reportsections => 'Artemis::Schema::ReportsDB::Result::ReportSection', { 'foreign.report_id' => 'self.id' });


#sub suite_name { shift->suite->name }
sub suite_name { my ($self, $arg) = @_; return $self->search({ "suite.name" => $arg })};

sub sections_cpuinfo
{
        my ($self) = @_;
        my $sections = $self->reportsections;
        my @cpus;
        while (my $section = $sections->next) {
                push @cpus, $section->cpuinfo;
        }
        return @cpus;
}

sub sections_osname
{
        my ($self) = @_;
        my $sections = $self->reportsections;
        my @cpus;
        while (my $section = $sections->next) {
                push @cpus, $section->osname;
        }
        return @cpus;
}

sub _get_cached_tapdom
{
        my ($report) = @_;

        require Artemis::TAP::Harness;
        require TAP::DOM;

        my $TAPVERSION = "TAP Version 13";
        my $tapdom_sections = [];
        my $tapdom_str = $report->tapdom;
        # set ARTEMIS_FORCE_NEW_TAPDOM to force the re-generation of the TAP DOM, e.g. when the TAP::DOM module changes
        if (not $tapdom_str or $ENV{ARTEMIS_FORCE_NEW_TAPDOM})
        {
                my $harness = new Artemis::TAP::Harness( tap => $report->tap );
                $harness->evaluate_report();
                foreach (@{$harness->parsed_report->{tap_sections}}) {
                        my $rawtap = $_->{raw};
                        $rawtap = $TAPVERSION."\n".$rawtap unless $rawtap =~ /^TAP Version/ms;
                        my $tapdom = new TAP::DOM ( tap => $rawtap );
                        push @$tapdom_sections, { section => { $_->{section_name} => { tap => $tapdom }}};
                }
                $tapdom_str = Dumper($tapdom_sections);
                $report->tapdom ($tapdom_str);
                $report->update;
        }
        else
        {
                my $VAR1;
                eval $tapdom_str;
                my $tapdom_sections = $VAR1;
        }
        return $tapdom_sections;
}

1;

__END__

=head1 NAME

Artemis::Schema::ReportsDB::Report - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::ReportsDB;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

