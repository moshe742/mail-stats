package Lib::Down;

use Mouse;
use v5.10;
use LWP::Simple;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);

has 'dir' => ( is => 'ro', isa => 'Str' );

sub download {
	print "Downloading and extracting the files, please be patient...\n\n";
	
	my $class = shift;
	my $dir = shift;
	my $url = shift;
	my @files = @_;
	say "in down dir is $dir";
	# downloading the needed files.
	for my $file_name ( @files ) {
		my $file_url = $file_name;
		$file_name =~ s/$url//;
		say "File $file_name is downloading.";
		getstore("$file_url", "$class->dir()/$file_name") or die "Unable to download file $file_name: $!";
	}
	print "\n";
}

sub extract {
	
	my $class = shift;
	my $dir = shift;
	# Extracting the files.
	gunzip "<$dir/*.txt.gz>" => "<$dir/#1.txt>" or die "gunzip failed: $GunzipError\n";
}

sub merge {
	
	my $class = shift;
	my $year  = shift;
	my $file_path = shift;
	my @file;

	# reading the files.
	opendir my $DIR, "$class->dir()" or die "can't open direcory $class->dir(): $! ";

	while ( my $file_name = readdir($DIR) ) {
		push @file, $file_name if $file_name =~ /\Q$year\E/ and $file_name !~ /.gz/;
	}

	open my $input_file, ">", "$file_path" or die "can't open file $file_path: $! ";
	
	# writing the needed info for the stats.
	for my $file ( @file ) {
		open my $output_file, "<", "$class->dir()/$file" or die "can't open $file : $! ";
		while ( my $data = <$output_file> ) {
			print $input_file $data;
		}
	}
	
	close $input_file or die "can't close file: $! ";
	
}

1;