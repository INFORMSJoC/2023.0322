


push!(LOAD_PATH, "./")
push!(LOAD_PATH, "./rere_dml")
push!(LOAD_PATH, "./lpsolver")

using CSV
using Tables
using DataFrames
using LinearAlgebra
using StatsBase
using RereDiagDmlADMMDistributed
using TripletModule
using Random


#本文件用于测试DDML（对角化度量学习）的ADMM求解器
#This file is used to test the performance of the ADMM solver for DDML(Diagonal Distance Metric Learning)

path="G:\\dataset\\dml_feature_selection_data\\"
f = "credit_score2"
# f = "iris"
# f = "credit_score2_samples"


fn=path*f*".csv"

println("Loading data from $fn--------------------------")
csv = CSV.read(fn,DataFrame)
# data = convert(Array{Float32,2}, csv[:,1:end-1])
data = Array{Float32,2}(csv[:,1:end-1])
dt = fit(UnitRangeTransform, data, dims=1)
# dt = fit(ZScoreTransform, data, dims=1)
data = StatsBase.transform(dt, data)
# println(data)
labels = "label_".*string.(csv[:,end])
# println(labels)

# reg = "l1"
# alpha = 0.8
# regWeight = 10^5

lns = 10.0 : -0.5: -10
as=0.0:0.1:0.9

triplets = TripletModule.build_triplets(data, labels)
Random.seed!(3)
shuffle!(triplets)
println("Total triplets number:",length(triplets))


for alpha in as
    println("Current task:",alpha)
    w_stack = zeros(length(lns),size(data)[2])
    Threads.@threads for (i,pow) in collect(pairs(lns))
        regWeight = 10.0^pow
        @time x,errors=RereDiagDmlADMMDistributed.admmIterate(triplets,regWeight,alpha)

        # x = round.(x;digits=12)
        println("Solutions:",x)
        println("errors:",errors)

        new_data = data * Diagonal(x)
        # new_data = round.(new_data;digits=12)
        # println(new_data)
        csv = hcat(new_data,labels)
        # println(csv)
        output = path*"grid_search\\"*f*"_a"*string(alpha)*"_lam_"*string(regWeight)*"_admm.csv"
        table = Tables.table(csv)
        CSV.write(output,table)

    end
end