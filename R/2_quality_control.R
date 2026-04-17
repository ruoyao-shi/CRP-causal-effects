library(ieugwasr)
library(dplyr)
library(mrScan)

res_initial <- snakemake@input[["file"]]
nsnp_cutoff <- as.numeric(snakemake@params[["nsnp_cutoff"]])
pop <- snakemake@params[["population"]]
gender <- snakemake@params[["gender"]]
out_id_list <- snakemake@output[["id_list"]]
out_trait_info <- snakemake@output[["trait_info"]]

dat <- readRDS(res_initial)$trait.info
res <- quality_control(dat = dat,nsnp_cutoff = nsnp_cutoff,pop = pop,gender = gender)
## manually add traits missing population information
manual_add_ids <- c(
  "ebi-a-GCST005194","ebi-a-GCST005195",
  "ebi-a-GCST90103632","ebi-a-GCST90038595",
  "ebi-a-GCST90038599","ebi-a-GCST90038604",
  "ebi-a-GCST90038610","ebi-a-GCST90038616",
  "ebi-a-GCST90038633","ebi-a-GCST90038637",
  "ebi-a-GCST90038687","ebi-a-GCST90038690",
  "ieu-b-5113")
## manually delete female traits
manual_delete_ids <- c("ebi-a-GCST90029037","ukb-b-17422")
id.list <- unique(c(res$id.list, manual_add_ids))
id.list <- setdiff(id.list, manual_delete_ids)
## update status
trait.info <- res$trait.info
trait.info$status[trait.info$id %in% manual_add_ids] <- "select after QC"
trait.info$status[trait.info$id %in% manual_delete_ids] <- "delete in QC"

write.csv(data.frame(id = id.list),file = out_id_list,row.names = F)
write.csv(trait.info,file = out_trait_info,row.names = F)
