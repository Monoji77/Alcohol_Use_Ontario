![Physical Health](https://github.com/user-attachments/assets/03234d68-0bb0-42a9-802d-fe4408fa5bce)

## Overview

Physical activeness is a highly researched topic for centuries. This papers examine modern sociodemographic factors such as gender, age, income, as well as health factors like smoking, drinking and drug habits and particularly, how they may explain physical activeness among residents in Ontario. 

## File Structure

The repo is structured as:

-   `data/simulated_data` contains the simulated dataset of Canadian Community Health Survey (2017-2018) (CCHS).
-   `data/raw_data` contains the raw data as obtained from University of Toronto for CCHS data.
-   `data/analysis_data` contains the cleaned dataset which exists as a parquet.
-   `data/map_data` contains raw shape files obtained from Statistics Canada.
-   `model` contains fitted linear models. 
-   `other` contains images related to this project, details about LLM chat interactions and map outputs.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download, clean, model and map the clean data, as well as scripts to test for simulated data and cleaned parquet data.

## Downloading data details

The study conducted utilises datasets that have been curated by Faculty of Arts and Science, University of Toronto. Students and staff from the University of Toronto may access the dataset from this link: [https://sda-artsci-utoronto-ca.myaccess.library.utoronto.ca/index.html/](https://sda-artsci-utoronto-ca.myaccess.library.utoronto.ca/index.html/).
1. If prompted, login using UTORID and password
2. Click on 'Continue in English'
3. Under 'Canadian microdata' section, click on 'Canadian community health surveys (CCHS)'
4. Under 'CCHS Public use microdata files', look for 'CCHS 2017-18:' and 'Annual Component'. On the same row, click on...
  
  - Data: to obtain raw dataset or a subset of raw data
  - Documentation: obtain detailed documentation of each variable
  
## Geographical area of interest
We will proceed to investigate individuals within this region (Ontario). This map sections out Ontario by health regions outlined by Provincial Ministries of Health, as displayed by black lines. The bounded blue regions are health regions with lesser data available and the red regions are those with more data available.

![health_region_map](https://github.com/user-attachments/assets/9ec11f01-b671-45df-8a7b-fe188f5fe39f)


## Statement on LLM usage

Aspects of the paper were written with the help of ChatGPT and the entire chat history is available in other/llm_usage.
- Formatting of mathematical equations in paper/paper.qmd were written with the help of ChatGPT. Refer to other/llms_usage/paper_formatting.txt.
- Summary of original dataset in paper/paper.qmd were written with the help of ChatGPT. Refer to other/llms_usage/original_dataset_summarising.txt
- Abstract in paper/paper.qmd was written with the help of ChatGPT. Refer to other/llm_usage/abstract.txt
- Introduction in paper/paper.qmd was written with the help of ChatGPT. Refer to other/llm_usage/introduction.txt
- Weaknesses in paper/paper.qmd was written with the help of ChatGPT. Refer to other/llm_usage/weaknesses.txt
- Survey appendix in paper/paper.qmd was written with the help of ChatGPT. Refer to other/llm_usage/survey.txt 