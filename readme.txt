README
NN:
First, run MLAO_Prep.m to generate training data. 
Next, run nn1 and nn2 to train the two neural networks.
Finally, optimize the results from each neural network in ______
Scripts:
    CRR_Fit: Used to find the coefficients for the crr formula. Uses tabulated data from Bicycle Rolling Resistance
    C_Roll_Resist: Calculates the crr using the equation found in crr_fit. Takes in velocity and tire pressure
    DrivetrainCurveFit:
    DrivetrailEfficiency: Relates power and gear ratio to bike efficiency
    formulation:
    Function_Call_test: Test functions to make sure they work
    MET_Fit: Fits the MET table to a linear function, with velocity in m/s as input, METs as output
    PenaltyMethod: Optimization using the penalty method
    
Functions:
    Eff_Eval:
    Power_Total:
    Trail_Energy: finds the amount of work expended on each section of each trail
    Trail_Time: Finds the time taken on each section of trail, given a desired velocity