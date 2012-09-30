package Lib::Input;

use warnings;
use strict;
use v5.10;

my ( $number, $year, $input_url );

sub input {
	
	my $class = shift;
	my @user_input = @_;
	#enabling using @ARGV for input.
	for my $input ( @user_input ) {
		_populate($input);
	}
	
	if ( @user_input and -e $user_input[0] ) {
		while ( my $input = <> ) {
			_populate($input);
		}
	}

	unless ( $year ) {
		print "which year do you want to get stats for? ";
		$year = <STDIN>;
		chomp $year;
	}
	
	unless ( $input_url ) {
		print "Whats the URL of your mails archive? ";
		$input_url = <STDIN>;
		chomp $input_url;
	}

	unless ( $number ) {
		print "Percent of how many participant do you want to calculate? ";
		$number = <STDIN>;
		chomp $number;
	}

#	print " the year you chose to stat is $year,\n the url you chose is $input_url,\n and the number of partisipants is $number\n";

	return ( $year, $input_url, $number );

}

sub _populate {
	my $input = shift;
	chomp $input;

	if ( $input =~ /http:/ ) {
		$input_url = $input;
		return $input_url;
	} elsif ( $input =~ /\d{4}/ ) {
		$year = $input;
		return $year;
	} elsif ( $input =~ /\d/ ) {
		$number = $input;
		return $number;
	}
}

1;