#!/bin/sh
#SBATCH -o job.%j.%N.out
#SBATCH --partition=fat
#SBATCH -J vibrant_10
#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=14
#SBATCH --mail-type=end
start_time=$(date +%s)

source activate vibrant

input=/lustre/home/41groundwater/01megahit
output=/lustre/home/41groundwater/04vibrant

cd ${output}
vibrant=/lustre/home/01software/VIBRANT

for i in Ji67  Ji68  Ji70  Ji71  Ji73  Ji74  Ji78  Ji79  Ji8   Ji80 \
         Ji83  Ji84  Ji85  JIN10 JIN12 JIN13 JIN19 JIN2  JIN22 JIN23 \
         JIN24 JIN28 JIN3  JIN30 JIN31 JIN32 JIN33 JIN35 JIN38 JIN5
do
mkdir ${i}
${vibrant}/VIBRANT_run.py  -i ${input}/${i}_final_assembly.fasta \
                -folder ${output}/${i} \
                -t 14
done

end_time=$(date +%s)
cost_time=$[ $end_time-$start_time ]
echo "execution time is $(($cost_time/60))min $(($cost_time%60))s"

#source activate vibrant
#VIBRANT_run.py  -i PATH/TO/INPUT/fasta \
                #-f Format of input ['nucl','prot',default='nucl'] \
                #-folder PATH/TO/OUTPUT [deflaut=working path] \
                #-t num of threads
                #-l length in basepairs to limit input sequeces [default=1000] \
                #-o number of ORFs per scaffold to limit input sequences [default=4] \

#database=/lustre/home/.conda/envs/vibrant/share/vibrant-1.2.0/databases
