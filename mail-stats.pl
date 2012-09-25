#!/usr/bin/perl

use warnings;
use strict;
use v5.10;
use LWP::Simple;
#use List::Util::sum;
use File::Temp qw(tempdir);

=pod

=head1 statperl

stats - statistics maker for mail archives of groups.

=head1 DESCRIPTION

Make the statistics for your mailgroup. For now it uses C<gzip> so I'm not sure it will work on other platforms. 

=cut

my ( @files, @names, $num, $year, $input_url, $number, %names );
our $VERSION = 0.09;
my $file_name = "file.txt";

# the data will be stored temporarily untill the script is done.

my $dir = tempdir( CLEANUP => 1 );

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

# Merging the data to 1 big file for easier retrival.
merge();

# Retriving the info we want for our stats.
var();

# Calculating the stats.
stats();

sub input {
	#enabling using @ARGV for input.
	for my $input ( @ARGV ) {
		chomp $input;

		if ( $input =~ /http:/ ) {
			$input_url = $input;
		} elsif ( $input =~ /\d{4}/ ) {
			$year = $input;
		} elsif ( $input =~ /\d/ ) {
			$number = $input;
		}

	}
	
	if ( -e $ARGV[0] ) {
	while ( my $input = <> ) {
		chomp $input;

		if ( $input =~ /http:/ ) {
			$input_url = $input;
		} elsif ( $input =~ /\d{4}/ ) {
			$year = $input;
		} elsif ( $input =~ /\d/ ) {
			$number = $input;
		}

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

	print " the year you chose to stat is $year,\n the url you chose is $input_url,\n and the number of partisipants is $number\n";

}

sub html {
	# the file we create for use to get the files of the archives we need to make stats of.
	getstore("$input_url", "$dir/mail.txt") or die "Unable to get page: $!";
	
	open my $html, "<", "$dir/mail.txt" or die "can't open mail.txt: $! ";

	# making the info in an easy way to read and use.
	while (my $gzip = <$html>) {
		if ( $gzip =~ /gzip/i ) {
			chomp $gzip;
			$gzip =~ s/<td><A href="/$input_url\//;
			$gzip =~ s/"\>\[ Gzip'd Text \d{1,6} KB \]\<\/a\>\<\/td>//;
			$gzip =~ s/"\>\[ Gzip'd Text \d{1,6} bytes \]\<\/a\>\<\/td>//;
			push @files, $gzip if $gzip =~ /$year/;
		}
	}

	close $html or die "can't close mail.txt: $! ";
}

sub down {
	print "Downloading and extracting the files, please be patient...\n\n";
	
	# downloading the needed files and extracting them.
	for my $file_name ( @files ) {
		my $url = $file_name;
		$file_name =~ s/$input_url\///;
		getstore("$url", "$dir/$file_name") or die "Unable to get page: $!";
	}
	
	system("gzip -d $dir/*.gz");
}

sub merge {
	my @file;
	
	# reading the files.
	opendir my $DIR, "$dir" or die "can't open direcory $dir: $! ";

	while ( my $file_name = readdir($DIR) ) {
		push @file, $file_name if $file_name =~ /$year/;
	}
	
	open my $input_file, ">", "$dir$file_name" or die "can't open file $file_name: $! ";
	
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
	open my $FI05, "<", "$dir$file_name" or die "can't open file $file_name: $! ";

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

	my $num_of_mails = 0;

	for ( 1 .. $number ) {
		$num_of_mails = $sort[-$_] + $num_of_mails;
	}

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