push!(LOAD_PATH, "./")
push!(LOAD_PATH, "./src/rere_dml")
push!(LOAD_PATH, "./src/solver")

using CSV
using Tables
using DataFrames
using LinearAlgebra
using StatsBase
using Statistics
using DiagDml
using TripletModule


# This file is used to analyze the grouping effects of the features with the amend factor.
# This file depends on the results generated by reg_path_diag_dml.jl, i.e., the regularization path results. 
# The amend factor can become unreasonably large when lambda_s is extremely large. This can makes the result risky.
# So far, experiments showed that the grouping effect results can be very similar with and without the amend factor.


path="./results"
f = "credit_data"
f_l1=path*"/reg_path/credit_data_a_1.0_path.csv"


reg_files=[f*"_a_0.1_path",f*"_a_0.2_path",f*"_a_0.3_path",f*"_a_0.4_path",f*"_a_0.5_path",f*"_a_0.6_path",f*"_a_0.7_path",f*"_a_0.8_path",f*"_a_0.9_path"]
alphas = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]


cor_threshold = 0.6

wps = 5:-0.5:-5
alpha_0 = 0.1
lambda_0 = 1.0E0

function compute_a(lambda_s,alpha_s)
    a = (lambda_s*(1-alpha_s))/(lambda_0*(1-alpha_0))
    # The amend factor can become unreasonably large when lambda_s is extremely large
    return a
end

ajacm = zeros(m,m)
for (ind,ff) in pairs(reg_files)
    fn = path*"/reg_path/"*ff*".csv"
    reg_data = CSV.read(fn,DataFrame)
    reg_data = Array{Float32,2}(reg_data)
    dt = fit(UnitRangeTransform, reg_data, dims=2)
    reg_data = StatsBase.transform(dt, reg_data)
    # println(reg_data)
    ajc = zeros(m,m)

    # println(ajc)
    for i in 1:m-1
        for j in i+1:m
            for (li, w) in pairs(wps)
                lamba_s=1.0*(10^w)
                f0=replace(ff, f*"_a_" => "")
                f0=replace(f0, "_path" => "")
                alpha_s = parse(Float32,f0)
                # calculate the amend factor
                amend = compute_a(lamba_s,alpha_s)
                wsi=reg_data[li,i]
                wsj=reg_data[li,j]
                diff_s = 0
                if wsi != 0 || wsj != 0
                    diff_s = amend*abs(wsi-wsj)
                end
                # 对称矩阵
                ajc[i,j]+=diff_s
                ajc[j,i]+=diff_s
            end
        end
    end
    ajc = ajc ./ length(wps)
    # println(ajacm)
    global ajacm = ajacm + ajc
end

ajacm = ajacm ./ length(reg_files)
ajacm = (ajacm .- minimum(ajacm))/(maximum(ajacm)-minimum(ajacm))
ajacm = 1 .- ajacm
# println(round.(ajacm,digits=2))
# ajacm[ajacm .>= cor_threshold] .= 1
# ajacm[ajacm .< cor_threshold] .= 0


l1_data = CSV.read(f_l1,DataFrame)
l1_data = Array{Float32,2}(l1_data)
m = length(l1_data[1,:])
for i in  1:m-1
    for j in i+1:m
        wi=l1_data[1,i]
        wj=l1_data[1,j]
        # The variables kept by L1 are hardly possible to be correlated (Use LP solver, not ADMM)
        if wi != 0 && wj != 0
            ajacm[i,j] = 0
            ajacm[j,i]=0
        end
    end
end

println(ajacm)

table = Tables.table(ajacm)
output = path*"/ajacm2.csv"
CSV.write(output,table)


