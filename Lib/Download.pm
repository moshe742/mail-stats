package Lib::Download;

use v5.10;
use warnings;
use strict;
use LWP::Simple;

sub download {
	print "Downloading and extracting the files, please be patient...\n\n";
	
	my $class = shift;
	my $dir = shift;
	my $url = shift;
	my @files = @_;
	# downloading the needed files.
	for my $file_name ( @files ) {
		next if $file_name =~ /href\Z/;
		my $file_url = $file_name;
		$file_name =~ s/$url//;
		say "File $file_name is downloading.";
		getstore("$file_url", "$dir/$file_name") or die "Unable to get page: $!";
	}
	print "\n";
}

1;