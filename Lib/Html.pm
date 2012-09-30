package Lib::Html;

use v5.10;
use warnings;
use strict;
use LWP::Simple;
use HTML::LinkExtor;
use URI::URL;

my ( @files, $year );

sub html {
	
	my $class = shift;
	$year = shift;
	my $input_url = shift;
	# the list we create for use to get the files of the archives we need
	# to make stats of.

	my $ua = LWP::UserAgent->new;

	# Make the parser.
	my $parse = HTML::LinkExtor->new(\&_links);

	# Request document and parse it as it arrives
	my $res = $ua->request(HTTP::Request->new(GET => $input_url),
						sub {$parse->parse($_[0])});

	# Expand all link URLs to absolute ones
	$input_url = $res->base;
	@files = map { $_ = url($_, $input_url)->abs; } @files;
}

sub _links {
	# Set up a callback that collect the links
	my($tag, @links) = @_;
	return if $tag ne 'a';  # we only look closer at <a ...>
	push(@files, @links) if $links[1] =~ /txt.gz/ and (index($links[1], $year) >= 0); 
}

1;