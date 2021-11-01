/*
General workflow, assembly SRA-NCBI-id_samples included in text list
*/

//import modules
include {fastp}             from  "../modules/clean_reads"
include {enadataget}       from  "../modules/enadwld"
include {megahit_assembly}  from  "../modules/assembly"

//run metagenomic assembly pipeline using megahit

workflow ASSEMBLY {
  if (!params.assembly_from_ENA){
     Channel
        .fromFilePairs(params.input, size: params.single_end ? 1 : 2)
        .ifEmpty { exit 1, "Cannot find any reads matching: ${params.input}\nNB: Path needs to be enclosed in quotes!\nIf this is single-end data, please specify --single_end on the command line." }
        .map { row ->
           def meta = [:]
           meta.id           = row[0]
           meta.group        = 0
           meta.single_end   = params.single_end
           return [ meta, row[1] ]
                }
        .set { ch_raw_short_reads }

     //fqsamples=Channel.fromFilePairs("$params.fq_samples/*{1,2}.fastq.gz")
     } else {
     ncbi_sampleid = file(params.sample_id)
     sra_sample_list = ncbi_sampleid.readLines()
     sampleid=Channel.fromList(sra_sample_list)
     enadataget(sampleid)
     ch_raw_short_reads=enadataget.out.reads
     }

     fastp(ch_raw_short_reads)

     fastq_trimmed=fastp.out.reads
     
     megahit_assembly(fastq_trimmed)
     }
