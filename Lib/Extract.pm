package Lib::Extract;

use v5.10;
use Mouse;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);

has 'name' => ( is => 'ro', isa => 'Str' );

sub extract {
	
	my $class = shift;
	my $dir = shift;
	# Extracting the files.
	gunzip "<$dir/*.txt.gz>" => "<$dir/#1.txt>" or die "gunzip failed: $GunzipError\n";
}

1;