%% Race Strategy Modelling for Mini-Endurance Races (2-3 Hours)

totalLapNumber = 102; % laps estimated for Cadwell Endurance round (3hours)
lapNumber = 1:totalLapNumber;

%% Refuelling Stops Required

fuelTankVolume = 30; % L fuel tank size
fuelDensity = 0.75; % kg/l
fuelTankMass_kg = fuelTankVolume / fuelDensity;  % kg
engineConsumption = 29; % kg/h

raceDuration = 3; % hours
raceDuration_sec = 3*60*60; % seconds

totalFuelRequired_kg = engineConsumption * raceDuration; % kg
totalFuelRequired_l = totalFuelRequired_kg / fuelDensity; % litres

refuelsRequired = totalFuelRequired_l / fuelTankVolume;

%% Fuel-Burn Laptime Correction

initialLaptime = 105.8;   %seconds

timePerKg = 0.035;   % seconds of laptime gain per kg fuel used
fuelBurnPerLap_kg = (totalFuelRequired_l / raceDuration_sec) .* initialLaptime; % kg/lap Fuel burn per lap approximation

fuelCorrectionFactor = fuelBurnPerLap_kg .* timePerKg;  % seconds/lap

fuelLapCorrections = fuelCorrectionFactor .* (lapNumber-1);

%% Tyre Wear Forecast

tyreWearFactor = linspace(0.09,0.14,totalLapNumber);  %seconds

tyreAge = 1:totalLapNumber; %laps

%% Laptime Forecast

predictedLaptime = initialLaptime + (tyreWearFactor .* (tyreAge-1)) - fuelLapCorrections(lapNumber);

%% Pitstop Duration

refuelRate = 3; %L/s
fullTankVolume = 30; %L
refuellingTime = fullTankVolume/refuelRate; %time for full tank

tyreChangeTime = 40; %s

%% Plot Laptime Progression due to Tyre Wear and Fuel Burn

% Visualising the laptime dropoff under the assumption of no pitstops,
% refuelling or tyre changes.

plot(lapNumber,predictedLaptime)
xlabel("Lap Number")
ylabel("Fuel Corrected Laptime (s)")
xlim([0 totalLapNumber])
% ylim([initialLaptime max(predictedLaptime)])
title("Estimated Tyre Pace Model")
grid on
