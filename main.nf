#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    sanger-tol/tiara_fcsgx_analysis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/sanger-tol/tiara_fcsgx_analysis
----------------------------------------------------------------------------------------
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT FUNCTIONS / MODULES / SUBWORKFLOWS / WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { TIARA_FCSGX_ANALYSIS  } from './workflows/tiara_fcsgx_analysis'
include { PIPELINE_INITIALISATION } from './subworkflows/local/utils_nfcore_tiara_fcsgx_analysis_pipeline'
include { PIPELINE_COMPLETION     } from './subworkflows/local/utils_nfcore_tiara_fcsgx_analysis_pipeline'
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOWS FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOW: Run main analysis pipeline depending on type of input
//
workflow SANGERTOL_TIARA_FCSGX_ANALYSIS {

    take:
    fasta
    taxid
    fcsgx_database
    ch_ncbi_path
    outdir

    main:

    //
    // WORKFLOW: Run pipeline
    //
    TIARA_FCSGX_ANALYSIS (
        fasta,
        taxid,
        fcsgx_database,
        ch_ncbi_path,
        outdir
    )

    emit:
    index               = TIARA_FCSGX_ANALYSIS.out.index
    sizes               = TIARA_FCSGX_ANALYSIS.out.sizes
    fasta               = TIARA_FCSGX_ANALYSIS.out.fasta
    seq_desc            = TIARA_FCSGX_ANALYSIS.out.seq_desc

    classifications     = TIARA_FCSGX_ANALYSIS.out.classifications
    tiara_logs          = TIARA_FCSGX_ANALYSIS.out.tiara_logs

    fcs_results         = TIARA_FCSGX_ANALYSIS.out.fcs_results
    fcs_genomedict      = TIARA_FCSGX_ANALYSIS.out.fcs_genomedict
    fcs_report_txt      = TIARA_FCSGX_ANALYSIS.out.fcs_report_txt
    fcs_taxonomy        = TIARA_FCSGX_ANALYSIS.out.fcs_taxonomy

    keep_scaffs         = TIARA_FCSGX_ANALYSIS.out.keep_scaffs
    remove_scaffs       = TIARA_FCSGX_ANALYSIS.out.remove_scaffs
    fcs_tiara_summary   = TIARA_FCSGX_ANALYSIS.out.fcs_tiara_summary
}
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {

    main:
    //
    // SUBWORKFLOW: Run initialisation tasks
    //
    PIPELINE_INITIALISATION (
        params.version,
        params.validate_params,
        params.monochrome_logs,
        args,
        params.outdir,
        params.fasta,
        params.help,
        params.help_full,
        params.show_hidden
    )


    //
    // WORKFLOW: Run main workflow
    //
    SANGERTOL_TIARA_FCSGX_ANALYSIS (
        PIPELINE_INITIALISATION.out.reference,
        params.taxid,
        params.fcs_gx_database_path,
        params.ncbi_ranked_lineage_path,
        params.outdir

    )


    //
    // SUBWORKFLOW: Run completion tasks
    //
    PIPELINE_COMPLETION (
        params.email,
        params.email_on_fail,
        params.plaintext_email,
        params.outdir,
        params.monochrome_logs,
    )

    publish:
    index               = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.index
    sizes               = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.sizes
    fasta               = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.fasta
    seq_desc            = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.seq_desc

    classifications     = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.classifications
    tiara_logs          = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.tiara_logs

    fcs_results         = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.fcs_results
    fcs_genomedict      = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.fcs_genomedict
    fcs_report_txt      = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.fcs_report_txt
    fcs_taxonomy        = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.fcs_taxonomy

    keep_scaffs         = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.keep_scaffs
    remove_scaffs       = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.remove_scaffs
    fcs_tiara_summary   = SANGERTOL_TIARA_FCSGX_ANALYSIS.out.fcs_tiara_summary
}

output {
    index {
        path { meta, file -> "${meta.id}/assembly_info/"}
    }
    sizes {
        path { meta, file -> "${meta.id}/assembly_info/"}
    }
    fasta {
        path { meta, file -> "${meta.id}/assembly_info/"}
    }
    seq_desc {
        path { meta, file -> "${meta.id}/assembly_info/"}
    }
    classifications {
        path { meta, file -> "${meta.id}/tiara/"}
    }
    tiara_logs {
        path { meta, file -> "${meta.id}/tiara/"}
    }
    fcs_results {
        path { meta, file -> "${meta.id}/fcsgx/"}
    }
    fcs_genomedict {
        path { meta, file -> "${meta.id}/fcsgx/"}
    }
    fcs_report_txt {
        path { meta, file -> "${meta.id}/fcsgx/"}
    }
    fcs_taxonomy {
        path { meta, file -> "${meta.id}/tiara/"}
    }
    keep_scaffs {
        path { meta, file -> "${meta.id}/joint_report/"}
    }
    remove_scaffs {
        path { meta, file -> "${meta.id}/joint_report/"}
    }
    fcs_tiara_summary {
        path { meta, file -> "${meta.id}/joint_report/"}
    }
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
