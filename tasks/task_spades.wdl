version 1.0

task spades_task{
    meta{
        description: "Reads assembly using Spades"
    }

    input{
        #task inputs
        File r1
        File r2
        Int cpu = 8
        String docker = "staphb/spades:3.15.5"
        Int memory = 100
        #String? samplename
    }

    String samplename_r1 = basename(r1, '_paired.fastq.gz')
    String samplename = ""

    command <<<
        echo ~{r1}
        echo ~{samplename_r1}
        #samplename="echo ~s{samplename_r1} | cut -d '_' -f 1"
        echo ~{samplename}
        samplename=echo ~{samplename_r1} | cut -d '_' -f 1
        echo ~{samplename}
        #mkdir "$samplename"
        #spades.py \
        #    -1 ~{r1} \
        #    -2 ~{r2} \
        #    -t ~{cpu} \
        #    --careful \
        #    -o $samplename
    >>>

    output{
        #task outputs
        File scaffolds = "${samplename}/scaffolds.fasta"
    }

    runtime{
        docker: "~{docker}"
        memory: "~{memory} GB"
        cpu: cpu
        disks: "local-disk 50 SSD"
        preemptible: 0
    }
}
