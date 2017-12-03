c0 = 3e8;
e0 = -1.60217662e-19;
eM = 9.10938356e-31;          
            

params.dimensionsOptimization    = false;
params.simulateTrajectory        = true;
params.useAngle                  = true;
params.use_bessel                = false;
params.simulateElectron          = true;
params.BunchOrSingle             = false;
params.VaLeft                    = -15*1e3;
params.VaRight                   = 15*1e3;
params.electrodeWidth            = 10/1e6;
params.leftElectrodeRadius       = 1/1e3;
params.rightElectrodeRadius      = 1/1e3;
params.deviceRadius              = 5/1e3;
params.distanceBetweenElectrodes = 1/1e3;
params.repetitions               = 1;
params.sideOffset                = 2/(1e3);

params.M                         = 100;
params.N                         = 25;
% params.M                         = 730;
% params.N                         = 290;

params.rPts                      = 100;
params.zPts                      = 100;

% params.rPts                      = 500;
% params.zPts                      = 500;

params.convergeTh                = 5e-8;
params.growthTh                  = 0.5e-4;
params.entryVel                  = 0.1*c0;
params.entryAngle                = 30;
params.entryR                    = 0;
params.q                         = 1*e0;
params.m                         = 1*eM;
params.axialEntryVelocity        = 0.1*c0;
params.radialEntryVelocity       = 0.05*c0;
params.useRelativeTrajectory     = true; 
params.electrodeProximityThresh  = 10/1e6;

params.numOfParticles            = 10;
% params.numOfParticles            = 1000;

params.lowAxialVel               = 0.1*c0;
params.highAxialVel              = 0.3*c0;
params.lowRadialVel              = 0.001*c0;
params.highRadialVel             = 0.05*c0;
params.exitRthresh               = 0.25/1e3;
params.beamInitialRadius         = 5e-4;
params.simulatePhaseSpace        = 1;
params.genNewSeed                = true;
params.simGlobalName             = 'ElectroStaticLens';
params.eraseOldSim               = true;    
% params.recordPhaseSpace          = true;
params.recordPhaseSpace          = false;
params.SingleSim                 = false;

paramsFields = fieldnames(params);

iterParamsCharges = struct();
iterParamsDevice = struct();

%charge parameters iteration variables definitions
iterParamsCharges.entryVel=[0.05,0.075]*c0;


% iterParamsCharges.entryVel=[0.05,0.075,0.1,0.125,0.15,0.2,0.3,0.5,0.75,0.9]*c0;


%device parameters iteration variables definitions
iterParamsDevice.globalVa = [10,15]*1e3;
% iterParamsDevice.globalElectrodeRadius=[0.25,0.5]/1e3;

% iterParamsDevice.globalVa = [10,15,30,50,100]*1e3;
% iterParamsDevice.repetitions = [1,2,3,5,7,9];
% iterParamsDevice.distanceBetweenElectrodes=[0.5,0.75,1,1.25,2]/1e3;
% iterParamsDevice.globalElectrodeRadius=[0.25,0.5,0.75,1,1.5,2]/1e3;


pcNames = fieldnames(iterParamsCharges);
pdNames = fieldnames(iterParamsDevice);


if isdir(['./simulations/',params.simGlobalName])
    rmdir(['./simulations/',params.simGlobalName],'s');
end
 
if (~exist(['./simulations/',params.simGlobalName,'/simulationsSummary'], 'dir'))
    mkdir (['./simulations/',params.simGlobalName,'/simulationsSummary'])
end

if(exist('SimulationsLog.txt', 'file'))
    delete('SimulationsLog.txt')
end

log = fopen('SimulationsLog.txt', 'wt');
fprintf(log, "Beginning %s... Time: %s \n",params.simGlobalName, datetime('now'));


results = struct();
results.in.globalDefaultParams = params;

%Writing the input values in the results vector
for pdNameInd = 1:numel(pdNames)
    name = pdNames{pdNameInd};
    results.in.device.(name) = iterParamsDevice.(name);
end

for pcNameInd = 1:numel(pcNames)
    name = pcNames{pcNameInd};
    results.in.charges.(name) = iterParamsCharges.(name);
end

for pdNameInd = 1:numel(pdNames)
    pdName = pdNames{pdNameInd};
    pdVec = iterParamsDevice.(pdName);
    for pdValInd = 1:length(pdVec)
        pdVal = pdVec(pdValInd);
        for pcNameInd = 1:numel(pcNames)
            pcName = pcNames{pcNameInd};
            pcVec = iterParamsCharges.(pcName);
            for pcValInd = 1:length(pcVec)  
                pcVal = pcVec(pcValInd);
                runParams = params;
                runParams.(pdName) = pdVal;
                runParams.(pcName) = pcVal;
                runParams.simName = sprintf('%s-[%d]-%s-[%d]',  ...
                                     pdName, pdVal, pcName, pcVal);
                runParams.simPdName = sprintf('%s-[%d]', pdName, pdVal);
                
                [focused_particles_percent, randomSeed] = runSim(runParams);
                results.out.(pdName).(pcName).focused(pdValInd,pcValInd) = focused_particles_percent;
                results.out.(pdName).(pcName).randomSeed(pdValInd,pcValInd) = randomSeed;
                fprintf(log, "%s DONE, Time: %s \n",runParams.simName, datetime('now'));
            end
        end
    end
end

    
    for pdNameInd = 1:numel(pdNames)
        pdName = pdNames{pdNameInd};
        for pcNameInd = 1:numel(pcNames)
            pcName = pcNames{pcNameInd};
            fig = figure;
            plot(results.in.charges.(pcName), results.out.(pdName).(pcName).focused, '-o');
            tit = ['Focused Particles vs. ', pdName, ' and ',  pcName];
            title(tit);
            xlabel(pcName);
            ylabel('Focused particles [%]');
            ylim([0,110]);
            legstr = string(results.in.device.(pdName));
            legstr = strcat(strjoin([pdName, " = "]), legstr); 
            legend(legstr);
            savefig(fig, ['./simulations/', params.simGlobalName,'/simulationsSummary/', tit, '.fig']);
            close(fig);
        end
    end
    
    
    save(['./simulations/', params.simGlobalName,'/simulationsSummary/results.mat'], 'results');
    
    fprintf(log, "Simulations FINISHED, Time: %s \n", datetime('now'));
    fclose(log);