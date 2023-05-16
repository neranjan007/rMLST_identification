version 1.0

import "../tasks/task_fastqc.wdl" as rawFastqc

workflow rMLST_workflow{
    input{
        File R1
        File R2
    }

    # tasks and/or subworkflows to execute
    call rawFastqc.fastqc_task{
        input:
            read1 = R1,
            read2 = R2 
    }

    output{
        File FASTQC_R1 = fastqc_task.r1_fastqc
        File FASTQC_R2 = fastqc_task.r2_fastqc
    }
}
