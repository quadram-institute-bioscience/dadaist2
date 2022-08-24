---
sort: 19
---

## dadaist2-checkstats

Analyse the stats from DADA2 (called `dada2_stats.tsv` in the output directory) and evaluates at which step(s) or
sample(s) the reads are loste.

```text
usage: dadaist2-checkstats [-h] -i INPUT [-l LOSS] [--sample] [--all] [--keys KEYS] [--tmp TMP] [--log LOG] [--verbose]

Check DADA2 stats

optional arguments:
  -h, --help            show this help message and exit

Main:
  -i INPUT, --input INPUT
                        DADA2 stats table
  -l LOSS, --loss LOSS  Warn when loss is above this value [default: 0.33]
  --sample              Also check sample by sample
  --all                 Report loss for all the steps
  --keys KEYS           Comma separated headers [default: input,filtered,denoised,merged,non-chimeric]
  --tmp TMP             Temporary directory

Other parameters:
  --log LOG             Log file
  --verbose             Verbose mode

```

## Input file

The input file is a TSV file produced by DADA2 via Dadaist2:

Sample   | input | filtered | denoised  |  merged   | non-chimeric
--------------------|-------:|----------:|------------:|-----------:|-----------
M0614DD2plus165     | 254245  |225049  |225049  |35382   |35114
M0614DD2plus45      | 296332  |281027  |281027  |12126   |12114
M0614DD3plus120     |2879433 |2706733 |2706733 |124381  |123007

## Output

When running with default parameters, the output is a JSON file, that will report the steps where the loss is 
bigger than `--loss FLOAT`:

Example:

```json
{
    "failed_steps": {
        "merged": 4.865372188100686
    }
}
```

Adding `--sample` will *also* report the loss for each sample:

```json
{
    "failed_steps": {
        "merged": 4.865372188100686
    },
    "failed_by_sample": {
        "input": [],
        "filtered": [
            "M0614GD3plus120"
        ],
        "denoised": [],
        "merged": [
            "M0614DD2plus165",
            "M0614DD2plus45",
            "M0614DD3plus120",
        ],
        "non-chimeric": []
    }
}
```
