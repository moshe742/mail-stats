package Lib::Merge;

use v5.10;
use Mouse;

sub merge {
	
	my $class = shift;
	my $year  = shift;
	my $dir   = shift;
	my $file_path = shift;
	my @file;

	# reading the files.
	opendir my $DIR, "$dir" or die "can't open direcory $dir: $! ";

	while ( my $file_name = readdir($DIR) ) {
		push @file, $file_name if $file_name =~ /\Q$year\E/ and $file_name !~ /.gz/;
	}

	open my $input_file, ">", "$file_path" or die "can't open file $file_path: $! ";
	
	# writing the needed info for the stats.
	for my $file ( @file ) {
		open my $output_file, "<", "$dir/$file" or die "can't open $file : $! ";
		while ( my $data = <$output_file> ) {
			print $input_file $data;
		}
	}
	
	close $input_file or die "can't close file: $! ";
	
}

1;