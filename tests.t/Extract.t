#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 3;
use File::Temp qw(tempdir);
use File::Copy;
use lib "/home/moshe/perl/mail-stats/";
use Lib::Extract;

my $module = Lib::Extract->new();
my $dir = tempdir( CLEANUP => 1 );
copy("/home/moshe/perl/mail-stats/check.txt.gz","$dir/check.txt.gz");

isa_ok( $module, 'Lib::Extract' );
can_ok( $module, 'extract' );

cmp_ok(
  Lib::Extract->extract( $dir ),
  'eq',
  1,
  'extract method works',
);