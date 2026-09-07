/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { FASTA_CLEAN_FAIDX      } from '../subworkflows/nf-core/fasta_clean_faidx/main'
include { TIARA_TIARA            } from '../modules/nf-core/tiara/tiara/main'
include { FCSGX_PARSECSV         } from '../subworkflows/sanger-tol/fcsgx_parsecsv/main'
include { AUTOFILTER_AUTOFILTER  } from '../modules/sanger-tol/autofilter/autofilter/main'

include { paramsSummaryMap       } from 'plugin/nf-schema'
include { softwareVersionsToYAML } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText } from '../subworkflows/local/utils_nfcore_tiara_fcsgx_analysis_pipeline'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow TIARA_FCSGX_ANALYSIS {

    take:
    ch_fasta
    val_taxid
    ch_fcsgx_db
    ch_ncbi_path
    outdir

    main:

    def ch_versions = channel.empty()


    //
    // MODULE: GUNZIP, UPPERCASE SEQUENCE, CLEAN HEADERRS
    //
    FASTA_CLEAN_FAIDX (
        ch_fasta,
        true,
        false
    )


    TIARA_TIARA (
        FASTA_CLEAN_FAIDX.out.reference
    )

    reference_taxid = FASTA_CLEAN_FAIDX.out.reference
        .map { meta, ref ->
            def new_meta = meta + [ taxid: val_taxid ]
            tuple(new_meta, ref)
        }

    FCSGX_PARSECSV (
        reference_taxid,
        ch_fcsgx_db,
        ch_ncbi_path
    )


    AUTOFILTER_AUTOFILTER (
        FASTA_CLEAN_FAIDX.out.fai,
        TIARA_TIARA.out.classifications,
        FCSGX_PARSECSV.out.fcsgxresult,
        val_taxid,
        ch_ncbi_path
    )

    //
    // Collate and save software versions
    //
    def topic_versions = channel.topic("versions")
        .distinct()
        .branch { entry ->
            versions_file: entry instanceof Path
            versions_tuple: true
        }

    def topic_versions_string = topic_versions.versions_tuple
        .map { process, tool, version ->
            [ process[process.lastIndexOf(':')+1..-1], "  ${tool}: ${version}" ]
        }
        .groupTuple(by:0)
        .map { process, tool_versions ->
            tool_versions.unique().sort()
            "${process}:\n${tool_versions.join('\n')}"
        }

    def ch_collated_versions = softwareVersionsToYAML(ch_versions.mix(topic_versions.versions_file))
        .mix(topic_versions_string)
        .collectFile(
            storeDir: "${outdir}/pipeline_info",
            name:  'tiara_fcsgx_analysis_software_'  + 'versions.yml',
            sort: true,
            newLine: true
        )
    emit:
    versions       = ch_versions                 // channel: [ path(versions.yml) ]
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
