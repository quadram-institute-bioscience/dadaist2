
params.reads = "$baseDir/reads/*_R{1,2}*.fastq.gz"
params.outdir = "dadaist"
params.singleEnd = false

// FASTQ Merge: very conservative defaults
params.forward   = "CCTACGGGNGGCWGCAG"
params.reverse   = "GGACTACHVGGGTATCTAATCC"
params.ref       = "" 
 

log.info """\
  Example pipeline
 =======================================
 taxonomy db  : ${params.ref}
 reads        : ${params.reads}
 outdir       : ${params.outdir}
 
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

process cutadapt {
    tag "$name"
    label 'filt'

    input:
    set val(name), file(reads)  from read_pairs_ch

    output:
    file("filtered/*.gz") into cutadapted_ch
 
    script:
    """
    mkdir -p filtered
    ForRC=\$(seqfu rc "${params.forward}" | tail -n 1)
    RevRC=\$(seqfu rc "${params.reverse}" | tail -n 1)
    F="${params.forward}...\${RevRC}"
    R="${params.reverse}...\${ForRC}"
    cutadapt -a "\${F}" -A "\${R}" --discard-untrimmed -o filtered/${name}_R1.fastq.gz -p filtered/${name}_R2.fastq.gz ${reads[0]} ${reads[1]}
    
    """
}

process dada {
    label 'hiend'

    input:
    file input_files        from cutadapted_ch.collect()
    file "*"                from taxref_ch
    output:
    file "dada"             into dadaist_ch
    

    script:
    """
     
    dadaist2 -i ./ -o dada -d *.gz *.RData -t ${task.cpu} 

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