# Introduction
> For this project, we selected a study that looked at the gut microbiome in patients of different age groups.
> Metagenomes were sequenced from feces samples. 10 samples were selected for our project. Since
> The study broke down their samples into three age groups, we selected 3 samples from the young 
> age group, YO, 4 from the middle age group, MO, and 3 from the old age group, LO.
>
> These samples were processed in our four person group pipeline, but each person changed one hyperparameter in the pipeline. I changed a hyperparameter in script 04. Specifically, I added an **--evalue 1e-15** flag to prokka.
>
> In order to obtain the same SRA accession file, enter the following search term into NIH's SRA server:
>> PRJNA1195999[All Fields]
>
> Send the results to the Run Selector. From there, sort the samples in the table by Bytes size and select the top 3 YO and LO runs, and top 4 MO runs.
> The following accession IDs should now be obtained:
>> SRR31654314
>>
>> SRR31654324
>>
>> SRR31654305
>>
>> SRR31654343
>>
>> SRR31654339
>>
>> SRR31654352
>>
>> SRR31654355
>>
>> SRR31654385
>>
>> SRR31654365
>>
>> SRR31654382
>
> All scripts used in this project are expected to be run from within a project directory that contains:
>> scripts directory that will contain all scripts to be run.
>> data directory that will contain the file titled "accessions.txt" that contains all of the accession numbers for the samples.
>
> All scripts are optimized to work with bacterial metagenomes.

# Optional Run Slurm script:

Scripts 01 and 02 do not contain slurm headers but can take a long time to run depending on the data.
This run script can be used in the main project directory to run scripts 01 and 02.

```
#!/bin/bash
#SBATCH --job-name=EDIT
#SBATCH --nodes=1 # how many physical machines in the cluster
#SBATCH --ntasks=1 # how many separate 'tasks' (stick to 1)
#SBATCH --cpus-per-task=20 # how many cores (bora max is 20)
#SBATCH --time=1-00:00:00 # d-hh:mm:ss or just No. of minutes
#SBATCH --mem=120G # how much physical memory (all by default)
#SBATCH --mail-type=FAIL,BEGIN,END # when to email you
#SBATCH --mail-user=USER@wm.edu # who to email
#SBATCH -o /sciclone/home/USER/logs/%x_%j.out # change this!
#SBATCH -e /sciclone/home/USER/logs/%x_%j.err # change this!

./scripts/SCRIPT
```

# Script 00_setup.sh

## This script is to build the project directory in the scr10 space of the W&M hpc.

```
#!/bin/bash

set -ueo pipefail

# build out data and output structure in scratch directory

## set scratch space for data IO

SCR_DIR="${HOME}/scr10" # change to main writeable scratch space if not on W&M HPC

## set project directory in scratch space

PROJECT_DIR="${SCR_DIR}/group_project"

## set database directory

DB_DIR="${SCR_DIR}/db"

## make directories for this project

mkdir -p "${PROJECT_DIR}/data/raw"
mkdir -p "${PROJECT_DIR}/data/clean"
mkdir -p "${PROJECT_DIR}/output"
mkdir -p "${DB_DIR}/metaphlan"
mkdir -p "${DB_DIR}/prokka"
```

# Script 01_download.sh

This script is to download the accessions specified in ./data/accessions.txt and to download metaphlan and prokka databases.

```
#!/bin/bash

set -ueo pipefail

# get conda
N_CORES=6
module load miniforge3
eval "$(conda shell.bash hook)"

# DOWNLOAD RAW READS #############################################################

# set filepath vars
SCR_DIR="${HOME}/scr10" # change to main writeable scratch space if not on W&M HPC
PROJECT_DIR="${SCR_DIR}/group_project"
DB_DIR="${SCR_DIR}/db"
DL_DIR="${PROJECT_DIR}/data/raw"
SRA_DIR="${SCR_DIR}/SRA"

# if SRA_DIR doens't exist, create it
[ -d "$SRA_DIR" ] || mkdir -p "$SRA_DIR"


# download the accession(s) listed in `./data/accessions.txt`
# only if they don't exist
for ACC in $(cat ./data/accessions.txt)
do

if [ ! -f "${SRA_DIR}/${ACC}/${ACC}.sra" ]; then
prefetch --output-directory "${SRA_DIR}" "$ACC"
fasterq-dump "${SRA_DIR}/${ACC}/${ACC}.sra" --outdir "$DL_DIR" --skip-technical --force --temp "${SCR_DIR}/tmp"
fi

done


# compress all downloaded fastq files (if they haven't been already)
if ls ${DL_DIR}/*.fastq >/dev/null 2>&1; then
gzip ${DL_DIR}/*.fastq
fi

# DOWNLOAD DATABASES #############################################################

# metaphlan is easiest to use via conda
# and metaphlan can install its own database to use
conda env list | grep -q '^metaphlan4-env' || mamba create -y -n metaphlan4-env -c bioconda -c conda-forge metaphlan

# look for the metaphlan database, only download if it does not exist already
if [ ! -f "${DB_DIR}/metaphlan/mpa_latest" ]; then
conda activate metaphlan4-env
# install the metaphlan database using N_CORES
# N_CORES is set in the pipeline.slurm script
metaphlan --install --db_dir "${DB_DIR}/metaphlan" --nproc $N_CORES
conda deactivate
fi


# prokka (also using conda, also installs its own database)
conda env list | grep -q '^prokka-env' || mamba create -y -n prokka-env -c conda-forge -c bioconda prokka
conda activate prokka-env
export PROKKA_DB=${DB_DIR}/prokka
prokka --setupdb --dbdir $PROKKA_DB
conda deactivate
```

# Script 02_qc.sh

This script is to perform quality control on the raw reads using fastp.

```
#!/bin/bash
SCR_DIR="${HOME}/scr10" # change to main writeable scratch space if not on W&M HPC
PROJECT_DIR="${SCR_DIR}/group_project"
DB_DIR="${SCR_DIR}/db"
DL_DIR="${PROJECT_DIR}/data/raw"
SRA_DIR="${SCR_DIR}/SRA"
QC_DIR="${PROJECT_DIR}/data/clean"

mkdir -p "$QC_DIR"

for fwd in ${DL_DIR}/*_1.fastq.gz;do rev=${fwd/_1.fastq.gz/_2.fastq.gz};outfwd=${fwd/$DL_DIR/$QC_DIR}; outrev=${rev/$DL_DIR/$QC_DIR}; outfwd=${outfwd/.fastq.gz/_qc.fastq.gz}; outrev=${outrev/.fastq.gz/_qc.fastq.gz};fastp -i $fwd -o $outfwd -I $rev -O $outrev -j /dev/null -h /dev/null -n 0 -l 100 -e 20;done
# all QC files will be in $QC_DIR and have *_qc.fastq.gz naming pattern
```

# Script 03_assemble_template.sh

This script performs the assembly on the DNA reads. 

In order to perform the assemblies on all samples simultaneously, the script comes in the form of a template, and additional commands will need to be run in order to create unique scripts for each sample. 

Those commands can be found in the next section.

```
#!/bin/bash
#SBATCH --job-name=REPLACEME_assembly
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=USER@wm.edu               # change this!
#SBATCH -o /sciclone/home/USER/logs/REPLACEME_%j.out # change this!
#SBATCH -e /sciclone/home/USER/logs/REPLACEME_%j.err # change this!

set -ueo pipefail

SCR_DIR="${HOME}/scr10" # change to main writeable scratch space if not on W&M HPC
PROJECT_DIR="${SCR_DIR}/group_project"
DB_DIR="${SCR_DIR}/db"
QC_DIR="${PROJECT_DIR}/data/clean"
SRA_DIR="${SCR_DIR}/SRA"
CONTIG_DIR="${PROJECT_DIR}/contigs"

mkdir -p $CONTIG_DIR

for fwd in ${QC_DIR}/*REPLACEME*1_qc.fastq.gz
do

# derive input and output variables 
rev=${fwd/_1_qc.fastq.gz/_2_qc.fastq.gz}
filename=$(basename $fwd)
samplename=$(echo ${filename%%_*})
outdir=$(echo ${CONTIG_DIR}/${samplename})

#run spades with mostly default options
spades.py -1 $fwd -2 $rev -o $outdir -t 20 --meta
done
```

## Script 03 command to create sample-specific scripts (run from main directory):

```
for i in $(cat ./data/accessions.txt); do cat ./scripts/03_assemble_template.sh | sed "s/REPLACEME/${i}/g" >> ./scripts/${i}_assemble.slurm;done
```

## Script 03 command to submit all sample-specific scripts (run from main directory):

```
for i in ./scripts/SRR*.slurm; do sbatch ${i}; done
```

# Script 04_annotate_template.sh

This script annotates the assembled bacterial metagenomes with identified genes. This script is once again designed to generate sample-specific scripts since one of our samples took 18 hours to run. The commands used to autogenerate the scripts are described in the next section.

> The evalue flag of the prokka toolkit was changed to 1e-15 as part of testing out different hyperparameters for our group project.

```
#!/bin/bash
#SBATCH --job-name=REPLACEME_Annotate
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=1-00:00:00 # each should only take ~30-60 minutes
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=USER@wm.edu               # change this!
#SBATCH -o /sciclone/home/USER/logs/annotate_%j.out # change this!
#SBATCH -e /sciclone/home/USER/logs/annotate_%j.err # change this!

set -ueo pipefail

# set filepath vars
SCR_DIR="${HOME}/scr10" # change to main writeable scratch space if not on W&M HPC
PROJECT_DIR="${SCR_DIR}/group_project"
DB_DIR="${SCR_DIR}/db"
QC_DIR="${PROJECT_DIR}/data/clean"
SRA_DIR="${SCR_DIR}/SRA"
CONTIG_DIR="${PROJECT_DIR}/contigs"
ANNOT_DIR="${PROJECT_DIR}/annotations"

# load prokka
module load miniforge3
eval "$(conda shell.bash hook)"
conda activate prokka-env

for fwd in ${QC_DIR}/REPLACEME_1_qc.fastq.gz

do

# derive input and output variables
rev=${fwd/_1_qc.fastq.gz/_2_qc.fastq.gz}
filename=$(basename $fwd)
samplename=$(echo ${filename%%_*})
contigs=$(echo ${CONTIG_DIR}/${samplename}/contigs.fasta)
outdir=$(echo ${ANNOT_DIR}/${samplename})
contigs_safe=${contigs/.fasta/.safe.fasta}

# rename fasta headers to account for potentially too-long names (or spaces)
seqtk rename <(cat $contigs | sed 's/ //g') contig_ > $contigs_safe

# run prokka to predict and annotate genes
prokka $contigs_safe --outdir $outdir --prefix $samplename --evalue 1e-15 --cpus 20 --kingdom Bacteria --metagenome --locustag $samplename --force

done

conda deactivate && conda deactivate
```

## Script 04 command to create sample-specific scripts (run from main directory):

```
for i in $(cat ./data/accessions.txt); do cat ./scripts/04_annotate_template.sh | sed "s/REPLACEME/${i}/g" >> ./scripts/${i}_annotate.slurm;done
```

## Script 04 command to submit all sample-specific scripts (run from main directory):

```
for i in ./scripts/*_annotate.slurm; do sbatch ${i}; done
```

# Script 05_coverage.sh

This script creates the final summary files submitted with this project. The final file outputs will populate in the annotations directory within the group_project directory in the scratch space. Each sample's directory will contain a file named *_SS.with_cov.tsv, with the sample ID in place of the *.

```
#!/bin/bash
#SBATCH --job-name=MG_Annotate
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=USER@wm.edu               # change this!
#SBATCH -o /sciclone/home/USER/logs/annotate_%j.out # change this!
#SBATCH -e /sciclone/home/USER/logs/annotate_%j.err # change this!

set -ueo pipefail

# filepath vars
SCR_DIR="${HOME}/scr10"
PROJECT_DIR="${SCR_DIR}/group_project"
QC_DIR="${PROJECT_DIR}/data/clean"
CONTIG_DIR="${PROJECT_DIR}/contigs"
ANNOT_DIR="${PROJECT_DIR}/annotations"
MAP_DIR="${PROJECT_DIR}/mappings"
COV_DIR="${PROJECT_DIR}/coverm"

mkdir -p "${MAP_DIR}" "${COV_DIR}"

# load conda
module load miniforge3
eval "$(conda shell.bash hook)"

# check if coverm-env exists, if not, create it
if ! conda env list | awk '{print $1}' | grep -qx "subread-env"; then     echo "[setup] creating subread-env with mamba";     mamba create -y -n subread-env -c bioconda -c conda-forge subread bowtie2 samtools; fi

# activate env
conda activate subread-env

# main loop
for fwd in ${QC_DIR}/*1_qc.fastq.gz
do
    rev=${fwd/_1_qc.fastq.gz/_2_qc.fastq.gz}
    filename=$(basename "$fwd")
    samplename=$(echo "${filename%%_*}")
    contigs="${CONTIG_DIR}/${samplename}/contigs.fasta"
    contigs_safe=${contigs/.fasta/.safe.fasta}
    gff="${ANNOT_DIR}/${samplename}/${samplename}.gff"
    bam="${MAP_DIR}/${samplename}.bam"
    cov_out="${COV_DIR}/${samplename}_gene_tpm.tsv"

    echo "[sample] ${samplename}"

    # index contigs if needed
        echo "  [index] bowtie2-build ${contigs_safe}"
        bowtie2-build "${contigs_safe}" "${contigs_safe}"

    # map reads to contigs
        echo "  [map] mapping reads"
        bowtie2 -x "${contigs_safe}" -1 "$fwd" -2 "$rev" -p 8 \
          2> "${MAP_DIR}/${samplename}.bowtie2.log" \
        | samtools view -b - \
        | samtools sort -@ 8 -o "${bam}"
        samtools index "${bam}"

 # run featureCounts per gene (CDS), then compute TPM
    counts="${COV_DIR}/${samplename}_gene_counts.txt"
    tpm_out="${COV_DIR}/${samplename}_gene_tpm.tsv"

    echo "  [featureCounts] counting reads per CDS (locus_tag)"
    featureCounts \
      -a "${gff}" \
      -t CDS \
      -g locus_tag \
      -p -B -C \
      -T 20 \
      -o "${counts}" \
      "${bam}"

    echo "  [TPM] calculating TPM"
    awk 'BEGIN{OFS="\t"}
         NR<=2 {next}                           # skip header lines
         {
           id=$1; len=$6; cnt=$(NF);           # Geneid, Length, sample count is last column
           if (len>0) {
             rpk = cnt/(len/1000);
             RPK[id]=rpk; LEN[id]=len; CNT[id]=cnt; ORDER[++n]=id; SUM+=rpk;
           }
         }
         END{
           print "gene_id","length","counts","TPM";
           for (i=1;i<=n;i++){
             id=ORDER[i];
             tpm = (SUM>0 ? (RPK[id]/SUM)*1e6 : 0);
             printf "%s\t%d\t%d\t%.6f\n", id, LEN[id], CNT[id], tpm;
           }
         }' "${counts}" > "${tpm_out}"

    echo "  [done] ${tpm_out}"

    echo "  [done] ${cov_out}"

# join the coverage estimation info back to the annotation file

ann="${ANNOT_DIR}/${samplename}/${samplename}.tsv"
joined="${ANNOT_DIR}/${samplename}/${samplename}_IN.with_cov.tsv" #CHANGE IN TO YOUR INITIAL

echo "  [join] adding coverage columns to annotation TSV"
awk -v FS='\t' -v OFS='\t' -v keycol='locus_tag' '
  # Read TPM table: gene_id  length  counts  TPM
  NR==FNR {
    if (FNR==1) next
    id=$1; LEN[id]=$2; CNT[id]=$3; TPM[id]=$4
    next
  }
  # On the annotation header, find which column is locus_tag
  FNR==1 {
    for (i=1;i<=NF;i++) if ($i==keycol) K=i
    if (!K) { print "ERROR: no \"" keycol "\" column in annotation header" > "/dev/stderr"; exit 1 }
    print $0, "cov_length_bp", "cov_counts", "cov_TPM"
    next
  }
  # Append coverage fields if we have them
  {
    id=$K
    print $0, (id in LEN? LEN[id]:"NA"), (id in CNT? CNT[id]:"0"), (id in TPM? TPM[id]:"0")
  }
' "${tpm_out}" "${ann}" > "${joined}"

echo "  [done] ${joined}"

done
```

## All output files (*_SS.with_cov.tsv) were moved from the scratch space to a directory called output in the main project directory so that they can be uploaded to GitHub.

## The summary table outlining the hyperparameters changed by each group member can also be found in the output directory as well as a table containing all 10 accession numbers and matching patient type.
