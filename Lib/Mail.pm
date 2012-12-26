package Lib::Mail;

use Mouse;
use v5.10;
use Term::ReadLine;
use LWP::Simple;
use HTML::LinkExtor;
use URI::URL;

has 'input_url' => ( is => 'ro', isa => 'Str' );

my ( $number, $year, @files );

sub html {
	
	my $class = shift;
	$year = shift;
#	my $input_url = $class->input_url();
	# the list we create for use to get the files of the archives we need
	# to make stats of.

	my $ua = LWP::UserAgent->new;

	# Make the parser.
	my $parse = HTML::LinkExtor->new(\&_links);

	# Request document and parse it as it arrives
	my $res = $ua->request(HTTP::Request->new(GET => $class->input_url()),
						sub {$parse->parse($_[0])});

	# Expand all link URLs to absolute ones
	my $input_url = $res->base;
	@files = map { $_ = url($_, $input_url)->abs; } @files;

	return @files;
}

sub download {
	print "Downloading and extracting the files, please be patient...\n\n";
	
	my $class = shift;
	my $dir = shift;
	my $url = $class->input_url();
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

sub _links {
	# Set up a callback that collect the links

	my($tag, @links) = @_;
	return if $tag ne 'a';  # we only look closer at <a ...>
	push(@files, $links[1]) if $links[1] =~ /txt.gz/ and (index($links[1], $year) >= 0);
}

1;