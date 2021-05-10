use 5.012;
use Getopt::Long;
use FASTX::Reader;
# parse a fasta file and print it as [>>>]nnn[<<<]

my $len = 300;
my $stretch = 6;

GetOptions(
  'l|len=i' => \$len,
  'n=i'     => \$stretch,
);

my $F = FASTX::Reader->new({filename => $ARGV[0] }) || die;
while (my $s = $F->getRead() ) {
 say '>', $s->{name}, "\n",
   substr($s->{seq}, 0, $len), 'N' x $stretch, substr($s->{seq}, -1 * $len);
}
