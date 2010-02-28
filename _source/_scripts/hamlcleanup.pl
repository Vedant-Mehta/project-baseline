#!/usr/bin/perl
# This file kindly written by Nate Weaver of http://derailer.org/
use strict;
use warnings;
use Fcntl 'SEEK_SET';

undef $/;

my @files = @ARGV;

for (@files) {
	my $intag = 0;
	
	open FILE, '+<:utf8', $_;
	
	my $in = <FILE>;
	
	# $in =~ s/  /\t/g;
	my $len = length $in;
	my $out = '';
	
	for (my $i = 0; $i < $len; ++$i) {
		my $c = substr $in, $i, 1;
				
		if ($c eq '<') {
			$intag = 1;
			$out .= $c;
		} elsif ($c eq '>') {
			$intag = 0;
			$out .= $c;
		} elsif ($intag && $c eq '\'') {
			$out .= '"';
		} else {
			$out .= $c;
		}
	}
	
	seek FILE, 0, SEEK_SET;
	truncate FILE, 0;
	
	print FILE $out;
	close FILE;
}