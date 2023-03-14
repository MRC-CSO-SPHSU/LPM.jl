# LPM.jl

[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

Implementation of the Lone Parents Model based on the SocioEconomics.jl Library. The initial code is based on the LoneParentsModel.jl package that was implemented together by Martin Hinsch and Atiyah Elsheikh.  

Releases
========

- **V0.1.0 (28.11.2022)** : The lone parent model (corresponding to LoneParentsModel.jl Version 0.6.1) based on the SocioEconomics.jl package V0.1.0 

   - V0.1.1 (29.11)  : Simplified usage of SocioEconomics Library 
   - V0.1.2 ( 1.12)  : "data parameters" and loading / handling parameters from command line and input files is now part of SE library within ParamTypes module
   - V0.1.3 ( 2.12)  : Utilties is a part of the SE* libraries (compatible with SE V0.1.3)  
   
- **V0.2.0 (5.12.2022)** : Unified API of CreateX and Initialize functions (compatible with SE V0.2)
   - Remark: main.jl is no longer maintained.  

   - V0.2.1 (7.12)   : New Simulation Interface for 3 functions, doBirths!, doDeaths!, doDivorces, Improved API for parameter accessory functions, compatible with SE* Version 0.2.1
   - V0.2.2 (8.12)   : doMarriages (SE* V0.2.2)
   - V0.2.3 (9.12)   : adoptions, workTransitions, socialTransitions, ageTransitions (SE* V0.2.3)  
   - V0.2.4 (14.12)  : adjusting to SimpleABM types of MA Version 0.4, improved model data structure 
   - V0.2.5 (21.12)  : exploits some tuned simulation functions from SE* V0.2.5 and improved performance  
   - V0.2.6 (27.12)  : Improved implementation of allocation algorithms (no temporary arrays), tuned do marriage algorithm (memoization can be avoided) & Improved runtime performance (3x faster & 4x less memory allocation and storage w.r.t. V0.2.5) 
   - V0.2.7 (6.1.2023) :  Memoization with domarriage alg can be done only externally (if desired). Employing newly tuned and exact API of four simulation functions. Optimized simulation (with deads removal) vs. normal simulation (without deads removal) 
   - V0.2.8 (8.1.2023) :  employing tuned API of assigning guardians 
- **V0.3 (14.01.2023)** : Making use of the rest of the fixed API of SE's Simulate function, further code simplification and tuning. Signficant memory allocation reduction and runtime performance improvement  
   - V0.3.1 (16.1) : Blue style badge, separating mainMAHelpers.jl from mainHelpers.jl, arbitrary population size
   - V0.3.2 (20.1) : Employing the blue-styled SE V0.3.2 
- **V0.4 (14.03.2023)** : Compatible with SE Version SE0.4, started an Agents.jl-based main program, moving unsed code to deprecated 

Performance Progress History 
============================

The following is the progress history of executing mainMA.jl on a personal labtop equipped with 2.5 GHz processor (11th Gen. Intel i9-11900) & Memory of 32 GB. The parameter values and data used are given within [SocioEconomics.ParamTypes module](https://github.com/MRC-CSO-SPHSU/SocioEconomics.jl/tree/V0.3.1/src/socioeconomics/paramtypes)

Version   |   Runtime  |  # Memory Allocation | Storage used | Comment 
--- | --- | --- | --- | ---
0  | ~29 sec. | ~ 400 M | 12.5 GB | The state of LoneParentsModel.jl before starting this repo.  
V0.2.3 | 29 sec. | ~ 360 M | ~ 14 GB | execution with main.jl was quite faster but consumed more memory and storage 
V0.2.4 | 21.5 sec. | ~ 280 M | ~ 10.5 GB | MA Version 0.4
V0.2.5 | 20 sec. | ~ 155 M | ~ 8 GB |  
V0.2.6 | 7.6 sec. | ~ 37 M | ~ 2.2 GB | 
V0.2.8 | 6.3 sec. | ~ 24 M | ~ 1.6 GB |
V0.3 | 4.7 sec | ~ 380 k | ~ 90 MB | 
V0.4.2 | 4.44 sec | ~ 354 k | 88 MB |

The following is the initial population size for a 1-minute simulation 

=======
Version | 1 Minute simulation with IPS of | IPS = 100,000 | IPS = 1,000,000
--- | --- | --- | --- 
0.3.1 | 56200 (~ 2.1 M A. + 520 MB) | ~ 168 secs  (3.84 M A., 930 MB) | 5 hours 11 min (40.04 M A., 9.116 GiB)
>>>>>>> 64de09e (formatting)




