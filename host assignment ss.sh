#!/bin/sh
#SBATCH -o job.ss.%j.%N.out
#SBATCH --partition=fat
#SBATCH -J ss
#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=28
#SBATCH --mail-type=end
#####sequence similarity
###blastn
thread=28
module load blast+/2.9.0-gcc-4.8.5
##path
mags=/lustre/home/41groundwater/14host/01MAGs
votu=/lustre/home/41groundwater/12vOTUs/01all_vOTUs/vOTUs.fna
out_path=/lustre/home/41groundwater/14host/03ss
for i in 1 2 3 4 5
do
makeblastdb -in ${mags}/gw_bin_marked${i}.fa -dbtype nucl -out ${out_path}/gw_MAGs${i} -hash_index -max_file_sz '4GB'
blastn -db ${out_path}/gw_MAGs${i} -query ${votu} -out ${out_path}/gw_votu_mags${i}.blastn.out -outfmt '6 qseqid sseqid pident evalue bitscore length qlen qcovs qcovhsp slen mismatch gapopen qstart qend sstart send' \
-num_threads ${thread} -evalue 1e-3 -perc_identity 70
cat ${out_path}/gw_votu_mags${i}.blastn.out >> ${out_path}/gw_votu_mags.blastn.out
done
less ${out_path}/gw_votu_mags.blastn.out |awk '{if($3>=90 && $6>=2000)print $2,$1}'|awk -F '+' '{print $2}'|awk '{print $2,$1}'|sort|uniq > ${out_path}/ss_votu_mags.txt
