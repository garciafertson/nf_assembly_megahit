//
// main workflow assembly SRA using megahit
//

nextflow.enable.dsl=2

include { ASSEMBLY } from './workflows/metagenome_assembly'

//Test Channel factory from sra, error 500
//server returned HTTP response code: 500 for URL: https://www.ebi.ac.uk/ena/portal/api/filereport
//  .fromSRA('SRR6784523', apiKey:'0e8e99340c8376916496d6b35a9a300b5a08')
//  .view()

//run assembly pipeline

workflow NF_META_ASSEMBLY {
    ASSEMBLY ()
}


//     WORKFLOW: Execute a single named workflow for the pipeline

workflow {
    NF_META_ASSEMBLY ()
}
