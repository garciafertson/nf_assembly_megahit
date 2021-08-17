/*
General workflow, assembly SRA-NCBI-id_samples included in text list
*/

//import modules
include {fastp}             from  "../modules/clean_reads"
include {enadataget}       from  "../modules/enadwld"
include {megahit_assembly}  from  "../modules/assembly"

//run metagenomic assembly pipeline using megahit

workflow ASSEMBLY {
        ncbi_sampleid = file(params.sample_id)
        sra_sample_list = ncbi_sampleid.readLines()
        sampleid=Channel.fromList(sra_sample_listq)
        enadataget(sampleid)
        fastq_sample=enadataget.out.reads
        fastp(fastq_sample)
        fastq_trimmed=fastp.out.reads
        megahit_assembly(fastq_trimmed)
        }
