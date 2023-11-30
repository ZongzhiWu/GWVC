#!/bin/sh
#SBATCH -o job.%j.gw_evp.%N.out
#SBATCH --partition=fat
#SBATCH -J evp_gw
#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --mail-type=end

#source activate py-meta
#####
contig=/lustre/home/90virus/07stage/cthmm/groundwater/00EVP #/0820_59sam/GS25/GS25_assembled_nt_FASTA_file_5kb.fna
protein=/lustre/home/90virus/07stage/cthmm/groundwater/00EVP #/0820_59sam/GS25/prot_GS25_genes_in_scafs_5kb.faa
npfam=/lustre/home/90virus/07stage/cthmm/groundwater/00EVP #/0820_59sam/GS25/prot_GS25_hits_to_npfam.hmmout
kegg=/lustre/home/90virus/07stage/cthmm/groundwater/00EVP #/0820_59sam/GS25/kegg_most.out

#####
#module load HAMMER/3.2.1-gcc-4.8.5
path=/lustre/home/90virus/11stage/06manual_curation/04curation/evp_new.hmm
outpath=/lustre/home/41groundwater/08EVP/01evp
###${sampleid}
for sampleid in `ls /lustre/home/41groundwater/08EVP/01evp $1`
do
start_time=$(date +%s)
#mkdir ${outpath}/${sampleid}
#hmmsearch --cpu 0 -E 1.0e-05 --tblout ${outpath}/${sampleid}/new_${sampleid}.hits_to_vpf.hmmout ${path} ${protein}/${sampleid}/prot_${sampleid}_genes_in_scafs_5kb.faa
#
cd ${outpath}/${sampleid}
#grep '>' ${protein}/${sampleid}/prot_${sampleid}_genes_in_scafs_5kb.faa|awk '{print $1}'|sort|uniq|cut -d ">" -f 2|cut -d "_" -f 1,2,3,4,5,6|sort |uniq -c >genes.cal
#grep ^[k] ${outpath}/${sampleid}/new_${sampleid}.hits_to_vpf.hmmout |awk '{print $1}'|sort|uniq|cut -d "_" -f 1,2,3,4,5,6 |sort |uniq -c >vpfs.cal
grep ^[k] ${npfam}/${sampleid}/prot_${sampleid}_hits_to_npfam.hmmout |awk '{print $1}'|sort|uniq|cut -d "_" -f 1,2,3,4,5,6 |sort |uniq -c > pfam.cal
awk '$2 !="None"&&NR!=1{print $1}' ${kegg}/${sampleid}/kegg_most.out |sort|uniq|cut -d "_" -f 1,2,3,4,5,6 |sort |uniq -c > kegg.cal
python /lustre/home/90virus/nature_protocol/cal.py ${outpath}/${sampleid} ${sampleid}
cat table.csv |sed 's/,/\t/g'|awk '$1!="Scaffold_ID"{print$0}' > table.txt
cat table.txt | awk '$2 >= 5' | awk '$8 <= 20'  | awk '$6 <= 40' | awk '$4 >= 10' | cut -f 1 > Filter1.out
cat table.txt | awk '$2 >= 5' | awk '$2 >= $5' | cut -f 1 > Filter2.out
cat table.txt | awk '$2 >= 5' | awk '$4 >= 60' | cut -f 1 > Filter3.out
cat Filter1.out Filter2.out Filter3.out > all_viral_contigs
cat all_viral_contigs |sort | uniq > viral_contigs
#screen_list.py ${contig}/${sampleid}/${sampleid}_assembled_nt_FASTA_file_5kb.fna -l viral_contigs -k -o new_extract.fa
#end_time=$(date +%s)
#cost_time=$[ $end_time-$start_time ]
#echo '${sampleid} execution time is $(($cost_time/60))min $(($cost_time%60))s'
done
