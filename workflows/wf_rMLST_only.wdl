version 1.0

import "../tasks/task_rmlst.wdl" as rmlst 

workflow rMLST_workflow{
    input{
        File fasta_file
    }

    call rmlst.rmlst_task{
        input:
            scaffolds = fasta_file
    }



    output{
        String TAXON = rmlst_task.taxon
        String rST = rmlst_task.rST
    }
}
