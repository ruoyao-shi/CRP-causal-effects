library(ieugwasr)
library(dplyr)
library(reshape2)
library(mrScan)

id.list <- read.csv(snakemake@input[["id_list"]])$id
df_info <- read.csv(snakemake@input[["trait_info"]])
R2_cutoff <- as.numeric(snakemake@params[["R2_cutoff"]])
res_cor <- readRDS(snakemake@input[["pairwise_cor"]])
extra_traits <- snakemake@params[["extra_traits"]]
out_id_list <- snakemake@output[["out_id_list"]]
out_trait_info <- snakemake@output[["out_trait_info"]]

Rg <- abs(res_cor$Rg)
df_matrix <- data.frame(Rg,check.names = FALSE)

res_unique <- unique_traits_inst(id.list = id.list, df_info = df_info, R_matrix = df_matrix,
                                 R2_cutoff = R2_cutoff, extra_traits = extra_traits)

write.csv(data.frame(id = res_unique$id.list),file = out_id_list,row.names = F)
write.csv(res_unique$trait.info,file = out_trait_info,row.names = F)
