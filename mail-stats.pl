#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use LWP::Simple;
use File::Temp qw(tempdir);

=pod

=head1 statperl

stats - statistics maker for mail archives of groups.

=head1 DESCRIPTION

Make the statistics for your mailgroup. For now it uses C<gzip> so I'm not sure it will work on other platforms. 

=cut

my ( @files, @names, $num, %names );
our $VERSION = 0.09;
my $file_name = "file.txt";

=pod

=head2 info for the script to work on.

Here you will be asked the year that you want to work on and what is the mail archive url to fetch from the info.

The first question is about the year you want to analyze and the second is about your site for the archives of your group.

Type the url fully (including the http://), since the script use the getstore function for the fetching

of the data.

=cut

print "which year do you want to get stats for? ";
my $year = <STDIN>;
chomp $year;

print "Whats the URL of your mails archive? ";
my $url = <STDIN>;
chomp $url;

print "Percent of how many participant do you want to calculate? ";
my $number = <STDIN>;
chomp $number;

# the data will be stored temporarily untill the script is done.

my $dir = tempdir( CLEANUP => 1 );

# the file we create for use to get the files of the archives we need to make stats of.

html {
	getstore("$url", "$dir/mail.txt") or die "Unable to get page: $!";

	open my $html, "<", "$dir/mail.txt" or die "can't open mail.txt: $! ";

	# making the info in an easy way to read and use.

	while (my $gzip = <$html>) {
		if ( $gzip =~ /gzip/i ) {
			chomp $gzip;
			$gzip =~ s/<td><A href="/$url\//;
			$gzip =~ s/"\>\[ Gzip'd Text \d{1,6} KB \]\<\/a\>\<\/td>//;
			$gzip =~ s/"\>\[ Gzip'd Text \d{1,6} bytes \]\<\/a\>\<\/td>//;
			push @files, $gzip if $gzip =~ /$year/;
		}
	}

	close $html or die "can't close mail.txt: $! ";
}

down {
	print "downloading and extracting the files, please be patient...\n\n";
	# downloading the needed files and extracting them.
	for ( @files ) {
#		system("wget -P $dir $_") if $_ =~ /$year/;
		my $ur = $_;
		s/$url\///;
		getstore("$ur", "$dir/$_") or die "Unable to get page: $!";
	}
	system("gzip -d $dir/*.gz");
}

merge {
	my @file;
	# reading the files.

	opendir my $DIR, "$dir" or die "can't open direcory $dir: $! ";
	open my $FILE05, ">", "$dir$file_name" or die "can't open file $file_name: $! ";

	while ( my $file_name = readdir($DIR) ) {
		next if $file_name eq "." or $file_name eq "..";
		push @file, $file_name;
	}

	# writing the needed info for the stats.
	for ( @file ) {
		open my $FILE, "<", "$dir/$_" or die "can't open $_ : $! ";
		if ( $_ =~ /$year/ ) {
			while ( <$FILE> ) {
				say $FILE05 $_;
			}
		}
	}
	close $FILE05 or die "can't close file: $! ";
}

var {
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

stats {
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