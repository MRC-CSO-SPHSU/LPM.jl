module SimSetup

using Memoization 

using  MALPM.Models: MAModel, allPeople, birthParameters
using  MALPM.Examples
using  MALPM.Simulate: dodeaths!, dobirths!, 
        do_age_transitions!, do_work_transitions!, do_social_transitions!, 
        dodivorces!, domarriages!, do_assign_guardians!

using  MultiAgents: AbstractABMSimulator
using  MultiAgents: attach_pre_model_step!, attach_post_model_step!, 
                    attach_agent_step!, currstep 
using  SocioEconomics.Utilities: setVerbose!, unsetVerbose!, setDelay!,
                    checkAssumptions!, ignoreAssumptions!, date2yearsmonths
using  SocioEconomics.XAgents: age, isMale, isFemale, isSingle, alive, hasDependents
using  SocioEconomics.API.Traits: FullPopulation, AlivePopulation
using  SocioEconomics.Specification.SimulateNew: death!, birth!, divorce!, marriage!, 
        assign_guardian!, age_transition!, work_transition!, social_transition!

import SocioEconomics.API.ModelFunc: share_childless_men, eligible_women
import MultiAgents: setup!, verbose
#export setup!  

function setupCommon!(sim::AbstractABMSimulator) 

    verbose(sim) ? setVerbose!() : unsetVerbose!()
    setDelay!(sim.parameters.sleeptime)
    sim.parameters.checkassumption ? checkAssumptions!() :
                                        ignoreAssumptions!()
    
    attach_post_model_step!(sim,dodeaths!)
    attach_post_model_step!(sim,do_assign_guardians!)
    attach_post_model_step!(sim,dobirths!)
    attach_post_model_step!(sim,domarriages!)
   
    nothing 
end 

_popfeature(::LPMUKDemography) = FullPopulation() 
_popfeature(::LPMUKDemographyOpt) = AlivePopulation() 

deathstep!(person, model, sim, example) = 
    death!(person, currstep(sim),model,_popfeature(example))

birthstep!(person, model, sim, example) = 
    birth!(person, currstep(sim),model,_popfeature(example))
    
divorcestep!(person, model, sim, example) = 
    divorce!(person, currstep(sim), model, _popfeature(example))

marriagestep!(person, model, sim, example) = 
    marriage!(person, currstep(sim), model, _popfeature(example))

assign_guardian_step!(person, model, sim, example) = 
    assign_guardian!(person, currstep(sim), model, _popfeature(example))

age_transition_step!(person, model, sim, example) = 
    age_transition!(person, currstep(sim), model, _popfeature(example))

work_transition_step!(person, model, sim, example) = 
    work_transition!(person, currstep(sim), model, _popfeature(example))

social_transition_step!(person, model, sim, example) = 
    social_transition!(person, currstep(sim), model, _popfeature(example))

_ageclass(person) = trunc(Int, age(person)/10)
@memoize Dict function share_childless_men(model::MAModel, ageclass :: Int)
    nAll = 0
    nNoC = 0
    for p in Iterators.filter(x->alive(x) && isMale(x) && _ageclass(x) == ageclass, allPeople(model))
        nAll += 1
        if !hasDependents(p)
            nNoC += 1
        end
    end
    return nNoC / nAll
end

@memoize eligible_women(model::MAModel) = 
    [f for f in allPeople(model) if isFemale(f) && alive(f) &&
        isSingle(f) && age(f) > birthParameters(model).minPregnancyAge]

function reset_cache_marriages(model,sim,::LPMUKDemography)
    #@info "cache reset at $(date2yearsmonths(currstep(sim)))"
    Memoization.empty_cache!(share_childless_men)
    Memoization.empty_cache!(eligible_women)
end

"set up simulation functions where dead people are removed" 
function setup!(sim::AbstractABMSimulator, example::LPMUKDemography)
    attach_agent_step!(sim,age_transition_step!)
    attach_agent_step!(sim,divorcestep!)
    attach_agent_step!(sim,work_transition_step!)
    attach_agent_step!(sim,social_transition_step!)
    # attach_agent_step!(sim,marriagestep!) # does not seem to work properly (may be due to memoization)
    setupCommon!(sim)
    nothing 
end

function setup!(sim::AbstractABMSimulator,example::LPMUKDemographyOpt) 
    attach_post_model_step!(sim,do_age_transitions!)
    attach_post_model_step!(sim,dodivorces!)
    attach_post_model_step!(sim,do_work_transitions!)
    attach_post_model_step!(sim,do_social_transitions!)
    setupCommon!(sim)
    nothing 
end

end # SimSetup 