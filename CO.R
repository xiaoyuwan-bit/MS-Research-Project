setwd("D:/OneDrive/墨大/Biostat resarch/paper information")
rm(list = ls())
library(tidyr)
library(ggplot2)
library(dplyr)
library(geeasy)

CO<-read.csv("CO.csv")
CO<-CO[,-1]
CO_wide<-reshape(CO, idvar="df.study_ID", timevar="df.time",direction = "wide",v.names = "CO")
CO_wide<-CO_wide%>%
  rename(
    CO_0=CO.0,
    CO_4=CO.4,
    CO_8=CO.8,
    CO_12=CO.12
  )
cor_0<-cor(CO_wide[CO_wide$df.group==0,c("CO_0","CO_4","CO_8","CO_12")],use = "complete.obs")
cor_1<-cor(CO_wide[CO_wide$df.group==1,c("CO_0","CO_4","CO_8","CO_12")], use = "complete.obs")
cor_t<-cor(CO_wide[c("CO_0","CO_4","CO_8","CO_12")],use = "complete.obs")


model <- geelm(CO~as.factor(df.group)+as.factor(df.time),
                data=CO,
                id=df.study_ID,
                family=gaussian,
                corstr="exchangeable")

model3 <- geelm(CO~as.factor(df.group)+as.factor(df.time),
               data=CO,
               id=df.study_ID,
               family=gaussian,
               corstr="unstructured")
model4 <- geelm(CO~as.factor(df.group)*as.factor(df.time),
                data=CO,
                id=df.study_ID,
                family=gaussian,
                corstr="unstructured")
QIC(model)

QIC(model3)
QIC(model4)
anova(model3,model4)
summary(model3)
confint(model)
summary(model4)
confint(model4)
CO_data <- CO %>%
  group_by(df.group, df.time) %>%
  summarise(mean = mean(CO, na.rm = TRUE),
            sd = sd(CO, na.rm = TRUE),
            .groups = "drop") %>%
  mutate(up_ci = mean + 1.96 * sd / sqrt(n()),
         lower_ci = mean - 1.96 * sd / sqrt(n()))
library(ggplot2)

ggplot(CO_data, aes(x = df.time, y = mean, color = factor(df.group))) +
  geom_line() +
  geom_point() +
  
  scale_x_continuous(breaks = c(0, 4, 8, 12), name = "Time") +
  scale_y_continuous(limit=c(0,45),breaks = seq(0, 100, by = 10), name = "Mean CO Score") +
  scale_color_manual(values = c("blue", "red"), 
                     labels = c("Azacitidine", "Azacitidine + Lenalidomide"),
                     name = "Treatment") +
  labs(title = "Constipation (CO Score)") +
  theme_minimal()


library(corrplot)
ggplot(CO_data, aes(x = df.time, y = mean, group = as.factor(df.group), color = as.factor(df.group))) +
  geom_line() +
  geom_errorbar(aes(ymin = lower_ci, ymax = up_ci), width = 0.2) +
  scale_x_continuous(breaks = c(0, 4, 8, 12), name = "Time") +
  scale_y_continuous(limit=c(0,50),breaks = seq(0, 100, by = 10), name = "Mean CO Score") +
  scale_color_manual(values = c("blue", "red"), 
                     labels = c("Azacitidine", "Azacitidine + Lenalidomide"),
                     name = "Treatment") +
  labs(title = "Constipation(CO Score)") +
  theme_minimal()



