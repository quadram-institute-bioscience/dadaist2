#!/usr/bin/env python3

 
class TaxonomyLabel():
    def __init__(self, name, rank="NA", score=0.0):
        self.name = name
        self.rank = rank
        self.score = score
    
    def __str__(self):
        return self.name + " (" + self.rank + ":" + str(self.score) + ")"

    def __repr__(self):
        return 'TaxonomyLabel(' + self.name + ", " + self.rank + ", " + str(self.score) + ")"
def parseDecipherTaxonomy(line):
    #Root [rootrank, 100.0%]; Bacteria [domain, 100.0%]; Proteobacteria [phylum, 75.3%]; Gammaproteobacteria [class, 75.3%]; Enterobacterales [order, 75.3%]; Enterobacteriaceae [family, 68.1%]; Escherichia-Shigella [genus, 62.0%]
    raw = line.split('; ')
    taxa = []
    for i in range(len(raw)):
        try:
            taxa.append( TaxonomyLabel( raw[i].split(' [')[0] , raw[i].split(' [')[1].split(',')[0], float(raw[i].split(' [')[1].split(', ')[1].split('%')[0])))
 
        except Exception as e:
            print("ERROR", e)
    return taxa

l = "Root [rootrank, 100.0%]; Bacteria [domain, 100.0%]; Proteobacteria [phylum, 75.3%]; Gammaproteobacteria [class, 75.3%]; Enterobacterales [order, 75.3%]; Enterobacteriaceae [family, 68.1%]; Escherichia-Shigella [genus, 62.0%]"
print(l)
print(parseDecipherTaxonomy(l))

def loadTaxonomyFromDecipher(file):
    '''
    Load taxonomy from decipher dump file.
    x
    ASV1	Root [rootrank, 100.0%]; Bacteria [domain, 100.0%]; Proteobacteria [phylum, 75.3%]; Gammaproteobacteria [class, 75.3%]; Enterobacterales [order, 75.3%]; Enterobacteriaceae [family, 68.1%]; Escherichia-Shigella [genus, 62.0%]
    ASV2	Root [rootrank, 100.0%]; Bacteria [domain, 100.0%]; Proteobacteria [phylum, 100.0%]; Alphaproteobacteria [class, 100.0%]; Rhizobiales [order, 100.0%]; Xanthobacteraceae [family, 97.2%]; unclassified_Xanthobacteraceae [genus, 97.2%]
    ASV3	Root [rootrank, 100.0%]; Bacteria [domain, 100.0%]; Bacteroidota [phylum, 100.0%]; Bacteroidia [class, 100.0%]; Bacteroidales [order, 100.0%]; Bacteroidaceae [family, 100.0%]; Bacteroides [genus, 100.0%]
    ASV4	Root [rootrank, 100.0%]; Bacteria [domain, 100.0%]; Proteobacteria [phylum, 100.0%]; Gammaproteobacteria [class, 100.0%]; Xanthomonadales [order, 100.0%]; Xanthomonadaceae [family, 100.0%]; Lysobacter [genus, 94.7%]
    ASV5	Root [rootrank, 97.9%]; Bacteria [domain, 97.9%]; Proteobacteria [phylum, 82.8%]; Gammaproteobacteria [class, 82.8%]; Enterobacterales [order, 82.8%]; Enterobacteriaceae [family, 77.5%]; unclassified_Enterobacteriaceae [genus, 77.5%]
    '''
    taxonomy = {}
    with open(file, 'r') as f:
        for line in f:
            line = line.strip().split('\t')
            if len(line) == 2:
                taxonomy[line[0]] = parseDecipherTaxonomy(line[1])
    return taxonomy

class MicrobiomeExperiment:
    def __init__(self, taxon, sample_count, sample_names):
        self.taxon = taxon
        self.sample_count = sample_count
        self.sample_names = sample_names

    def __repr__(self):
        return 'MicrobiomeExperiment(taxon={}, sample_count={}, sample_names={})'.format(self.taxon, self.sample_count, self.sample_names)