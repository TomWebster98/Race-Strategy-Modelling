%% Race Strategy Modelling for Mini-Endurance Races (2-3 Hours)

totalLapNumber = 125; % laps estimated for Cadwell Endurance round (3hours)
lapNumber = 1:totalLapNumber;

%% Fuel and Race Duration Parameters

fuelTankVolume = 33; % L fuel tank size
fuelDensity = 0.787; % kg/l
fuelTankMass_kg = fuelTankVolume .* fuelDensity;  % kg

raceDuration = 3; % hours
raceDuration_sec = raceDuration*60*60; % seconds

%% Energy Use and PWT Parameters

EnergyUsePerLap = 3.96;  % kWh

BatteryCapacity = 8.9;    % kWh
ICECapacity = 110.55;     % kWh
GeneratorEfficiency = 0.85*0.9; % Percentage of ICE output to battery

ICE_UsableEnergy = ICECapacity * GeneratorEfficiency; % ICE energy amount able to become battery charge.

Battery_InitialCharge = BatteryCapacity;

%% Fuel-Burn Parameters

initialLaptime = 90;   % seconds [With the initial fuel mass]

timePerKg = 0.01;   % seconds of laptime gain per kg fuel used
fuelBurnRate = 7.8962e-3;  % kg/s fuel burn rate while the ICE is running

ICE_runtime = fuelTankMass_kg/fuelBurnRate; % Maximum runtime on a full tank of fuel

%% Tyre Wear Forecast

trackLength = 2.175; % Miles
tyreWearPerMile = 0.0217; % s/mile
tyreWearFactor = tyreWearPerMile .* trackLength;  %seconds/lap

tyreAge = 1:totalLapNumber; %laps

%% Tyre Limit

tyreAgeLimit_miles = 85; % miles
tyreAgeLimit_laps = tyreAgeLimit_miles / trackLength;

%% Define Stint Lengths and Initial ICE SOC/Fuel Requirements

% Minimum Number of Stops: 2 (3 sets of tyres available)
% Stint lengths of the half tyre life - 20 laps. (5-Stop Strategy)

Stint_Length = 20; %laps
Energy_Per_Stint = Stint_Length .* EnergyUsePerLap;

% ICE Initial Fuel Required for First Stint
ICE_InitialSOC = (Energy_Per_Stint - Battery_InitialCharge); % kWh
fuelMass_Initial = (ICE_InitialSOC/ICE_UsableEnergy) * fuelTankMass_kg; % Fuel mass for stint 1.

refuelAmount_kg = (Energy_Per_Stint/ICE_UsableEnergy) * fuelTankMass_kg; % Amount for each refuel.

%% Tyre Degradation Model

tyreDegModelLaptime = initialLaptime + (tyreWearFactor .* (tyreAge-1));

%% Pitstop Duration

refuelRate = 3; %L/s
refuelRate_kg = refuelRate * fuelDensity;
refuelTime = refuelAmount_kg/refuelRate_kg;
fullTankFillTime = fuelTankVolume/refuelRate; %time for full refuel while stationary from empty

tyreChangeTime = 40; %s time cost while stationary changing tyres

pitLaneTime = 15; %s time cost in driving through pits

%% Plot Laptime Progression due to Tyre Wear Only

% Visualising the laptime dropoff under the assumption of no fuel burn,
% pitstops, refuelling or tyre changes.

plot(lapNumber,tyreDegModelLaptime)
xlabel("Tyre Age")
ylabel("Laptime (s)")
xlim([0 totalLapNumber])
title("Tyre Degradation Model")
grid on

%% Determine Race Laptimes from Tyre Deg, Pitstops and Fuel Correction.

lapTime = zeros(1,totalLapNumber);
raceTimeRemaining = zeros(1,totalLapNumber);

fuelRemaining_kg = zeros(1,totalLapNumber);
batterySOC_kWh = zeros(1,totalLapNumber);
ICE_SOC_kWh = zeros(1,totalLapNumber);
numberOfPitstops = 0;
numberOFTyreChanges = 0;
finalRefuel = 0;
stint_number = 1;

for i = 1:totalLapNumber
    if i == 1
        batterySOC_kWh(i) = Battery_InitialCharge - EnergyUsePerLap;
        ICE_SOC_kWh(i) = ICE_InitialSOC;
    elseif i~=1 && batterySOC_kWh(i-1) >= EnergyUsePerLap
        batterySOC_kWh(i) = batterySOC_kWh(i-1) - EnergyUsePerLap;
        ICE_SOC_kWh(i) = ICE_InitialSOC;
    elseif i~=1 && batterySOC_kWh(i-1) < EnergyUsePerLap % && ICE_SOC_kWh(i-1) > EnergyUsePerLap
        if ICE_SOC_kWh(i-1) >= EnergyUsePerLap
            batterySOC_kWh(i) = 0;
            ICE_SOC_kWh(i) = ICE_SOC_kWh(i-1) - (EnergyUsePerLap - batterySOC_kWh(i-1));
        end
    end
    fuelRemaining_kg(i) = (ICE_SOC_kWh(i)/ICE_UsableEnergy) .* fuelTankMass_kg;
    lapTime(i) = lapTime(i) + initialLaptime + (tyreWearFactor .* (tyreAge(i)-1)) - ((fuelMass_Initial - fuelRemaining_kg(1)) .* timePerKg);
    raceTimeRemaining = raceDuration_sec - cumsum(lapTime);
    if i == Stint_Length-1
        numberOfPitstops = numberOfPitstops + 1;
        stint_number = stint_number + 1;
        ICE_SOC_kWh(i+1) = Energy_Per_Stint - EnergyUsePerLap;
        lapTime(i+1) = pitLaneTime + (refuelAmount_kg/refuelRate_kg);
    elseif i == (2*Stint_Length)-1
        numberOfPitstops = numberOfPitstops + 1;
        stint_number = stint_number + 1;
        numberOFTyreChanges = numberOFTyreChanges + 1;
        tyreChangeLap = i;
        tyreAge(tyreChangeLap:totalLapNumber) = lapNumber(1:(totalLapNumber-tyreChangeLap+1)); % Update tyreAge vector to reflect fresh tyres from this point
        ICE_SOC_kWh(i+1) = Energy_Per_Stint - EnergyUsePerLap;
        lapTime(i+1) = pitLaneTime + tyreChangeTime - (refuelAmount_kg/refuelRate_kg);
    elseif i == (3*Stint_Length)-1
        numberOfPitstops = numberOfPitstops + 1;
        stint_number = stint_number + 1;
        ICE_SOC_kWh(i+1) = Energy_Per_Stint - EnergyUsePerLap;
        lapTime(i+1) = pitLaneTime + (refuelAmount_kg/refuelRate_kg);
    elseif i == (4*Stint_Length)-1
        numberOfPitstops = numberOfPitstops + 1;
        stint_number = stint_number + 1;
        numberOFTyreChanges = numberOFTyreChanges + 1;
        tyreChangeLap = i;
        tyreAge(tyreChangeLap:totalLapNumber) = lapNumber(1:(totalLapNumber-tyreChangeLap+1)); % Update tyreAge vector to reflect fresh tyres from this point
        ICE_SOC_kWh(i+1) = Energy_Per_Stint - EnergyUsePerLap;
        lapTime(i+1) = pitLaneTime + tyreChangeTime - (refuelAmount_kg/refuelRate_kg);
    elseif i == (5*Stint_Length)-1
        numberOfPitstops = numberOfPitstops + 1;
        stint_number = stint_number + 1;
        if raceTimeRemaining(i) < ICE_runtime*(refuelAmount_kg/fuelTankMass_kg)
            ICE_SOC_kWh(i+1) = Energy_Per_Stint - EnergyUsePerLap;
            lapTime(i+1) = pitLaneTime + (refuelAmount_kg/refuelRate_kg);
        else
            ICE_SOC_kWh(i+1) = ICE_UsableEnergy - EnergyUsePerLap;
            lapTime(i+1) = pitLaneTime + (fuelTankMass_kg/refuelRate_kg);           
        end
    elseif ICE_SOC_kWh(i) < EnergyUsePerLap && finalRefuel ~= 1
        numberOfPitstops = numberOfPitstops + 1;
        finalRefuel = 1;
        stint_number = stint_number + 1;
        ICE_SOC_kWh(i+1) = (((raceTimeRemaining(i)+90)*fuelBurnRate)/fuelTankMass_kg)*ICE_UsableEnergy - EnergyUsePerLap;
        lapTime(i+1) = pitLaneTime + (refuelAmount_kg/refuelRate_kg); 
    end
end

% for i = 1:totalLapNumber
%     if i == 1
%         fuelRemaining_l(i) = fuelTankVolume - fuelBurnPerLap_l;
%     elseif i~=1 && fuelRemaining_l(i-1) >= fuelBurnPerLap_l
%         fuelRemaining_l(i) = fuelRemaining_l(i-1) - fuelBurnPerLap_l;
%     end
%     lapTime(i) = lapTime(i) + initialLaptime + (tyreWearFactor .* (tyreAge(i)-1)) - ((fuelTankVolume - fuelRemaining_l(i)) .* fuelDensity .* timePerKg);
%     raceTimeRemaining = raceDuration_sec - cumsum(lapTime);
%     if fuelRemaining_l(i) < fuelBurnPerLap_l
%         if (raceTimeRemaining(i) >= threeQuarterTankBurnTime_sec) && (i ~= totalLapNumber)
%             numberOfPitstops = numberOfPitstops + 1;
%             fuelRemaining_l(i+1) = fuelTankVolume - fuelBurnPerLap_l;
%             lapTime(i+1) = pitLaneTime + (fuelTankVolume-fuelRemaining_l(i))/refuelRate;
%             if tyreAgeLimit_laps - tyreAge(i) < (fuelTankVolume/fuelBurnPerLap_l)
%                 % Change tyres as they will die before next refuel stop
%                 lapTime(i+1) = lapTime(i+1) + tyreChangeTime - (fuelTankVolume-fuelRemaining_l(i))/refuelRate;
%                 tyreChangeLap = i;
%                 tyreAge(tyreChangeLap:totalLapNumber) = lapNumber(1:(totalLapNumber-tyreChangeLap+1)); % Update tyreAge vector to reflect fresh tyres from this point
%                 numberOFTyreChanges = numberOFTyreChanges + 1;
%             end            
%         elseif (raceTimeRemaining(i) < threeQuarterTankBurnTime_sec) & (finalRefuel ~= 1)
%             % Only fill to required amount to finish the race
%             finalRefuel = 1;
%             numberOfPitstops = numberOfPitstops + 1;
%             finalStintFuelVolume = ((engineConsumption/fuelDensity)/(60*60)) .* raceTimeRemaining(i-2);
%             fuelRemaining_l(i+1) = finalStintFuelVolume - fuelBurnPerLap_l;
%             lapTime(i+1) = pitLaneTime + (finalStintFuelVolume-fuelRemaining_l(i))/refuelRate;
%         end
%     end
% end

%% Sum Laptimes to Find Actual Laps Completed in Race Duration

cumulativeRaceTime = cumsum(lapTime);
lapsComplete = 0;

for i = 1:length(cumulativeRaceTime)
    if lapsComplete == 0
        if cumulativeRaceTime(i) > raceDuration_sec
            lapsComplete = i;
        end
    end
end

%% Plot Fuel Level

figure(2)
plot(lapNumber, fuelRemaining_kg,"LineWidth",1)
hold on
xline(lapsComplete,"LineWidth",1)
xlabel('Lap Number')
ylabel('Fuel Mass (kg)')
xlim([1,totalLapNumber])
ylim([0,26])
title('Full Race Distance Fuel Mass')
grid on
hold off

%% Plot ICE SOC

figure(3)
plot(lapNumber, ICE_SOC_kWh,"LineWidth",1)
hold on
xline(lapsComplete,"LineWidth",1)
xlabel('Lap Number')
ylabel('ICE State of Charge (kWh)')
xlim([1,totalLapNumber])
ylim([0,85])
title('Full Race Distance ICE SOC')
grid on
hold off

%% Plot Laptimes

figure(4)
plot(lapNumber, lapTime,"LineWidth",1)
hold on
xline(lapsComplete,"LineWidth",1)
xlabel('Lap Number')
ylabel('Laptimes (s)')
xlim([1,totalLapNumber])
ylim([85,140])
%xticks(0:5:105)
%yticks(105:2.5:120)
title('Full Race Laptimes - Cadwell Park 3hr Endurance')
grid on
hold off

%% Gapper Plot with Calcs to Reference Average Laptime

% lapTimesCompleted = lapTime(1:lapsComplete);
% isoAvgLapTime = cumulativeRaceTime(lapsComplete)/lapsComplete;
% 
% isoPace = cumsum(ones(1, length(lapTimesCompleted)) .* isoAvgLapTime);
% isoPaceDelta = cumulativeRaceTime(1:lapsComplete) - isoPace;
% 
% figure(4)
% plot(1:lapsComplete,isoPaceDelta,"LineWidth",1)
% title('Endurance Race Laptime Delta to Reference Average Laptime')
% xlabel('Lap Number')
% ylabel('Delta to Average (s)')
% grid on
% xlim([1,lapsComplete])