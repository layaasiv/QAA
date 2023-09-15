#!/bin/bash

#SBATCH --account=bgmp   ### change this to your actual account for charging
#SBATCH --partition=interactive       ### queue to submit to
#SBATCH --reservation=bgmp-res      ### added when compute partition was overloaded
#SBATCH --job-name=star_align    ### job name
#SBATCH --output=hostname.out   ### file in which to store job stdout
#SBATCH --error=hostname.err    ### file in which to store job stderr
#SBATCH --time=2:00:00                ### wall-clock time limit, in minutes
#SBATCH --mem=16G              ### memory limit per node, in MB
#SBATCH --nodes=1               ### number of nodes to use
#SBATCH --ntasks-per-node=1     ### number of tasks to launch per node
#SBATCH --cpus-per-task=8       ### number of cores for each task

conda activate QAA

# /usr/bin/time -v htseq-count --stranded=yes \
# /projects/bgmp/layaasiv/bioinfo/Bi623/QAA/aligned_21_Aligned.out.sam \
# /projects/bgmp/layaasiv/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.110.gtf \
# > genecounts_21_stranded.tsv

# /usr/bin/time -v htseq-count --stranded=reverse \
# /projects/bgmp/layaasiv/bioinfo/Bi623/QAA/aligned_21_Aligned.out.sam \
# /projects/bgmp/layaasiv/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.110.gtf \
# > genecounts_21_revstranded.tsv

# /usr/bin/time -v htseq-count --stranded=yes \
# /projects/bgmp/layaasiv/bioinfo/Bi623/QAA/aligned_4_Aligned.out.sam \
# /projects/bgmp/layaasiv/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.110.gtf \
# > genecounts_4_stranded.tsv

/usr/bin/time -v htseq-count --stranded=reverse \
/projects/bgmp/layaasiv/bioinfo/Bi623/QAA/aligned_4_Aligned.out.sam \
/projects/bgmp/layaasiv/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.110.gtf \
> genecounts_4_revstranded.tsv