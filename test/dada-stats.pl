#!/usr/bin/env perl
use 5.022;
use Data::Dumper;
my $file = $ARGV[0];

die "Missing stats file.\n" unless (-e "$file");

my $data = stats_check($file, 0.5);
print Dumper $data;
sub stats_check {
  my ($file, $maxloss) = @_;
  my $data;
  my @labels = ('input'  ,'filtered'  ,'denoised'  ,'merged'  ,'non-chimeric');
  my $I;
  if (not open ( $I, '<', $file) ) {
    $data->{pass} = 0;
    $data->{label} = 'fileNotFound';
  }
  my $c = 0;
  my %counts = ();
  my %loss   = (); 
  
  $data->{pass} = 1;
  $data->{step} = '';
  $data->{percentage};

  # Parse DADA2 stats
  while (my $line = readline($I)) {
    chomp($line);
    $c++;
    my @fields = split /\t/, $line;
    if ($c == 1) {  
      #x,input,filtered,denoised,merged,non-chimeric
      return 0 if ($fields[1] ne 'input' and $fields[4] ne 'merged');
    } else {
      my $sample = shift @fields;

      for my $label (@labels) {
        $counts{$label} += shift @fields;
      }
    }
  }

  # Check at each step the data loss
  for my $label (@labels) {
    $loss{$label} += $counts{$label} / $counts{'input'} if ($counts{'input'});
    if ($loss{$label} < $maxloss) {
      $data->{pass} = 0;
      $data->{step} = $label;
      $data->{percentage} = sprintf("%.4f", 100 * $counts{$label} / $counts{'input'});
    } 
    $data->{"reads_$label"} = $counts{$label};
  }

  # Set data loss if pass
  if ($data->{pass} == 1) {
    $data->{step} = 'non-chimeric';
    $data->{percentage} = sprintf("%.4f", 100 * $counts{$data->{step}} / $counts{'input'}) if ($counts{'input'});
  }

  
  return $data;
}