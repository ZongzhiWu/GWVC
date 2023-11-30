#!/bin/sh
#SBATCH -o job.crispr.%j.%N.out
#SBATCH --partition=cpu
#SBATCH -J crispr
#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=21
#SBATCH --mail-type=end
#####方法4 crispr match 
###软件minced blastn
##用minced预测crispr序列

input=/lustre/home/41groundwater/14host/01MAGs/gw_bin_marked.fa  ##
output=/lustre/home/41groundwater/14host/06crispr  ##

#/lustre/home/01software/minced-master/minced -spacers ${input} ${output}/gw_bin_marked.crisprs ${output}/gw_bin_marked.gff

##blastn

thread=21

module load blast+/2.9.0-gcc-4.8.5
spacer=${output}/gw_bin_marked_spacers.fa ##minced
votu=/lustre/home/41groundwater/12vOTUs/01all_vOTUs/vOTUs.fna  ##votu

makeblastdb -in ${votu} -dbtype nucl -out ${output}/gw_votu -hash_index -max_file_sz '4GB'
blastn -db ${output}/gw_votu -query ${spacer} -out ${output}/gw_spacers_votu.blastn.out -outfmt '6 qseqid sseqid pident evalue mismatch bitscore length qlen qcovs qcovhsp slen gapopen qstart qend sstart send' \
-num_threads ${thread} -evalue 1e-5 -word_size 8 -task 'blastn-short'

##
less ${output}/gw_spacers_votu.blastn.out |awk '{if($5<=1 && $9==100) print $0}'| awk -F '+' '{print $2}'| awk -F '_CRISPR' '{print $1,$2}'|awk '{print $3,$1}'|sort|uniq > ${output}/crispr_votu_mags.txt
