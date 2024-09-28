


push!(LOAD_PATH, "./")
push!(LOAD_PATH, "./src/rere_dml")
push!(LOAD_PATH, "./src/solver")

using CSV
using Tables
using DataFrames
using LinearAlgebra
using StatsBase
using RereDiagDmlADMMDistributed
using TripletModule
using Random


# This file is used to conduct grid search, i.e., generate transformed files using different combinations of alpha and regWeight,
# such that we can evaluate the performances of the generated files with k-NN, and infer the best parameters.

path="./data/"
# f = "credit_score2"
f = "credit_data_masked"

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
        # To conduct data transformation, we need to take the square root form of the DML matrix A
        # This issue has been handled by DiagDml. But if we call admm solver directly, we need to handle this issue manually.
        x = sqrt.(x)
        x = round.(x;digit)
        println("Solutions:",x)
        println("errors:",errors)

        new_data = data * Diagonal(x)
        new_data = round.(new_data;digits=12)
        # println(new_data)
        csv = hcat(new_data,labels)
        # println(csv)
        path2 = path*"grid_search/"
        mkpath(path2)
        output = path2*f*"_a"*string(alpha)*"_lam_"*string(regWeight)*"_admm.csv"
        table = Tables.table(csv)
        CSV.write(output,table)

    end
end