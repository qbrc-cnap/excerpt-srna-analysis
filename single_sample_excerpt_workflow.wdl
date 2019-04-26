workflow SingleSampleExcerptRun {
    
    File fastq
    String genome_id
    File genome_database

    call executeExcerpt {
        input:
            fastq = fastq,
            genome_id = genome_id,
            genome_database = genome_database
    }

    output {
        Array[File] core_results = executeExcerpt.core_results
    }

}


task executeExcerpt {
    File fastq
    File genome_database
    String genome_id

    # Extract the samplename from the fastq filename
    String sample_name = basename(fastq, "_R1.fastq.gz")

    Int disk_size = 100

    command {

        # Cromwell puts the genome database in some file like /cromwell_root/some/path/to/db.tgz
        # Use that for common reference
        export DB_DIR=$(dirname ${genome_database})

        # extract the database in that location, which makes a folder like like $DB_DIR/hg38
        tar -xf ${genome_database}
        mkdir /exceRptOutput

        make -f /exceRpt_bin/exceRpt_smallRNA \
            EXE_DIR=/exceRpt_bin \
            DATABASE_PATH=$DB_DIR \
            JAVA_EXE=java \
            OUTPUT_DIR=/exceRptOutput \
            MAP_EXOGENOUS=off \
            N_THREADS=6 \
            INPUT_FILE_PATH=${fastq} \
            MAIN_ORGANISM_GENOME_ID=${genome_id} \
            SAMPLE_NAME=${sample_name}
    }

    output {
        Array[File] core_results = glob("/exceRptOutput/*_CORE_RESULTS_v4.*.tgz")
    }

    runtime {
        docker: "docker.io/blawney/excerpt:v0.0.1"
        cpu: 6
        memory: "30 G"
        disks: "local-disk " + disk_size + " HDD"
        preemptible: 0
    }
}