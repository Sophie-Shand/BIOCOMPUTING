# Search term on SRA (Oct 21 2025)
dental plaque[All Fields] AND "human oral metagenome"[Organism] AND ("biomol dna"[Properties] AND "library layout paired"[Properties] AND "platform illumina"[Properties] AND "filetype fastq"[Properties])

# pipeline

# download accessions from SRA

fasterq-dump $(cat accession.txt | cut -f 1)

# download e coli ref genome

datasets download genome taxon "Escherichia coli" --reference --filename ./ref/ecoli.zip 

unzip ./ref/ecoli.zip -d ./ref

# run bbmap

REF="ref/ncbi_dataset/data/GCF_000005845.2/GCF_000005845.2_ASM584v2_genomic.fna"

bbmap.sh ref=$REF in1=data/ERR10083819_1.fastq in2=data/ERR10083819_2.fastq out=./output/mapped_to_Ecoli.sam minid=0.95


