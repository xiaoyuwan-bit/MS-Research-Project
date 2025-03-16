setwd("D:/OneDrive/墨大/Biostat resarch/paper information")
rm(list = ls())
library(tidyr)
library(ggplot2)
library(dplyr)
library(geeasy)


CF<-read.csv("CF.csv")
CF<-CF[,-1]
CF_wide<-reshape(CF, idvar="df.study_ID", timevar="df.time",direction = "wide",v.names = "CF")
CF_wide<-CF_wide%>%
  rename(
    CF_0=CF.0,
    CF_4=CF.4,
    CF_8=CF.8,
    CF_12=CF.12
  )
cor_0<-cor(CF_wide[CF_wide$df.group==0,c("CF_0","CF_4","CF_8","CF_12")],use = "complete.obs")
cor_1<-cor(CF_wide[CF_wide$df.group==1,c("CF_0","CF_4","CF_8","CF_12")],use = "complete.obs")
cor_t<-cor(CF_wide[c("CF_0","CF_4","CF_8","CF_12")],use = "complete.obs")


model <- geelm(CF~as.factor(df.group)+as.factor(df.time),
                data=CF,
                id=df.study_ID,
                family=gaussian,
                corstr="exchangeable")

model2 <- geelm(CF~as.factor(df.group)+as.factor(df.time),
               data=CF,
               id=df.study_ID,
               family=gaussian,
               corstr="independence")

model3 <- geelm(CF~as.factor(df.group)+as.factor(df.time),
               data=CF,
               id=df.study_ID,
               family=gaussian,
               corstr="unstructured")
model4<-geelm(CF~as.factor(df.group)*as.factor(df.time),
              data=CF,
              id=df.study_ID,
              family=gaussian,
              corstr="independence")


QIC(model)
QIC(model2)
QIC(model3)
QIC(model4)
anova(model2,model4)
summary(model2)
confint(model2)
summary(model4)
confint(model4)
CF_data <- CF %>%
  group_by(df.group, df.time) %>%
  summarise(mean = mean(CF, na.rm = TRUE),
            sd = sd(CF, na.rm = TRUE),
            .groups = "drop") %>%
  mutate(up_ci = mean + 1.96 * sd / sqrt(n()),
         lower_ci = mean - 1.96 * sd / sqrt(n()))
library(ggplot2)

ggplot(CF_data, aes(x = df.time, y = mean, color = factor(df.group))) +
  geom_line() +
  geom_point() +
  
  scale_x_continuous(breaks = c(0, 4, 8, 12), name = "Time") +
  scale_y_continuous(breaks = seq(0, 100, by = 10), name = "Mean CF Score") +
  scale_color_manual(values = c("blue", "red"), 
                     labels = c("Azacitidine", "Azacitidine + Lenalidomide"),
                     name = "Treatment") +
  labs(title = "CF Score") +
  theme_minimal()


ggplot(CF_data, aes(x = df.time, y = mean, group = as.factor(df.group), color = as.factor(df.group))) +
  geom_line() +
  geom_errorbar(aes(ymin = lower_ci, ymax = up_ci), width = 0.2) +
  scale_x_continuous(breaks = c(0, 4, 8, 12), name = "Time") +
  scale_y_continuous(breaks = seq(0, 100, by = 10), name = "Mean CF Score") +
  labs(x = "Time", y = "Mean CF Score", color = "Group") +
  scale_color_manual(values = c("blue", "red"), 
                     labels = c("Azacitidine", "Azacitidine + Lenalidomide"),
                     name = "Treatment") +
  labs(title = "CF Score") +
  theme_minimal()
  



ggplot(CF_data, aes(x = df.time, y = mean, color = factor(df.group))) +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = c(0, 4, 8, 12), name = "Weeks") +
  scale_y_continuous(limits = c(50,100),breaks = seq(0, 100, by = 10), name = "Mean CF Score") +
  scale_color_manual(values = c("blue", "red"), 
                     labels = c("Azacitidine", "Azacitidine + Lenalidomide"),
                     name = "Treatment") +
  labs(title = "Cognitive Functioning (CF score)") +
  theme_minimal()+
  theme(legend.position = "none")

