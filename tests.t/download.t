#!/usr/bin/perl

use strict;
use warnings;
use File::Temp qw(tempdir);
use Test::More tests => 3;
use lib "/home/moshe/perl/mail-stats/";
use Lib::Download;

my $module = Lib::Download->new();
my $dir = tempdir( CLEANUP => 1 );

isa_ok( $module, 'Lib::Download' );
can_ok( $module, 'download' );

cmp_ok(
  Lib::Download->download( $dir,
    "https://github.com/moshe742/mail-stats/blob/master/Lib/",
    "https://github.com/moshe742/mail-stats/blob/master/Lib/Inputfile.pm"
  ),
  '==',
  1,
  'Downloading method works',
);