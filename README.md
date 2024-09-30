[![INFORMS Journal on Computing Logo](https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg)](https://pubsonline.informs.org/journal/ijoc)

# Feature Selection and Grouping Effect Analysis for Credit Evaluation via Regularized Diagonal Distance Metric Learning

This archive is distributed in association with the [INFORMS Journal on
Computing](https://pubsonline.informs.org/journal/ijoc) under the [MIT License](LICENSE.txt).

The software and data in this repository are a snapshot of the software and data reported in the paper 
[Feature Selection and Grouping Effect Analysis for Credit Evaluation via Regularized Diagonal Distance Metric Learning](https://doi.org/10.1287/ijoc.2023.0322) by Tie Li, Gang Kou, Yi Peng, and Philip S. Yu. 

**Important: This code is being developed on an on-going basis at [https://github.com/lteb2002/ddml](https://github.com/lteb2002/ddml). Please go there if you would like to get a more recent version or would like to support**.

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

This repository provides an implementation of the regularized diagonal Distance Metric Learning (DML) model, which improves distance metrics, selects features, and conducts grouping effect analysis by rescaling the features. One characteristic of the proposed model is that it does not pursue linear separability, which is highly unrealistic in financial data. Another characteristic of the proposed model is that it considers correlated features when conducting feature selection, and thus, does not neglect important credit risk sources when used for credit evaluation. The implementation of the solver based on the Alternating Direction Method of Multipliers(ADMM) makes it suitable for large-scale financial applications. The repository also provides the scripts, data, and experimental results reported in the paper.


This repository includes four folders, **src**, **scripts**, **data**, and **results**.

## Source code
The **src** folder contains the solvers of the regularized diagonal DML problems and the helper modules used to build triplets, formulate optimization problems, and return optimized results. Specifically, the folder contains the solver and rere_dml sub-folders:

The **solver** contains the solvers of the regularized diagonal DML problems.

1. RereDiagDmlADMMDistributed.jl: It is the main solver of the optimization problem with ADMM-based parallelization. It splits the problem into smaller ones using blocks of samples and is suitable for large-scale industrial applications.
2. RereDmlLpSolver.jl: The solver is based on Linear Programming and is used in three typical cases: (1) The solver of the DML problem when no regularization is used; (2) The solver of the DML problem when L1 regularization is used; (3) The solver of the optimization problem in the first line of the ADMM functions (Eq. 15).
3. RereDiagDmlSolverLangMul.jl: The solver is based on Lagrange Multiplier Method (Augmented Lagrangian Function) and is used as a traditional solver to compare its performance with the ADMM-based solver. 
4. RereDiagDmlSolverPf2.jl:  The solver is based on Penalty Function Method and is also used as a traditional solver to compare its performance with the ADMM-based solver. 


The **rere_dml** contains the helper modules to formulate the regularized diagonal Distance Metric Learning (DML) problems.

1. TripletModule.jl: The module builds the triplets in DML with provided features and labels.
2. DiagDml.jl: The module formulates the triplets and regularization parameters into optimization problems, then calls the solvers accordingly, and finally returns the results.

## Script files

The **script** folder contains the scripts used for DML data transformation and grouping effect analysis. 

1. test_ddml_gd.jl: The script is used to test the performance of the proposed and traditional solvers for regularized diagonal DML.
2. test_ddml_admm.jl: The script is used to test the performance of the ADMM solver for regularized diagonal DML.
3. grid_search_ddml_admm.jl: The script is used to conduct grid search, i.e., generate transformed files using different combinations of alpha and regularization weights (defined in Eq. 3), such that we can evaluate the performance of the generated files with k-NN, and find the best combination of parameters.
4. reg_path_diag_dml.jl: The script is used to generate the regularization path with different combinations of alpha and regularization weights (defined in Eq. 3).
5. grouping_effect_analysis.jl: This file is used to analyze the grouping effects of the features. This file depends on the results generated by reg_path_diag_dml.jl, i.e., the regularization path results. 
6. grouping_effect_analysis_amended.jl: The script is used to analyze the grouping effects of the features with the amend factor. This file depends on the results generated by reg_path_diag_dml.jl, i.e., the regularization path results. 


## Data files
The **data** folder contains a masked version of the raw credit data used in the experiment. The original meaning of the features can be found in Section 3 of the paper. The sensitive information has been masked, and the order of data rows and columns has been shuffled due to data privacy.


## Results
The **results** folder contains log files and final outputs of the regularization path and grouping effect analysis.

## Ongoing Development

This code is being developed on an on-going basis at the author's
[Github site](https://github.com/lteb2002/ddml).