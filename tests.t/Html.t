#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 3;
use lib "/home/moshe/perl/mail-stats/";
use Lib::Html;

my $module = Lib::Html->new();
my @info = ( 2009, "http://mail.perl.org.il/pipermail/perl/" );

isa_ok( $module, 'Lib::Html' );
can_ok( $module, 'html' );

cmp_ok(
  Lib::Html->html( 2009, "http://mail.perl.org.il/pipermail/perl/" ),
  'eq',
  12,
  'Html method works',
);