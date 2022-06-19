process megahit_assembly {
  scratch true
  module "bioinfo-tools: megahit"
  publishDir params.outdir,
    mode: 'copy',
    overwrite: false
  cpus 10
  time "10h"

  input:
    tuple val(x) ,path(reads)

  output:
    tuple val(x), path("megahit_out/${x.id}.contigs.fa") , emit:assembly

  script:
  //def mem_mh = task.memory.toBytes()
  if(x.single_end) {
    """
    megahit \\
    -r ${reads}     \\
    -t ${task.cpus} \\
    -o megahit_out  \\
    --out-prefix ${x.id} \\
    --min-contig-len 1500
    """

  }else{

    """
    megahit \\
    -1 ${reads[0]} \\
    -2 ${reads[1]} \\
    -t ${task.cpus} \\
    -o megahit_out \\
    --out-prefix ${x.id} \\
    --min-contig-len 2000
    """
  }
}


process ion_assembly {
  scratch true
  module  "bioinfo-tools: spades"
  publishDir params.outdir,
    mode: 'copy',
    overwrite: false
  cpus 10
  time "10h"
  errorStrategy "ignore"
  
   input:
    tuple val(x), path(reads)
  output:
    tuple val(x), path("spades_out/${x.id}.contigs.fasta"), emit:assembly

  script:
  if(x.single_end){
    """
    spades.py --iontorrent    \\
              -s ${reads}     \\
              -t ${task.cpus} \\
              -o spades_out
    mv spades_out/contigs.fasta spades_out/${x.id}.contigs.fasta
    """
  }else{
    """
    metaspades.py --iontorrent   \\
                  -1 ${reads[0]}  \\
                  -2 ${reads[1]}  \\
                  -t ${task.cpus} \\
                  -o spades_out

    mv spades_out/contigs.fasta spades_out/${x.id}.contigs.fasta
    """ 
  }
}
