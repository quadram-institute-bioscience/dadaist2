#!/usr/bin/env python3 
import os, sys
import json
import logging
import urllib.request
import hashlib
from rich.logging import RichHandler
import concurrent.futures
import dadaister


# Set program version
__version__ = '2.0'


 

# Set database in JSON format for interoperability
databases_json = """{
   "dada2-refseq-2020" : {
      "desc" : "RefSeq+RDP: This database contains 22433 bacterial, 1055 archaea and 99 eukaryotic full lengths16S  (19/07/2020)",
      "url" : "https://zenodo.org/record/4409439/files/RefSeq_16S_6-11-20_RDPv16_Genus.fa.gz?download=1",
      "md5" : "53aac0449c41db387d78a3c17b06ad07",
      "ver" : "2020-07",
      "c"    : "Alishum 2021",
      "cite" : "Ali Alishum. (2021). DADA2 formatted 16S rRNA gene sequences for both bacteria & archaea (Version Version 4.1) [Data set]. Zenodo. http://doi.org/10.5281/zenodo.4409439"
   },
   "dada2-hitdb" : {
      "md5" : "1a94d81644a76e513f486a5901a78a1b",
      "ver" : "v1.00",
      "url" : "https://zenodo.org/record/159205/files/hitdb_v1.00.fa.gz?download=1",
      "desc" : "HITdb is a reference taxonomy for Human Intestinal 16S rRNA genes",
      "c": "Ritari 2015",
      "cite" : "Ritari J, Salojärvi J, Lahti L & de Vos WM. Improved taxonomic assignment of human intestinal 16S rRNA sequences by a dedicated reference database. BMC Genomics. 2015 Dec 12;16(1):1056. doi: 10.1186/s12864-015-2265-y."
   },
   "decipher-silva-138" : {
      "md5" : "cb983b6a5e8cdb46f8c88b5afae21f66",
      "ver" : "138",
      "desc" : "SILVA release 138 (Decipher)",
      "url" : "http://www2.decipher.codes/Classification/TrainingSets/SILVA_SSU_r138_2019.RData",
      "c":     "Quast 2013",
      "cite" : "Quast C, Pruesse E, Yilmaz P, Gerken J, Schweer T, Yarza P, Peplies J, Glöckner FO (2013) The SILVA ribosomal RNA gene database project: improved data processing and web-based tools.  ucl. Acids Res. 41 (D1): D590-D596."
   },
   "dada2-unite" : {
      "c": "Nilsson 2018",
      "cite" : "Nilsson RH, Larsson K-H, Taylor AFS, Bengtsson-Palme J, Jeppesen TS, Schigel D, Kennedy P, Picard K, Glöckner FO, Tedersoo L, Saar I, Kõljalg U, Abarenkov K. 2018. The UNITE database for molecular identification of fungi: handling dark taxa and parallel taxonomic classifications. Nucleic Acids Research",
      "url" : "https://github.com/quadram-institute-bioscience/dadaist2/releases/download/v0.7.3/uniref.fa.gz",
      "desc" : "UNITE database for ITS",
      "md5" : "ac09ed60363790ffbd2c0fa67f681107",
      "ver" : "2020"
   },
   "dada2-gtdb-2018" : {
      "c"    : "Alishum 2019",
      "cite" : "Ali Alishum. (2019). DADA2 formatted 16S rRNA gene sequences for both bacteria & archaea (Version Version 1) [Data set]. Zenodo. http://doi.org/10.5281/zenodo.2541239",
      "ver" : "2018-11",
      "md5" : "307c9d79fb7e167b696fad16f698eb57",
      "url" : "https://zenodo.org/record/2541239/files/GTDB_bac-arc_ssu_r86.fa.gz?download=1",
      "desc" : "GTDB 20486 bacteria and 1073 archaea full 16S rRNA gene sequences. (20/11/2018)"
   },
   "decipher-unite-2020" : {
      "ver" : "2020",
      "md5" : "72a18bf939bcd30bedf7a7edd2d907f1",
      "url" : "http://www2.decipher.codes/Classification/TrainingSets/UNITE_v2020_February2020.RData",
      "desc" : "UNITE 2020 (Decipher)",
      "c"    : "Nilsson 2018",
      "cite" : "Nilsson RH, Larsson K-H, Taylor AFS, Bengtsson-Palme J, Jeppesen TS, Schigel D, Kennedy P, Picard K, Glöckner FO, Tedersoo L, Saar I, Kõljalg U, Abarenkov K. 2018. The UNITE database for molecular identification of fungi: handling dark taxa and parallel taxonomic classifications. Nucleic Acids Research"
   },
   "dada2-gtdb-2020" : {
      "c"    : "Alishum 2021",
      "cite" : "Ali Alishum. (2021). DADA2 formatted 16S rRNA gene sequences for both bacteria & archaea (Version Version 4.1) [Data set]. Zenodo. http://doi.org/10.5281/zenodo.4409439",
      "desc" : "GTDB 21965 bacteria and 1126 archaea full 16S rRNA gene sequences. (19/07/2020)",
      "url" : "https://zenodo.org/record/4409439/files/GTDB_bac120_arc122_ssu_r95_Genus.fa.gz?download=1",
      "md5" : "2f8bc3fee2ccde9d94f0bbdcfd92e809",
      "ver" : "2020-07"
   },
   "testset" : {
      "desc" : "FASTQ input, Small 16S dataset to test the suite",
      "url" : "https://github.com/quadram-institute-bioscience/dadaist2/releases/download/v0.1.04/data.zip",
      "ver" : "1.0",
      "md5" : "719c15308bcb67986e03df5c5ab14be4",
      "cite": ""
 },
   "dada2-rdp-train-16" : {
      "c": "Cole 2014",
      "cite" : "Cole, J. R., Q. Wang, J. A. Fish, B. Chai, D. M. McGarrell, Y. Sun, C. T. Brown, A. Porras-Alfaro, C. R. Kuske, and J. M. Tiedje. 2014. Ribosomal Database Project: data and tools for high throughput rRNA analysis Nucl. Acids Res. 42(Database issue):D633-D642; doi: 10.1093/nar/gkt1244 ",
      "ver" : "16",
      "md5" : "cac51b436f1679fefc9a1db1d3b24686",
      "desc" : "RDP taxonomic training data formatted for DADA2 (RDP trainset 16/release 11.5)",
      "url" : "https://zenodo.org/record/801828/files/rdp_train_set_16.fa.gz?download=1"
   },
   "dada2-silva-138" : {
      "c" : "Quast 2013",
      "cite" : "Quast C, Pruesse E, Yilmaz P, Gerken J, Schweer T, Yarza P, Peplies J, Glöckner FO (2013) The SILVA ribosomal RNA gene database project: improved data processing and web-based tools. Nucl. Acids Res. 41 (D1): D590-D596. ",
      "md5" : "1deeaa2ecc9dbeabdcb9331a565f8343",
      "ver" : "138",
      "url" : "https://zenodo.org/record/3731176/files/silva_nr_v138_train_set.fa.gz?download=1",
      "desc" : "SILVA release 138"
   },
   "decipher-gtdb95" : {
      "url" : "http://www2.decipher.codes/Classification/TrainingSets/GTDB_r95-mod_August2020.RData",
      "desc" : "GTDB",
      "md5" : "7d926cc5f95f3eca1bef31d54b0ed2b8",
      "ver" : "r95 (aug2020)",
      "c" : "Chaumeil 2019",
      "cite" : "Chaumeil, P.-A, et al. (2019). GTDB-Tk: a toolkit to classify genomes with the Genome Taxonomy Database. Bioinformatics,"
   }
}"""

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

# logging.basicConfig(
#     level="NOTSET",
#     #format="{asctime} {levelname:<9} {name:<9} - {message} ({funcName})",
#     format="[italic]{name:<9}[/] {message} ({funcName})",
#     style="{",
#     filename="dadaist2-getdb.log",
#     #filemode="a",
#     )
# logger = logging.getLogger(name=__name__)
#
# consolog = logging.getLogger()
# logger.basicConfig(level="DEBUG")

# check MD5 of a file
def check_md5(fname):
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()



# Download URL to FILEPATH destination
def download(url, destdir, md5=None):
    destBasename = os.path.basename(url).split("?")[0]
    filepath = os.path.join(destdir, destBasename)
    #print("Downloading {} to {}".format(url, filepath))
    if md5 and os.path.exists(filepath) and md5 is not None:
        term_logger.info("{} found: checking integrity".format(destBasename), extra={"markup": True})
        if check_md5(filepath) == md5:
            term_logger.info(":white_check_mark: {} found and verified!".format(destBasename), extra={"markup": True})
            return filepath
        term_logger.info(":warning: File found but MD5 does not match", extra={"markup": True})

    try:
        term_logger.info(":checkered_flag: Downloading {}...".format(url, filepath), extra={"markup": True})
        urllib.request.urlretrieve(url, filepath)
        if md5:
            if check_md5(filepath) == md5:
                term_logger.info(":white_check_mark: {} downloaded".format(destBasename), extra={"markup": True})
            else:
                term_logger.error(":warning: {} downloaded but failed MD5 check".format(destBasename), extra={"markup": True})
                return False
    except Exception as e:
        term_logger.error(":warning: Downloading {} to {} failed with exception {}".format(url, filepath, e), extra={"markup": True})
        return False
    return True

def printProgramTitleBoxed(title):
    from rich.panel import Panel
    console.print()
    console.print(Panel("  [white]{title}[/]   ".format(title=title), style="cyan", title="Dadaist2"), justify="left")
if __name__ == "__main__":

    # User home directory
    default_outdir = os.path.join(os.path.expanduser("~"), "refs")

    #   if exists default_outdir
    if os.path.exists(default_outdir):
        default_logfile = os.path.join(default_outdir, "dadaist2-getdb.log")
    else:
        default_logfile = os.path.join("dadaist2-getdb.log")

    import argparse
    from rich.console import Console
    from rich.table import Table
    console = Console()
    
    # Arguments
    parser = argparse.ArgumentParser(description="Download databases for Dadaist2")
    parser.add_argument("-d", "--database", help="Database code")
    parser.add_argument("-l", "--list", action="store_true", help="List databases")
    parser.add_argument("-q", "--query", help="Query string for databases, to be used with --list or alone (instead of --database)")
    parser.add_argument("-o", "--output-dir", dest="outdir", help="Output directory", default=default_outdir)
    parser.add_argument("--full", action="store_true", help="Print full citation")
    parser.add_argument("--logfile", help="Log file", default=default_logfile)
    parser.add_argument("--version", action="version", version="%(prog)s " + __version__)
    parser.add_argument("--verbose", "-v", action="count", default=0, help="Increase verbosity")
    opts = parser.parse_args()

    printProgramTitleBoxed("dadaist2-getdb v{}".format(__version__))
    # Set logger 
    logging.basicConfig(filename=opts.logfile, filemode="a", format="%(asctime)s - %(levelname)s: %(name)s > %(message)s")
    term_logger = logging.getLogger(__name__)
    term_logger.setLevel(logging.INFO)
    term_logger.addHandler(RichHandler(console=console))

    # parse databases_json from JSON
    try:
        dbs = json.loads(databases_json)
    except Exception as e:
        term_logger.error("Error parsing databases.json: %s" % e)
        term_logger.error(databases_json)
        sys.exit(1)

    if opts.list:
        c = 0
        
        table = Table(show_header=True, header_style="bold cyan")
        table.add_column("Code", style="bold", width=22)
        table.add_column("Description")
        #table.add_column("URL")
        table.add_column("Paper")

       
        
        # Print databases
        for db in dbs:
            if opts.query and (opts.query.lower() not in db.lower()):
                continue
            c += 1
            #console.print("[bold white on blue] {db:<20} [/] [green]({c})[/] {desc}\n   [italic]url[/]: {url}\n   [italic]cite[/]: {cite}\n".format(c=c, db=db, desc=dbs[db]["desc"], cite=dbs[db]["cite"], url=dbs[db]["url"])  )
            table.add_row(
                db,
                dbs[db]["desc"],
                #dbs[db]["url"],
                dbs[db]["cite"] if opts.full else dbs[db]["c"] if "c" in dbs[db] else "",
            )
        console.print(table)
        sys.exit(0)
    else:
        # Get databases


        # Check output directory, try to make it
        if not os.path.exists(opts.outdir):
            try:
                os.makedirs(opts.outdir)
            except Exception as e:
                term_logger.error("Error creating output directory: %s" % e)
                sys.exit(1)

        if opts.query or opts.database:
            urls = {}
            for db in dbs:
                if (opts.query == "all") or (opts.database and db == opts.database) or (opts.query  and (opts.query.lower() in db.lower() )):
                    urls[ dbs[db]["url"] ] = dbs[db]["md5"]
            if not urls:
                term_logger.error("No databases to download!")
            else:
                # Concurrently download databases
                with console.status("[bold]Dadaist2[/] - Getting databases", spinner="point"):
                    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
                        futures = [executor.submit(download, url, os.path.join(opts.outdir), urls[url]) for url in urls]

        else:
            # Print usage from argparse

            parser.print_help()
            eprint()
            eprint("Use --list to print a list of available databases (add --query STR to filter).")
            eprint("To download, use --query STR to download multiple databases ('all' is  supported) or --database ID to download one.")
            sys.exit(0)
