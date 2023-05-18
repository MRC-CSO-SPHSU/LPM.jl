"""
LPM using Agents.jl package
"""

include("src/agentsjlspec.jl")

#using MultiAgents
using Agents

const simPars, dataPars, pars = load_parameters()
# significant parameters
simPars.seed = 0; ParamTypes.seed!(simPars)
simPars.verbose = false
simPars.checkassumption = false
simPars.sleeptime = 0
pars.poppars.initialPop = 500

const data = load_demography_data(dataPars)

space = DemographicMap("The United Kingdom")
model = DemographicABM(space,pars,simPars,data)
declare_inhabited_towns!(model)
declare_pyramid_population!(model)  # pyramid population
Initialize.init!(model,AgentsModelInit();verify=true)

# Execute ...

debug_setup(model.simPars)

# TODO move to Models?
function agent_steps!(person,model)
    age_transition!(person, model)
    divorce!(person, model)
    work_transition!(person, model)
    social_transition!(person, model)
    nothing
end

function model_steps!(model)
    model.t += model.simPars.dt
    dodeaths!(model)
    do_assign_guardians!(model)
    dobirths!(model,FullPopulation())
    domarriages!(model)
    nothing
end

@time run!(model,agent_steps!,model_steps!,12*10) # run 10 year

@info currenttime(model)
