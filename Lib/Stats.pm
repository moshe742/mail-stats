package Lib::Stats;

use v5.10;
use Mouse;
use List::Util;

sub stats_year {
	my $class = shift;
	my $number = shift;
	my $number_of_participants = shift;
	my $number_of_posts = shift;
	my $year = shift;
	my %score_by_names = @_;
	my @sort = sort { $a <=> $b } ( values %score_by_names );

	# making the statistics.

	my $num_of_mails = List::Util::sum( @sort[ -$number .. -1 ]  );

	my $percent_of_people = 100 * $num_of_mails / $number_of_posts;
	my $percent_first = 100 * $sort[-1] / $number_of_posts;
	# writing the statistics on the terminal.

	my $firstname;

	for my $name ( keys %score_by_names ) {
		if ( $score_by_names{$name} == $sort[-1] ) {
			$firstname = $name;
			last;
		}
	}
	return ( $number_of_participants, $number_of_posts, $firstname, $percent_first, $number, $percent_of_people );
}

1;