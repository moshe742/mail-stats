package Lib::Input;

use Mouse;
use v5.10;
use Term::ReadLine;

my ( $number, $year, $input_url );
my $input = Term::ReadLine->new('Input for mail-sats');

sub input {
	
	my $class = shift;
	my @user_input = @_;
	#enabling using @ARGV for input.
	if ( @user_input and -e $user_input[0] ) {
		while ( my $input = <> ) {
			_populate($input);
		}
	} else {
		for my $input ( @user_input ) {
		   _populate($input);
		}
	}

	unless ( $year ) {
		$year = $input->readline("which year do you want to get stats for? ");
	}
	
	unless ( $input_url ) {
		$input_url = $input->readline("Whats the URL of your mails archive? ");
	}

	unless ( $number ) {
		$number = $input->readline("Percent of how many participant do you want to calculate? ");
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