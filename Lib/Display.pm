package Lib::Display;

=pod

=head1 Display

Lib::Display - This module will display the stats of mail-stats.

=head1 SYNOPSIS

  my $object = Lib::Display->new(
      foo  => 'bar',
      flag => 1,
  );
  
  $object->dummy;

=head1 DESCRIPTION

This module will display the mail stats wanted according to what the user wants.

=head1 METHODS

=cut

use 5.010;
use strict;
use warnings;
use Mouse;

=pod

=head2 dummy

This method does something... apparently.

=cut

sub display_year {

	my $self = shift;
	my ( $number_of_participants, $number_of_posts, $firstname, $percent_first, $number, $percent_of_people, $year ) = @_;

	say "we had $number_of_participants participants and they sent $number_of_posts posts in $year";
	print "the participant with the most posts is $firstname with ";
	printf( "%.1f", $percent_first );
	say "% of the posts";
	print "the top $number posters made about ";
	printf("%.1f", $percent_of_people);
	say "% of the posts";

	return 1;
}

sub display_month {

	my $self = shift;
	my ( $number_of_participants, $number_of_posts, $firstname, $percent_first, $number, $percent_of_people, $year ) = @_;

	say "we had $number_of_participants participants and they sent $number_of_posts posts in $year";
	print "the participant with the most posts is $firstname with ";
	printf( "%.1f", $percent_first );
	say "% of the posts";
	print "the top $number posters made about ";
	printf("%.1f", $percent_of_people);
	say "% of the posts";

	return 1;
}

sub display_day {

	my $self = shift;
	my ( $number_of_participants, $number_of_posts, $firstname, $percent_first, $number, $percent_of_people, $year ) = @_;

	say "we had $number_of_participants participants and they sent $number_of_posts posts in $year";
	print "the participant with the most posts is $firstname with ";
	printf( "%.1f", $percent_first );
	say "% of the posts";
	print "the top $number posters made about ";
	printf("%.1f", $percent_of_people);
	say "% of the posts";

	return 1;
}

1;

=pod

=head1 SUPPORT

No support is available

=head1 AUTHOR

Copyright 2011 Anonymous.

=cut
