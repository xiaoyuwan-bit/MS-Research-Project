# Biostats Research Project
## Quality of Life Analysis: Azacitidine ± Lenalidomide in MDS/AML Patients 
This repository contains the R code and analysis from my project evaluating the impact of combining azacitidine with lenalidomide on the quality of life (QoL) of patients diagnosed with higher-risk myelodysplastic syndrome (MDS) and low-blast acute myeloid leukemia (AML). The analysis uses simulated data based on a clinical trial by Kenealy et al.
## Project Objectives
* Assess how adding lenalidomide to azacitidine impacts patient QoL.
* Identify statistically and clinically meaningful differences using EORTC QLQ-C30 metrics.
## Data
* Simulated raw data, and converted it into standardized EORTC QLQ-C30 metric.
* Assessments at baseline, 4, 8, and 12 months, with typical clinical trial missing data scenarios.
## EORTC QLQ-C30 Questionnaire
![image](https://github.com/user-attachments/assets/eea80bad-3dae-4d40-8d39-cdfeda397103)

The European Organization for Research and Treatment of Cancer (EORTC) QLQ-C30 is a standardized questionnaire developed to evaluate the quality of life in cancer patients. It includes 30 questions across three main areas:

**Global Health Status/QoL:** Reflects overall health and perceived quality of life.

**Functional Scales:** Covers physical, emotional, cognitive, social, and role function.

**Symptom Scales:** Includes fatigue, nausea/vomiting, pain, dyspnea, insomnia, appetite loss, constipation, diarrhea, and financial difficulties.

Scoring ranges from 0 to 100, with higher scores indicating better function status or greater symptom severity.
## Scoring Formula ##
<img width="423" alt="1742292561534" src="https://github.com/user-attachments/assets/fe41bf8f-34c0-4209-b8c7-8534818de923" />

To calculate the final score, first calculate the raw score for each indicator:

$$
\begin{align*}
\text{Raw Score} = RS = \frac{I_1 + I_2 + \ldots + I_n}{n} \\
\text{Where } I_1, I_2, \ldots, I_n \text{ are items response (on a Likert scale)}
\end{align*}
$$

**Global Health Status:** items measuring overall health and quality of life, scaled from 1 (very poor) to 7 (excellent). After averaging the relevant questions, standardize the average scores from 0 to 100 scores.
  
  $$
  \begin{align*}
 Score = \left(\frac{\text{RS} - 1}{\text{range}}\right) \times 100
  \end{align*}
  $$
  
**Functional Scales:** 5 indicators assessing physical functioning, role functioning, emotional functioning, cognitive functioning, and social functioning. Each item rated from 1 (not at all) to 4 (very much), indicating increasing difficulty.

$$
\begin{align*}
Score =\left(1-\frac{\text{RS}-1}{\text{range}}\right)\times100
\end{align*}
$$


**Symptom Scales:** 9 items evaluating common symptoms of cancer such as fatigue, nausea, and vomiting, pain, dyspnea, insomnia, appetite loss, constipation, diarrhea, financial difficulties. Each is also rated from 1 (not at all) to 4 (very much), where the higher score indicates greater symptom severity.

$$
\begin{align*}
Score =\left(\frac{\text{RS}-1}{\text{range}}\right)\times100
\end{align*}
$$

EORTC QLQ-C30 assessments were conducted at baseline and at 4, 8, and 12 months during the study. 
For detailed scoring methods, please see the [EORTC QLQ-C30 Scoring Manual](chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://www.eortc.org/app/uploads/sites/2/2018/02/SCmanual.pdf).

## Methodology ##
* Generalized Estimating Equation (GEE) for longitudinal data analysis.
* Graphical representation using mean QoL scores and forest plots.
* Model selection using ANOVA tests and Quasi-likelihood Information Criterion (QIC).

## Key Results ##
* No statistically significant improvement in QoL from combining lenalidomide with azacitidine.
* QoL indicators largely showed no meaningful clinical difference between treatment groups.

## Visualizations ##
* Mean QoL scores over time 
![image](https://github.com/user-attachments/assets/b2a7d1d7-bfaf-41f2-9403-482f9d9319bf)
![image](https://github.com/user-attachments/assets/4c89752f-be5a-4e1d-b0f8-322c978cba52)
![image](https://github.com/user-attachments/assets/81bdecae-e871-4948-b8e6-4d730d923c77)
![image](https://github.com/user-attachments/assets/c313d16a-19d7-4f86-a9b9-c50f4a7c4ffb)
* Forest plots showing treatment differences
![image](https://github.com/user-attachments/assets/2772fefb-8c58-43da-a9ec-5a3f55bf2638)

## Limitations ##
* Analysis performed on simulated data; results may differ from real-word data.
* Missing data could introduce potential biases.

## Tools Used ##
* R (version 4.4.0)
* Libraries: Tidyerse, geepack, ggplot2, geeasy
* Microsoft Excel




