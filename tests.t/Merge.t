#!/usr/bin/perl

use strict;
use warnings;
use File::Temp qw(tempdir);
use File::Spec;
use Test::More tests => 3;
use lib "/home/moshe/perl/mail-stats/";
use Lib::Merge;

my $module = Lib::Merge->new();
my $dir = tempdir( CLEANUP => 1 );
my $file_path = File::Spec->catfile( $dir, "test.txt" );
my @info = ( 2009, $dir, $file_path );

isa_ok( $module, 'Lib::Merge' );
can_ok( $module, 'merge' );

cmp_ok(
  Lib::Input->input( @info ),
  'eq',
  ( 2009, "http://mail.perl.org.il/pipermail/perl/", 10 ),
  'Input method works with @ARGV',
);

cmp_ok(
  Lib::Input->input( $file ),
  'eq',
  @info,
  'Input method works with file input',
);