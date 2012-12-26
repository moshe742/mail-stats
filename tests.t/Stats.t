#!/usr/bin/perl

use strict;
use warnings;
use File::Temp qw(tempdir);
use File::Spec;
use Test::More tests => 3;
use lib "/home/moshe/perl/mail-stats/";
use Lib::Stats;

my %scores_people = (
 info => 14,
 'Yossi Itzkovich' => 20,
 'Yuval Kogman' => 15,
 'ISOC-IL <eyal at isoc.org.il>' => 1,
 'Yosef Meller' => 1,
 'Yitzchak Scott-Thoennes' => 14,
 'Amir Elisha Aharoni' => 1,
 'bc.other' => 15,
 'Avishalom Shalit' => 39,
 'Amir E. Aharoni' => 17,
 'Assaf Gordon' => 1,
 'Yaron Golan' => 1,
 'Chanan Berler' => 32,
 'Jason Elbaum' => 7,
 'Gabor Szabo' => 126,
 'Mike Freedman' => 1,
 'Georges EL OJAIMI' => 1,
 'Adriano Ferreira' => 3,
 'Shmuel Fomberg' => 42,
 'guy keren' => 2,
 'Alexander Gurevich' => 2,
 'Roey Almog roey@gmail.com' => 1,
 'Roey Almog'  => 30,
 'Ran Eilam' => 1,
 'Gaal Yahas' => 48,
 'sawyer x' => 45,
 'Srikanth Madani' => 2,
 'Evgeny' => 10,
 'Levenglick Dov-RM07994' => 20,
 'Boris Reitman' => 3,
 'Issac Goldstand' => 13,
 'Mikhael Goikhman' => 20,
 'Offer Kaye' => 30,
 'Yona Shlomo' => 1,
 'Uri Bruck' => 5,
 'Richie Sevrinsky' => 3,
 'jaime.prilusky at weizmann.ac.il' => 3,
 'Pinkhas Nisanov' => 4,
 'Nicky Pappo' => 1,
 'Peter Gordon' => 12,
 'Roman M. Parparov' => 1,
 'Amit Aronovitch' => 8,
 'Eli Billauer' => 1,
 'Shlomi Fish' => 134,
 'Amos Shapira' => 2,
 'Alan Haggai Alavi' => 2,
 'Infoneto Ltd' => 1,
 'ik' => 2,
 'problematic' => 1,
 'Oded Arbel' => 1,
 'Omer Zak' => 4,
 'Berler Chanan' => 45,
 'Oron Peled' => 5,
 'Oren Maurer' => 3,
 'Ephraim Dan' => 6,
 'Michael Gang' => 1,
 'sigurko atwork' => 1
	);
my $module = Lib::Stats->new();

isa_ok( $module, 'Lib::Stats' );
can_ok( $module, 'stats' );

cmp_ok(
  Lib::Stats->stats_year( 10, 57, 825, 2009, %scores_people ),
  'eq',
  1,
  'stats method works',
);