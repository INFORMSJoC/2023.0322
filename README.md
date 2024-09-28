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

The models proposed in the paper are implemented using Julia language (v.1.8.0), and the dependencies of the Julia libraries can be found in [Project.toml](Project.toml).



## Description

This repository provides an end-to-end solution to the static rebalancing operations in bike sharing systems. The study uses the raw data of bike demand and station inventory status to generate the optimal rebalancing routes that reallocate system-wide bike inventories among stations during the night to maintain a high service level while minimizing demand loss due to stockout or overcapacity. The repository reports the raw data, algorithms, and extensive numerical experiments reported in the paper, using real-world data from New York City Citi Bike.

This repository includes three folders, **src**, **scripts**, **results**, and **data**.

## Source code
The **src** folder contains a sample of the raw data used in the paper and different scales of case studies for the rebalancing optimization. Specifically, the folder contains the following data files:

The **solver** folder contains the solvers of the regularized diagonal Distance Metric Learning (DML) problems.

1. RereDiagDmlADMMDistributed.jl: The main solver of the optimization problem with ADMM-based parallelization. It can split the problem with many blocks of samples, and is suitable for large-scale industrial applications.
2. RereDmlLpSolver.jl: The solver based on Linear Programming. It has three typical use cases: (1) The solver of the DML problem when no regularization is used; (2) The solver of the DML problem when L1 regularization is used; (3) The solver of the optimization problem in the first line of the ADMM functions.
3. RereDiagDmlSolverLangMul.jl: The solver based on Lagrange Multiplier Method (Augmented Lagrangian Function). It is used to compare the performances with ADMM-based solver. 
4. RereDiagDmlSolverPf2.jl: The solver based on Penalty Function Method. It is also used to compare the performances with ADMM-based solver. 

The **rere_dml** folder contains the helper modules to formulate the regularized diagonal Distance Metric Learning (DML) problems.

1. TripletModule.jl: The module for building the triplets in DML with provided features and labels.
2. DiagDml.jl: The module for formulating the triplets and regularization parameters into optimization problems, then call the solvers accordingly, and finally returns the results.

## Script files

The **script** folder contains the scripts used for DML data transformation and grouping effect analysis. 

1. test_ddml_gd.jl: This file is used to test the performance of the proposed and traditional solvers for DDML(Diagonal Distance Metric Learning).
2. test_ddml_admm.jl: This file is specially used to test the performance of the ADMM solver for DDML(Diagonal Distance Metric Learning).
3. grid_search_ddml_admm.jl: This file is used to conduct grid search, i.e., generate transformed files using different combinations of alpha and regWeight, such that we can evaluate the performances of the generated files with k-NN, and infer the best parameters.
4. reg_path_diag_dml.jl: This file is used to generate the regularization path with different combinations of alpha and regWeight.
5. grouping_effect_analysis.jl: This file is used to analyze the grouping effects of the features. This file depends on the results generated by reg_path_diag_dml.jl, i.e., the regularization path results. 
6. grouping_effect_analysis_amended.jl: This file is used to analyze the grouping effects of the features with the amend factor. This file depends on the results generated by reg_path_diag_dml.jl, i.e., the regularization path results. 


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