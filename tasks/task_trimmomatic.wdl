version 1.0

task trimmomatic_task{
    meta{
        description: "Trimmomatic trimming of fastw files"
    }

    input{
        #task inputs
        File r1
        File r2
        Int minlen = 75
        Int window_size = 6
        Int required_quality = 30
        String docker = "staphb/trimmomatic:0.39"
        Int cpu = 8
        Int memory = 10
    }

    String samplename_r1 = basename(r1, '.fastq.gz')
    String samplename_r2 = basename(r2, '.fastq.gz')

    command <<<
        echo "~{r1}"
        echo "~{samplename_r1}"
        echo "~{samplename_r2}"
        trimmomatic PE \
            -threads ~{cpu} \
            "~{r1}" "~{r2}" \
            "~{samplename_r1}_paired.fastq.gz" "~{samplename_r1}_unpaired.fastq.gz" \
            "~{samplename_r2}_paired.fastq.gz" "~{samplename_r2}_unpaired.fastq.gz" \
            ILLUMINACLIP:/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:20:10:8:TRUE \
            SLIDINGWINDOW:~{window_size}:~{required_quality} MINLEN:~{minlen}        
    >>>
    
    output{
        File r1_paired = "~{samplename_r1}_paired.fastq.gz"
        File r2_paired = "~{samplename_r2}_paired.fastq.gz"
    }

    runtime{
        docker: "~{docker}"
        memory: "~{memory} GB"
        cpu: cpu
        disks: "local-disk 50 SSD"
        preemptible: 0
    }    
}
