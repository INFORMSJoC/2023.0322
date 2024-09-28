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

This repository provides an implementation of the regularized diagonal Distance Metric Learning (DML) model, which improves distance metrics, selecting features and conduct grouping effect analysis by rescaling the features. One characteristic of the proposed model is that it does not pursue linear separability, which is highly unrealistic in financial data. Another characteristic of the proposed model is that it does not ommit correlated features when conducting feature selection, and thus not neglect important credit risk sources when used for credit evaluation. The implementation of the solver based on ADMM makes it suitable for large-scale financial application. The repository also provides the scripts, raw data, and experiments results reported in the paper, using real-world data from a Chinese bank.


This repository includes four folders, **src**, **scripts**, **data**, and **results**.

## Source code
The **src** folder contains the solvers of the regularized diagonal DML problems and the helper modules used to build triplets, formulate optimization problems, and return optimized ressults. Specifically, the folder contains the following folders:

The **solver** folder contains the solvers of the regularized diagonal DML problems.

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
The **data** folder contains a masked version of the raw credit data used in the paper. The original meaning of the features can be found in Section 3 of the paper. The sensitive information has been masked, and the order of data rows and columns has been shuffled because of privacy concerns.


## Results
The **results** folder contains log files and final outputs of the regularization path and grouping effect analysis.

## Ongoing Development

This code is being developed on an on-going basis at the author's
[Github site](https://github.com/lteb2002/ddml).