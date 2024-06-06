// ReheaderProcess.nf

// Define the process
process REHEADER_BAM {

    tag "$meta.id"

    conda "bioconda::samtools=1.16.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/samtools:1.16.1--h6899075_1' :
        'quay.io/biocontainers/samtools:1.16.1--h6899075_1' }"

    // Input parameter
    input:
    tuple val(meta),path(bam)
    path(gff)

    // Output file (sorted BAM)
    output:
    tuple val(meta), path("*.bam"),   emit: reheadered_bam
    path  "versions.yml",            emit: versions

    // Script to run within the container
    script:
    """
    bash reheaderbam.sh $bam $gff

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """
}
