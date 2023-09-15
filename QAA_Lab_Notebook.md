# QAA Lab Notebook

## September 8, 2023
My assigned fastq files: \
 4_2C_mbnl_S4_L008: \
  4_2C_mbnl_S4_L008_R1_001.fastq.gz \
  4_2C_mbnl_S4_L008_R2_001.fastq.gz \

  Number of records: ```zcat 4_2C_mbnl_S4_L008_R2_001.fastq.gz | sed -n '2~4p' | wc -l``` \
  ```9265284``` (equal in both)
    
 21_3G_both_S15_L008: \
  21_3G_both_S15_L008_R1_001.fastq.gz \
  21_3G_both_S15_L008_R2_001.fastq.gz \

  Number of records: ```zcat 21_3G_both_S15_L008_R1_001.fastq.gz | sed -n '2~4p' | wc -l``` \
  ```9237299``` (equal in both)

Install fastqc on Talapas, using the following code: \
```module spider fastqc```
```module load fastqc/0.11.5```

To run FASTQC on my FASTQC files: \
```/usr/bin/time -v fastqc -o fastqc_out -f fastq -extract /projects/bgmp/shared/2017_sequencing/demultiplexed/21_3G_both_S15_L008_R1_001.fastq.gz /projects/bgmp/shared/2017_sequencing/demultiplexed/21_3G_both_S15_L008_R2_001.fastq.gz```

```
Slurm output: \
    Percent of CPU this job got: 99% \
    Elapsed (wall clock) time (h:mm:ss or m:ss): 3:11.56 \
    Maximum resident set size (kbytes): 290804
```

Run these fastq files on the demultiplex qscore distribution code to get per-base histograms and compare to FASTQC. [sbatch script here](qscore_dist_demult_sbatch.sh) 

```
Slurm outputs (all 4 were similar, this was 1 of them): \
    Percent of CPU this job got: 96% \
    Elapsed (wall clock) time (h:mm:ss or m:ss): 2:31.55 \
    Maximum resident set size (kbytes): 72584
```

## September 9, 2023

**Comparison:** \
The distribution plots produced by my demux code looks identical to the plots produced by FASTQC for for all 4 files. However, the run time for FASTQC is slightly longer than the demux code. I would imagine this is because the FASTQC program was running many different analyses on the fastq files and producing multiple plot, whereas the demux code was only creating the per-base distribution plot. 

**Analysis of quality of data:** \
The median per base quality scores are very high, and the IQR for R1 files are very small, indicating that there is very little variance in these values at each position. In the R2 files, the median is a bit lower and there is more variance since the IQR looks larger. However, this is expected in R2 reads, and the scores are still reasonably high enough to warrant confidence. Per base N content is low across all files, which indicates there were very few positions that got multiple conflicting base calls. 

The great majority of sequences have significantly high mean quality score in the R1 files. In the R2 files, the more sequences had slightly lower mean quality scores (phred score ~20-30 range). Still, most are of high mean quality. Again, this is expected of R2 reads because of the nature of the sequencing protol. 

Adapter content is very low across all files. It does increase a bit at the end of the sequence, but they contain less than 5% adapter sequence, so I would conclude that this can be managed with adapter trimming. 

Overall, I believe these libraries are of high enough quality to be used for downstream analyses. 

**Create conda env and install ```cutadapt``` and ```trimmomatic```**

```$ srun --account=bgmp --partition=compute --time=1:00:00 --pty bash 
   $ conda create -n QAA
   $ conda activate QAA
   $ conda install cutadapt=4.4
   $ conda install trimmomatic=0.39
```

## September 11, 2023

**Finding the adapter sequences**

Started with looking at the 'Overrepresented sequences' in the FASTQC report for all 4 files. 21_3G_both_S15_L008_R1_001.fastq was identified to have 1 seq overrepresented that was predicted to be 'TruSeq Adapter, Index 18'. So I looked up this adapter sequence online. \

R1 adapter: ```AGATCGGAAGAGCACACGTCTGAACTCCAGTCA```

R2 adapter: ```AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT```

Number of seq containing adapter: ```zcat 21_3G_both_S15_L008_R1_001.fastq.gz | sed -n '2~4p' | grep -c 'AGATCGGAAGAGCACACGTCTGAACTCCAGTCA'``` \
    ```66732```

Number of seq containing adapter: ```zcat 21_3G_both_S15_L008_R2_001.fastq.gz | sed -n '2~4p' | grep -c 'AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT'``` \
    ```67707```

Number of seq containing adapter: ```zcat 4_2C_mbnl_S4_L008_R1_001.fastq.gz | sed -n '2~4p' | grep -c 'AGATCGGAAGAGCACACGTCTGAACTCCAGTCA'``` \
    ```51173```

Number of seq containing adapter: ```zcat 4_2C_mbnl_S4_L008_R2_001.fastq.gz | sed -n '2~4p' | grep -c 'AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT'``` \
    ```51593```


**Running cutadapt on the reads**

```
conda activate QAA
/usr/bin/time -v cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
-o cutadapt_4_out.fastq.gz -p cutadapt_4_pair.fastq.gz \
/projects/bgmp/shared/2017_sequencing/demultiplexed/4_2C_mbnl_S4_L008_R1_001.fastq.gz \
/projects/bgmp/shared/2017_sequencing/demultiplexed/4_2C_mbnl_S4_L008_R2_001.fastq.gz
```
```
Slurm output: \
    Percent of CPU this job got: 99% \
    Elapsed (wall clock) time (h:mm:ss or m:ss): 4:06.74 \
    Maximum resident set size (kbytes): 40308
```

=== Summary ===

Total read pairs processed:          9,265,284
  Read 1 with adapter:                 570,274 (6.2%)
  Read 2 with adapter:                 637,307 (6.9%)
Pairs written (passing filters):     9,265,284 (100.0%)

Total basepairs processed: 1,871,587,368 bp
  Read 1:   935,793,684 bp
  Read 2:   935,793,684 bp
Total written (filtered):  1,855,605,260 bp (99.1%)
  Read 1:   927,955,998 bp
  Read 2:   927,649,262 bp


```
conda activate QAA
/usr/bin/time -v cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
-o cutadapt_21_R1.fastq.gz -p cutadapt_21_R2.fastq.gz \
/projects/bgmp/shared/2017_sequencing/demultiplexed/21_3G_both_S15_L008_R1_001.fastq.gz \
/projects/bgmp/shared/2017_sequencing/demultiplexed/21_3G_both_S15_L008_R2_001.fastq.gz
```
```
Slurm output: \
    Percent of CPU this job got: 99% \
    Elapsed (wall clock) time (h:mm:ss or m:ss): 4:09.65 \
    Maximum resident set size (kbytes): 41960
```
    
=== Summary ===

Total read pairs processed:          9,237,299
  Read 1 with adapter:                 613,874 (6.6%)
  Read 2 with adapter:                 679,275 (7.4%)
Pairs written (passing filters):     9,237,299 (100.0%)

Total basepairs processed: 1,865,934,398 bp
  Read 1:   932,967,199 bp
  Read 2:   932,967,199 bp
Total written (filtered):  1,841,521,110 bp (98.7%)
  Read 1:   920,902,485 bp
  Read 2:   920,618,625 bp


**Running trimmomatic on reads**
```
/usr/bin/time -v trimmomatic PE -threads 20 -phred33 cutadapt_4_R1.fastq.gz \
cutadapt_4_R2.fastq.gz \
trim_4_R1.fastq.gz trim_unpaired_4_R1.fastq.gz \
trim_4_R2.fastq.gz trim_unpaired_4_R2.fastq.gz \
LEADING:3 TRAILING:3 SLIDINGWINDOW:5:15 MINLEN:35
```
```
Slurm output: \
    Percent of CPU this job got: 215% \
    Elapsed (wall clock) time (h:mm:ss or m:ss): 4:05.58 \
    Maximum resident set size (kbytes): 592904
```

```
/usr/bin/time -v trimmomatic PE -threads 20 -phred33 cutadapt_21_R1.fastq.gz \
cutadapt_21_R2.fastq.gz \
trim_21_R1.fastq.gz trim_unpaired_21_R1.fastq.gz \
trim_21_R2.fastq.gz trim_unpaired_21_R2.fastq.gz \
LEADING:3 TRAILING:3 SLIDINGWINDOW:5:15 MINLEN:35
```

```
Slurm output: \
    Percent of CPU this job got: 216% \
    Elapsed (wall clock) time (h:mm:ss or m:ss): 4:03.42 \
    Maximum resident set size (kbytes): 591004
```

**Number of mapped/unmapped reads**

Code located here: mapped_reads.py

aligned_21_Aligned.out.sam \
    Primary mapped reads: 17061162 \
    Primary unmapped reads: 645462 \

aligned_4_Aligned.out.sam \
    Primary mapped reads: 17172681 \
    Primary unmapped reads: 788079 \

**Installing STAR, numpy, matplotlib, htseq**

```conda install star -c bioconda```
    version: 2.7.10b

```conda install numpy```
    version: 1.25.2

```conda install maplotlib```
    version: 3.7.2

```conda install htseq```
    version: 2.0.3

**Running STAR**

STAR bash script: star_database_align.sh

Downloaded FASTA and GTF files from Ensembl 110 for mouse genome. \
    ```Mus_musculus.GRCm39.dna.primary_assembly.fa.gz``` \
    ```Mus_musculus.GRCm39.110.gtf.gz```

Created database and aligned reads to mouse genomic database (refer to star_database_align.sh). \

**Running HTSeq**

Bash script: htseq_slurm.sh

```
Slurm output: \
    Percent of CPU this job got: 98% \
    Elapsed (wall clock) time (h:mm:ss or m:ss): 11:54.87 \
    Maximum resident set size (kbytes): 175432 
```

**Plotting distribution of read lengths of trimmed reads**

To get distribution data from each file: \
```zcat trim_21_R1.fastq.gz | sed -n '2~4p' | awk '{print length($0)}' | sort -n | uniq -c | awk '{ print $2 " " $1}' > <file_name>``` \

Made plots on R. 

**Strandedness**

```grep "^ENSMUSG" genecounts_21_stranded.tsv | awk '{sum+=$2} END {print sum}'``` \
    ```334465```

```grep "^ENSMUSG" genecounts_21_revstranded.tsv | awk '{sum+=$2} END {print sum}'``` \
    ```7180828```

```grep "^ENSMUSG" genecounts_4_stranded.tsv | awk '{sum+=$2} END {print sum}'``` \
    ```356074```

```grep "^ENSMUSG" genecounts_4_revstranded.tsv | awk '{sum+=$2} END {print sum}'``` \
    ```7236906```

Looking at the uneven alignment of reads in the stranded=yes and =reverse settings, the library was likely stranded. 