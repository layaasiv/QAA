#!/bin/bash

#SBATCH --account=bgmp   ### change this to your actual account for charging
#SBATCH --partition=compute       ### queue to submit to
#SBATCH --job-name=q_dist_dmx    ### job name
#SBATCH --output=hostname.out   ### file in which to store job stdout
#SBATCH --error=hostname.err    ### file in which to store job stderr
#SBATCH --time=4:00:00                ### wall-clock time limit, in minutes
#SBATCH --mem=16G              ### memory limit per node, in MB
#SBATCH --nodes=1               ### number of nodes to use
#SBATCH --ntasks-per-node=1     ### number of tasks to launch per node
#SBATCH --cpus-per-task=8       ### number of cores for each task

# /usr/bin/time -v /projects/bgmp/layaasiv/bioinfo/Bi622/Demultiplex/Assignment-the-first/qscore_dist_demult.py \
# -f /projects/bgmp/shared/2017_sequencing/demultiplexed/4_2C_mbnl_S4_L008_R2_001.fastq.gz \
# -o 4_R2_histogram -s 101

# /usr/bin/time -v /projects/bgmp/layaasiv/bioinfo/Bi622/Demultiplex/Assignment-the-first/qscore_dist_demult.py \
# -f /projects/bgmp/shared/2017_sequencing/demultiplexed/4_2C_mbnl_S4_L008_R1_001.fastq.gz \
# -o 4_R1_histogram -s 101

# /usr/bin/time -v /projects/bgmp/layaasiv/bioinfo/Bi622/Demultiplex/Assignment-the-first/qscore_dist_demult.py \
# -f /projects/bgmp/shared/2017_sequencing/demultiplexed/21_3G_both_S15_L008_R2_001.fastq.gz \
# -o 21_R2_histogram -s 101

/usr/bin/time -v /projects/bgmp/layaasiv/bioinfo/Bi622/Demultiplex/Assignment-the-first/qscore_dist_demult.py \
-f /projects/bgmp/shared/2017_sequencing/demultiplexed/21_3G_both_S15_L008_R1_001.fastq.gz \
-o 21_R1_histogram -s 101