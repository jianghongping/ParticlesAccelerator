function [] = saveDefaultVals( params )
%SAVEDEFAULTVALS Summary of this function goes here
%   Detailed explanation goes here

c0 = 3e8;
e0 = -1.60217662e-19;
eM = 9.10938356e-31;          
            

defaultVals.VaLeft                    = params.VaLeft;
defaultVals.VaRight                   = params.VaRight;
defaultVals.electrodeWidth            = params.electrodeWidth;
defaultVals.leftElectrodeRadius       = params.leftElectrodeRadius;
defaultVals.rightElectrodeRadius      = params.rightElectrodeRadius;
defaultVals.deviceRadius              = params.deviceRadius;
defaultVals.distanceBetweenElectrodes = params.distanceBetweenElectrodes;
defaultVals.repetitions               = params.repetitions;
defaultVals.lensPreOffset             = params.lensPreOffset;
defaultVals.lensPostOffset            = params.lensPostOffset;
defaultVals.q                         = params.q;
defaultVals.m                         = params.m;
defaultVals.electrodeProximityThresh  = params.electrodeProximityThresh;
defaultVals.numOfParticles            = params.numOfParticles;
defaultVals.exitRthresh               = params.exitRthresh ;
defaultVals.M                         = params.M;
defaultVals.N                         = params.N;   
defaultVals.beamInitialRadius         = params.beamInitialRadius;
defaultVals.maxInitMoment             = params.maxInitMoment;
defaultVals.Ek                        = params.Ek; 
defaultVals.pcNames                   = params.pcNames; 
defaultVals.pdNames                   = params.pdNames; 



save(sprintf('./simulations/%s/simDefaultVals.mat', params.simGlobalName), 'defaultVals')

end

