# sanger-tol/tiara_fcsgx_analysis: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.1.0dev - Kraft Paper [unreleased]

Initial release of sanger-tol/tiara_fcsgx_analysis, created with the [nf-core](https://nf-co.re/) template.

### `Added`

- Added the `nf-core/fasta_clean_faidx` subworkflow
    - This includes the `nf-core` modules `SAMTOOLS_FAIDX`, `SAMTOOLS_DICT`, `SEQKIT_REPLACE`, `SEQKIT_SEQ` and `GUNZIP`
- Added `nf-core/tiara/tiara` module
- `--sample` parameter to specify the sample name
- `--fasta` parameter to specify the FASTA file
- `--taxid` parameter to specify the taxid
- Added `sanger-tol/fcsgx_parsecsv` subworkflow
    - This includes the `sanger-tol` modules `FCSGX_RUNGX`, `FCSGX_PARSERESULTS` and `AUTOFILTER_AUTOFILTER`
- `--fcs_gx_database_path` parameter to specify the FCSGX database path
- `--ncbi_ranked_lineage_path` parameter to specify the NCBI ranked lineage path
- Adopted the workflow_output system

### `Dependencies`

| Module | Tool | Old Version | New Version |
|--------|------|-------------|-------------|
| `TIARA_TIARA` | `tiara` | `NA` | `1.0.3` |
| `SAMTOOLS_FAIDX` | `samtools` | `NA` | `1.24` |
| `SAMTOOLS_DICT` | `samtools` | `NA` | `1.24` |
| `SEQKIT_REPLACE` as `SEQKIT_DOTS` | `seqkit` | `NA` | `2.13.0` |
| `SEQKIT_SEQ` | `seqkit` | `NA` | `2.13.0` |
| `GUNZIP` | `gunzip` | `NA` | `1.13.0` |
| `FCSGX_RUNGX` | `fcsgx` | `NA` | `0.5.5` |
| `FCSGX_PARSERESULTS` | `fcsgx` | `NA` | `1.1.0` |
| `FCSGX_PARSERESULTS` | `python` | `NA` | `3.14.3` |
| `AUTOFILTER_AUTOFILTER` | `autofilter` | `NA` | `1.1.0` |
| `AUTOFILTER_AUTOFILTER` | `python` | `NA` | `3.14.3` |
