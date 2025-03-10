%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This document will only track changes to the toolbox proper (i.e., those 
%files residing in the 'Palamedes' folder). Changes to files in the 
%PalamedesDemos folder will not be documented here (or elsewhere).
%
%Palamedes: Matlab routines for analyzing psychophysical data.
%
%Nick Prins & Fred Kingdom. palamedes@palamedestoolbox.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.0.0 launch: September 13, 2009
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.0.1 release: September 17, 2009
%Modifications:
%
% PAL_SDT_MAFCmatchSample_DiffMod_DPtoPC:
% Modified: Palamedes version 1.0.1 (FK). Changed default value of numReps 
%   from 500000 to 100000
%
% PAL_SDT_MAFCoddity_DPtoPC:
% Modified: Palamedes version 1.0.1 (FK). Changed default value of numReps 
%   from 500000 to 100000
%
% PAL_PFML_BootstrapNonParametricMultiple:
% Modified: Palamedes version 1.0.1 (NP). A warning and suggestion will be 
%   issued when OutOfNum contains ones. 
%
% PAL_PFML_BootstrapNonParametric:
% Modified: Palamedes version 1.0.1 (NP). A suggestion to consider a
%   parametric bootstrap is added to the warning issued when OutOfNum 
%   contains ones.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.0.2 release: October 1, 2009
%Modifications:
%
% PAL_PFML_GoodnessOfFitMultiple:
% Modified: Palamedes version 1.0.2 (NP). No longer produces 'DivideByZero'
%   warning when B is set to 0 (to avoid the running of simulations).
%
% PAL_PFML_GoodnessOfFit:
% Modified: Palamedes version 1.0.2 (NP). No longer produces 'DivideByZero'
%   warning when B is set to 0 (to avoid the running of simulations).
%
% PAL_PFLR_ModelComparison:
% Modified: Palamedes version 1.0.2 (NP). No longer produces 'DivideByZero'
%   warning when B is set to 0 (to avoid the running of simulations).
% Modified: Palamedes version 1.0.2 (NP). Fixed error in comments section
%   regarding the names of PF routines.
%
% PAL_PFML_Fit:
% Modified: Palamedes version 1.0.2 (NP). Fixed error in comments section
%   regarding the names of PF routines.
%
% PAL_PFML_FitMultiple:
% Modified: Palamedes version 1.0.2 (NP). Fixed error in comments section
%   regarding the names of PF routines.
%
% PAL_PFML_BootstrapNonParametric:
% Modified: Palamedes version 1.0.2 (NP). Fixed error in comments section
%   regarding the names of PF routines.
%
% PAL_PFML_BootstrapParametric:
% Modified: Palamedes version 1.0.2 (NP). Fixed error in comments section
%   regarding the names of PF routines.
%
% PAL_PFML_BootstrapNonParametricMultiple:
% Modified: Palamedes version 1.0.2 (NP). Fixed error in comments section
%   regarding the names of PF routines.
%
% PAL_PFML_BootstrapParametricMultiple:
% Modified: Palamedes version 1.0.2 (NP). Fixed error in comments section
%   regarding the names of PF routines.
%
% PAL_PFML_GoodnessOfFit:
% Modified: Palamedes version 1.0.2 (NP). Fixed error in comments section
%   regarding the names of PF routines.
%
% PAL_PFML_GoodnessOfFitMultiple:
% Modified: Palamedes version 1.0.2 (NP). Fixed error in comments section
%   regarding the names of PF routines.
%
% PAL_Logistic:
% Modified: Palamedes version 1.0.2 (NP). Added some help comments.
%
% PAL_Gumbel:
% Modified: Palamedes version 1.0.2 (NP). Added some help comments.
%
% PAL_HyperbolicSecant:
% Modified: Palamedes version 1.0.2 (NP). Added some help comments.
%
% PAL_CumulativeNormal:
% Modified: Palamedes version 1.0.2 (NP). Added some help comments.
%
% PAL_Weibull:
% Modified: Palamedes version 1.0.2 (NP). Added some help comments.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.1.0 release: November 23, 2009
%
%Summary of major change: Version 1.1.0 adds the option to custom-define 
%   constraints on the parameters of PFs between several data sets while 
%   simultaneously fitting PFs to multiple data sets. This option is also 
%   added to model comparison, multi-condition bootstrap, and 
%   multi-condition goodness-of-fit routines (specifically: 
%   PAL_PFML_FitMultiple, PAL_PFML_BootstrapNonParametricMultiple,
%   PAL_PFML_BootstrapParametricMultiple, PAL_PFML_GoodnessOfFitMultiple,
%   PAL_PFLR_ModelComparison). All previous functionality of these 
%   routines is retained. Modified and added functions are listed below.
%
%Version 1.1.0 incorporates some other changes also, but these are minor. 
%   All changes are listed below.
%
%Modifications:
%
% PAL_PFML_rangeTries:
% Modified: Palamedes version 1.1.0 (NP): Modified to assign zeros to 
%   entries in multiplier array which correspond to custom-parametrized 
%   parameters.
%
% PAL_PFML_FitMultiple:
% Modified: Palamedes version 1.1.0 (NP). Modified to allow custom-defined
%   reparametrizations of parameters. Also returns the number of free
%   parameters.
%
% PAL_PFML_TtoP:
% Modified: Palamedes version 1.1.0 (NP): Modified to accept custom-defined
%   reparametrizations also.
%
% PAL_PFML_PtoT:
% Modified: Palamedes version 1.1.0 (NP): Modified to accept custom-defined
%   reparametrizations also.
%
% PAL_Entropy:
% Modified: Palamedes version 1.1.0 (NP): upon completion returns all 
%   warning states to prior settings.
%
% PAL_MLDS_Bootstrap:
% Modified: Palamedes version 1.1.0 (NP): upon completion returns all 
%   warning states to prior settings.
%
% PAL_PFLR_ModelComparison:
% Modified: Palamedes version 1.1.0 (NP). Modified to allow custom-defined
%   reparametrization of parameters.
% Modified: Palamedes version 1.1.0 (NP): upon completion returns all 
%   warning states to prior settings.
%
% PAL_PFLR_TLR:
% Modified: Palamedes version 1.1.0 (NP). Modified to accept
%   custom-reparametrization of parameters.
%
% PAL_PFML_BootstrapNonParametric:
% Modified: Palamedes version 1.1.0 (NP): upon completion returns all 
%   warning states to prior settings.
%
% PAL_PFML_BootstrapNonParametricMultiple:
% Modified: Palamedes version 1.1.0 (NP). Modified to allow custom-defined
%   reparametrization of parameters.
% Modified: Palamedes version 1.1.0 (NP): upon completion returns all 
%   warning states to prior settings.
%
% PAL_PFML_BootstrapParametric:
% Modified: Palamedes version 1.1.0 (NP): upon completion returns all 
%   warning states to prior settings.
%
% PAL_PFML_BootstrapParametricMultiple:
% Modified: Palamedes version 1.1.0 (NP). Modified to allow custom-defined
%   reparametrization of parameters.
% Modified: Palamedes version 1.1.0 (NP): upon completion returns all 
%   warning states to prior settings.
%
% PAL_PFML_GoodnessOfFit:
% Modified: Palamedes version 1.1.0 (NP): upon completion returns all 
%   warning states to prior settings.
%
% PAL_PFML_GoodnessOfFitMultiple:
% Modified: Palamedes version 1.1.0 (NP): upon completion returns all 
%   warning states to prior settings.
% Modified: Palamedes version 1.1.0 (NP). Modified to accept custom-defined
%   reparametrizations of parameters.
%
% PAL_PFML_LLNonParametric:
% Modified: Palamedes version 1.1.0 (NP). Returns the number of free
%   parameters.
%
%Added Routines:
%
% PAL_whatIs:
% Introduced: Palamedes version 1.1.0 (NP): Determines variable type. 
%   Internal function.
%
% PAL_PFML_IndependentFit:
% Introduced: Palamedes version 1.1.0 (NP): Determines whether PFs to 
%   multiple conditions can be fit individually or whether 
%   interdependencies exist. Internal function.
%
% PAL_PFML_LLsaturated:
% Introduced: Palamedes version 1.1.0 (NP): Returns Log Likelhood and 
%   number of parameters in saturated model.
%
% PAL_PFML_setupParametrizationStruct:
% Introduced: Palamedes version 1.1.0 (NP): Creates a parameter 
%   reparametrization structure for (optional) use in functions which allow
%   specification of a model regarding the parameters of PFs across several
%   datasets.
%
% PAL_PFML_CustomDefine:
% Introduced: Palamedes version 1.1.0 (NP): This file only contains 
%   instructions on the use of custom reparametrization.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.1.1 Release October 31, 2010
%
% 
%
% Changed comments in PAL_AMPM_Demo to make explicit that values for Slope
%   estimate are in log (base 10) units.
%
% PAL_AMPM_setupPM:
% Modified: Palamedes version 1.1.1 (NP): Included previously omitted 
%   lines:  
%   PM.numTrials = 50;
%   PM.response = [];
%
%   Made explicit in the help section that log values used are log base 10.
%
% PAL_Weibull:
% Modified: Palamedes version 1.1.1 (NP). Allowed gamma and lambda to be
%   multidimensional arrays.
%
% PAL_HyperbolicSecant:
% Modified: Palamedes version 1.1.1 (NP). Allowed gamma and lambda to be
%   multidimensional arrays.
%
% PAL_CumulativeNormal:
% Modified: Palamedes version 1.1.1 (NP). Allowed gamma and lambda to be
%   multidimensional arrays.
%
% PAL_Logistic:
% Modified: Palamedes version 1.1.1 (NP). Allowed gamma and lambda to be
%   multidimensional arrays.
%
% Added routines:
%
% PAL_findMax:
% Introduced: Palamedes version 1.1.1 (NP): find value and position of 
%   maximum in 2 or 3D array
%
% PAL_PFML_paramsTry:
% Introduced: Palamedes version 1.1.1 (NP): Generate jitter on values of 
%   guesses to be supplied to PAL_PFML_Fit or PAL_PFML_FitMultiple as 
%   initial values in search.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.2.0 Release March 23, 2011
%
% 
%
% Changed PAL_PFML_Demo to include new features detailed below
% Introduced PAL_PFML_BruteForceInitials_Demo to demonstrate new features
% detailed below.
%
% PAL_AMPM_CreateLUT:
% Modified: Palamedes version 1.2.0 (NP). Corrected error in function name.
%
% PAL_AMPM_setupPM:
% Modified: Palamedes version 1.2.0 (NP): Fixed some stylistic nasties
%   (failing to pre-allocate arrays, etc.)
%
% PAL_AMRF_setupRF:
% Modified: Palamedes version 1.2.0 (NP): Fixed some stylistic nasties
%   (failing to pre-allocate arrays, etc.)
%
% PAL_AMUD_setupUD:
% Modified: Palamedes version 1.2.0 (NP) Added Garia-Perez reference in
%   comments.
%
% PAL_CumulativeNormal:
% Modified: Palamedes version 1.2.0 (NP). Added inverse PF and derivative of
%   PF as options.
%
% PAL_findMax:
% Modified: Palamedes version 1.2.0 (NP). Added 4D array. 
% Modified: Palamedes version 1.2.0 (NP). Modified such that routine works 
%   with array containing singleton dimensions. 
% Modified: Palamedes version 1.2.0 (NP). Fixed issue with function name 
%   (findMax -> PAL_findMax). 
% Modified: Palamedes version 1.2.0 (NP). Reduced memory load by
%   avoiding creation of maxVal array that existed in earlier version.
%
% PAL_Gumbel:
% Modified: Palamedes version 1.2.0 (NP). Added inverse PF and derivative 
%   of PF as options.
%
% PAL_HyperbolicSecant:
% Modified: Palamedes version 1.2.0 (NP). Added inverse PF and derivative 
%   of PF as options.
%
% PAL_inverseCumulativeNormal:
% Modified: Palamedes version 1.2.0 (NP). Added warning regarding removal 
%   of the function from a future version of Palamedes.
%
% PAL_inverseGumbel:
% Modified: Palamedes version 1.2.0 (NP). Added warning regarding removal 
%   of the function from a future version of Palamedes.
%
% PAL_inverseHyperbolicSecant:
% Modified: Palamedes version 1.2.0 (NP). Added warning regarding removal 
%   of the function from a future version of Palamedes.
%
% PAL_inverseLogistic:
% Modified: Palamedes version 1.2.0 (NP). Added warning regarding removal 
%   of the function from a future version of Palamedes.
%
% PAL_inverseWeibull:
% Modified: Palamedes version 1.2.0 (NP). Added warning regarding removal 
%   of the function from a future version of Palamedes.
%
% PAL_Logistic:
% Modified: Palamedes version 1.2.0 (NP). Added inverse PF and derivative 
%   of PF as options.
%
% PAL_MLDS_Bootstrap:
% Modified: Palamedes version 1.2.0 (NP): 'converged' is now array of 
%   logicals.
%
% PAL_PFLR_ModelComparison:
% Modified: Palamedes version 1.2.0 (NP): 'converged' is now array of 
%   logicals.
%
% PAL_PFML_BootstrapNonParametric:
% Modified: Palamedes version 1.2.0 (NP): 'converged' is now array of 
%   logicals.
% Modified: Palamedes version 1.2.0 (NP). Modified to accept 'searchGrid'
%   argument as a structure defining 4D parameter grid to search for
%   initial guesses for parameter values. See also
%   PAL_PFML_BruteForceFit.m.
%
% PAL_PFML_BootstrapNonParametricMultiple:
% Modified: Palamedes version 1.2.0 (NP): 'converged' is now array of 
%   logicals.
%
% PAL_PFML_BootstrapParametric:
% Modified: Palamedes version 1.2.0 (NP): 'converged' is now array of 
%   logicals.
% Modified: Palamedes version 1.2.0 (NP). Modified to accept 'searchGrid'
%   argument as a structure defining 4D parameter grid to search for
%   initial guesses for parameter values. See also
%   PAL_PFML_BruteForceFit.m.
%
% PAL_PFML_BootstrapParametricMultiple:
% Modified: Palamedes version 1.2.0 (NP): fixed error in help comments
%   (omission of two outputs in 'syntax' statement).
% Modified: Palamedes version 1.2.0 (NP): 'converged' is now array of 
%   logicals.
%
% PAL_PFML_Fit:
% Modified: Palamedes version 1.2.0 (NP). Modified to accept 'searchGrid'
%   argument as a structure defining 4D parameter grid to search for
%   initial guesses for parameter values. See also
%   PAL_PFML_BruteForceFit.m.
%
% PAL_PFML_GoodnessOfFit:
% Modified: Palamedes version 1.2.0 (NP): 'converged' is now array of 
%   logicals.
% Modified: Palamedes version 1.2.0 (NP). Modified to accept 'searchGrid'
%   argument as a structure defining 4D parameter grid to search for
%   initial guesses for parameter values. See also
%   PAL_PFML_BruteForceFit.m.
%
% PAL_PFML_GoodnessOfFitMultiple:
% Modified: Palamedes version 1.2.0 (NP): 'converged' is now array of 
%   logicals.
%
% PAL_PFML_GroupTrialsbyX:
% Modified: Palamedes version 1.2.0 (NP). Corrected error in function name
%   (Pal_GroupTrialsbyX -> PAL_PFML_GroupTrialsbyX)
%
% PAL_Scale0to1:
% Modified: Palamedes version 1.2.0 (NP): Modified to accept arrays of any
% size.
%
% PAL_Weibull:
% Modified: Palamedes version 1.2.0 (NP). Added inverse PF and derivative of
%   PF as options.
%
% Added routines:
%
% PAL_PFML_BruteForceFit:
% Introduced: Palamedes version 1.2.0 (NP): Fit PF using a brute-force 
%   search through 4D parameter space.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.3.0 Release September 19, 2011
%
% 
%
% Introduced PAL_PFML_lapseFit_Demo and PAL_PFML_gammaEQlambda_Demo to 
%   demonstrate new features.
%
% PAL_PF_SimulateObserverParametric;
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFLR_ModelComparison:
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFLR_TLR:
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFML_BootstrapNonParametric:
% Modified: Palamedes version 1.3.0 (NP). Added warning when 'LapseLimits'
%   argument is used but lapse is not a free parameter.
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFML_BootstrapNonParametricMultiple:
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFML_BootstrapParametric:
% Modified: Palamedes version 1.3.0 (NP). Added warning when 'LapseLimits'
%   argument is used but lapse is not a free parameter.
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFML_BootstrapParametricMultiple:
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFML_BruteForceFit:
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFML_DevianceGoF:
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFML_Fit:
% Modified: Palamedes version 1.3.0 (NP). Issue warning when 'LapseLimits'
%   argument is used but lapse is not a free parameter.
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFML_FitMultiple:
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFML_GoodnessOfFit:
% Modified: Palamedes version 1.3.0 (NP). Added warning when 'LapseLimits'
%   argument is used but lapse is not a free parameter.
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFML_GoodnessOfFitMultiple:
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFML_negLL:
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
% PAL_PFML_negLLMultiple:
% Modified: Palamedes version 1.3.0 (NP). Fixed error in function name.
% Modified: Palamedes version 1.3.0 (NP). Added options 'lapseFit' and
%   'gammaEQlambda'.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.3.1 Release September 25, 2011
%
%Minor upgrade. Modified manner in which warnings regarding 'lapseFit' and
%   'lapseLimits' are issued. In Version 1.3.0 warnings would be issued by 
%   PAL_PFML_Fit if, for example, PAL_PFML_BootstrapParametric was called
%   without 'lapseFit' argument. All modifications related to above issue.
%
% PAL_PFML_negLL:
% Modified: Palamedes version 1.3.1 (NP). Added (hidden) option 'default' 
%   for 'lapseFit'.
%
% PAL_PFML_BruteForceFit:
% Modified: Palamedes version 1.3.1 (NP). Added (hidden) option 'default' 
%   for 'lapseFit'.
%
% PAL_PFML_Fit:
% Modified: Palamedes version 1.3.1 (NP). Added (hidden) option 'default' 
%   for 'lapseFit' and modified 'lapseFit' and 'lapseLimits' warnings to
%   avoid false throws of warnings.
%
% PAL_PFML_BootstrapParametric:
% Modified: Palamedes version 1.3.1 (NP). Added (hidden) option 'default' 
%   for 'lapseFit' and modified 'lapseFit' and 'lapseLimits' warnings to
%   avoid false throws of warnings.
%
% PAL_PFML_BootstrapNonParametric:
% Modified: Palamedes version 1.3.1 (NP). Added (hidden) option 'default' 
%   for 'lapseFit' and modified 'lapseFit' and 'lapseLimits' warnings to
%   avoid false throws of warnings.
%
% PAL_PFML_GoodnessOfFit:
% Modified: Palamedes version 1.3.1 (NP). Added (hidden) option 'default' 
%   for 'lapseFit' and modified 'lapseFit' and 'lapseLimits' warnings to
%   avoid false throws of warnings.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.4.0 Release February 15, 2012
%
% The major purpose of this upgrade is to make Palamedes compatible with
% GNU Octave. All Nelder-Mead simplex searches performed by the added
% routine PAL_minimize. Also added the option to constrain the guess rate
% in the PFML and PFLR functions. Some additional minor changes.
%
% PAL_AMPM_setupPM:
% Modified: Palamedes version 1.4.0 (NP): Fixed some stylistic nasties
%   ('Matlab style short circuit operator')
%
% PAL_AMRF_setupRF:
% Modified: Palamedes version 1.4.0 (NP): Fixed some stylistic nasties
%   ('Matlab style short circuit operator')
%
% PAL_AMRF_updateRF:
% Modified: Palamedes version 1.4.0 (NP): Fixed some stylistic nasties
%   ('Matlab style short circuit operator')
%
% PAL_AMUD_updateUD:
% Modified: Palamedes version 1.4.0 (NP): Fixed some stylistic nasties
%   ('Matlab style short circuit operator')
%
% PAL_CumulativeNormal:
% Modified: Palamedes version 1.4.0 (NP). Avoided use of erfcinv for
%   compatibility with Octave.
%
% PAL_inverseCumulativeNormal:
% Modified: Palamedes version 1.4.0 (NP). Functionality removed.
%
% PAL_inverseGumbel:
% Modified: Palamedes version 1.4.0 (NP). Functionality removed.
%
% PAL_inverseHyperbolicSecant:
% Modified: Palamedes version 1.4.0 (NP). Functionality removed.
%
% PAL_inverseLogistic:
% Modified: Palamedes version 1.4.0 (NP). Functionality removed.
%
% PAL_inverseWeibull:
% Modified: Palamedes version 1.4.0 (NP). Functionality removed.
%
% PAL_isIdentity:
% Modified: Palamedes version 1.4.0 (NP): Short-circuited logical 
%   operators.
%
% PAL_minimize:
% Introduced: Palamedes version 1.4.0 (NP)
%
% PAL_MLDS_Bootstrap:
% Modified: Palamedes version 1.4.0 (NP): Nelder-Mead simplex search
%   now performed by PAL_minimize.
%
% PAL_MLDS_Fit:
% Modified: Palamedes version 1.4.0 (NP): Nelder-Mead simplex search
%   now performed by PAL_minimize.
%
% PAL_PF_SimulateObserverParametric:
% Modified: Palamedes version 1.4.0 (NP). Short-circuited logical
%   operators.
%
% PAL_PFLR_ModelComparison:
% Modified: Palamedes version 1.4.0 (NP). Added 'guessLimits' option.
% Modified: Palamedes version 1.4.0 (NP). Short-circuited logical
%   operators.
%
% PAL_PFLR_TLR:
% Modified: Palamedes version 1.4.0 (NP). Added 'guessLimits' option.
% Modified: Palamedes version 1.4.0 (NP). Short-circuited logical 
%   operators.
%
% PAL_PFML_BootstrapNonParametric:
% Modified: Palamedes version 1.4.0 (NP). Added 'guessLimits' option.
%
% PAL_PFML_BootstrapNonParametricMultiple:
% Modified: Palamedes version 1.4.0 (NP). Check whether funcParamsSim needs
%   to be updated now performed properly.
% Modified: Palamedes version 1.4.0 (NP). Added 'guessLimits' option.
% Modified: Palamedes version 1.4.0 (NP). Short-circuited logical
%   operators.
%
% PAL_PFML_BootstrapParametric:
% Modified: Palamedes version 1.4.0 (NP). Added 'guessLimits' option.
% Modified: Palamedes version 1.4.0 (NP). Short-circuited logical
%   operators.
%
% PAL_PFML_BootstrapParametricMultiple:
% Modified: Palamedes version 1.4.0 (NP). Check whether funcParamsSim needs
%   to be updated now performed properly.
% Modified: Palamedes version 1.4.0 (NP). Added 'guessLimits' option.
% Modified: Palamedes version 1.4.0 (NP). Short-circuited logical
%   operators.
%
% PAL_PFML_Fit:
% Modified: Palamedes version 1.4.0 (NP). Added 'guessLimits' option.
% Modified: Palamedes version 1.4.0 (NP): Nelder-Mead simplex search
%   now performed by PAL_minimize.
% Modified: Palamedes version 1.4.0 (NP). Short-circuited logical
%   operators.
%
% PAL_PFML_FitMultiple:
% Modified: Palamedes version 1.4.0 (NP). Added 'guessLimits' option.
% Modified: Palamedes version 1.4.0 (NP): Nelder-Mead simplex search
%   now performed by PAL_minimize.
% Modified: Palamedes version 1.4.0 (NP). Short-circuited logical
%   operators.
%
% PAL_PFML_GoodnessOfFit:
% Modified: Palamedes version 1.4.0 (NP). Added 'guessLimits' option.
% Modified: Palamedes version 1.4.0 (NP). Short-circuited logical
%   operators.
%
% PAL_PFML_GoodnessOfFitMultiple:
% Modified: Palamedes version 1.4.0 (NP). Added 'guessLimits' option.
% Modified: Palamedes version 1.4.0 (NP). Short-circuited logical
%   operators.
%
% PAL_PFML_IndependentFit:
% Modified: Palamedes version 1.4.0 (NP): Short-circuited logical
%   operators.
%
% PAL_PFML_negLL:
% Modified: Palamedes version 1.4.0 (NP). Added 'guessLimits' option.
% Modified: Palamedes version 1.4.0 (NP). Short-circuited logical
%   operators.
%
% PAL_PFML_negLLMultiple:
% Modified: Palamedes version 1.4.0 (NP). Added 'guessLimits' option.
% Modified: Palamedes version 1.4.0 (NP). Short-circuited logical
%   operators.
%
% PAL_SDT_1AFCsameDiff_DiffMod_PHFtoDP:
% Modified: Palamedes version 1.4.0 (NP): Nelder-Mead simplex search now
%   performed by PAL-minimize.
%
% PAL_SDT_2AFCmatchSample_DiffMod_PCtoDP:
% Modified: Palamedes version 1.4.0 (NP): Nelder-Mead simplex search now
%   performed by PAL-minimize.
%
% PAL_SDT_2AFCmatchSample_DiffMod_PHFtoDP:
% Modified: Palamedes version 1.4.0 (NP): Nelder-Mead simplex search now
%   performed by PAL-minimize.
%
% PAL_SDT_2AFCmatchSample_IndMod_PCtoDP:
% Modified: Palamedes version 1.4.0 (NP): Nelder-Mead simplex search now
%   performed by PAL-minimize.
%
% PAL_SDT_2AFCmatchSample_IndMod_PHFtoDP:
% Modified: Palamedes version 1.4.0 (NP): Nelder-Mead simplex search now
%   performed by PAL-minimize.
%
% PAL_SDT_MAFC_DPtoPC:
% Modified: Palamedes version 1.4.0 (NP): Solved Octave incompatibility
%   issue.
%
% PAL_SDT_MAFC_PCtoDP:
% Modified: Palamedes version 1.4.0 (NP): Nelder-Mead simplex search now
%   performed by PAL-minimize.
%
% PAL_SDT_MAFCmatchSample_DiffMod_PCtoDP:
% Modified: Palamedes version 1.4.0 (NP): Nelder-Mead simplex search now
%   performed by PAL-minimize.
%
% PAL_SDT_MAFCoddity_PCtoDP:
% Modified: Palamedes version 1.4.0 (NP): Nelder-Mead simplex search now
%   performed by PAL_minimize.
%
% PAL_spreadPF:
% Modified: Palamedes version 1.4.0 (NP) Avoided use of erfcinv for
%   compatibility with Octave.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.4.1 Release February 18, 2012
%
% Fixed bug which resulted when PAL_minimize encounters NaN's: 
%   PAL_PFML_negLL no longer returns NaN's.
%
% PAL_PFML_negLL:
% Modified: Palamedes version 1.4.1 (NP). Ignore NaN's (which arise when
%   0*log(0) is evaluated).
% 
% PAL_nansum:
% Introduced: Palamedes version 1.4.1 (NP).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.4.2 Release March 17, 2012
%
% Fixes a bug that would make PAL_PFML_BootstrapParametricMultiple and
%   PAL_PFML_FitMultiple misbehave when data arrays (StimLevels,
%   NumPos, OutOfNum) were such that a call to PAL_PFML_GroupTrialsbyX 
%   would have changed their arrangement.
%
% PAL_PFML_BootstrapParametricMultiple:
% Modified: Palamedes version 1.4.2 (NP). Fixed typo-bug Stimlevels -
%   StimLevels (line 207 in version 1.4.2). This bug would have caused
%   trouble if this function was used with data-arrays that would have 
%   changed by running it through PAL_PFML_GroupTrialsbyX
%
% PAL_PFML_FitMultiple:
% Modified: Palamedes version 1.4.2 (NP). Fixed typo-bug Stimlevels ->
%   StimLevels (line 330 in version 1.4.2). This bug would have caused
%   trouble if this function was used with data-arrays that would have 
%   changed by running it through PAL_PFML_GroupTrialsbyX
%
% PAL_PFML_negLL: 
% Modified: Palamedes version 1.4.2 (NP). Changed manner in which NaN's
%   arising from evaluating 0*log(0) are handled (some more).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.4.3 Release March 19, 2012
%
% Undoes an unintended change introduced in 1.4.2. In PAL_minimize, the
%   value of delta was changed to 0.02. Now it's back to 0.05.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.4.4 Release March 29, 2012
%
% Undoes another unintended change introduced in 1.4.2. In PAL_PFLR_TLR, 
%   procedure was 'paused' in case convergence failure occurred (for 
%   debugging purposes). Now undone.
%
%PAL_CumulativeNormal: 
%Modified: Palamedes version 1.4.4 (NP). Fixed bug: '.5*erfc' -> '.5.*erfc'
%   credit: Loes van Dam
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.4.5 Release April 6, 2012
%
% PAL_AMUD_setupUD:
% Modified: Palamedes version 1.4.5 (NP) Initialized UD.xMax and UD.xMin to
%   Inf and -Inf, respectively.
% Modified: Palamedes version 1.4.5 (NP): Bug fix: Changed 'UD.truncate ==
%   1' to 'strcmp(UD.truncate,'yes')' (line 68 in 1.4.5)
% Modified: Palamedes version 1.4.5 (NP): Bug fix: Changed 'UD.reversal < 1'
%   to max(UD.reversal) < 1 (lines 47 & 66 in 1.4.5)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.5.0 Release June 10, 2012
%
% Purpose of release: Implementation of Psi+ method. The Psi+ method
% modifies the Psi method to allow optimization of guess rate and/or lapse
% rate as well as threshold and slope.
%
% A minor incompatibility with older versions is introduced. See warning in
% PAL_AMPM_setupPM or www.palamedestoolbox.org/pal_ampm_incompatibility.html
%
% PAL_AMPM_createLUT:
% Modified: Palamedes version 1.5.0 (NP): Modified to allow 'Psi+' 
%   (optimization of guess rate and/or lapse rate as well as threshold and 
%   slope).
%
% PAL_AMPM_posteriorTplus1:
% Modified: Palamedes version 1.5.0 (NP): Modified to allow 'Psi+' 
%   (optimization of guess rate and/or lapse rate as well as threshold and 
%   slope).
%
% PAL_AMPM_pSuccessGivenx:
% Modified: Palamedes version 1.5.0 (NP): Modified to allow 'Psi+' 
%   (optimization of guess rate and/or lapse rate as well as threshold and 
%   slope).
%
% PAL_AMPM_setupPM:
% Modified: Palamedes version 1.5.0 (NP): Modified to allow 'Psi+' 
%   (optimization of guess rate and/or lapse rate as well as threshold and 
%   slope).
%
% PAL_AMPM_updatePM:
% Modified: Palamedes version 1.5.0 (NP): Modified to allow 'Psi+' 
%   (optimization of guess rate and/or lapse rate as well as threshold and 
%   slope).
%
% PAL_Entropy:
% Modified: Palamedes version 1.5.0 (NP): Modified to accept N-D arrays.
%   Added option to return entropies across limited number of dimensions.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.6.0 Release March 15, 2013
%
% Purposes of release: (1) Introduce new SDT routines: routines that fit 
%   ROC curve, determine standard errors of its parameters, goodness of the 
%   fit, and perform a model comparison to determine whether the ratio of 
%   standard deviations of signal and noise distributions equals 1 (or any 
%   other value). Also introduced 3AFC and MAFC oddity routines (2) Extend 
%   functionality of Psi method routines: when lapse rate is included in 
%   the posterior distribution it can now be assumed that gamma and lambda 
%   are equal (e.g., in bistable percept task in which both gamma and 
%   lambda can be thought of as estimating the lapse rate). User can also 
%   marginalize nuisance parameters such that expected entropy is 
%   determined across parameters of interest only.
%
% PAL_SDT_cumulateHF:
% Introduced: Palamedes version 1.6.0 (FK & NP)
%
% PAL_SDT_3AFCoddity_IndMod_DPtoPC
% Introduced: Palamedes version 1.6.0 (FK)
%
% PAL_SDT_3AFCoddity_IndMod_DPtoPCpartFuncA
% Introduced: Palamedes version 1.6.0 (FK)
%
% PAL_SDT_3AFCoddity_IndMod_DPtoPCpartFuncB
% Introduced: Palamedes version 1.6.0 (FK)
%
% PAL_SDT_3AFCoddity_IndMod_PCtoDP
% Introduced: Palamedes version 1.6.0 (FK)
%
% PAL_SDT_MAFCoddity_IndMod_DPtoPC
% Introduced: Palamedes version 1.6.0 (FK)
%
% PAL_SDT_MAFCoddity_IndMod_PCtoDP
% Introduced: Palamedes version 1.6.0 (FK)
%
% PAL_SDT_ROC_SimulateObserverParametric:
% Introduced: Palamedes version 1.6.0 (FK & NP)
%
% PAL_SDT_ROCML_BootstrapParametric:
% Introduced: Palamedes version 1.6.0 (FK & NP)
%
% PAL_SDT_ROCML_Fit:
% Introduced: Palamedes version 1.6.0 (FK & NP)
%
% PAL_SDT_ROCML_GoodnessOfFit:
% Introduced: Palamedes version 1.6.0 (FK & NP)
%
% PAL_SDT_ROCML_negLL:
% Introduced: Palamedes version 1.6.0 (FK & NP)
%
% PAL_SDT_ROCML_negLLNonParametric:
% Introduced: Palamedes version 1.6.0 (FK & NP)
%
% PAL_SDT_ROCML_RatioSDcomparison:
% Introduced: Palamedes version 1.6.0 (FK & NP)
%
% PAL_Quick:
% Introduced: Palamedes version 1.6.0 (NP)
%
% PAL_logQuick:
% Introduced: Palamedes version 1.6.0 (NP)
%
% PAL_AMPM_CreateLUT:
% Modified: Palamedes version 1.6.0 (NP): Modified to allow Psi method to
% 	assume that gamma equals lambda.
%
% PAL_AMPM_setupPM:
% Modified: Palamedes version 1.6.0 (NP): Modified to allow Psi method to
%   assume that gamma equals lambda (e.g., both estimating lapse rate in a
%   bistable percept task). Modified to allow marginalization of
%   parameters before entropy is calculated.
%
% PAL_AMPM_updatePM:
% Modified: Palamedes version 1.6.0 (NP): Modified to allow Psi method to
%   assume that gamma equals lambda (e.g., both estimating lapse rate in a
%   bistable percept task). Modified to allow marginalization of
%   parameters before entropy is calculated.
%
% PAL_Entropy:
% Modified: Palamedes version 1.6.0 (NP): Modified to allow marginalizing
%   out dimension(s) before calculating entropy.
%
% PAL_findMax:
% Modified: Palamedes version 1.6.0 (NP): Revamped (and simplified) 
%   strategy in order to allow finding maximum in N-D arrays.
%
% PAL_PFML_bruteForceFit:
% Modified: Palamedes version 1.6.0 (NP): Avoid waste of memory (in case
%   user sets 'gammaEQlambda' to 'true' but supplies non-scalar
%   searchGrid.gamma) by setting searchGrid.gamma to scalar with 
%   (arbitrary) value of 0.
%
% PAL_PFML_negLLNonParametric:
% Modified: Palamedes version 1.6.0 (NP): Deal with 0.*log(0) issue using
%   PAL_nansum.
%
% PAL_PFML_TtoP:
% Modified: Palamedes version 1.6.0 (NP): Allow one to fix a parameter in
%   one condition while allowing it to be free in other conditions when 
%   using a contrast matrix to constrain parameter in functions that fit 
%   PFs simultaneously to multiple conditions. Example: passing 
%   [1 0 0; 0 1 0] to, say, 'thresholds' in PAL_PFML_FitMultiple fixes the
%   threshold value in the third condition while estimating independent 
%   thresholds in conditions 1 and 2. Example 2: [0 1 1 1; 0 -1 0 1] will
%   fix parameter in condition 1 while fitting an intercept and linear 
%   trend to conditions 2 through 4.
%
% PAL_SDT_MAFC_DPtoPCpartFunc:
% Modified: Palamedes version 1.6.0 (NP): Modified to eliminate reliance on
%   Matlab Statistics Toolbox.
%
% PAL_SDT_1AFC_DPtoPHF:
% Modified: Palamedes version 1.6.0 (FK & NP): Modified to allow
%   functionality of new ROC routines.
%
% PAL_SDT_1AFC_PHFtoDP:
% Modified: Palamedes version 1.6.0 (FK & NP): Modified to allow
%   functionality of new ROC routines.
%
% PAL_PFLR_ModelComparison:
% Modified: Palamedes version 1.6.0 (NP): Use of 'lapseLimits' option now
%   allowed when lapse rates in model(s) defined using model matrix or
%   custom reparametrization.
%
% PAL_PFML_BootstrapNonParametricMultiple:
% Modified: Palamedes version 1.6.0 (NP): Use of 'lapseLimits' option now
%   allowed when lapse rates in model(s) defined using model matrix or
%   custom reparametrization.
%
% PAL_PFML_BootstrapParametricMultiple:
% Modified: Palamedes version 1.6.0 (NP): Use of 'lapseLimits' option now
%   allowed when lapse rates in model(s) defined using model matrix or
%   custom reparametrization.
%
% PAL_PFML_FitMultiple:
% Modified: Palamedes version 1.6.0 (NP): Use of 'lapseLimits' option now
%   allowed when lapse rates in model(s) defined using model matrix or
%   custom reparametrization.
%
% PAL_PFML_GoodnessOfFitMultiple:
% Modified: Palamedes version 1.6.0 (NP): Use of 'lapseLimits' option now
%   allowed when lapse rates in model(s) defined using model matrix or
%   custom reparametrization.
%
% PAL_PFML_negLLMultiple:
% Modified: Palamedes version 1.6.0 (NP): Modified to allow modification
%   made to PAL_PFLR_ModelComparison, 
%   PAL_PFML_BootstrapNonParametricMultiple,
%   PAL_PFML_BootstrapParametricMultiple, PAL_PFML_FitMultiple, and
%   PAL_PFML_GoodnessOfFitMultiple.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.6.1 Release December 20, 2013
%
% Purposes of release: (1) Reduction of computational load of AMPM 
% routines: duplication of a computation avoided by absorbing 
% PAL_AMPM_pSuccessGivenx function into PAL_AMPM_PosteriorTplus1, 
% PAL_AMPM_PosteriorTplus1 recoded to increase efficiency. 
% Functionality of user-end AMPM routines not affected (2) update 
% PAL_spreadPF (3) fix incompatibility of PAL_AMPM_DEMO with
% GNU Octave.
%
% PAL_AMPM_pSuccessGivenx:
% Removed: Palamedes version 1.6.1 (NP): Removed. Functionality absorbed in
%   PAL_AMPM_PosteriorTplus1 in order to reduce computational load of AMPM 
%   routines.
%
% PAL_AMPM_expectedEntropy:
% Modified: Palamedes version 1.6.1 (NP): pSuccessGivenx imported from
%   PAL_AMPM_PosteriorTSplus1 rather than from (the now removed) 
%   PAL_AMPM_pSuccessGivenx.
%
% PAL_AMPM_PosteriorTplus1:
% Modified: Palamedes version 1.6.1 (NP): Recoded to increase efficiency, 
%   absorbed functionality of (the now removed) PAL_AMPM_pSuccessGivenx.
%
% PAL_AMPM_setupPM:
% Modified: Palamedes version 1.6.1 (NP): Modified to comply with
%   absorption of PAL_AMPM_pSuccessGivenx functionality into
%   PAL_AMPM_PosteriorTplus1.
%
% PAL_spreadPF:
% Modified: Palamedes version 1.6.1 (NP): Added the options to compute
%   spread for Quick and logQuick functions (both introduced in version
%   1.6.0).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.6.2 Release February 17, 2014
%
% Purposes of release: Improve PAL_Contrast (functionality and
%   user-friendliness), minor maintenance on PAL_minimize.
% 
% PAL_isOrthogonal:
% Introduced: Palamedes version 1.6.2 (NP): Checks orthogonality of the
%   pairings of row vectors. Called by PAL_Contrasts to verify 
%   orthogonality of model matrices.
%
% PAL_Contrasts:
% Modified: Palamedes version 1.6.2 (NP): Modified to return integer-
%   valued contrast coefficients when possible, also verifies orthogonality
%   of polynomial contrasts and issues warning when incapable of finding a
%   full set of orthogonal polynomial contrasts, allows user to specify IV
%   levels that are not equally spaced.
%
% PAL_minimize:
% Modified: Palamedes version 1.6.2 (NP): Directs user to possible cause of
%   issued warning regarding values of MaxFunEvals and/or MaxIter.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.6.3 Release March 3, 2014
%
% Purposes of release: Restore backward compatibility to Matlab Release 14
%   SP1 (compatibility checked with Matlab version 7.0.1.24704, bare Matlab
%   [no Matlab toolboxes]) and restore compatibility with GNU Octave 
%   (compatibility checked with GNU Octave version 3.8.0 under Ubuntu 
%   13.10). Minor maintenance.
%
% PAL_AMPM_PosteriorTplus1:
% Modified: Palamedes version 1.6.3 (NP): Checks for presence of bsxfun.m
%   and performs alternative operation if not present (in order to restore 
%   compatibility with older versions of Matlab).
%
% PAL_Contrasts:
% Modified: Palamedes version 1.6.3 (NP): No longer changes type of 'temp'
%   to int64. (in order to restore compatibility with older versions of 
%   Matlab).
%
% PAL_PFML_BootstrapNonParametric:
% Modified: Palamedes version 1.6.3 (NP): No longer calls iscolumn.m (in 
%   order to restore compatibility with older versions of Matlab).
%
% PAL_PFML_BootstrapParametric:
% Modified: Palamedes version 1.6.3 (NP): No longer calls iscolumn.m (in 
%   order to restore compatibility with older versions of Matlab).
%
% PAL_PFML_GoodnessOfFit:
% Modified: Palamedes version 1.6.3 (NP): No longer calls iscolumn.m (in 
%   order to restore compatibility with older versions of Matlab).
%
% PAL_PFML_PtoT:
% Modified: Palamedes version 1.6.3 (NP): Removed rounding of theta values 
%   that are very near zero. Problem is taken care of in PAL_minimize.
%
% PAL_Quick:
% Modified: Palamedes version 1.6.3 (NP): Negative stimulus intensity
%   values will generate an error. Error message suggests to use
%   PAL_logQuick.
%
% PAL_Weibull:
% Modified: Palamedes version 1.6.3 (NP): Negative stimulus intensity
%   values will generate an error. Error message suggests to use
%   PAL_logQuick.
% 
% PAL_AMPM_CreateLUT and
% PAL_AMPM_expectedEntropy and
% PAL_AMPM_PosteriorTplus1 and
% PAL_AMPM_setupPM and
% PAL_AMPM_updatePM and
% PAL_AMRF_pdfDescriptives and
% PAL_AMRF_setupRF and
% PAL_AMRF_updateRF and
% PAL_AMUD_analyzeUD and
% PAL_AMUD_setupUD and
% PAL_Contrasts and
% PAL_CumulativeNormal and
% PAL_Entropy and
% PAL_findMax and
% PAL_Gumbel and
% PAL_HyperbolicSecant and
% PAL_isOrthogonal and
% PAL_Logistic and
% PAL_logQuick and
% PAL_MeanSDSSandSE and
% PAL_minimize and
% PAL_MLDS_Bootstrap and
% PAL_MLDS_Fit and
% PAL_MLDS_GroupTrialsbyX and
% PAL_MLDS_SimulateObserver and
% PAL_PF_SimulateObserverParametric and
% PAL_PFBA_Fit and
% PAL_PFLR_ModelComparison and
% PAL_PFLR_setupMC and
% PAL_PFLR_TLR and
% PAL_PFML_BootstrapNonParametric and
% PAL_PFML_BootstrapNonParametricMultiple and
% PAL_PFML_BootstrapParametric and
% PAL_PFML_BootstrapParametricMultiple and
% PAL_PFML_BruteForceFit and
% PAL_PFML_DevianceGoF and
% PAL_PFML_Fit and
% PAL_PFML_FitMultiple and
% PAL_PFML_GoodnessOfFit and
% PAL_PFML_GoodnessOfFitMultiple and
% PAL_PFML_GroupTrialsbyX and
% PAL_PFML_LLsaturated and
% PAL_PFML_negLL and
% PAL_PFML_negLLMultiple and
% PAL_PFML_negLLNonParametric and
% PAL_PFML_paramsTry and
% PAL_PFML_PtoT and
% PAL_Quick and
% PAL_randomizeArray and
% PAL_SDT_1AFC_DPtoPHF and
% PAL_SDT_1AFC_PHFtoDP and
% PAL_SDT_1AFCsameDiff_DiffMod_PHFtoDP and
% PAL_SDT_1AFCsameDiff_IndMod_PHFtoDP and
% PAL_SDT_2AFC_PHFtoDP and
% PAL_SDT_2AFCmatchSample_DiffMod_PCtoDP and
% PAL_SDT_2AFCmatchSample_DiffMod_PHFtoDP and
% PAL_SDT_2AFCmatchSample_IndMod_PCtoDP and
% PAL_SDT_2AFCmatchSample_IndMod_PHFtoDP and
% PAL_SDT_3AFCoddity_IndMod_DPtoPC and
% PAL_SDT_3AFCoddity_IndMod_PCtoDP and
% PAL_SDT_MAFC_DPtoPC and
% PAL_SDT_MAFC_PCtoDP and
% PAL_SDT_MAFCmatchSample_DiffMod_DPtoPC and
% PAL_SDT_MAFCmatchSample_DiffMod_PCtoDP and
% PAL_SDT_MAFCoddity_DPtoPC and
% PAL_SDT_MAFCoddity_IndMod_DPtoPC and
% PAL_SDT_MAFCoddity_IndMod_PCtoDP and
% PAL_SDT_MAFCoddity_PCtoDP and
% PAL_SDT_ROCML_BootstrapParametric and
% PAL_SDT_ROCML_Fit and
% PAL_SDT_ROCML_GoodnessOfFit and
% PAL_SDT_ROCML_negLL and
% PAL_SDT_ROCML_negLLNonParametric and
% PAL_SDT_ROCML_RatioSDcomparison and
% PAL_spreadPF and
% PAL_unpackParamsPF and
% PAL_Weibull:
% Modified: Palamedes version 1.6.3 (NP): Minor maintenance: Removed
%   suppression of logOfZero warnings, removed suppression of DivideByZero 
%   warnings (users of older versions of Matlab and users of Octave may
%   occassionally encounter either warning, please ignore [they are 
%   inconsequential] or suppress in code), Palamedes warnings are given
%   identifiers, separated output variables using commas, pre-allocated
%   variables, etc.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.6.3.1 Release April 10, 2014
%
% Purposes of release: Direct user to page:
% www.palamedestoolbox.org/weibullandfriends.html in help comments of:
% PAL_Gumbel, PAL_logQuick, PAL_Quick, and PAL_Weibull. Error messages
% issued by PAL_Weibull and PAL_Quick when negative stimulus values are
% passed direct user to same page.
%
% No change in functionality.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.7.0 Release June 27, 2014
%
% Purposes of release: (1) Introduce SDT summation routines (listed below)
% (2) Introduce PAL_LLfixed and PAL_GoodnessOfFitZeroDF (3) Correct some 
% regressions that occurred in 1.6.3.1 (some of the updates introduced in 
% version 1.6.3 were, somehow, undone in 1.6.3.1). Version 1.7.0 was 
% created by starting from 1.6.3, performing upgrade to 1.6.3.1 again, then 
% making the changes that are recorded below to result in version 1.7.0.
%
% PAL_SDT_AS_PCtoSL:
% Introduced: Palamedes version 1.7.0 (FK&NP)
% uses an iterative search procedure of PAL_SDT_AS_SLtoPC to calculate the 
% stimulus level x from proportion correct PC, a PC that would result 
% from the ADDITIVE SUMMATION of n identical stimuli in Q monitored 
% channels, if x was subject to a scaling factor g and a transducer 
% exponent p such that d'= (gx)^p, for a M-AFC 
% (M-alternative-forced-choice) task under the assumptions of 
% signal-detection-theory, assuming an unbiased observer.
%
% PAL_SDT_AS_uneqSLtoPC:
% Introduced: Palamedes version 1.7.0 (FK&NP)
% uses numerical integration to calculate proportion correct PC based 
% on the ADDITIVE SUMMATION of unequal stimulus levels x in Q monitored 
% channels, with each stimulus level x subject to a scaling factor g 
% and a transducer exponent p such that d'= (gx)^p, for a M-AFC 
% (M-alternative-forced-choice) task under the assumptions of SDT and 
% assuming an unbiased observer
%
% PAL_SDT_PS_DPtoPCpartFunc:
% Introduced: Palamedes version 1.7.0 (FK&NP)
% Internal function
%
% PAL_SDT_PS_MonteCarlo_SLtoPC:
% Introduced: Palamedes version 1.7.0 (FK&NP)
% uses numerical integration to calculate proportion correct PC based 
% on the PROBABILITY SUMMATION of n identical stimuli in Q monitored 
% channels, with signal level x subject to a scaling factor g and 
% transducer exponent p such that d'= (gx)^p, for a M-AFC 
% (M-alternative-forced-choice) task under the assumptions of 
% signal-detection-theory and assuming an unbiased observer
%
% PAL_SDT_PS_MonteCarlo_uneqSLtoPC:
% Introduced: Palamedes version 1.7.0 (FK&NP)
% uses Monte Carlo simulation to calculate proportion correct based 
% on the PROBABILITY SUMMATION of unequal stimulus levels x in Q monitored 
% channels, with each stimulus level x subject to a scaling factor g 
% and a transducer exponent p such that d'= (gx)^p, for a M-AFC 
% (M-alternative-forced-choice) task, under the assumptions of SDT and 
% assuming an unbiased observer
%
% PAL_SDT_PS_PCtoSL:
% Introduced: Palamedes version 1.7.0 (FK&NP)
% uses an iterative search procedure of PAL_SDT_AS_SLtoPC to calculate 
% stimulus level x from proportion correct PC, a PC that would result 
% from the PROBABILITY SUMMATION of n identical stimuli in Q monitored 
% channels, with x subject to a scaling factor g and transducer exponent p 
% such that d'= (gx)^p, for a M-AFC (M-alternative-forced-choice) task 
% under the assumptions of signal-detection-theory, assuming an unbiased 
% observer.
%
% PAL_SDT_PS_SLtoPC:
% Introduced: Palamedes version 1.7.0 (FK&NP)
% uses numerical integration to calculate proportion correct PC based 
% on the PROBABILITY SUMMATION of n identical stimuli in Q monitored 
% channels, with stimulus level x subject to a scaling factor g and 
% transducer exponent p such that d'= (gx)^p, for a M-AFC 
% (M-alternative-forced-choice) task, under the assumptions of 
% signal-detection-theory and assuming an unbiased observer
%
% PAL_SDT_PS_uneqDPtoPCpartFunc:
% Introduced: Palamedes version 1.7.0 (FK&NP)
% Internal function
%
% PAL_SDT_PS_uneqDPtoPCpartFunc2:
% Introduced: Palamedes version 1.7.0 (FK&NP)
% Internal function
%
% PAL_SDT_PS_uneqSLtoPC:
% Introduced: Palamedes version 1.7.0 (FK&NP)
% uses numerical integration to calculate proportion correct based 
% on the PROBABILITY SUMMATION of unequal stimulus levels in Q monitored 
% channels, with each stimulus level x subject to a scaling factor g 
% and a transducer with exponent p such that d'= (gx)^p, for a M-AFC 
% (M-alternative-forced-choice) task, under the assumptions of SDT and 
% assuming an unbiased observer
%
% PAL_LLfixed:
% Introduced: Palamedes version 1.7.0 (NP)
% Internal Function
%
% PAL_GoodnessOfFitZeroDF:
% Introduced: Palamedes version 1.7.0 (NP)
% Determine Goodness-of-Fit of model of binomial data where the model 
% consists only of fixed parameter values (i.e., the model has zero degrees 
% of freedom).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.8.0 Release February 19, 2015
%
% Purpose of release is to a) modify the names of the SDT (signal-
% detection-theory) differencing model oddity routines, b) introduce 2AFC 
% SDT routines, c) introduce routines for fitting PFs (psychometric 
% functions) with SDT models, d) introduce new routines for summation under 
% SDT and e) introduce routines for fitting summation PFs under SDT.
% 
% PAL_SDT_MAFC_Oddity_DPtoPC
% Modified: Palamedes version 1.8.0 (FK)
% Disabled, renamed PAL_SDT_MAFC_Oddity_DiffMod_DPtoPC
% 
% PAL_SDT_MAFC_Oddity_DPtoPC
% Modified: Palamedes version 1.8.0 (FK)
% Disabled, renamed PAL_SDT_MAFC_Oddity_DiffMod_PCtoDP
% 
% PAL_SDT_MAFC_Oddity_DiffMod_DPtoPC
% Introduced: Palamedes version 1.8.0 (FK & NP)
% PAL_SDT_MAFCoddity_DiffMod_DPtoPC converts d'(d-prime) to 
% proportion correct for a M-AFC (M-alternative-forced-choice) 
% oddity task, assuming a Differencing model and an unbiased 
% observer
% 
% PAL_SDT_MAFC_Oddity_DiffMod_PCtoDP
% Introduced: Palamedes version 1.8.0 (FK & NP)
% PAL_SDT_MAFCoddity_DiffMod_PCtoDP converts proportion correct into 
% d'(d-prime) for a M-AFC (M-alternative-forced-choice) oddity
% task, assuming a Differencing Observer model and an unbiased observer
% 
% PAL_SDT_2AFC_DPtoPC
% Introduced: Palamedes version 1.8.0 (FK)
% PAL_SDT_2AFC_DPtoPC converts d'(d-prime) into proportion correct for a 
% 2AFC (two-alternative-forced-choice) task
% 
% PAL_SDT_2AFC_PCtoDP
% Introduced: Palamedes version 1.8.0 (FK)
% PAL_SDT_2AFC_PCtoDP converts proportion correct to d' (d-prime) for a 
% 2AFC (two-alternative-forced-choice) task
%
% PAL_SDT_PS_2uneqSLtoPC
% Introduced: Palamedes version 1.8.0 (FK)
% uses numerical integration to calculate proportion correct based 
% on the PROBABILITY SUMMATION of two unequal intensity stimuli, one 
% with an intensity of x the other r*x, in Q monitored channels, with each 
% x subject to a scaling factor g and transducer exponent p 
% such that d'= (gx)^p, in a M-AFC (M-alternative-forced-choice) task, 
% under the assumptions of SDT and assuming an unbiased observer
% 
% PAL_SDT_AS_2uneqSLtoPC
% Introduced: Palamedes version 1.8.0 (FK)
% uses numerical integration to calculate proportion correct based 
% on the ADDITIVE SUMMATION of two unequal stimulus intensities, one of 
% which is x the other r*x, in Q monitored channels, with each x subject 
% to a scaling factor g and transducer exponent p such that d'= (gx)^p, 
% for a M-AFC (M-alternative-forced-choice) task, under the assumptions of 
% SDT and assuming an unbiased observer
% 
% PAL_SDT_PS_PCto2uneqSL
% Introduced: Palamedes version 1.8.0 (FK)
% uses an iterative search procedure of PAL_SDT_PS_2uneqSLtoPC to 
% calculate two stimulus levels x with a ratio r from proportion correct PC, 
% a PC that would result from the PROBABILITY SUMMATION of the two 
% different stimuli, in Q monitored channels, with x subject to a scaling 
% factor g and transducer exponent p such that d'= (gx)^p, for a M-AFC 
% (M-alternative-forced-choice) task under the assumptions of 
% signal-detection-theory, assuming an unbiased observer.
% 
% PAL_SDT_AS_PCto2uneqSL
% Introduced: Palamedes version 1.8.0 (FK)
% uses an iterative search procedure of PAL_SDT_AS_2uneqSLtoPC to 
% calculate two stimulus levels x with ratio r from proportion correct PC, 
% a PC that would result from the ADDITIVE SUMMATION of the two 
% x values, in Q monitored channels, with x subject to a scaling 
% factor g and transducer exponent p such that d'= (gx)^p, for a M-AFC 
% (M-alternative-forced-choice) task under the assumptions of 
% signal-detection-theory, assuming an unbiased observer.
% 
% PAL_SDT_SLtoPC
% Introduced: Palamedes version 1.8.0 (FK)
% Converts stimulus intensities to proportion correct assuming parameters 
% of an SDT (signal detection theory) model
% 
% PAL_SDT_PCtoSL
% Introduced: Palamedes version 1.8.0 (FK)
% Converts proportion correct to stimulus intensity assuming parameters of 
% an SDT (signal detection theory) model
% 
% PAL_SDT_PFML_negLL
% Introduced: Palamedes version 1.8.0 (FK & NP)
% (negative) Log Likelihood associated with fit of SDT (signal-detection-
% theory) psychometric function 
% 
% PAL_SDT_PFML_Fit
% Introduced: Palamedes version 1.8.0 (FK & NP)
% Fits the parameters of an SDT (signal dtection theory) psychometric 
% function (PF) using a Maximum Likelihood criterion.
% 
% PAL_SDT_PF_SimulateObserverParametric
% Introduced: Palamedes version 1.8.0 (FK & NP)
% Simulate observer characterized by a PF (psychomtric function) from an 
% SDT (signal detection thory) model.
% 
% PAL_SDT_PFML_BootstrapParametric
% Introduced: Palamedes version 1.8.0 (FK & NP)
% Perform parametric bootstrap to determine standard errors on parameters 
% of an SDT (signal detection theory) model fitted to PF (psychometric 
% function) data
% 
% PAL_SDT_PFML_GoodnessOfFit
% Introduced: Palamedes version 1.8.0 (FK & NP)
% Determines goodness-of-fit of the parameters of a signal detection theory 
% (SDT) model fitted to psychometric function (PF) data
% 
% PAL_SDT_Summ_MultiplePFML_negLL
% Introduced: Palamedes version 1.8.0 (FK & NP)
% (negative) Log Likelihood associated with fit of summation psychometric 
% function 
% 
% PAL_SDT_Summ_MultiplePFML_Fit
% Introduced: Palamedes version 1.8.0 (FK & NP)
% Fits the parameters of a set of summation psychometric curves using a 
% Maximum Likelihood criterion, based on either a probability or additive 
% summation model
% 
% PAL_SDT_Summ_MultiplePF_SimulateObserverParametric
% Introduced: Palamedes version 1.8.0 (FK & NP)
% Simulate observer for a summation experiment with multiple PFs 
% (psychometric functions) based on SDT (signal detection theory)
% 
% PAL_SDT_Summ_MultiplePFML_BootstrapParametric
% Introduced: Palamedes version 1.8.0 (FK & NP)
% Perform parametric bootstrap to determine standard errors on parameters 
% of SDT (signal detection theory) probability and additive summation 
% models simultaneously fitted to multiple PF (psychometric function) data
% 
% PAL_SDT_Summ_MultiplePFML_GoodnessOfFit
% Introduced: Palamedes version 1.8.0 (FK & NP)
% Obtains Goodness-of-fit of parameters of SDT (signal detection theory) 
% probability and additive summation models obtained from simultaneously 
% fitted multiple PF (psychometric function) data  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.8.1 Release December 2, 2015
%
% Minor maintenance. Upgrade PAL_PFBA_Fit, bug fixes, make code compatible 
% with 2nd Edition of 'Psychophysics: A Practical Introduction'
%
% PAL_AMRF_setupRF:
% Modified: Palamedes version 1.8.1 (NP)
% initialized xMin and xMax to -Inf and Inf respectively
%
% PAL_PFBA_Fit:
% Modified: Palamedes version 1.8.1 (NP)
% Any combination of the four parameters of the PF can now be freed. The
% format of the input and output arguments has changed. That is, 'old 
% style' usage is not compatible with 'new style' usage. For now, 
% PAL_PFBA_Fit will detect whether routine is used 'old style' or 'new 
% style' and act accordingly. 
%
% PAL_PFBA_Fit_OldStyle:
% Introduced/Modified: Palamedes version 1.8.1 (NP)
% This routine handles the 'old style' usage of PAL_PFBA_Fit (see entry
% above) and is essentially PAL_PFBA_Fit from earlier Palamedes version.
%
% PAL_PFML_BootstrapNonParametric:
% Modified: Palamedes version 1.8.1 (NP)
% Removed functionality of 'maxTries' and 'rangeTries' options. Users 
% supplying these arguments will be encouraged to use 'searchGrid' option 
% instead.
%
% PAL_PFML_BootstrapParametric:
% Modified: Palamedes version 1.8.1 (NP)
% Removed functionality of 'maxTries' and 'rangeTries' options. Users 
% supplying these arguments will be encouraged to use 'searchGrid' option 
% instead.
%
% PAL_PFML_Fit:
% Modified: Palamedes version 1.8.1 (NP)
% output argument 'output' has new field output.seed that contains the seed 
% that was used for the Nelder-Mead Simplex search.
%
% PAL_PFML_GoodnessOfFit:
% Modified: Palamedes version 1.8.1 (NP)
% Removed functionality of 'maxTries' and 'rangeTries' options. Users 
% supplying these arguments will be encouraged to use 'searchGrid' option 
% instead.
%
% PAL_PFML_GoodnessOfFitMultiple:
% Modified: Palamedes version 1.8.1 (NP)
% Default setting for 'thresholds' and 'slopes' is now 'unconstrained' 
% (was 'constrained').
%
% PAL_PFML_negLL:
% Modified: Palamedes version 1.8.1 (NP)
% Evaluates to Inf when params(2) < 0. Keeps search away from negative 
% values for slope parameter.
%
% PAL_PFML_setupParametrizationStruct:
% Introduced: Palamedes version 1.8.1 (NP)
% Allows alternative spelling of PAL_PFML_setupParametrizationStruct
%
% PAL_PFML_setupParametrizationStruct:
% Modified: Palamedes version 1.8.1 (NP)
% Code has been moved to new PAL_PFML_setupParameterizationStruct (alt.
% spelling).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.8.2 Release June 22, 2016
%
% Purpose: Fix bug in PAL_AMPM_setupPM. Also: Introduce a minimal-code demo 
% program of basic psi-method (PAL_AMPM_Basic_Demo). PAL_AMPM_Demo updated 
% to use a custom prior.
%
% PAL_AMPM_setupPM:
% Modified: Palamedes version 1.8.2 (NP)
% Bug fix: User supplied prior was ignored when supplied with existing PM 
% in call to PAL_AMPM_setupPM, i.e., when first argument to
% PAL_AMPM_setupPM was a previously existing structure, e.g.: 
% PM = PAL_AMPM_setupPM(PM, 'prior',prior) %prior was ignored
% PM = PAL_AMPM_setupPM('prior',prior)     %prior was not ignored
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.9.0 Release September 18, 2018
%
% Purpose: (1) Introduce PAL_PFML_CheckLimits.m which checks whether fit
% performed by PAL_PFML_Fit.m corresponds to true global maximum or 
% whether a step function or constant function (either of which can be 
% approached to any degree of precision by sigmoidal function) exists that 
% has higher log likelihood. (2) Add option to MLDS routines to use Devinck 
% & Knoblauch's  2012 (JoV, 12, 19) version of model. (3) Minor 
% maintenance.
%
% PAL_PFML_BruteForceFit.m:
% Modified: Palamedes version 1.9.0 (NP)
% Added line to avoid LLspace containing NaNs
%
% PAL_PFML_CheckLimits.m:
% Introduced: Palamedes vesrion 1.9.0 (NP)
% Check whether the parameter estimates found by PAL_PFML_Fit correspond to 
% global maximum or whether a step function or constant function (each of 
% which may be approached to any arbitrary degree of precision by model to 
% be fitted) exists that has higher likelihood.
%
% PAL_PFML_Fit.m:
% Modified: Palamedes version 1.9.0 (NP)
% Default limits for guess and lapse rate changed to [0 1] (from [] in 
% earlier versions)
%
% PAL_PFML_negLL.m:
% Modified: Palamedes version 1.9.0 (NP)
% Avoids failed fits due to imaginary or NaN Log Likelihood values (that
% may arise e.g., when a negative value for threshold is used and a Weibull
% if fitted). This issue was brought to our attention by David H. Brainard.
%
% PAL_PFML_negLLMultiple.m:
% Modified: Palamedes version 1.9.0 (NP)
% See comment on PAL_PFML_negLL.m
%
% PAL_MLDS_Bootstrap.m:
% Modified: Palamedes version 1.9.0 (NP)
% Allow Devinck & Knoblauch's 2012 (JoV, 12, 19) version of model. Type
% help PAL_MLDS_Fit for more detail.
%
% PAL_MLDS_Fit.m:
% Modified: Palamedes version 1.9.0 (NP)
% Allow Devinck & Knoblauch's 2012 (JoV, 12, 19) version of model. Type
% help PAL_MLDS_Fit for more detail.
%
% PAL_MLDS_negLL.m:
% Modified: Palamedes version 1.9.0 (NP)
% Allow Devinck & Knoblauch's 2012 (JoV, 12, 19) version of model. Type
% help PAL_MLDS_Fit for more detail.
%
% PAL_MLDS_SimulateObserver.m:
% Modified: Palamedes version 1.9.0 (NP)
% Allow Devinck & Knoblauch's 2012 (JoV, 12, 19) version of model. Type
% help PAL_MLDS_SimulateObserver for more detail.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.9.1 Release December 21, 2018
%
% Purpose: (1) Have functions PAL_PFML_Fit, PAL_PFML_BootstrapParametric,
% PAL_PFML_BootstrapNonParametric, PAL_PFMLGoodnessOfFit check whether
% likelihood function contains a true maximum by default. See (updated)
% page www.palamedestoolbox.org/understandingfitting.html for more 
% information. Thing to note: output argument 'exitflag' of PAL_PFML_Fit 
% and output argument 'converged' of PAL_PFML_BootstrapParametric,
% PAL_PFML_BootstrapNonParametric, PAL_PFMLGoodnessOfFit are no longer of
% type logical and can contain values -1, -2, and -3. This may cause hard 
% to spot erratic behavior in cases where convergence is checked by
% something like: if(exitflag == true). Instead, use something like 
% if(exitflag == 1) (2) Extend capability to check likelihood function for 
% true maximum to 'jAPLE' fitting scheme. (3) Disable 'iAPLE' fitting 
% scheme. Reasons: Including this option made the code real bulky to begin 
% with. Extending new functionality to 'iAPLE' would have been a huge
% undertaking with likely zero users ever making use of this. Finally, 
% 'iAPLE' fitting instead of 'jAPLE' fitting is hard to defend.
%
% PAL_PFML_Fit.m:
% Modified: Palamedes version 1.9.1 (NP)
% Modified to check whether likelihood function contains true maximum. If
% not, function will identify which limiting function can be approached by
% psychometric function. 'iAPLE' fitting scheme disabled.
%
% PAL_PFML_BootstrapParametric.m:
% Modified: Palamedes version 1.9.1 (NP)
% Modified to check whether likelihood functions of bootstrap simulations
% contain true maximum. If not, function will identify which limiting 
% function can be approached by psychometric function. If any simulation
% does not have true maximum, a finite value cannot be assigned to some
% parameters and no SE can be determined. 'iAPLE' fitting scheme disabled.
%
% PAL_PFML_BootstrapNonParametric.m:
% Modified: Palamedes version 1.9.1 (NP)
% Modified to check whether likelihood functions of bootstrap simulations
% contain true maximum. If not, function will identify which limiting 
% function can be approached by psychometric function. If any simulation
% does not have true maximum, a finite value cannot be assigned to some
% parameters and no SE can be determined. 'iAPLE' fitting scheme disabled.
%
% PAL_PFML_GoodnessOfFit.m:
% Modified: Palamedes version 1.9.1 (NP)
% Modified to check whether likelihood functions of MS simulations
% contain true maximum. If not, function will identify which limiting 
% function can be approached by psychometric function. These will have
% finite-valued and meaningful log-likelihood values and pDev can be
% determined even if some simulated fits 'fail'.  'iAPLE' fitting scheme 
% disabled.
%
% PAL_PFML_CheckLimits.m:
% Modified: Palamedes version 1.9.1 (NP)
% The actual work done by this function now happens in sub-routine
% PAL_PFML_CheckLimitsEngine.m
%
% PAL_PFML_CheckLimitsEngine.m:
% Introduced: Palamedes version 1.9.1 (NP)
% See previous entry
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.10.0 Release May 6, 2019
%
% Purpose: (1) Introduce Hierarchical Bayesian fitting of psychometric
% functions functionality (2) minor maintenance
%
%PAL_contains:
% Introduced: Palamedes version 1.10.0 (NP)
% Emulates (some) functionality of Matlab's 'contains' function.
%
%PAL_environment:
% Introduced: Palamedes version 1.10.0 (NP)
% Returns 'octave' or 'matlab' depending on environment from which it is 
% called.
%
%PAL_kde:
% Introduced: Palamedes version 1.10.0 (NP)
% Kernel Density Estimation
%
%PAL_mat2Rdump:
% Introduced: Palamedes version 1.10.0 (NP)
% Write (numeric) matlab structure to R dump format file
%
%PAL_mmType:
% Introduced: Palamedes version 1.10.0 (NP)
% Simple function that can identify some basic forms of model matrices.
%
%PAL_PFHB_buildStan:
% Introduced: Palamedes version 1.10.0 (NP)
% Issues OS-appropriate directive to build executable Stan model.
%
%PAL_PFHB_data2Rdump:
% Introduced: Palamedes version 1.10.0 (NP)
% Add fields .finite, .pInf, and .nInf to 'data' structure, indicating, 
% respectively, whether values in field x are finite-valued, equal to +Inf 
% or to -Inf, then writes 'data' to R dump format.
%
%PAL_PFHB_dataSortandGroup:
% Introduced: Palamedes version 1.10.0 (NP)
% Combines and sorts like trials (i.e., those with identical entries in .x, 
% .s, and .c fields) in data structure containing fields .x, (stimulus 
% levels), .y (number of positive responses), .n (number of trials), .s 
% (integer [1:Number of subjects] identifying subject), and .c (integer 
% [1:Number of conditions] identifying subject).
%
%PAL_PFHB_engineFinished:  
% Introduced: Palamedes version 1.10.0 (NP)
% Waits for Stan or JAGS to finish its work.
%
%PAL_PFHB_figureInits:
% Introduced: Palamedes version 1.10.0 (NP)
% Find reasonable initials for MCMC sampling based on distribution of 
% trials across stimulus intensities (unless initials were provided by 
% user).
%
%PAL_PFHB_findEngine:  
% Introduced: Palamedes version 1.10.0 (NP)
% Find path to Stan or Jags
%
%PAL_PFHB_findJagsinFolder:
% Introduced: Palamedes version 1.10.0 (NP)
% Find most recent version of JAGS in given folder.
%
%PAL_PFHB_findStaninFolderList:
% Introduced: Palamedes version 1.10.0 (NP)
% Find Stan in (list of) given folder.
%
%PAL_PFHB_fitModel:
% Introduced: Palamedes version 1.10.0 (NP)
% Fit psychometric function(s) to single set of data or simultaneously to 
% multiple sets of data obtained from multiple subjects and/or in multiple 
% conditions using Bayesian criterion. Requires that JAGS 
% (http://mcmc-jags.sourceforge.net/) or cmdSTAN ('command Stan')
% (https://mc-stan.org/users/interfaces/cmdstan.html) is installed.
% Compatible with Linux, MAC, Windows, Octave and Matlab. Please cite JAGS 
% or Stan (as well as Palamedes) when you use this function in your 
% research.
%
%PAL_PFHB_getESS:
% Introduced: Palamedes version 1.10.0 (NP)
% Determines the effective sample size for MCMC chain.
%
%PAL_PFHB_getRhat:
% Introduced: Palamedes version 1.10.0 (NP)
% Determines Gelman & Rubin's Rhat statistic (aka, 'potential scale 
% reduction factor, psrf) based on multiple MCMC chains.
%
%PAL_PFHB_getSummaryStats:
% Introduced: Palamedes version 1.10.0 (NP)
% Calculates summary statistics for parameters in Bayesian analysis.
%
%PAL_PFHB_inspectFit:
% Introduced: Palamedes version 1.10.0 (NP)
% Graph data and fit for single subject/condition combination.
%
%PAL_PFHB_inspectParam:
% Introduced: Palamedes version 1.10.0 (NP)
% Display posterior and diagnostic plots for individual parameters or 
% difference parameters, return summary statistics.
%
%PAL_PFHB_organizeSamples:
% Introduced: Palamedes version 1.10.0 (NP)
% Resizes MCMC samples to appropriate sizes and creates a messssage listing 
% the sampled and derived parameters.
%
%PAL_PFHB_readCODA:
% Introduced: Palamedes version 1.10.0 (NP)
% Read JAGS output.
%
%PAL_PFHB_readStanOutput:
% Introduced: Palamedes version 1.10.0 (NP)
% Read Stan output.
%
%PAL_PFHB_runEngine:  
% Introduced: Palamedes version 1.10.0 (NP)
% Issue OS and engine (stan, JAGS) appropriate command to OS to start MCMC 
% sampling and wait for sampling to be finished.
%
%PAL_PFHB_setupModel:
% Introduced: Palamedes version 1.10.0 (NP)
% Set up and initialize 'pfhb' structure based on contents of data 
% structure and optional arguments.
%
%PAL_PFHB_writeInits:
% Introduced: Palamedes version 1.10.0 (NP)
% Write sampler initiation values to file.
%
%PAL_PFHB_writeModel:
% Introduced: Palamedes version 1.10.0 (NP)
% Write Stan or JAGS model according to specifications.
%
%PAL_PFHB_writeModelJags:
% Introduced: Palamedes version 1.10.0 (NP)
% Write JAGS model according to specifications.
%
%PAL_PFHB_writeModelStan:  
% Introduced: Palamedes version 1.10.0 (NP)
% Write stan model according to specifications.
%
%PAL_PFHB_PAL_PFHB_writeScript:  
% Introduced: Palamedes version 1.10.0 (NP)
% Write script for JAGS.
%
%PAL_removeSpaces:
% Introduced: Palamedes version 1.10.0 (NP)
% Remove superfluous spaces from string
%
% PAL_AMPM_setupPM.m:
% Modified: Palamedes version 1.10.0 (NP)
% Removed incompatibility message/warning that was introduced in version 
% 1.5.0
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.10.1 Release August 19, 2019
%
% Purpose: (1) Bug fixes (2) restore compatibility with old Matlab versions
% (tested on Matlab 7.9.1 (R2009b) Service Pack 1). Also tested on Octave 
% (version 5.1.0, 2019) (3) Make PAL_PFHB_fitModel more user-friendly by
% throwing error if build of Stan fails or execution of JAGS or Stan
% fails.
%
%PAL_mmType:
% Modified: Palamedes version 1.10.1 (NP)
% Fixed incompatibility with older versions of Matlab (specifically:
% Matlab function 'isdiag')
%
%PAL_PFHB_buildStan:
% Modified: Palamedes version 1.10.1 (NP)
% Added return argument 'status' that signals whether build was successful
% Added return argument 'OSsays' that contains any message from OS
% regarding call to 'make'.
%
%PAL_PFHB_findEngine:
% Modified: Palamedes version 1.10.1 (NP)
% Fixed error in call to PAL_PFHB_findStaninFolderList in what is current
% line 91.
%
%PAL_PFHB_findStaninFolderList:
% Modified: Palamedes version 1.10.1 (NP)
% Improved the manner in which routine looks for Stan in Windows
% OS (original method failed in Octave).
%
%PAL_PFHB_fitModel:
% Modified: Palamedes version 1.10.1 (NP)
% Will now throw error when (1) chosen sampler (JAGS or Stan) cannot be
% found (did this in version 1.10.0 also but error now has ID), (2) build 
% of Stan executable fails, or (3) execution of JAGS or Stan fails.
%
%PAL_PFHB_runEngine:
% Modified: Palamedes version 1.10.1 (NP)
% Added return argument 'status' that signals whether call to sampler (JAGS 
% or Stan) terminated successfully.
% Added return argument 'OSsays' that contains any message from OS
% regarding execution of sampler.
%
%PAL_PFML_CheckLimitsEngine:
% Modified: Palamedes version 1.10.1 (NP)
% Fixed incompatibility with older versions of Matlab (specifically:
% Matlab function 'round')
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.10.2 Release September 4, 2019
%
% Purpose: Bug fixes
%
%PAL_PFHB_findEngine:
% Modified: Palamedes version 1.10.2 (NP)
% Fixed incorrect call to PAL_PFHB_findStaninFolderList in what is current
% line 43.
%
%PAL_PFHB_fitModel:
% Modified: Palamedes version 1.10.2 (NP)
% Fixed typo in message generated in what is current line 304
%
%PAL_PFHB_setupModel:
% Modified: Palamedes version 1.10.2 (NP)
% Fixed bug that would lead to aborting search for Stan path if a Stan 
% executable sampler exists in current folder regardless of whether 
% engine.recyclestan is set to 'true' or 'false' (should only happen when 
% engine.recylcestan is 'true').
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.10.3 Release October 2, 2019
%
% Purpose: Bug fixes
%
%PAL_PFHB_writeModelStan:
% Modified: Palamedes version 1.10.3 (NP)
% Used JAGS 'pnorm' instead of Stan's 'phi' to evaluate normal in current
% line 378 
%
%PAL_PFHB_inspectFit:
% Modified: Palamedes version 1.10.3 (NP)
% Potentially tried to plot PF at x < 0 even in case of 'Weibull' and
% 'Quick'
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.10.4 Release February 26, 2020
%
% Purpose: Minor upgrades & Bug fixes
%
%PAL_PFHB_fitModel:
% Modified: Palamedes version 1.10.4 (NP)
% (1) Changed error message after Stan build fail (2) Report Rhat with 5
% decimals (even if all 5 decimals are 0) (3) Add engine (stan/jags) version
% number to pfhb structure (in field engine.version). May not always work
% for JAGS depending on OS/environment(matlab/octave)/parallel(yes/no)
% combination
%
%PAL_PFHB_getESS:
% Modified: Palamedes version 1.10.4 (NP)
% Bug fix: added line autoc = []; (line 41), otherwise earlier longer
% vectors will carry over to later short ones.
%
%PAL_PFHB_readStanOutput:
% Modified: Palamedes version 1.10.4 (NP)
% Read Stan version number from Stan's samples file and return.
%
%PAL_PFHB_setupModel:
% Modified: Palamedes version 1.10.4 (NP)
% (1) Added fields .palamedes_version and .environment_version to 
% pfhb.machine (2) environment (matlab/octave) random number generator is 
% now seeded with same seed as engine (JAGS/Stan) when generating initial 
% values for MCMC sampler. After generating initial values random number 
% generator is returned to state it was in. May not work in Octave.
%
%PAL_version:
% Modified: Palamedes version 1.10.4 (NP)
% Added option to 'silently' (no command window output) return Palamedes
% version number either as text or 3-element vector.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.10.5 Release June 6, 2020
%
% Purpose: Minor upgrades & bug fix
%
%PAL_AMPM_setupPM:
% Modified: Palamedes version 1.10.5 (NP)
% Added option to move the heavy duty computations to GPU (if present and
%   Parallel Computing Toolbox is installed)
%
%PAL_AMPM_updatePM:
% Modified: Palamedes version 1.10.5 (NP)
% See PAL_AMPM_setupPM above
%
%PAL_PFHB_inspectFit:
% Modified: Palamedes version 1.10.5 (NP)
% Added options to display posterior predictive distributions of 
%   proportions correct for each stimulus intensity used.
%
%PAL_PFHB_writeModelStan:
% Modified: Palamedes version 1.10.5 (NP)
% Prior parameters for beta were given to Stan as [mean, concentration], 
%   but Stan expects [a, b]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.10.6 Release June 7, 2020
%
% Purpose: bug fix
%
%PAL_PFHB_inspectFit:
% Modified: Palamedes version 1.10.6 (NP)
% Bug fix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.10.7 Release August 24, 2020
%
% Purpose: bug fix
%
%PAL_PFHB_figureInits:
% Modified: Palamedes version 1.10.7 (NP)
% Under certain circumstances the initial values for MCMC for asigma and 
%   bsigma parameters could be set to zero, which would lead to error.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.10.8 Release October 8, 2020
%
% Purpose: bug fix
%
%PAL_PFLR_ModelComparison:
% Modified: Palamedes version 1.10.8 (NP)
% Make default lapseLimits and guessLimits [0 1] rather than [] to avoid
%   possible trouble down the line.
%
%PAL_PFML_BootstrapNonParametricMultiple:
% Modified: Palamedes version 1.10.8 (NP)
% Make default lapseLimits and guessLimits [0 1] rather than [] to avoid
%   possible trouble down the line.
%
%PAL_PFML_BootstrapParametricMultiple:
% Modified: Palamedes version 1.10.8 (NP)
% Make default lapseLimits and guessLimits [0 1] rather than [] to avoid
%   possible trouble down the line.
%
%PAL_PFML_FitMultiple:
% Modified: Palamedes version 1.10.8 (NP)
% Make default lapseLimits and guessLimits [0 1] rather than [] to avoid
%   possible trouble down the line.
%
%PAL_PFML_GoodnessOfFit:
% Modified: Palamedes version 1.10.8 (NP)
% Make default lapseLimits and guessLimits [0 1] rather than [] to avoid
%   possible trouble down the line.
%
%PAL_PFML_GoodnessOfFitMultiple:
% Modified: Palamedes version 1.10.8 (NP)
% Make default lapseLimits and guessLimits [0 1] rather than [] to avoid
%   possible trouble down the line.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.10.9 Release January 5, 2021
%
% Purpose: minor bug fixes and maintenance
%
%PAL_PFML_CheckLimits:
% Modified: Palamedes version 1.10.9 (NP)
% Edited help text and added error if non-finite parameter values are
%   supplied.
%
%PAL_PFML_CheckLimitsEngine:
% Modified: Palamedes version 1.10.9 (NP)
% Added line ('See www.palamedestoobox.org/understandingfitting.html for 
% more information.') to output message.
%
%PAL_PFML_Fit:
% Modified: Palamedes version 1.10.9 (NP)
% Edited help text.
%
%PAL_SDT_AS_PCtoSL:
% Modified: Palamedes version 1.10.9 (FK)
% Changed initial value in call to PAL_minimize (from 1 to 0).
%
%PAL_SDT_PS_PCtoSL:
% Modified: Palamedes version 1.10.9 (FK)
% Changed initial value in call to PAL_minimize (from 1 to 0).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.10.10 Release January 23, 2022
%
% Purpose: upgrades and bug fixes
%
%PAL_hdi:
% Introduced: Palamedes version 1.10.10 (NP)
% Find high-density interval.
%
%PAL_kde:
% Modified: Palamedes version 1.10.10 (NP)
% Added option to perform a quicker, but less accurate, estimate.
%
%PAL_PFHB_drawViolins:
% Introduced: Palamedes version 1.10.10 (NP)
%
%PAL_PFHB_getSummaryStats:
% Modified: Palamedes version 1.10.10 (NP)
% Changed manner in which HDIs are stored. Formerly:
% pfhb.summStats.[param].HDI68low and ...HDI68high
% Currently: pfhb.summStats.[param].hdi68
% PAL_PFHB_updateOldStyleStructure updates old style to new style.
%
%PAL_PFHB_inspectParam:
% Modified: Palamedes version 1.10.10 (NP)
% Changed in accordance with changes made in PAL_PFHB_getSummaryStats
% Changed background of Figure to white.
%
%PAL_PFHB_updateOldStyleStructure:
% Introduced: Palamedes version 1.10.10 (NP)
% Adds fields hdi68 and hdi95 to structures produced by PL_PFHB_fitModel in
% versions less than 1.10.10 (see modification to
% PAL_PFHB_getSummaryStats).
%
%PAL_PFHB_inspectFit:
% Modified: Palamedes version 1.10.10 (NP)
% (1) Fixed bug that occurred when hidens and posteriorpredictive were both
% set to 0. (2) Draw 68% hi-density band around best-fitting PF. This is
% now default behavior instead of drawing randomly sampled hi-density
% curves. (3) Background of figure set to white.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.10.11 Release January 27, 2022
%
% Purpose: bug fix
%
%PAL_MLDS_Fit:
% Modified: Palamedes version 1.10.11 (NP)
% Fixed error in documentation regarding the coding of 'NumGreater' (thanks
%   to Christopher Shooner for finding error!)
%
% Also, PAL_PFHB_MultipleSubjectsSingleCondition_Demo.m and 
%   PAL_PFHB_MultipleSubjectsandConditions_Demo.m no longer require the
%   Matlab Statistics toolbox
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.11.1 Release May 13, 2022
%
% Purpose: Introducing optimization of category membership in
%   Psi(-marginal) method. See PAL_AMPM_Classify_Demo.m for example use.
%
%PAL_AMPM_CreateLUT, PAL_AMPM_expectedEntropy, PAL_AMPM_PosteriorTplus1, 
% PAL_AMPM_setupPM, PAL_AMPM_updatePM:
% Modified: Palamedes version 1.11.1 (NP)
%   Allow inclusion (and optimization of) 'model' (population/category) in 
%   prior and posterior.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.11.2 Release July 7, 2022
%
% Purpose: Fix bug in PAL_AMPM_Demo
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.11.3 Release February 24, 2023
%
% Purpose: Add option to override suggested stimulus intensity when using
%   Psi(-marginal) method, minor modification and bug fix
%
%PAL_AMPM_updatePM:
% Modified: Palamedes version 1.11.3 (NP)
%   Added 'xIndex' option to allow user to override suggested stimulus
%   intensity. See PAL_AMPM_Override_Demo.m for example.
%
%PAL_PFHB_figureInits:
% Modified: Palamedes version 1.11.3 (NP)
%   Bug fix: Code generated model.Ncond initial values for asigma and 
%   bsigma instead of model.a.Nc and model.b.Nc values
%
%PAL_PFHB_fitModel:
% Modified: Palamedes version 1.11.3 (NP)
%   Check whether data.s and data.c entries are consecutive integers 
%   starting with 1. If not, attempt recode and throw warning that recode
%   may fail (fail would be rare but is possible under specific 
%  circumstances).
%
%PAL_PFHB_findEngine:
% Modified: Palamedes version 1.11.3 (NP)
%   Edited 'engine found' message (from 'This may not be the latest ...' to
%   'This may or may not be the latest ...'. The former seemed to imply we
%   have reason to believe that 'this may not' (but we don't).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.11.4 Release February 26, 2023
%
% Purpose: Compliance with: 
% https://mc-stan.org/docs/reference-manual/brackets-array-syntax.html
% Store operating system messages regarding sampler build and/or execution
% in (new) field in result structure: pfhb.engine.ossays
% Store ALL system commands issued in pfhb.engine.syscmd (not just those
% related to execution of the last of the MCMC chains).
% Note: this breaks compatibility with old versions of Stan.
%
%PAL_PFHB_writeModelStan:
% Modified: Palamedes version 1.11.4 (NP)
% Made compliant with brackets array syntax of Stan (old style would break
% starting with Stan 2.32)
%
%PAL_PFHB_fitModel, PAL_PFHB_runEngine, PAL_PFHB_setupModel:
% Modified: Palamedes version 1.11.4 (NP)
% Store operating system messages regarding sampler build and/or execution
%  in (new) field in result structure: pfhb.engine.ossays
% Store all commands sent to operating system in result structure: 
%   pfhb.engine.syscmd
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.11.5 Release February 27, 2023
%
% Purpose: Bug fix
%
%PAL_PFHB_fitModel:
% Modified: Palamedes version 1.11.5 (NP)
% Bug fix. Would crash when engine is JAGS and pfhb.engine.parallel is true
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.11.6 Release March 9, 2023
%
% Purpose: Minor maintenance. Changed made clean up code a bit and fix some
%  minor bugs introduced in version 1.11.4 having to do with storing syscmd
%  and OSsays as cell strings.
%
%PAL_AMPM_setupPM:
% Modified: Palamedes version 1.11.6 (NP)
% Initialize conditional parameter estimates (e.g., PM.threshold_cond) when
%  appropriate (i.e., when PM.model is a vector).
%
%PAL_PFHB_buildStan:
% Modified: Palamedes version 1.11.6 (NP)
%  Moved Stan build fail error message generation to this function (from
%   PAL_PFHB_fitModel).
%  
%PAL_PFHB_fitModel:
% Modified: Palamedes version 1.11.6 (NP)
%  Moved error messages related to engine (JAGS, Stan) failures (build or
%   execute) to PAL_PFHB_buildStan and PAL_PRHB_runEngine.
%  
%PAL_PFHB_runEngine:
% Modified: Palamedes version 1.11.6 (NP)
%  Moved engine execution error message generation to this function (from
%   PAL_PFHB_fitModel).
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.11.7 Release March 17, 2023
%
% Purpose: Add some functionality
%
%PAL_kde2:
% Introduced: Palamedes version 1.11.7 (NP)
% Bivariate kernel density estimation
%
%PAL_pdfBiNormal:
% Introduced: Palamedes version 1.11.7 (NP)
% Probability density function of bivariate normal distribution
%
%PAL_rndBiNormal:
% Introduced: Palamedes version 1.11.7 (NP)
% Random samples from bivariate normal distribution
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.11.8 Release March 27, 2023
%
% Purpose: Provide workaround for Matlab/Stan/Mac Silicon chip
% incompatibility and remove an Octave incompatibility. Minor maintenance.
%
% See here for some background the Matlab/Stan/Mac Silicon chip
% incompatibility: 
% https://www.palamedestoolbox.org/forum/viewtopic.php?t=16
%
%PAL_contains:
% Modified: Palamedes version 1.11.8 (NP)
% Can now handle cell string vectors
%
%PAL_PFHB_buildStan:
% Modified: Palamedes version 1.11.8 (NP)
% If combination of MAC Silicon chip/Matlab/Stan is detected, will ask user
% for help to build stan. See link above for more information.
%
%PAL_PFHB_drawViolins:
% Modified: Palamedes version 1.11.8 (NP)
% Now calls on PAL_contains instead of contains in order to restore
% compatibility with Octave.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.11.9 Release June 6, 2023
%
% Purpose: Minor bug fixes/maintenance.
%
%PAL_drawViolins:
% Modified: Palamedes version 1.11.9 (NP)
% Fixed mislabeling of x-axis in some circumstances
%
%PAL_PFHB_figureInits:
% Modified: Palamedes version 1.11.9 (NP)
% Improved finding initialization values for slope values
%
%PAL_PFHB_inspectParam:
% Modified: Palamedes version 1.11.9 (NP)
% Trim most extreme .01% of MCMC sample from histogram shown to prevent
% extreme outliers from forcing excessive limits on x-axis. Does not affect 
% reported summary statistics.
%
%PAL_PFHB_runEngine:
% Modified: Palamedes version 1.11.9 (NP)
% Fixed issue in error message reports due to file path separator on MS
% windows systems (i.e.,'\') acting as 'escape' character in Matlab 
% strings.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.11.10 Release September 30, 2023
%
% Purpose: Update MAC Silicon chip/Stan issue with release of Matlab 
%   release R2023b, the firs release to run natively on Silicon chip. See
%   https://www.palamedestoolbox.org/forum/viewtopic.php?t=16
%
%PAL_PFHB_buildStan:
% Modified: Palamedes version 1.11.10 (NP)
% Updated after release of Matlab R2023b which runs natively on Silicon
% chip.


