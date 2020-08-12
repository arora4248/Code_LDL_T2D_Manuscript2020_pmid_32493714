
#########################################
### 7/03/18 -- create 
### Incidental T2D
### prevalent T2D

dat=readRDS(file="/rsgrps/yann/amit/UKBiobank/Derived_variables/ukbiobank_v.053018.rds")

add=read.table(file='/rsgrps/yann/UKBIOBANK/Download/Addl_Data_June2018/ukb22705.tab',T)

dat$id<-1:nrow(dat)
dat2<- merge(dat,add,by="f.eid",all.x=T)
rm(add)

## put back into original order

dat2<- dat2[order(dat2$id),]
all.equal(dat2$f.eid,dat$f.eid)

rm(dat)
####
dat=dat2; rm(dat2)

### by UK group criteria for T2D

### remove the following
### age @ diagnosis <=35
### people on insulin within 1 year of diagnosis

dat$Age_at_T2D_Dg=dat$f.2976.0.0
dat$Age_at_T2D_Dg[dat$Age_at_T2D_Dg=='-3'] <- NA
dat$Age_at_T2D_Dg[dat$Age_at_T2D_Dg=='-1'] <- NA
summary(dat$Age_at_T2D_Dg)

#summary(dat$Age_at_T2D_Dg)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#      1      46      54      51      60      70  464585 

### people on Insulin within 1 year
dat$taking_insulin_oneYr=dat$f.2986.0.0
dat$taking_insulin_oneYr[dat$taking_insulin_oneYr=="-3"]<-NA
dat$taking_insulin_oneYr[dat$taking_insulin_oneYr=="-1"]<-NA
table(dat$taking_insulin_oneYr)

colnames(dat)[3322]<-"taking_insulin_withinOneYr"

#    0     1 
#  21269  2932 
###

### T2D is in f20002.0.0 - f.20002.0.28 (non cancerous ds.)
### + f1220.0.0 (generic T2D)
### + f1223.0.0 (T2D)

X<-c("1220","1223") ### generic T2d and endocrine t2d

#X<-c("1140861958","1141146234") 

###### loop for statin use variable
l<-rep(0, nrow(dat))
g<-c()

for(i in c(2723:2751)){
  
  g<-ifelse(dat[,i]%in%X,1,0)
  
  l<-g+l
  
  print(i)
  
}

table(l)

data$Uncorrected_T2D_v0<-ifelse(l>=1,1,0)

#### prevalent T2D

dat$Prev_T2D=NA
dat$Prev_T2D[(dat$Uncorrected_T2D_v0=='1' & dat$taking_insulin_withinOneYr=='0' & dat$Age_at_T2D_Dg>35)]<-'1'
dat$Prev_T2D[(dat$Uncorrected_T2D_v0=='0')]<-'0'
table(as.factor(dat$Prev_T2D))

### incidental T2d

names(dat)[2752:2780] ## f.20002.1.0 -- f.20002.1.28

l<-rep(0, nrow(dat))
g<-c()

for(i in c(2752:2780)){
  
  g<-ifelse(dat[,i]%in%X,1,0)
  
  l<-g+l
  
  print(i)
  
}

table(l)

dat$Uncorrected_T2D_v1<-ifelse(l>=1,1,0)

#    0      1 
#487272   1105

dat$Inc_T2D=NA
dat$Inc_T2D[dat$Prev_T2D=='0'& dat$Uncorrected_T2D_v1=='1']<-'1'
dat$Inc_T2D[dat$Prev_T2D=='0' & dat$Uncorrected_T2D_v1=='0']<-'0'
dat$Inc_T2D[dat$Prev_T2D=='1']<- NA
table(dat$Inc_T2D)

#0          1 
#463761    361

save(dat,file="/rsgrps/yann/amit/UKBiobank/Derived_variables/ukbiobank_T2DandStatins_v.070318.rda")

###################################################