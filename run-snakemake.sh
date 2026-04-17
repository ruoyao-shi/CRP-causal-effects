#!/bin/bash

mkdir -p log
mkdir -p results
mkdir -p data
snakemake \
   --keep-going \
   --rerun-triggers mtime \
   --jobs 20 \
   --max-jobs-per-second 10 \
   --latency-wait 60 \
   --cluster-config cluster.yaml  \
   --cluster "sbatch \
              --output={cluster.log}_%j.out \
              --error={cluster.log}_%j.err \
              --account=jvmorr1 \  # need to change to your account
              --job-name={cluster.name} \
              --time={cluster.time}  \
              --cpus-per-task={cluster.cpus}  \
              --mem={cluster.mem}"



