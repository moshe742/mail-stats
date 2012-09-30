package Lib::Stats;

use v5.10;
use warnings;
use strict;
use List::Util;

sub stats {
	my $class = shift;
	my $number = shift;
	my $number_of_participants = shift;
	my $number_of_posts = shift;
	my $year = shift;
	my %names = @_;
	my @sort = sort { $a <=> $b } ( values %names );

	# making the statistics.

	my $num_of_mails = List::Util::sum( @sort[ -$number .. -1 ]  );

	my $percent_of_people = 100 * $num_of_mails / $number_of_posts;
	my $percent_first = 100 * $sort[-1] / $number_of_posts;
	# writing the statistics on the terminal.

	my $firstname;

	for my $name ( keys %names ) {
		if ( $names{$name} == $sort[-1] ) {
			$firstname = $name;
			last;
		}
	}

	say "we had $number_of_participants participants and they sent $number_of_posts posts in $year";
	print "the participant with the most posts is $firstname with ";
	printf( "%.1f", $percent_first );
	say "% of the posts";
	print "the top $number posters made about ";
	printf("%.1f", $percent_of_people);
	say "% of the posts";
}

1;