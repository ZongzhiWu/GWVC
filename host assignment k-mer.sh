#!/bin/sh
#SBATCH -o job.onf.%j.%N.out
#SBATCH --partition=fat
#SBATCH -J onf
#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=14
#SBATCH --mail-type=end

#####Oligonucleotide frequency(ONF) 
###php
source activate PHP

host=/lustre/home/41groundwater/14host/01MAGs/01all_bins/01ar_bac ##bins
output=/lustre/home/41groundwater/14host/04onf ##
virus=/lustre/home/41groundwater/14host/02chm ###

#python /lustre/home/01software/PHP/PHP-master/countKmer.py -f ${host} -d ${output} -n all_bins_hostkmer -c 1

#python /lustre/home/01software/PHP/PHP-master/PHP.py -v ${virus} -o ${output} -d ${output} -n all_bins_hostkmer

#link .fa and votu id
for i in /lustre/home/41groundwater/14host/02chm/*
do
name=${i##*/}
sq=$(awk -F '>' 'NR==1{print $2}' $i)
echo $name,$sq >> ${output}/num_sq.txt
done
#votu-host file
less ${output}/all_bins_hostkmer_Prediction_Maxhost.tsv |awk '{if($2>1436 && NR >1 )print $0}' > ${output}/max_1436.tsv
python /lustre/home/31Yellowriver_virus/18virhost/10php/yellowriver/findhost.py /lustre/home/41groundwater/14host/04onf ##替换output路径
less ${output}/1436_prediction.txt | awk '{print $1,$3}'|sort|uniq > ${output}/onf_votu_mags.txt
