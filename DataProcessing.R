setwd("D:/OneDrive/墨大/Biostat resarch/paper information")
rm(list = ls())
library(tidyverse)
library(ggplot2)
library(dplyr)
library(Matrix)
library(geepack)

Qol<-read.csv("QoL_all_questions_v2_formatted.csv")
df2<-read.csv("Demographics.csv")
df<-merge(Qol,df2,by="study_ID")
df <- df %>%
  mutate(group = recode(group, "1" = 0, "2" = 1))

QL2<-df[,c("q29","q30")]
PF2<-df[,c("q1","q2","q3","q4","q5")]
RF2<-df[,c("q6","q7")]
EF<-df[,c("q21","q22","q23","q24")]
CF<-df[,c("q20","q25")]
SF<-df[,c("q26","q27")]
FA<-df[,c("q10","q12","q18")]
NV<-df[,c("q14","q15")]
PA<-df[,c("q9","q19")]
DY<-df[,c("q8")]
SL<-df[,c("q11")]
AP<-df[,c("q13")]
CO<-df[,c("q16")]
DI<-df[,c("q17")]
FI<-df[,c("q28")]

## cal_raw_score: row_score=(I1+I2+...+In)/n
cal_raw_score<-function(item_data){
  num_item<-length(item_data)
  non_missing<-sum(!is.na(item_data))
  
  if(non_missing >= num_item/2) {
    raw_score<-mean(item_data, na.rm=TRUE)
  } else {
    raw_score<-NA
  }
  
  return(raw_score)
}

## Functioning part

## Score for Function Scale={1-(RS-1)/range}*100
fun<-list(PF2=PF2,RF2=RF2,EF=EF,CF=CF,SF=SF)
func_raw<-list()
for (fun_name in names(fun)) {
  func_raw[[fun_name]]<-apply(fun[[fun_name]],1,cal_raw_score)
}
func_score<-list()
for (i in names(func_raw)){
  func_score[[i]]<-(1-(func_raw[[i]]-1)/3)*100
}

##symptomatic part A Symptom scales score= {(RS-1)/range}*100
sym<-list(FA=FA,NV=NV,PA=PA)
sym_raw<-list()
for(i in names(sym)) {
  sym_raw[[i]]<-apply(sym[[i]],1,cal_raw_score)
}
sym_score_1<-list()

for(i in names(sym_raw)){
  sym_score_1[[i]]<-((sym_raw[[i]]-1)/3)*100
}

## symptomatic part b Symptom scales score= {(RS-1)/range}*100
sym_raw_2<-list(AP=AP,CO=CO,DI=DI,DY=DY,FI=FI,SL=SL)
sym_score_2<-list()
for(i in names(sym_raw_2)){
  sym_score_2[[i]]<-((sym_raw_2[[i]]-1)/3)*100
}

## QL2 Global heatlth status/Qol
QL2_raw<-apply(QL2,1,cal_raw_score)
QL2_score<-(QL2_raw-1)/6*100


## result
result<-data.frame(df$study_ID,df$time,df$group,df$ecog,
                   df$sex,df$age,func_score,sym_score_1,sym_score_2,QL2_score)

## reshape each column to long
for ( i in 4:21){
  new_data_name<-colnames(result)[i]
  new_data<-result[,c(1:6,i)]
  colnames(new_data)<-c(colnames(result)[1:6],colnames((result)[i]))
  assign(new_data_name, new_data)
  path=paste0("D:/OneDrive/墨大/Biostat resarch/paper information/",new_data,".csv")
  write.csv(new_data,file="path")
}


set.seed(1234567890)
DF_list<-list(PF2=PF2,RF2=RF2,EF=EF,CF=CF,SF=SF,FA=FA,NV=NV,PA=PA,AP=AP,CO=CO,DI=DI,DY=DY,FI=FI,
              SL=SL,QL2_score=QL2_score)



for (i in 1:length(DF_list)) {
  df_name <- names(DF_list)[i]
  df <- DF_list[[i]]
  
  sample_df_name <- paste0(df_name, "_sample_long")
  sample_df <- df %>%
    group_by(df.group) %>%
    filter(df.study_ID %in% sample(unique(df.study_ID), 10)) %>%
    ungroup()
  assign(sample_df_name, sample_df)
  
  col_name <- paste0("mean_", df_name)
  summary_df_name <- paste0(df_name, "_summary")
  summary_df <- df %>%
    group_by(df.group, df.time) %>%
    summarise(!!col_name := mean(!!sym(df_name), na.rm = TRUE),
              .groups ="drop")
  assign(summary_df_name, summary_df)
  
  pp<-ggplot(summary_df,aes(x=df.time,y=!!sym(col_name),color=factor(df.group)))+
    geom_line()+scale_x_continuous(breaks=c(0,4,8,12))+
    scale_x_continuous(breaks = c(0, 4, 8, 12), name = "Time") +
    geom_point()+
    theme_minimal()
  print(pp)
}


for(i in 1:length(DF_list)) {
  filename <- paste0("D:/OneDrive/桌面/", names(DF_list)[i], ".csv")
  write.csv(DF_list[[i]], filename)
}


