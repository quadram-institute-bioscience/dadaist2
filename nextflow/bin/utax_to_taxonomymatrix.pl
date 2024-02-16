#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my ($input_file, $output_file);
my $sep = "\t";
my $header = "#TAXONOMY";
GetOptions(
    'a|input=s' => \$input_file,
    'output=s' => \$output_file,
    's|separator=s' => \$sep,
    'h|header=s' => \$header
);

if (not defined $input_file) {
    die "Usage: $0 -a input_file [-o output_file] [-s separator] [-h header]\n";
}
# If not output_file, print to STDOUT
open my $in_fh, '<', $input_file or die "Cannot open file $input_file: $!";
my $out_fh;
if (defined $output_file) {
    print STDERR "Info: writing to file $output_file\n";
    open $out_fh, '>', $output_file or die "Cannot open file $output_file: $!";
} else {
    print STDERR "Info: writing to STDOUT\n";
    open $out_fh, '>&STDOUT';
}
# Print header to the output CSV
print $out_fh "${header}${sep}Kingdom${sep}Phylum${sep}Class${sep}Order${sep}Family${sep}Genus${sep}Species\n";

while (my $line = <$in_fh>) {
    chomp $line;
    my ($seq_name, $taxonomy, undef, $short_taxonomy) = split /\t/, $line;
    my @levels = ('Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus', 'Species');
    my %tax_hash;
    foreach my $lvl (@levels) {
        $tax_hash{$lvl} = '';
    }

    if ($short_taxonomy =~ /^.:/) { # Check if taxonomy is provided
        print STDERR "$seq_name: $short_taxonomy\n";
        my @tax_parts = split /,/, $short_taxonomy;
        
        foreach my $part (@tax_parts) {
            if ($part =~ /(k|p|c|o|f|g|s):([^,]+)/) {
                my ($prefix, $name) = ($1, $2);
                my $level = "";
                if ($prefix eq 'k') {
                    $level = 'Kingdom';
                } elsif ($prefix eq 'p') {
                    $level = 'Phylum';
                } elsif ($prefix eq 'c') {
                    $level = 'Class';
                } elsif ($prefix eq 'o') {
                    $level = 'Order';
                } elsif ($prefix eq 'f') {
                    $level = 'Family';
                } elsif ($prefix eq 'g') {
                    $level = 'Genus';
                } elsif ($prefix eq 's') {
                    $level = 'Species';
                }
                $tax_hash{$level} = $name if $level;
            }
        }
    }

    # Format and print to CSV
    print $out_fh join($sep, $seq_name, map { $tax_hash{$_} } @levels) . "\n";
}

close $in_fh;
close $out_fh;

print STDERR "Conversion completed successfully.\n";
