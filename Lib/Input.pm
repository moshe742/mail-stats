package Lib::Input;

use Mouse;
use v5.10;
use Term::ReadLine;

has 'year', is => 'rw', isa => 'Int';
has 'url', is => 'rw', isa => 'Str';
has 'number', is => 'rw', isa => 'Int';

my ( $number, $year, $input_url );

sub input {
	
	my $input = Term::ReadLine->new('Input for mail-sats');
	my $class = shift;
	my @user_input = @_;
	
	#enabling using @ARGV for input.
	if ( @user_input and -e $user_input[0] ) {
		while ( my $input = <> ) {
			say "input is $input";
			_populate($input);
		}
	} else {
		for my $input ( @user_input ) {
		   _populate($input);
		}
	}

	unless ( $year ) {
		$class->year() = $input->readline("which year do you want to get stats for? ");
	}
	
	unless ( $input_url ) {
		$input_url = $input->readline("Whats the URL of your mails archive? ");
	}

	unless ( $number ) {
		$number = $input->readline("Percent of how many participant do you want to calculate? ");
	}

	return ( $year, $input_url, $number );

}

sub _populate {
	my $input = shift;
	chomp $input;

	if ( $input =~ /http:/ ) {
		$input_url = $input;
	} elsif ( $input =~ /\d{4}/ ) {
		$year = $input;
	} elsif ( $input =~ /\d/ ) {
		$number = $input;
	} else {
		say "_populate didn't work.";
	}
}

1;