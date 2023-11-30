#!/bin/sh
#SBATCH -o job.%j.%N.Ji54_JIN23.out
#SBATCH --partition=fat
#SBATCH -J PPR_Meta_Ji54_JIN23
#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=7
#SBATCH --mail-type=end

module load PPR_Meta/1.0
source activate py-meta

### PPR-Meta
PPR_path=/lustre/home/01software/PPR_Meta_v_1_0
### 
rootpath=/lustre/home/41groundwater/06PPR
### contigs
asspath=/lustre/home/41groundwater/01megahit/02filter_1kb

###
#mkdir ${rootpath}/soft_copy
cp -R ${PPR_path} ${rootpath}/soft_copy
###
mv ${rootpath}/soft_copy/PPR_Meta_v_1_0 ${rootpath}/soft_copy/PPR_Meta_Ji54_JIN23
###
cd ${rootpath}/soft_copy/PPR_Meta_Ji54_JIN23


for i in Ji54  Ji55  Ji56  Ji57  Ji59  Ji60  Ji61  Ji62  Ji63  Ji64 \
Ji67  Ji68  Ji70  Ji71  Ji73  Ji74  Ji78  Ji79  Ji8   Ji80 \
Ji83  Ji84  Ji85  JIN10 JIN12 JIN13 JIN19 JIN2  JIN22 JIN23
do
echo ${i}
mkdir ${rootpath}/${i}

start_time=$(date +%s)

###
./PPR_Meta ${asspath}/${i}_1kb.fasta ${rootpath}/${i}/result_1kb.csv 

end_time=$(date +%s)
cost_time=`expr ${end_time} - ${start_time}`
echo -e "start time:${start_time}\nend time:${end_time}\nexecution time is $(expr ${cost_time} / 60)min $(expr ${cost_time} % 60)s" >> ${rootpath}/${i}/runtime_log.txt

### id
cat ${rootpath}/${i}/result_1kb.csv | awk 'BEGIN{OFS=FS=","}{if($2>=1000 && $6=="phage")print $1}' > ${rootpath}/${i}/viral_id.txt
### 
screen_list.py ${asspath}/${i}_1kb.fasta -l ${rootpath}/${i}/viral_id.txt -k -o ${rootpath}/${i}/viral_contigs.fa

done
