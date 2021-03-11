/*
   This is an example workflow based on USEARCH 
*/
params.reads = "$baseDir/reads/*_R{1,2}*.fastq.gz"


params.outdir = "usearch"
params.singleEnd = false

// FASTQ Merge: very conservative defaults
params.merge_minoverlap = 40
params.merge_maxdiffs   = 60
params.merge_pctid      = 80
params.merged_min_lines = 20000 // 5000 reads 
params.minmerged        = 6000 

// FASTQ filter: very conservative defaults
params.maxee            = 1
params.trimprimer1      = 22
params.trimprimer2      = 22
params.cpus             = 8

// taxonomy
params.tax_cutoff       = 0.8

params.featurename      = 'seq_';
params.rarefy           = 10000;
params.maxreads         = 100000;

log.info """\
  Example USEARCH / DADAIST2 pipeline
 =======================================
 taxonomy db  : ${params.ref}
 reads        : ${params.reads}
 outdir       : ${params.outdir}

 global-cores : ${params.cpus}
 merge        : overlap=${params.merge_minoverlap};maxDiffs=${params.merge_maxdiffs};pctId=${params.merge_pctid}%;
 quality      : maxEE=${params.maxee};trim=${params.trimprimer1}F-${params.trimprimer2}R;
 """

//ch_multiqc_config = file("$baseDir/assets/multiqc_config.yaml", checkIfExists: true)

Channel
        .fromFilePairs( params.reads, size: params.singleEnd ? 1 : 2 )
        .ifEmpty { exit 1, "Cannot find any reads matching: ${params.reads}\nNB: Path needs to be enclosed in quotes!\nNB: Path requires at least one * wildcard!\nIf this is single-end data, please specify --singleEnd on the command line." }
        .into { read_pairs_ch; read_pairs2_ch;  }
 
if (params.ref) {
    Channel.fromPath("${params.ref}", checkIfExists: true)
           .set { taxref_ch }
}

process mergepairs {
    tag "$name"
    label 'filt'
    publishDir path:"${params.outdir}/qc/", mode: "copy",
        saveAs: {it.indexOf(".html") > 0 ? it : null}
 

    input:
    set val(name), file(reads)  from read_pairs_ch

    output:
    file("*.mrg.fq") into mrg_ch
    file("*.html")   into reports_ch
    file("*.json")   into jsonqc_ch

    script:
    """
    fastp --in1 ${reads[0]} --in2 ${reads[1]} \
          --out1 ${name}_pre_R1.fq --out2 ${name}_pre_R2.fq \
          --trim_front1  ${params.trimprimer1} --trim_front2  ${params.trimprimer2} \
          --html ${name}.fastp.html --json ${name}.fastp.json -R "QC for Sample ${name}" \
          -w ${task.cpus}

    usearch -filter_phix ${name}_pre_R1.fq -reverse ${name}_pre_R2.fq \
         -output ${name}_trim_R1.fq -output2 ${name}_trim_R2.fq \
         -threads ${task.cpus} 
    
    usearch -fastq_mergepairs ${name}_trim_R1.fq  \
        -reverse ${name}_trim_R2.fq \
        -threads ${task.cpus} \
        -fastq_minovlen ${params.merge_minoverlap} \
        -fastq_maxdiffs ${params.merge_maxdiffs} \
        -fastq_pctid    ${params.merge_pctid} \
        -relabel \$(basename ${reads[0]} | sed 's/-/~/g' |  sed 's/\\./~/g' | cut -f 1 -d _ ). \
        -fastqout ${name}.mrg.fq 

    rm *_trim_R?.fq *_pre_R?.fq
    """
}

process collect_merged {
    label 'hiend'

    input:
    file input_files        from mrg_ch.collect()

    output:
    file "filtered.fasta"   into filtered_ch
    file "merged.fastq"     into merged_reads_ch

    script:
    """
    echo Collect merged: merged.fastq
    for FILE in $input_files;
    do 
        if [[ \$(cat  \$FILE | wc -l) -gt ${params.merged_min_lines} ]]; then
          cat "\$FILE" >> merged.fastq
        fi
    done
    
    echo Filter: filtered.fasta
    usearch -fastq_filter merged.fastq \
        -threads ${task.cpus} \
        -fastq_maxee ${params.maxee} \
        -fastq_maxns 0 \
        -relabel flt. \
        -fastaout filtered.fasta

    """
}




process uniq_asv {
    label 'hiend'
    publishDir params.outdir, mode: "copy"

    input:
    file filt  from filtered_ch
 

    output:
    file "asv.fasta" into asv_ch
     
    script:
    """
    usearch -fastx_uniques ${filt} -threads ${task.cpus} -sizeout -relabel s_ -fastaout uniq.fa
    usearch -unoise3 uniq.fa -zotus asv.fasta
    sed -i 's/Zotu/${params.featurename}/' asv.fasta
    rm uniq.fa
    
    """
}

process otutab_raw {
    label 'hicpu'
    tag "cores:${task.cpus}"

    publishDir params.outdir, mode: "copy",
        saveAs: {it.indexOf(".csv") > 0 ? it : null}

    input:
    file reads  from merged_reads_ch
    file repseq from asv_ch
 

    output:
    file "otutab_raw.tsv" into otutab_raw_ch
    file "otutab_raw.csv" into otutab_csv_ch

    script:
    """
    usearch -otutab ${reads} -otus ${repseq} -threads ${task.cpus} \
        -otutabout otutab_raw.tsv

    sed 's/OTU ID/NAME/' otutab_raw.tsv | sed 's/\t/,/g' > otutab_raw.csv
    """
}

process otutab {
    label 'hiend'
    publishDir params.outdir, mode: "copy"

    input:
    file otutab from otutab_raw_ch
 

    output:
  
    file "otutab*.tsv" into otutab_norm_ch
    file "otutab_freq.tsv" into relative_ch

    script:
    """
    # Sorts OTUs by decreasing total count.
    usearch -otutab_sortotus ${otutab} -output otutab_sort.tsv

    # Identify and filter cross-talk in an OTU table using the UNCROSS2 algorithm.
    dadaist2-crosstalk --input otutab_sort.tsv --output otutab.tsv

    # Convert OTU table from counts to frequencies. 
    usearch -otutab_counts2freqs otutab.tsv -output otutab_freq.tsv

    # Remove low-abundance counts, samples and OTUs from an OTU table
    usearch -otutab_trim otutab.tsv -min_count 3 -min_otu_size 10  -output otutab_uncross_clean.tsv
    
    usearch -otutab_rare otutab_uncross_clean.tsv -sample_size ${params.rarefy} -output otutab_rare_${params.rarefy}.tsv
    
    rm otutab_sort.tsv
    """
}
process dendrogram {
    input:
    file("table.tsv") from relative_ch

    output:
    file("dendrogram.png") optional true into dendro_ch

    script:
    """
    hclust.py -o dendrogram.png table.tsv
    """
}
process taxonomy {
    label 'hiend'

    input:
    file repseq    from asv_ch
    file 'db.udb'  from taxref_ch
    
    output:
    file "taxonomy_sintax.tsv" into taxonomyraw_ch

    script:
    """
    usearch -sintax ${repseq} -db db.udb \
        -threads ${task.cpus} -tabbedout taxonomy_sintax.tsv \
        -strand both -id ${params.tax_cutoff}

  
    """
}

process refine_taxonomy {
    input:
    file taxonomy    from taxonomyraw_ch


    output:
    file "taxonomy_raw.tsv" into taxonomy_ch, taxonomytab_ch

    //    #g:Escherichia-Shigella
    script:
    """
    cat ${taxonomy} | perl -ne '
    my @fields = split /\\t/, \$_;
    print \$_ if (\$fields[3]);
    ' > taxonomy_raw.tsv
    """
}
process taxonomy_tab {
    publishDir params.outdir, mode: "copy"

    input:
    file taxonomy from taxonomytab_ch

    output:
    file "taxonomy.*" into taxonomy_tabs

    script:
    """
    utax_to_taxonomymatrix.pl  -s , -h '#TAXONOMY' -a $taxonomy > taxonomy.csv
    utax_to_taxonomymatrix.pl       -h '#TAXONOMY' -a $taxonomy > taxonomy.tsv

    """
}

 process taxonomy_ranks {
    publishDir path:"${params.outdir}/ranks_tables", mode: "copy"

    input:
    file repseq    from asv_ch
    file otutab    from otutab_raw_ch
    file taxonomy  from taxonomy_ch

    output:
    file "ranks.zip" into taxonomy_ranks_ch
    

    script:
    """


    usearch -sintax_summary ${taxonomy} -otutabin ${otutab} \
        -output taxonomy_phylum.tsv -rank p
    
    
    usearch -sintax_summary ${taxonomy} -otutabin ${otutab} \
        -output taxonomy_class.tsv -rank c

    

    usearch -sintax_summary ${taxonomy} -otutabin ${otutab} \
        -output taxonomy_family.tsv -rank f

    
    
    usearch -sintax_summary ${taxonomy} -otutabin ${otutab} \
        -output taxonomy_genus.tsv -rank g
    
    zip ranks.zip *.tsv
    """
}

process summary_taxa {

    input:
    file "ranks.zip" from taxonomy_ranks_ch

    output:
    file "tables/*.tsv" into summary_ch

    script:
    """
    mkdir -p tables
    unzip ranks.zip
    transpose.py -t 5     taxonomy_phylum.tsv > tables/phylum.tsv
    transpose.py -g -t 7 taxonomy_class.tsv   > tables/class.tsv
    transpose.py -g -t 7 taxonomy_family.tsv  > tables/family.tsv
    transpose.py -g -t 7 taxonomy_genus.tsv   > tables/genus.tsv
    
    """
} 
//
//head -n 1 otutab_raw.csv | sed 's/,/\n/g' | perl -ne 'chomp;print "$_,SampleType\n"'
workflow.onComplete {
    log.info summary.collect { k,v -> "${k.padRight(18)}: $v" }.join("\n")
    log.info ( workflow.success ? 
        "\nDone! The results are saved in --> $params.outdir/\n" : 
        "Oops .. something went wrong" )
}