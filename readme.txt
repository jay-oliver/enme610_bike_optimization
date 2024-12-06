README

Scripts:
    ===Variable Setup===
    CRR_Fit: Used to find the coefficients for the crr formula. Uses tabulated data from Bicycle Rolling Resistance
    C_Roll_Resist: Calculates the crr using the equation found in crr_fit. Takes in velocity and tire pressure
    DrivetrainCurveFit:used to find the coefficients on the polynomial fit for drivetrain efficiency
    formulation: DO NOT RUN, purely for our visualization sake. Redundant and obsolete now 
    Function_Call_test: Test functions to make sure they work as intended
    MET_Fit: Fits the MET table to a linear function, with velocity in m/s as input, METs as output

Functions:
    Eff_Eval:used to evaluate efficiency given some reasonable gear ratio
        % eff_eval(Gear Ratio)
    Power_Total:returns an array with power for each section of the trail fed into it
        % power_total(Trail angle data (degrees), Trail distance data (m), velocity (m/s), gear ratio, tire
        % pressure (bar), mass (kg),Characteristic Area (m^2))
    Trail_Energy: finds the amount of work expended on each section of each trail
        % trail_energy(trail distance data, trail angle data, mass, pressure, velocity)
    Trail_Time: Finds the time taken on each section of trail, given a desired velocity
        % trail_time(trail distance, velocity)
    energy_sum: returns a total energy of some trail section when given the proper parameters 
        % energy_sum(trail angle data, trail distance data, velocity, Gear Ratio, tire pressure, mass, Characteristic area)

Single Objective Optimization:
    OPT_PenaltyMethod: Optimization using an inverse penalty method
    OPT_fmincon: Optimization using fmincon
    Excel file should not be looked at in matlab please for your sanity use Excel

Multi-Objective Optimization: 
    OPT_fminimax: Optimization using fminimax (not used in report)
    OPT_paretosearch: Optimization using the paretosearch() function
    OPT_Scalarized: Optimization using a scalarized combination method

Parametric Study: There are many scripts here, basically duplicates of the base 6
    "ParaCdA_[method]" indicates it varies characteristic area with the method in the name 
    "ParaMass_[method]" indicates it varies mass with the method in the name 

NN:
    Run nn_main in it's entirety, 
    it calls nn1_fxn to train a function 
    specified by "type" and generates the 
    sample data to train and test it with.