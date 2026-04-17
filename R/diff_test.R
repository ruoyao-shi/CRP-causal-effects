library(dplyr)
outcomes <- list(
  list(id = "ebi-a-GCST006906", label = "stroke"),
  list(id = "ebi-a-GCST005194", label = "CAD"),
  list(id = "ieu-b-109", label = "HDL"),
  list(id = "ieu-b-110", label = "LDL"),
  list(id = "ieu-b-111", label = "Triglycerides"),
  list(id = "ebi-a-GCST90475667", label = "T2D"),
  list(id = "ebi-a-GCST90014006", label = "HbA1c"),
  list(id = "ebi-a-GCST90038683", label = "IBD"),
  list(id = "ebi-a-GCST90018910", label = "RA"),
  list(id = "ieu-b-5102", label = "SCZ"),
  list(id = "ieu-b-41", label = "BD"),
  list(id = "ebi-a-GCST90027158", label = "Alzheimer"),
  list(id = "ieu-b-7", label = "Parkinson"),
  list(id = "ebi-a-GCST90018808", label = "Colorectal"),
  list(id = "ebi-a-GCST007090", label = "Knee"),
  list(id = "ebi-a-GCST90014022", label = "BMD")
)
analyses <- list(
  list(suffix = "_MVMR_GRAPPLE_FDR_p_0.05_summary_new.csv",  analysis = "MVMR - main results"),
  list(suffix = "_MVMR_GRAPPLE_FDR_p_0.1_summary_new.csv",   analysis = "MVMR - FDR 0.1"),
  list(suffix = "_MR_GRAPPLE_FDR_p_0.05_summary_new.csv",    analysis = "MVMR - no BMI by default")
)
method_labels <- c(
  "GRAPPLE_5e-08" = "GRAPPLE (p<5e-08)",
  "IVW_5e-08" = "IVW (p<5e-08)",
  "GRAPPLE_1e-05" = "GRAPPLE (p<1e-05)",
  "MRBEE_5e-08_pleio_0" = "MRBEE (p<5e-08, pleiotropy=0)",
  "MRBEE_5e-08_pleio_0.05" = "MRBEE (p<5e-08, pleiotropy=0.05)"
)


df_all <- data.frame()
for (outcome in outcomes) {
  id <- outcome$id
  label <- outcome$label
  for (ana in analyses) {
    ana_path <- paste0(id, "/results/", label, ana$suffix)
    df_tmp <- read.csv(ana_path)
    df_tmp$outcome <- label
    df_tmp$analysis <- ana$analysis
    df_all <- bind_rows(df_all, df_tmp)
  }
}
df_all <- df_all %>% filter(exposure == "ebi-a-GCST90029070") %>%
    filter(method != "IVW_T_5e-08" & method != "ESMR_5e-08" & method != "ESMR_optimize_5e-08")
df_uvmr <- df_all %>% filter(type == "UVMR")
df_mvmr <- df_all %>% filter(type == "Stepwise")
df_joined <- inner_join(
  df_uvmr, df_mvmr,
  by = c("outcome", "method", "analysis"),
  suffix = c("_UVMR", "_MVMR")
) %>% 
    select(outcome, method, analysis, b_UVMR, b_MVMR, se_UVMR, se_MVMR) %>%
    mutate(
    Z_diff = (b_UVMR - b_MVMR) / sqrt(se_UVMR^2 + se_MVMR^2),
    p_diff = 2 * (1 - pnorm(abs(Z_diff)))
  ) %>%
  mutate(method = recode(method, !!!method_labels)) %>%
  mutate(
    method = factor(method, levels = c(
      "GRAPPLE (p<5e-08)",
      "IVW (p<5e-08)",
      "GRAPPLE (p<1e-05)",
      "MRBEE (p<5e-08, pleiotropy=0)",
      "MRBEE (p<5e-08, pleiotropy=0.05)")))
df_joined$outcome[df_joined$outcome == "stroke"] <- "Stroke"
df_joined$outcome[df_joined$outcome == "Knee"] <- "OA"
df_joined$outcome[df_joined$outcome == "Triglycerides"] <- "TG"
df_joined$outcome[df_joined$outcome == "Alzheimer"] <- "AD"
df_joined$outcome[df_joined$outcome == "Parkinson"] <- "PD"
df_joined$outcome[df_joined$outcome == "Colorectal"] <- "CRC"
write.csv(df_joined,"res_diff_new.csv",row.names=F)