package Lib::Var;

use v5.10;
use Mouse;

sub var {
	
	my $class = shift;
	my $file_path = shift;

	my ( @names, %names, $number_of_posts );
	
	# reading the file to populate the variables for the stats.
	open my $work_file, "<", "$file_path" or die "can't open file $file_path: $! ";
	
	my %post;
	$number_of_posts = 0;
	while ( my $file = <$work_file> ) {
		if ( $file =~ /\AFrom:/ and $file =~ /\(/ ) {
			$file =~ s/\)//;
			my @name = split /\(/, $file;
			chomp @name;
			my $name = $name[1];
			push @names, $name unless (exists $post{$name});
			$names{$name} = 0 unless exists $names{$name};
			if ( exists $names{$name} ) {
				$names{$name}++;
			}
			$post{$name} = $names[$number_of_posts];
			$number_of_posts++;
		}
	}
	my $number_of_participants = @names;

	return ( $number_of_posts, $number_of_participants, %names );
}

1;