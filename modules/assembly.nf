process megahit_assembly{

  module "bioinfo-tools: megahit"
  publishDir "assemblies",
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
    """
    megahit \\
    -1 ${reads[0]} \\
    -2 ${reads[1]} \\
<<<<<<< HEAD
    -t "${task.cpus}" \\
=======
    -t ${task.cpus} \\
>>>>>>> 6531a5a0e87daf25db990c2eddfd19c62c5883ce
    -o megahit_out \\
    --out-prefix ${x.id} \\
    --min-contig-len 2000
    """
}
