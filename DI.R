setwd("D:/OneDrive/墨大/Biostat resarch/paper information")
rm(list = ls())
library(tidyr)
library(ggplot2)
library(dplyr)
library(geeasy)

DI<-read.csv("DI.csv")
DI<-DI[,-1]
DI_wide<-reshape(DI, idvar="df.study_ID", timevar="df.time",direction = "wide",v.names = "DI")
DI_wide<-DI_wide%>%
  rename(
    DI_0=DI.0,
    DI_4=DI.4,
    DI_8=DI.8,
    DI_12=DI.12
  )
corr_0<-cor(DI_wide[DI_wide$df.group==0,c("DI_0","DI_4","DI_8","DI_12")],use = "complete.obs")
corr_1<-cor(DI_wide[DI_wide$df.group==1,c("DI_0","DI_4","DI_8","DI_12")], use="complete.obs")
corr_t<-cor(DI_wide[c("DI_0","DI_4","DI_8","DI_12")],use="complete.obs")


model <- geelm(DI~as.factor(df.group)+as.factor(df.time),
                data=DI,
                id=df.study_ID,
                family=gaussian,
                corstr="exchangeable")
model2 <- geelm(DI~as.factor(df.group)+as.factor(df.time),
               data=DI,
               id=df.study_ID,
               family=gaussian,
               corstr="independence")
model3 <- geelm(DI~as.factor(df.group)+as.factor(df.time),
               data=DI,
               id=df.study_ID,
               family=gaussian,
               corstr="unstructured")

model4 <- geelm(DI~as.factor(df.group)*as.factor(df.time),
                data=DI,
                id=df.study_ID,
                family=gaussian,
                corstr="independence")


QIC(model)
QIC(model2)
QIC(model3)
QIC(model4)
anova(model2, model4)
summary(model)
confint(model)
summary(model4)
confint(model4)
DI_data <- DI %>%
  group_by(df.group, df.time) %>%
  summarise(mean = mean(DI, na.rm = TRUE),
            sd = sd(DI, na.rm = TRUE),
            .groups = "drop") %>%
  mutate(up_ci = mean + 1.96 * sd / sqrt(n()),
         lower_ci = mean - 1.96 * sd / sqrt(n()))
library(ggplot2)

ggplot(DI_data, aes(x = df.time, y = mean, color = factor(df.group))) +
  geom_line() +
  geom_point() +
  
  scale_x_continuous(breaks = c(0, 4, 8, 12), name = "Time") +
  scale_y_continuous(breaks = seq(0, 100, by = 10), name = "Mean DI Score") +
  scale_color_manual(values = c("blue", "red"), 
                     labels = c("Azacitidine", "Azacitidine + Lenalidomide"),
                     name = "Treatment") +
  labs(title = "DI Score") +
  theme_minimal()



pairs(DI_wide[,6:9],col=ifelse(DI_wide$df.group==0,"black","red"))


ggplot(DI_data, aes(x = df.time, y = mean, group = as.factor(df.group), color = as.factor(df.group))) +
  geom_line() +
  geom_errorbar(aes(ymin = lower_ci, ymax = up_ci), width = 0.2) +
  scale_x_continuous(breaks = c(0, 4, 8, 12), name = "Time") +
  scale_y_continuous(breaks = seq(0, 50, by = 10), name = "Mean DI Score") +
  scale_color_manual(values = c("blue", "red"), 
                     labels = c("Azacitidine", "Azacitidine + Lenalidomide"),
                     name = "Treatment") +
  labs(title = "DI Score") +
  theme_minimal()



ggplot(DI_data, aes(x = df.time, y = mean, color = factor(df.group))) +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = c(0, 4, 8, 12), name = "Weeks") +
  scale_y_continuous(limits = c(0, 50),breaks = seq(0, 100, by = 10), name = "Mean DI Score") +
  scale_color_manual(values = c("blue", "red"), 
                     labels = c("Azacitidine", "Azacitidine + Lenalidomide"),
                     name = "Treatment") +
  labs(title = "Diarrhoea (DI score)") +
  theme_minimal()+
  theme(legend.position = "none")

