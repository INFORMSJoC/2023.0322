


push!(LOAD_PATH, "./")
push!(LOAD_PATH, "./src/rere_dml")
push!(LOAD_PATH, "./src/solver")

using CSV
using Tables
using DataFrames
using LinearAlgebra
using StatsBase
using DiagDml
using TripletModule

#本文件用于测试DDML（对角化度量学习）的求解器，如交替方向乘子法、拉格朗日乘子法和线性规划方法（仅能用于原问题或者L1）。罚函数法等方法的使用请在DiagDml模块中设置
#This file is used to test the performance of the proposed and traditional solvers for DDML(Diagonal Distance Metric Learning)


path="./data/"
# f = "credit_score2"
f = "credit_data_masked"


fn=path*f*".csv"

println("Loading data from $fn--------------------------")
csv = CSV.read(fn,DataFrame)
# data = convert(Array{Float16,2}, csv[:,1:end-1])
data = Array{Float32,2}(csv[:,1:end-1])
dt = fit(UnitRangeTransform, data, dims=1)
# dt = fit(ZScoreTransform, data, dims=1)
data = StatsBase.transform(dt, data)
# println(data)
labels = "label_".*string.(csv[:,end])
# println(labels)

reg = "l2"
reg = "elastic"
# reg = "none"

# 是否使用ADMM求解器，不使用ADMM时，默认使用拉格朗日乘子法
# set if the ADMM-based solver is used. If set false, Lagrangian Multiplier method (LangMul) will be used by default.

if_admm = true

max_trip_num = 10000000
if !if_admm
    # 使用传统梯度下降法的求解器时，三元组的数量设置取决于运行电脑的内存大小，设置过大容易导致内存崩溃
    # When traditional gradient-descent methods (e.g., LangMul) are used, too many triplets will generate too many varibles and overwhelm the solver
    max_trip_num = 3000
end

# reg = "l1"
distance_type = "no_huber"
# set regWeight to 0 if we want no regularization
regWeight = 10^5
# set alpha to 1 if we want to conduct L1 regularization
alpha = 0.8

triplets = TripletModule.build_triplets(data, labels,max_trip_num)
@time x=DiagDml.solve_diag_dml(triplets,regWeight,alpha,distance_type,if_admm)
println("Solutions:",x)

new_data = data * Diagonal(x)
new_data = round.(new_data;digits=12)
# println(new_data)
csv = hcat(new_data,labels)
# println(csv)
output = path*f*"_"*reg*"_"*distance_type*".csv"
table = Tables.table(csv)
CSV.write(output,table)

using Plots
plotly()
bar(x)