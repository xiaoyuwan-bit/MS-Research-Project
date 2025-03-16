setwd("D:/OneDrive/墨大/Biostat resarch/paper information")
rm(list = ls())
library(tidyr)
library(ggplot2)
library(dplyr)
library(geeasy)


DY<-read.csv("DY.csv")
DY<-DY[,-1]
DY_wide<-reshape(DY, idvar="df.study_ID", timevar="df.time",direction = "wide",v.names = "DY")
DY_wide<-DY_wide%>%
  rename(
    DY_0=DY.0,
    DY_4=DY.4,
    DY_8=DY.8,
    DY_12=DY.12
  )
corr_0<-cor(DY_wide[DY_wide$df.group==0,c("DY_0","DY_4","DY_8","DY_12")],use="complete.obs")
corr_1<-cor(DY_wide[DY_wide$df.group==1,c("DY_0","DY_4","DY_8","DY_12")],use = "complete.obs")
corr_t<-cor(DY_wide[c("DY_0","DY_4","DY_8","DY_12")], use = "complete.obs")


model <- geelm(DY~as.factor(df.group)+as.factor(df.time),
                data=DY,
                id=df.study_ID,
                family=gaussian,
                corstr="exchangeable")
model2 <- geelm(DY~as.factor(df.group)+as.factor(df.time),
               data=DY,
               id=df.study_ID,
               family=gaussian,
               corstr="independence")

model3 <- geelm(DY~as.factor(df.group)+as.factor(df.time),
               data=DY,
               id=df.study_ID,
               family=gaussian,
               corstr="unstructured")
model4 <- geelm(DY~as.factor(df.group)*as.factor(df.time),
                data=DY,
                id=df.study_ID,
                family=gaussian,
                corstr="independence")
QIC(model)
QIC(model2)
QIC(model3)
QIC(model4)
anova(model2, model4)

summary(model2)
confint(model2)
summary(model4)
confint(model4)
anova(model)
confint(model)
DY_data <- DY %>%
  group_by(df.group, df.time) %>%
  summarise(mean = mean(DY, na.rm = TRUE),
            sd = sd(DY, na.rm = TRUE),
            .groups = "drop") %>%
  mutate(up_ci = mean + 1.96 * sd / sqrt(n()),
         lower_ci = mean - 1.96 * sd / sqrt(n()))
library(ggplot2)

ggplot(DY_data, aes(x = df.time, y = mean, color = factor(df.group))) +
  geom_line() +
  geom_point() +
  
  scale_x_continuous(breaks = c(0, 4, 8, 12), name = "Time") +
  scale_y_continuous(breaks = seq(0, 100, by = 10), name = "Mean DY Score") +
  scale_color_manual(values = c("blue", "red"), 
                     labels = c("Azacitidine", "Azacitidine + Lenalidomide"),
                     name = "Treatment") +
  labs(title = "DY Score") +
  theme_minimal()




ggplot(DY_data, aes(x = df.time, y = mean, group = as.factor(df.group), color = as.factor(df.group))) +
  geom_line() +
  geom_errorbar(aes(ymin = lower_ci, ymax = up_ci), width = 0.2) +
  scale_x_continuous(breaks = c(0, 4, 8, 12), name = "Time") +
  scale_y_continuous(breaks = seq(0, 100, by = 10), name = "Mean DY Score") +
  scale_color_manual(values = c("blue", "red"), 
                     labels = c("Azacitidine", "Azacitidine + Lenalidomide"),
                     name = "Treatment") +
  labs(title = "DY Score") +
  theme_minimal()


ggplot(DY_data, aes(x = df.time, y = mean, color = factor(df.group))) +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = c(0, 4, 8, 12), name = "Weeks") +
  scale_y_continuous(limits = c(10, 60),breaks = seq(0, 100, by = 10), name = "Mean DY Score") +
  scale_color_manual(values = c("blue", "red"), 
                     labels = c("Azacitidine", "Azacitidine + Lenalidomide"),
                     name = "Treatment") +
  labs(title = "Dyspnoea (DY score)") +
  theme_minimal()+
  theme(legend.position = "none")
