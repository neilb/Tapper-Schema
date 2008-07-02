package Artemis::Schema::HardwareDB;

use strict;
use warnings;

our $VERSION = '2.010009';

use parent 'DBIx::Class::Schema';

our $NULL  = 'NULL';
our $DELIM = ' | ';

__PACKAGE__->load_namespaces;

# not versioned: __PACKAGE__->load_components(qw/+DBIx::Class::Schema::Versioned/);
# __PACKAGE__->upgrade_directory('/var/tmp/');
# __PACKAGE__->backup_directory('/var/tmp/');

sub backup
{
        #say STDERR "(TODO: Implement backup method.)";
        1;
}

1;
