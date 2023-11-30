#!/bin/sh
#SBATCH -o job.%j.%N.out
#SBATCH --partition=fat
#SBATCH -J mtvVerify_gw10
#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=21
#SBATCH --mail-type=end

module load prodigal/2.6.3-gcc-4.8.5
module load HAMMER/3.2.1-gcc-4.8.5

input=/lustre/home/1801111833/0924_202sam/3assembly
cd /lustre/home/41groundwater/03mtvverify
###viral contigs
for i in JIN13 JIN19 JIN2 JIN30 JIN31 JIN33 JIN38 JIN6 JIN8 JIN9 \
         JL10 JL11 JL12 JL13 JL14 JL15 JL21 JL22 JL24 JL26 \
         JL30 JL31 JL32 JL33 JL34 JL35 JL36 JL37 JL38 JL4
do
viralverify.py  -t 21 \
                -f ${input}/${i}/final_assembly.fasta \
                -o ${i} \
                --hmm /lustre/home/01software/viralVerify/nbc_hmms.hmm
done