use 5.012;
my $fh;
if ($ARGV[0]) {
	say ">>$ARGV[0]";
	open ($fh, '<', "$ARGV[0]") || die $!;
} else {
	$fh = *STDERR;
}


say {$fh} "print this line";
