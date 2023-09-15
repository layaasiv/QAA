#!/bin/bash

#SBATCH --account=bgmp   ### change this to your actual account for charging
#SBATCH --partition=interactive       ### queue to submit to
#SBATCH --reservation=bgmp-res      ### added when compute partition was overloaded
#SBATCH --job-name=star_align    ### job name
#SBATCH --output=hostname.out   ### file in which to store job stdout
#SBATCH --error=hostname.err    ### file in which to store job stderr
#SBATCH --time=2:00:00                ### wall-clock time limit, in minutes
#SBATCH --mem=50G              ### memory limit per node, in MB
#SBATCH --nodes=1               ### number of nodes to use
#SBATCH --ntasks-per-node=1     ### number of tasks to launch per node
#SBATCH --cpus-per-task=8       ### number of cores for each task

conda activate QAA 

# /usr/bin/time -v STAR --runThreadN 8 --runMode genomeGenerate \
# --genomeDir /projects/bgmp/layaasiv/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.dna.ens110.STAR_2.7.10b/ \
# --genomeFastaFiles /projects/bgmp/layaasiv/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.dna.primary_assembly.fa \
# --sjdbGTFfile /projects/bgmp/layaasiv/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.110.gtf

/usr/bin/time -v STAR --runThreadN 8 --runMode alignReads \
--outFilterMultimapNmax 3 \
--outSAMunmapped Within KeepPairs \
--alignIntronMax 1000000 --alignMatesGapMax 1000000 \
--readFilesCommand zcat \
--readFilesIn /projects/bgmp/layaasiv/bioinfo/Bi623/QAA/trim_21_R1.fastq.gz /projects/bgmp/layaasiv/bioinfo/Bi623/QAA/trim_21_R2.fastq.gz \
--genomeDir /projects/bgmp/layaasiv/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.dna.ens110.STAR_2.7.10b/ \
--outFileNamePrefix aligned_21_