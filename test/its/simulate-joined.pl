use 5.012;
use FASTX::Reader;
my $len = 300;
my $stretch = 6;
my $F = FASTX::Reader->new({filename => $ARGV[0] }) || die;
while (my $s = $F->getRead() ) {
 say '>', $s->{name}, "\n",
   substr($s->{seq}, 0, $len), 'N' x $stretch, substr($s->{seq}, -1 * $len);
}
