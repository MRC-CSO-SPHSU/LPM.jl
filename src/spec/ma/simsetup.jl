using Memoization

using  MultiAgents: AbstractABMSimulator
using  MultiAgents: attach_pre_model_step!, attach_post_model_step!,
                    attach_agent_step!, currstep

import SocioEconomics.API.ModelFunc: share_childless_men, eligible_women
import MultiAgents: setup!
#export setup!

function _setup_common!(sim::AbstractABMSimulator)

    debug_setup(sim.parameters)

    attach_pre_model_step!(sim,increment_time!)
    attach_post_model_step!(sim,dodeaths!)
    attach_post_model_step!(sim,do_assign_guardians!)
    attach_post_model_step!(sim,dobirths!)
    attach_post_model_step!(sim,domarriages!)

    nothing
end

_popfeature(::LPMUKDemography) = FullPopulation()
_popfeature(::LPMUKDemographyOpt) = AlivePopulation()

deathstep!(person, model, sim, example) =
    death!(person, model, _popfeature(example))

birthstep!(person, model, sim, example) =
    birth!(person, model, _popfeature(example))

divorcestep!(person, model, sim, example) =
    divorce!(person, model, _popfeature(example))

marriagestep!(person, model, sim, example) =
    marriage!(person, model, _popfeature(example))

assign_guardian_step!(person, model, sim, example) =
    assign_guardian!(person, model, _popfeature(example))

age_transition_step!(person, model, sim, example) =
    age_transition!(person, model, _popfeature(example))

work_transition_step!(person, model, sim, example) =
    work_transition!(person, model, _popfeature(example))

social_transition_step!(person, model, sim, example) =
    social_transition!(person, model, _popfeature(example))

_ageclass(person) = trunc(Int, age(person)/10)
@memoize Dict function share_childless_men(model, ageclass :: Int)
    nAll = 0
    nNoC = 0
    for p in Iterators.filter(x->alive(x) && ismale(x) && _ageclass(x) == ageclass, all_people(model))
        nAll += 1
        if !has_dependents(p)
            nNoC += 1
        end
    end
    return nNoC / nAll
end

@memoize eligible_women(model) =
    [f for f in all_people(model) if isfemale(f) && alive(f) &&
        issingle(f) && age(f) > birth_pars(model).minPregnancyAge]

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
    _setup_common!(sim)
    nothing
end

function setup!(sim::AbstractABMSimulator,example::LPMUKDemographyOpt)
    attach_post_model_step!(sim,do_age_transitions!)
    attach_post_model_step!(sim,dodivorces!)
    attach_post_model_step!(sim,do_work_transitions!)
    attach_post_model_step!(sim,do_social_transitions!)
    _setup_common!(sim)
    nothing
end
