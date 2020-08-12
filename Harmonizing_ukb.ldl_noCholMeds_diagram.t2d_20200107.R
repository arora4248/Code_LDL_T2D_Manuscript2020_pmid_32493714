
### Amit Arora
### Jan 6th, 2020

ldl<-read.table(file="/rsgrps/yann/amit/UKBiobank/Gwas/LDL_eatingTime_noStatins_noCholMeds/Bolt_LMM/bolt_460K_selfRepWhite.LDL_corrected_Gwas.bgenv3.stats.gz",T)
t2d<-read.table(file="/rsgrps/yann/amit/ConsortiumData/gwas_datasets/Mahajan.NatGenet2018b.T2D_w_rsid_20190723.txt",T)
colnames(ldl)[1]<-"rsid"

t2d$rsid=as.character(t2d$rsid)
ldl$rsid=as.character(ldl$rsid)

ldl2<-ldl[grep("^rs",ldl$rsid),]
ldl3<-ldl2[-which(ldl2$A1FREQ<0.001 | ldl2$A1FREQ>0.99),]

### merge

dat<-merge(ldl3,t2d[,c(2:11)],by="rsid")
write.table(dat,file="/rsgrps/yann/amit/ConsortiumData/output_files/Merged_ukb.ldl_diagram.t2d_corrected_20200106.txt",row.names=F,quote=F)

#install.packages("devtools")
#library(devtools)
#install_github("MRCIEU/TwoSampleMR")

setwd('C:/Users/arora/OneDrive for Business/Yanns_Work_060118/MRBase')

library(TwoSampleMR)
ao <- available_outcomes()

## Read trait1 and Trait2 text files

#exposure data

T1<-read_exposure_data(
  
  filename = 'C:/Users/arora/OneDrive for Business/Yanns_Work_060118/Misc/Merged_ukb.ldl_diagram.t2d_corrected_20200106.txt',
  
  sep = " ",
  
  snp_col = "rsid",
  
  beta_col = "BETA",
  
  se_col = "SE.x",
  
  effect_allele_col = "ALLELE1",
  
  other_allele_col = "ALLELE0",
  
  eaf_col = "A1FREQ",
  
  pval_col = "P_BOLT_LMM_INF",
  
  phenotype ="ldl"
  
)


T2<-read_outcome_data(
  
  filename = 'C:/Users/arora/OneDrive for Business/Yanns_Work_060118/Misc/Merged_ukb.ldl_diagram.t2d_corrected_20200106.txt',
  
  sep = " ",
  
  snp_col = "rsid",
  
  beta_col = "Beta",
  
  se_col = "SE.y",
  
  effect_allele_col = "EA",
  
  other_allele_col = "NEA",
  
  eaf_col = "EAF",
  
  pval_col = "Pvalue",
  
  phenotype ="t2d"
  
)

dat <- harmonise_data(T1, T2)

write.table(dat,file="Harmonized_ldl.t2d_20200106.txt",row.names=F,quote=F)





