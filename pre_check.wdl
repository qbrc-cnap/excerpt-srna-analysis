workflow ExcerptSmallRna {

    Array[File] fastq_files
    String genome_id
    File excerpt_genome_database
    String output_zip_name
    String git_repo_url
    String git_commit_hash

    scatter(fq in fastq_files){

        call assert_valid_fastq {
            input:
                fastq = fq
        }
    }
}

task assert_valid_fastq {

    File fastq

    Int disk_size = 50

    command <<<
        python3 /opt/software/precheck/check_fastq.py -f ${fastq}
    >>>

    runtime {
        zones: "us-east4-c"
        docker: "docker.io/blawney/excerpt:v0.0.1"
        cpu: 2
        memory: "6 G"
        disks: "local-disk " + disk_size + " HDD"
        preemptible: 0
    }
}
