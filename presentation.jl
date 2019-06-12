import Pkg
Pkg.activate(".")
using JuMP, ProxSDP, SCS, LinearAlgebra, JLD

function solvewithprox(W, n)
    m = Model(with_optimizer(ProxSDP.Optimizer, log_verbose = true))
    @variable(m, X[1:n, 1:n], PSD)
    @constraint(m, diag(X) .== 1)
    @objective(m, Min, sum(diag(W*X)))
    optimize!(m)
    solution = JuMP.value.(X)
    return nothing
end

function solvewithscs(W, n)
    m = Model(with_optimizer(SCS.Optimizer))
    @variable(m, X[1:n, 1:n], PSD)
    @constraint(m, diag(X) .== 1)
    @objective(m, Min, sum(diag(W*X)))
    optimize!(m)
    solution = JuMP.value.(X)
    return nothing
end


n = 50
W = load("matrixW50.jld")["W"]
solvewithprox(W, n)
solvewithscs(W, n)

n = 100
W = load("matrixW100.jld")["W"]
solvewithprox(W, n)
solvewithscs(W, n)

n = 300
W = load("matrixW300.jld")["W"]
solvewithprox(W, n)
solvewithscs(W, n)