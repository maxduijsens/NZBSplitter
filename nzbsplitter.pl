#!/usr/bin/perl
use strict;
use warnings;

my $lastfile = "";
my $curfile = "";

open(IN, "<all.nzb");
open(OUT, ">>dummy");

while (my $line = <IN>) {
	# check if this is a new file
	if ($line =~ /<file poster=/) {
		# this line is a new file
		# close the old filehandle
		# close(OUT);
		# extract the rls name
		my $tmpline = $line;
		$tmpline =~ s/(.*?)&quot;//;
		$tmpline =~ s/&quot;.*//;
		# check whether this is a new rls
		$curfile = $tmpline;
		chomp($curfile);
		if ( $lastfile ne $curfile ) {
			#if they are equal set lastfile to this one
			# else close the old output file and open a new one
			print OUT "\n</nzb>";
			close(OUT);
			open(OUT, ">>", $curfile . ".nzb") or die "cannot open outfile $!";
			print OUT "<nzb xmlns=\"http://www.newzbin.com/DTD/2003/nzb\">\n";
		}
		$lastfile = $curfile;
	}

	#if its not a file line, write it to the current filehandle
	print OUT $line;

}
