push!(LOAD_PATH, "./")
push!(LOAD_PATH, "./rere_dml")
push!(LOAD_PATH, "./lpsolver")

using CSV
using Tables
using DataFrames
using LinearAlgebra
using StatsBase
using Statistics
using DiagDml
using TripletModule

path="E:\\julia_work\\test\\data\\new_finance\\"
f = "credit_score2"
f_l1=path*f*"\\reg_path\\credit_score2_a_1.0_path.csv"

reg_files=[f*"_a_0.6_path",f*"_a_0.7_path",f*"_a_0.8_path"]
alphas = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]


cor_threshold = 0.6

ajacm = nothing
for (ind,ff) in pairs(reg_files)
    ff = path*f*"\\reg_path\\"*ff*".csv"
    reg_data = CSV.read(ff,DataFrame)
    reg_data = Array{Float32,2}(reg_data)
    dt = fit(UnitRangeTransform, reg_data, dims=2)
    reg_data = StatsBase.transform(dt, reg_data)
    m = length(reg_data[1,:])
    if ajacm === nothing
        ajacm = zeros(m,m)
    end
    # println(reg_data)
    ajc = zeros(m,m)
    wps = 5:-0.5:-5
    # println(ajc)

    for i in 1:m-1
        for j in i+1:m
            for (li, w) in pairs(wps)
                wsi=reg_data[li,i]
                wsj=reg_data[li,j]
                diff_s = 0
                if wsi != 0 || wsj != 0
                    diff_s=abs(wsi-wsj)
                end
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
output = path*f*"\\reg_path\\diff2.csv"
CSV.write(output,table)


