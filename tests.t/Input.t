#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 4;
use lib "/home/moshe/perl/mail-stats/";
use Lib::Input;

my $module = Lib::Input->new();
my @info = ( "http://mail.perl.org.il/pipermail/perl/", 5, 2008 );
my @file = "/home/moshe/perl/mail-stats/try";

isa_ok( $module, 'Lib::Input' );
can_ok( $module, 'input' );

is_deeply(
  [ $module->input( @info ) ],
  [ 2008 , "http://mail.perl.org.il/pipermail/perl/", 5 ],
  'Input method works with @ARGV',
);

is_deeply(
  [ $module->input( @file ) ],
  [ "2009", "http://mail.perl.org.il/pipermail/perl/", "10" ],
  'Input method works with file input',
);