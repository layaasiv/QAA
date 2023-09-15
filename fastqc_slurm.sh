#!/bin/bash

#SBATCH --account=bgmp   ### change this to your actual account for charging
#SBATCH --partition=compute       ### queue to submit to
#SBATCH --job-name=qaa    ### job name
#SBATCH --output=hostname.out   ### file in which to store job stdout
#SBATCH --error=hostname.err    ### file in which to store job stderr
#SBATCH --time=1:00:00                ### wall-clock time limit, in minutes
#SBATCH --mem=8G              ### memory limit per node, in MB
#SBATCH --nodes=1               ### number of nodes to use
#SBATCH --ntasks-per-node=1     ### number of tasks to launch per node
#SBATCH --cpus-per-task=8       ### number of cores for each task

# module load fastqc/0.11.5

# /usr/bin/time -v fastqc -o fastqc_out -f fastq -extract \
# /projects/bgmp/shared/2017_sequencing/demultiplexed/21_3G_both_S15_L008_R1_001.fastq.gz \
# /projects/bgmp/shared/2017_sequencing/demultiplexed/21_3G_both_S15_L008_R2_001.fastq.gz \
# /projects/bgmp/shared/2017_sequencing/demultiplexed/4_2C_mbnl_S4_L008_R1_001.fastq.gz \
# /projects/bgmp/shared/2017_sequencing/demultiplexed/4_2C_mbnl_S4_L008_R2_001.fastq.gz

conda activate QAA

# /usr/bin/time -v cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
# -o cutadapt_4_R1.fastq.gz -p cutadapt_4_R2.fastq.gz \
# /projects/bgmp/shared/2017_sequencing/demultiplexed/4_2C_mbnl_S4_L008_R1_001.fastq.gz \
# /projects/bgmp/shared/2017_sequencing/demultiplexed/4_2C_mbnl_S4_L008_R2_001.fastq.gz

# /usr/bin/time -v cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
# -o cutadapt_21_R1.fastq.gz -p cutadapt_21_R2.fastq.gz \
# /projects/bgmp/shared/2017_sequencing/demultiplexed/21_3G_both_S15_L008_R1_001.fastq.gz \
# /projects/bgmp/shared/2017_sequencing/demultiplexed/21_3G_both_S15_L008_R2_001.fastq.gz

# /usr/bin/time -v trimmomatic PE -threads 20 -phred33 cutadapt_4_R1.fastq.gz cutadapt_4_R2.fastq.gz \
# trim_4_R1.fastq.gz trim_unpaired_4_R1.fastq.gz \
# trim_4_R2.fastq.gz trim_unpaired_4_R2.fastq.gz \
# LEADING:3 TRAILING:3 SLIDINGWINDOW:5:15 MINLEN:35

/usr/bin/time -v trimmomatic PE -threads 20 -phred33 cutadapt_21_R1.fastq.gz cutadapt_21_R2.fastq.gz \
trim_21_R1.fastq.gz trim_unpaired_21_R1.fastq.gz \
trim_21_R2.fastq.gz trim_unpaired_21_R2.fastq.gz \
LEADING:3 TRAILING:3 SLIDINGWINDOW:5:15 MINLEN:35