package Lib::Download;

use Mouse;
use v5.10;
use LWP::Simple;

has 'name' => ( is => 'ro', isa => 'Str' );

sub download {
	print "Downloading and extracting the files, please be patient...\n\n";
	
	my $class = shift;
	my $dir = shift;
	my $url = shift;
	my @files = @_;
	
	# downloading the needed files.
	for my $file_name ( @files ) {
		my $file_url = $file_name;
		$file_name =~ s/$url//;
		say "File $file_name is downloading.";
		getstore("$file_url", "$dir/$file_name") or die "Unable to download file $file_name: $!";
	}
	print "\n";
}

1;