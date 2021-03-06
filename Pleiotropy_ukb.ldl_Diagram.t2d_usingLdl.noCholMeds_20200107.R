

#### put together harmonized and univariae data

dat<-read.table(file="/rsgrps/yann/amit/ConsortiumData/output_files/Merged_ukb.ldl_diagram.t2d_corrected_20200106.txt",T)
harmonize<-read.table(file="/rsgrps/yann/amit/PleiotropicTraits/output_files/Harmonized_ldl.t2d_20200106.txt",T)
colnames(harmonize)[1]<-"rsid"

dat$rsid=as.character(dat$rsid)
harmonize$rsid=as.character(harmonize$rsid)

### merge
dat2<-merge(dat,harmonize,by="rsid")
dat3<-dat2[!duplicated(dat2$rsid),]

write.table(dat3,file="/rsgrps/yann/amit/PleiotropicTraits/output_files/Harmonized_with_univ_ukb.ldl_diagram.t2d_20200107.txt",row.names=F,quote=F)

##################################


### the ukb_ldlEatingTime_DiagramT2D_merged.txt 
### was harmonized using two-sample MRbase (only those signals with p<0.05 were harmonized)
### the harmonized data was later used to pull out opposite going signals

### read harmonized data file
dat2<-read.table(file="/rsgrps/yann/amit/PleiotropicTraits/output_files/Harmonized_with univ_ukb.ldl_diagram.t2d_20200107.txt",T)

pos<-dat2[which(dat2$beta.exposure>0 & dat2$beta.outcome<0),]
neg<-dat2[which(dat2$beta.exposure<0 & dat2$beta.outcome>0),]

dat3<-rbind(pos,neg)

dat4<-dat3[(dat3$pval.exposure<5e-5 & dat3$pval.outcome<5e-5),] ## n was =2646, now it is n=2267

write.csv(dat4,file="/rsgrps/yann/amit/PleiotropicTraits/output_files/ukb.ldl.EatingTime_diagram.t2d_opp_5e-5_20200107.csv",row.names=F,quote=F)

## "ukb.ldl.EatingTime_diagram.t2d_opp_5e-5_20190724.csv" was then used to pull out chunks