version 1.0

import "../tasks/task_fastqc.wdl" as fastqc
import "../tasks/task_trimmomatic.wdl" as trimmomatic 
import "../tasks/task_spades.wdl" as spades
import "../tasks/task_rmlst.wdl" as rmlst 

workflow rMLST_workflow{
    input{
        File R1
        File R2
    }

    # tasks and/or subworkflows to execute
    call fastqc.fastqc_task as rawfastqc_task{
        input:
            read1 = R1,
            read2 = R2 
    }

    call trimmomatic.trimmomatic_task{
        input:
            r1 = R1,
            r2 = R2
    }

    call fastqc.fastqc_task as trimmedfastqc_task{
        input:
            read1 = trimmomatic_task.r1_paired,
            read2 = trimmomatic_task.r2_paired
    }

    call spades.spades_task{
        input:
            r1 = trimmomatic_task.r1_paired,
            r2 = trimmomatic_task.r2_paired
    }

    call rmlst.rmlst_task{
        input:
            scaffolds = spades_task.scaffolds
    }



    output{
        # raw FASTQC 
        File FASTQC_R1 = rawfastqc_task.r1_fastqc
        File FASTQC_R2 = rawfastqc_task.r2_fastqc
        # trimmed FASTQC
        File Trim_FASTQC_R1 = trimmedfastqc_task.r1_fastqc
        File Trim_FASTQC_R2 = trimmedfastqc_task.r2_fastqc
        # Spades
        #File Spades_scaffolds = spades_task.scaffolds
        # rMLST
        String TAXON = rmlst_task.taxon
        String rST = rmlst_task.rST
    }
}
