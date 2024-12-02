## Overview

Physical activeness and factors affecting it is explored in this repository. 

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from X.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.

## Downloading data details

The study conducted utilises datasets that have been curated by Faculty of Arts and Science, University of Toronto. Students and staff from the University of Toronto may access the dataset from this link: [https://sda-artsci-utoronto-ca.myaccess.library.utoronto.ca/index.html/](https://sda-artsci-utoronto-ca.myaccess.library.utoronto.ca/index.html/).
1. If prompted, login using UTORID and password
2. Click on 'Continue in English'
3. Under 'Canadian microdata' section, click on 'Canadian community health surveys (CCHS)'
4. Under 'CCHS Public use microdata files', look for 'CCHS 2017-18:' and 'Annual Component'. On the same row, click on...
  
  - Data: to obtain raw dataset or a subset of raw data
  - Documentation: obtain detailed documentation of each variable
  
## Interactive Health Region Map 

The map shows the area of interest. We will proceed to investigate individuals within this region (Ontario). This map sections out Ontario by health regions outlined by Provincial Ministries of Health.


## Statement on LLM usage

Aspects of the paper were written with the help of ChatGPT and the entire chat history is available in other/llm_usage.
- Formatting of mathematical equations in paper/paper.qmd were written with the help of ChatGPT. Refer to other/llms_usage/paper_formatting.txt.
- Summary of original dataset in paper/paper.qmd were written with the help of ChatGPT. Refer to other/llms_usage/original_dataset_summarising.txt
- Abstract in paper/paper.qmd was written with the help of ChatGPT. Refer to other/llm_usage/abstract.txt