#!/bin/sh
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=graph_partition
#SBATCH --partition=compute
#SBATCH --output=partitions/partition_log_flickr.txt

source /home/ubuntu/miniconda3/bin/activate
conda activate envforgnn
# module load anaconda3
# module load codes/gpu/cuda/11.6

python3.9 partition_code/partition_default.py \
                      --dataset flickr \
                      --num_parts 4 \
                      --balance_train \
                      --balance_edges \
                      --output partitions/flickr/metis


echo -e "\n\n============================================================================================================================================"
echo -e "============================================================================================================================================\n\n"


python3.9 partition_code/partition_edge_weighted.py \
                      --dataset flickr \
                      --num_parts 4 \
                      --balance_train \
                      --balance_edges \
                      --c 10 \
                      --output partitions/flickr/edge-weighted


echo -e "\n\n============================================================================================================================================"
echo -e "============================================================================================================================================\n\n"


python3.9 partition_code/print_all_entropies.py \
                      --dataset Flickr \
                      --json_metis partitions/flickr/metis/flickr.json \
                      --json_ew partitions/flickr/edge-weighted/flickr.json \
                      --log partitions/partition_log_flickr.txt \
                      --no_of_part 4
