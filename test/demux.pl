#!/usr/bin/env perl 

use 5.012;
use warnings;
use FASTX::Reader;
use Getopt::Long;
my $opt_r1;
my $opt_r2;
my $opt_basename;
my $MAX_MISMATCHES = 3;

my %validbc = (
#  'AAGTGGCTATCC' => 1,
#  'GTTCACGCCCAA' => 1,
#  'CGTTCCTTGTTA' => 1,
  'GGATAGCCACTT' => 2,
  'TTGGGCGTGAAC' => 2,
  'TAACAAGGAACG' => 2,
);

GetOptions(
  '1=s'              => \$opt_r1,
  '2=s'              => \$opt_r2,
  'o=s'              => \$opt_basename,
  'max-mismatches=i' => \$MAX_MISMATCHES,
) || die "Invalid parameters\n";

my $R1 = FASTX::Reader->new({ filename => "$opt_r1" });
my $R2 = FASTX::Reader->new({ filename => "$opt_r2" });

# Initialize
my $t = 0;
my $p = 0;
my $x = 0;

while (my $s1 = $R1->getRead() ) {
  my $s2 = $R2->getRead();
  my ($tag1) = $s1->{name} =~/#([A-Z]+)/;
  my ($tag2) = $s2->{name} =~/#([A-Z]+)/;
  $t++;
  my $tag = findPrimer($tag1);
  $x++ if (not defined $validbc{$tag1} and defined $validbc{$tag});
  if (defined $validbc{$tag}) {
    $p++;
    say STDERR sprintf("%.2f", 100*$p/$t), " printed [$x]..." unless ($p % 1000);
    open (my $O1, '>>', "${opt_basename}_${tag}_R1.fq") || die;
    open (my $O2, '>>', "${opt_basename}_${tag}_R2.fq") || die;
    say {$O1} '@', $s1->{name}, "\n", $s1->{seq}, "\n+\n", $s1->{qual};
    say {$O2} '@', $s2->{name}, "\n", $s2->{seq}, "\n+\n", $s2->{qual};
    close $O1;
    close $O2;
  }
   

  
}

sub findPrimer {
  my $s = shift @_;
  my $max = 0;
  my $return = '';
  for my $ref (sort keys %validbc) {
    my $m = matchString($s, $ref);
    if ($m > $max) {
      $max = $m;
      $return = $ref;
    }
  }
  return $return;
}
sub matchString {
  my ($s, $z) = @_;
  my $matches = 0;
  my $mismatches = 0;
  for (my $i = 0; $i < length($s); $i++ ) {
    my $char1 = substr( $s, $i, 1 );
    my $char2 = substr( $z, $i, 1 );
    if ($char1 eq $char2) {
      $matches++;
    } else {
      $mismatches++;
    }

    if ($mismatches >= $MAX_MISMATCHES) {
      return 0;
    }
  }
  return $matches;
}