#!/usr/bin/perl

use warnings;
use strict;
use v5.10;
use LWP::Simple;
use HTML::LinkExtor;
use URI::URL;
use File::Spec;
use List::Util;
use Compress::Zlib;
use File::Temp qw(tempdir);

=pod

=head1 statperl

stats - statistics maker for mail archives of groups.

=head1 DESCRIPTION

Make the statistics for your mailgroup. For now it uses C<gzip> so I'm not sure it will work on other platforms. 

=cut

my ( @files, @names, $num, $year, $input_url, $number, %names );
our $VERSION = 0.09;

# the data will be stored temporarily untill the script is done.

my $dir = tempdir( CLEANUP => 1 );

my $file_path = File::Spec->catfile( $dir, "file.txt" );

=pod

=head2 info for the script to work on.

Here you will be asked the year that you want to work on and what is the mail archive url to fetch from the info.

The first question is about the year you want to analyze and the second is about your site for the archives of your group.

Type the url fully (including the http://), since the script use the getstore function for the fetching

of the data.

=cut

# Input from the user of the program.
input();

# Finding the files we need to download and getting ready to download them.
html();

# Downloading and extracting the files we want to check.
down();

# Extracting the downloaded files.
extract();

# Merging the data to 1 big file for easier retrival.
merge();

# Retriving the info we want for our stats.
var();

# Calculating the stats.
stats();

sub input {
	#enabling using @ARGV for input.
	for my $input ( @ARGV ) {
		_populate($input);
	}
	
	if ( defined @ARGV and -e $ARGV[0] ) {
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

}

sub html {
	# the list we create for use to get the files of the archives we need to make stats of.

	my $ua = LWP::UserAgent->new;

	# Make the parser.  Unfortunately, we don't know the base yet
	# (it might be different from $url)
	my $parse = HTML::LinkExtor->new(\&_links);

	# Request document and parse it as it arrives
	my $res = $ua->request(HTTP::Request->new(GET => $input_url),
						sub {$parse->parse($_[0])});

	# Expand all link URLs to absolute ones
	$input_url = $res->base;
	@files = map { $_ = url($_, $input_url)->abs; } @files;
}

sub down {
	print "Downloading and extracting the files, please be patient...\n\n";

	# downloading the needed files.
	for my $file_name ( @files ) {
		next if $file_name =~ /href\Z/;
		my $url = $file_name;
		$file_name =~ s/$input_url//;
		say "File $file_name is downloading.";
		getstore("$url", "$dir/$file_name") or die "Unable to get page: $!";
	}
	print "\n";
}

sub extract {
	# Extracting the files.
	system("gzip -d $dir/*.gz");
}

sub merge {
	my @file;
	
	# reading the files.
	opendir my $DIR, "$dir" or die "can't open direcory $dir: $! ";

	while ( my $file_name = readdir($DIR) ) {
		push @file, $file_name if $file_name =~ /\Q$year\E/;
	}

	open my $input_file, ">", "$file_path" or die "can't open file $file_path: $! ";
	
	# writing the needed info for the stats.
	for my $file ( @file ) {
		open my $output_file, "<", "$dir/$file" or die "can't open $file : $! ";
		
		while ( <$output_file> ) {
			print $input_file $_;
		}
	}
	
	close $input_file or die "can't close file: $! ";
	
}

sub var {
	# reading the file to populate the variables for the stats.
	open my $FI05, "<", "$file_path" or die "can't open file $file_path: $! ";

	my %post;
	$num = 0;
	while ( <$FI05> ) {
		if ( $_ =~ /\AFrom:/ and $_ =~ /\(/ ) {
			s/\)//;
			my @name = split /\(/, $_;
			chomp @name;
			my $name = $name[1];
			push @names, $name unless (exists $post{$name});
			$names{$name} = 0 unless exists $names{$name};
			if ( exists $names{$name} ) {
				$names{$name}++;
			}
			$post{$name} = $names[$num];
			$num++;
		}
	}
}

sub stats {
	my @sort = sort { $a <=> $b } ( values %names );

	my $n = @names;

	# making the statistics.

	my $num_of_mails = List::Util::sum( @sort[ -$number .. -1 ]  );

	my $percent_of_people = 100 * $num_of_mails / $num;
	my $percent_first = 100 * $sort[-1] / $num;
	# writing the statistics on the terminal.

	my $firstname;

	for ( keys %names ) {
		if ( $names{$_} == $sort[-1] ) {
			$firstname = $_;
			last;
		}
	}

	say "we had $n participants and they sent $num posts in $year";
	print "the participant with the most posts is $firstname with ";
	printf( "%.1f", $percent_first );
	say "% of the posts";
	print "the top $number posters made about ";
	printf("%.1f", $percent_of_people);
	say "% of the posts";
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

sub _links {
	# Set up a callback that collect the links
	my($tag, @links) = @_;
	return if $tag ne 'a';  # we only look closer at <img ...>
	push(@files, @links) if $links[1] =~ /\Qtxt.gz\E/ and $links[1] =~ /\Q$year\E/; 
}