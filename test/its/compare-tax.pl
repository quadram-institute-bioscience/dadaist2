#!/usr/bin/env perl
use 5.026;
use warnings;


my $c = 0;
my $wrong = 0;

while (my $line=<STDIN>) {
    $c++;
    next if ($c==1);
    
    chomp($line);
	my @f = split /\t/, $line;
    if (compareStrings(@f)) {
    	say "<OK>", removeLast($f[0])
    } else {
    	$wrong++;
    	say "$c <ERR>", removeLast($f[0]);
    	for (my $i = 0; $i <= $#f; $i++) {
    		say $ARGV[$i] // $i, "\t", removeLast( $f[$i] ) 
    	}
    }
}

# Do not count header
$c--;
say "$wrong/$c errors\n";
die if ($wrong);

sub compareStrings {
	my $first = shift @_;
    my $last = 0;
    my @fArray = split /\s+/, $first;

    for (my $i = 0; $i < $#fArray; $i++) {
    	last if ($fArray[$i] eq 'NA' or $fArray[$i] eq 'unidentified');
    	$last = $i;
    }
	
    @fArray = @fArray[0 .. $last];
    
	for my $item (@_) {
       my @iArray = split /\s+/, $item;
       @iArray = @iArray[0 .. $last];
       my $refString = join(' ', @fArray);
       my $iString   = join(' ', @iArray);
	   if ($refString ne $iString) {
	   	say STDERR 'a. ', $refString, "\t:\t", $first, "(", @fArray ,")";
	   	say STDERR 'b. ', $iString, "\t:\t", $item;
	   	say STDERR "i. $last";
	   	return 0;
	   }
	}
	return 1
}

sub removeLast {
	my $s = shift @_;
	$s =~s/\s\S+$//;
	return $s;
}
