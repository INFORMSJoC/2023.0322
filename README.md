[![INFORMS Journal on Computing Logo](https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg)](https://pubsonline.informs.org/journal/ijoc)

# Feature Selection and Grouping Effect Analysis for Credit Evaluation via Regularized Diagonal Distance Metric Learning

This archive is distributed in association with the [INFORMS Journal on
Computing](https://pubsonline.informs.org/journal/ijoc) under the [MIT License](LICENSE.txt).

The software and data in this repository are a snapshot of the software and data that were used in the research reported on in the paper 
[Feature Selection and Grouping Effect Analysis for Credit Evaluation via Regularized Diagonal Distance Metric Learning](https://doi.org/10.1287/ijoc.2023.0322) by Tie Li, Gang Kou, Yi Peng, and Philip S. Yu. 

**Important: This code is being developed on an on-going basis at [https://github.com/lteb2002/ddml](https://github.com/lteb2002/ddml). Please go there if you would like to get a more recent version or would like support**.

## Cite

To cite the contents of this repository, please cite both the paper and this repo, using their respective DOIs.

[https://doi.org/10.1287/ijoc.2023.0322](https://doi.org/10.1287/ijoc.2023.0322)

[https://doi.org/10.1287/ijoc.2023.0322.cd](https://doi.org/10.1287/ijoc.2023.0322.cd)


Below is the BibTex for citing this version of the code.

```
@article{tie_li_2024ijoc,
  author =        {Tie Li and Gang Kou and Yi Peng and Philip S. Yu},
  publisher =     {INFORMS Journal on Computing},
  title =         {Feature Selection and Grouping Effect Analysis for Credit Evaluation via Regularized Diagonal Distance Metric Learning},
  year =          {2024},
  doi =           {10.1287/ijoc.2023.0322.cd},
  url =           {https://github.com/INFORMSJoC/2023.0322},
  note =          {Available for download at https://github.com/INFORMSJoC/2023.0322}
}  
```
## Requirements

The models proposed in the paper are implemented using Julia 1.8.0, and the dependencies of the Julia libraries can be found in [Project.toml](Project.toml).



## Description

This repository provides an end-to-end solution to the static rebalancing operations in bike sharing systems. The study uses the raw data of bike demand and station inventory status to generate the optimal rebalancing routes that reallocate system-wide bike inventories among stations during the night to maintain a high service level while minimizing demand loss due to stockout or overcapacity. The repository reports the raw data, algorithms, and extensive numerical experiments reported in the paper, using real-world data from New York City Citi Bike.

This repository includes three folders, **src**, **scripts**, **results**, and **data**.

## Source code
The **src** folder contains a sample of the raw data used in the paper and different scales of case studies for the rebalancing optimization. Specifically, the folder contains the following data files:

1. 0-RawData: 3-month raw data of station-level bike demand and inventory status.
2. 1-DemandData: aggregated bike demand features with regional station inventory status.
3. 2-DataWeather: Data table with weather conditions for model inputs.
4. 3-1-SmallCase (SCA): Small case studies of size 15 - 19 for comparison of multi-visit and single-visit strategies. 
5. 3-2-MiddleCase: Medium case studies of size 20 - 35 for comparison of vMILP and SCA. 
6. 4-LargeCase: Large case study of the NYC Bike-sharing System.

## Script files

The **script** folder contains the core scripts used for data processing, prediction, and optimization. 

1. 0-Generate_AggregateDemand.py: generage aggregate demand (in 1-DemandData Folder) using raw dataset (in 0-RawData).
2. 1-CombineWeather.py: combine weather information and generate data table (in 2-DataWeather).
3. 2-Regression.py: a NARX model for demand prediction. Please revise the following configuration for the prediction of a specific time period demand.

## Data files
The **data** folder contains a sample of the raw data used in the paper and different scales of case studies for the rebalancing optimization. Specifically, the folder contains the following data files:

1. 0-RawData: 3-month raw data of station-level bike demand and inventory status.
2. 1-DemandData: aggregated bike demand features with regional station inventory status.
3. 2-DataWeather: Data table with weather conditions for model inputs.
4. 3-1-SmallCase (SCA): Small case studies of size 15 - 19 for comparison of multi-visit and single-visit strategies. 
5. 3-2-MiddleCase: Medium case studies of size 20 - 35 for comparison of vMILP and SCA. 
6. 4-LargeCase: Large case study of the NYC Bike-sharing System.

```python
HOUR = 8 #hour of the day
PERIOD = 1 # period of the hour (1: first 30-minutes period; 2: second 30-minutes period)
WEEKDAY = True #(Weekday demand or weekend demand prediction)
HISTORICAL_WINDOW = 5 #(time lag. 5: for weekday prediction; 2: weekend prediction.)
TEST_HORIZON = 10 #(number of days for evaluation)
```
The following scripts are used for small and medium case studies:

4. 3-1-Multivisit_vMIP.py: vMIP model that supports multivisit strategy (Table 2).
5. 3-2-Singlevisit_vMIP.py: vMIP model that supports single visit strategy (Table 2).
6. 3-3-SCA.py, 3-3-SCA-middlecase.py: SCA heuristic model that supports multi-visit strategy (Tables 3, 4, E1, E2, E3, E4).

The following scripts are used for large case study.

1. 4-1-NYC LargeCase Codeserver.py: SCA heuristic model for the complete case study (Table F.1).
2. 4-2-NYC LargeCase visualization.py: visualization of the final rebalacing operation decisions (Figure F.1).


The **result** folder contains log files and final outputs of the scripts.

## Ongoing Development

This code is being developed on an on-going basis at the author's
[Github site](https://github.com/liujm8/IJOC-Bike).