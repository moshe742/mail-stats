#!/usr/bin/perl

use warnings;
use strict;
use v5.10;
use Lib::Download;
use Lib::Input;
use Lib::Html;
#use Lib::Mail;
use Lib::Extract;
use Lib::Merge;
use Lib::Var;
use Lib::Stats;
use Lib::Display;
use File::Spec;
use File::Temp qw(tempdir);

=pod

=head1 Mail-stats

Mail-stats - statistics maker for mail archives of groups.

=head1 DESCRIPTION

Make the statistics for your mailgroup.

=cut

our $VERSION = 0.09;

# the data will be stored temporarily untill the script is done.

my $dir = tempdir( CLEANUP => 1 );

my $file_path = File::Spec->catfile( $dir, "file.txt" );

=pod

=head2 info for the script to work on.

Here you will be asked the year that you want to work on and what is the mail archive url to fetch from the

info.

The first question is about the year you want to analyze and the second is about your site for the archives

of your group.

Type the url fully (including the http://), since the script use the getstore function for the fetching

of the data.

=cut

my $input = Lib::Input->new();
my $html = Lib::Html->new();
my $down = Lib::Download->new();
my $extract = Lib::Extract->new();
my $merge = Lib::Merge->new();
my $var = Lib::Var->new();
my $stats = Lib::Stats->new();
my $display = Lib::Display->new();

# Input from the user of the program.
my ( $year, $input_url, $number ) = $input->input(@ARGV);

#my $mail = Lib::Mail->new(
#								year => $year,
#								input_url => $input_url,
#								);

# Finding the files we need to download and getting ready to download them.
my @files = $html->html( $year, $input_url );

# Downloading the files we want to check.
$down->download( $dir, $input_url, @files );

# Extracting the downloaded files.
$extract->extract($dir);

# Merging the data to 1 big file for easier retrival.
$merge->merge($year, $dir, $file_path);

# Retriving the info we want for our stats.
my ( $number_of_posts, $number_of_participants, %names ) = $var->var($file_path);

# Calculating the stats.
my @stats = $stats->stats_year($number, $number_of_participants, $number_of_posts, $year, %names);

$display->display_year( @stats, $year );