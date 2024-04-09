%% Race Strategy Modelling for Mini-Endurance Races (2-3 Hours)

% Anglesey coastal circuit length = 1.550 Miles

totalLapNumber = 80; % laps estimated for Anglesey Endurance round (2hours)
lapNumber = 1:totalLapNumber;

%% Refuelling Stops Required

fuelTankVolume = 30; % L fuel tank size
fuelDensity = 0.75; % kg/l
fuelTankMass_kg = fuelTankVolume .* fuelDensity;  % kg
engineConsumption = 29; % kg/h

raceDuration = 2; % hours
raceDuration_sec = raceDuration*60*60; % seconds

totalFuelRequired_kg = engineConsumption * raceDuration; % kg
totalFuelRequired_l = totalFuelRequired_kg / fuelDensity; % litres

estimatedRefuelsRequired = totalFuelRequired_l / fuelTankVolume;

%% Fuel-Burn Laptime Correction

initialLaptime = 90;   %seconds

timePerKg = 0.035;   % seconds of laptime gain per kg fuel used
fuelBurnPerLap_kg = (totalFuelRequired_l / raceDuration_sec) .* initialLaptime; % kg/lap Fuel burn per lap approximation
fuelBurnPerLap_l = fuelBurnPerLap_kg / fuelDensity; % litres

fuelCorrectionFactor = fuelBurnPerLap_kg .* timePerKg;  % seconds/lap

fuelLapCorrections = fuelCorrectionFactor .* (lapNumber-1);

fullTankBurnTime_sec = (fuelTankVolume / (engineConsumption/fuelDensity))*(60*60); % seconds to burn full tank of fuel

%% Tyre Wear Forecast

trackLength = 1.550; % Miles
tyreWearPerMile = 0.0217; % s/mile
tyreWearFactor = tyreWearPerMile .* trackLength;  %seconds/lap

tyreAge = 1:totalLapNumber; %laps

%% Tyre Limit

tyreAgeLimit_miles = 85; % miles
tyreAgeLimit_laps = tyreAgeLimit_miles / trackLength;

%% Laptime Forecast

tyreDegModelLaptime = initialLaptime + (tyreWearFactor .* (tyreAge-1)) - fuelLapCorrections(lapNumber);

%% Pitstop Duration

refuelRate = 3; %L/s
fullTankFillTime = fuelTankVolume/refuelRate; %time for full refuel while stationary from empty

tyreChangeTime = 40; %s time cost while stationary changing tyres

pitLaneTime = 15; %s time cost in driving through pits

%% Plot Laptime Progression due to Tyre Wear and Fuel Burn

% Visualising the laptime dropoff under the assumption of no pitstops,
% refuelling or tyre changes.

plot(lapNumber,tyreDegModelLaptime)
xlabel("Lap Number")
ylabel("Fuel Corrected Laptime (s)")
xlim([0 totalLapNumber])
% ylim([initialLaptime max(predictedLaptime)])
title("Estimated Tyre Pace Model")
grid on

%% Monitor Fuel Remaining in Tank

% fuelRemaining_l = fuelTankVolume - (fuelBurnPerLap_kg / fuelDensity) .* lapNumber;

% If fuel remaining in tank < fuel required to complete a lap: pitstop (refuelling)
% If pitstop (refuelling only), then laptime for that lap is + refuel time and pitlane time.
% If pitstop (refuelling+tyres), then laptime for that lap is + tyre change time and pitlane time.

lapTime = zeros(1,totalLapNumber);

fuelRemaining_l = zeros(1,totalLapNumber);
numberOfPitstops = 0;
finalRefuel = 0;

for i = 1:totalLapNumber
    if i == 1
        fuelRemaining_l(i) = fuelTankVolume - fuelBurnPerLap_l;
    elseif i~=1 && fuelRemaining_l(i-1) >= fuelBurnPerLap_l
        fuelRemaining_l(i) = fuelRemaining_l(i-1) - fuelBurnPerLap_l;
    end
    lapTime(i) = lapTime(i) + initialLaptime + (tyreWearFactor .* (tyreAge(i)-1)) - ((fuelTankVolume - fuelRemaining_l(i)) .* fuelDensity .* timePerKg);
    raceTimeRemaining = raceDuration_sec - cumsum(lapTime);
    if fuelRemaining_l(i) < fuelBurnPerLap_l
        if (raceTimeRemaining(i) >= fullTankBurnTime_sec) && (i ~= totalLapNumber)
            numberOfPitstops = numberOfPitstops + 1;
            fuelRemaining_l(i+1) = fuelTankVolume - fuelBurnPerLap_l;
            lapTime(i+1) = pitLaneTime + (fuelTankVolume-fuelRemaining_l(i))/refuelRate;
            if tyreAgeLimit_laps - tyreAge(i) < (fuelTankVolume/fuelBurnPerLap_l)
                % Change tyres as they will die before next refuel stop
                lapTime(i+1) = lapTime(i+1) + tyreChangeTime - (fuelTankVolume-fuelRemaining_l(i))/refuelRate;
                tyreChangeLap = i;
                tyreAge(tyreChangeLap:totalLapNumber) = lapNumber(1:(totalLapNumber-tyreChangeLap+1)); % Update tyreAge vector to reflect fresh tyres from this point
            end
        elseif (raceTimeRemaining(i) < fullTankBurnTime_sec) & (finalRefuel ~= 1)
            % Only fill to required amount to finish the race
            finalRefuel = 1;
            numberOfPitstops = numberOfPitstops + 1;
            finalStintFuelVolume = ((engineConsumption/fuelDensity)/(60*60)) .* raceTimeRemaining(i-3);
            fuelRemaining_l(i+1) = finalStintFuelVolume - fuelBurnPerLap_l;
            lapTime(i+1) = pitLaneTime + (finalStintFuelVolume-fuelRemaining_l(i))/refuelRate;
        end
    end
end

% Consider only refuelling for the final time the right amount to finish
% the race, given the known engine consumption, and time remaining in the
% event.

% Time remaining = race duration - cumulative sum of laptimes
% Fuel required to complete final stint = (consumption (kg/h) / density
% (kg/l)) * time remaining

% if lapTime(i) > raceTimeRemaining(i-1) then final lap is i

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
plot(lapNumber, fuelRemaining_l,"LineWidth",1)
hold on
xline(lapsComplete,"LineWidth",1)
xlabel('Lap Number')
ylabel('Fuel Remaining in Tank (Litres)')
xlim([1,totalLapNumber])
title('Full Race Distance Fuel Quantity')
grid on
hold off

%% Plot Laptimes

figure(3)
plot(lapNumber, lapTime,"LineWidth",1)
hold on
xline(lapsComplete,"LineWidth",1)
xlabel('Lap Number')
ylabel('Laptimes (s)')
xlim([1,totalLapNumber])
xticks(0:5:105)
%yticks(105:2.5:120)
title('Full Race Laptimes')
grid on
hold off

%% Gapper Plot with Calcs to Reference Average Laptime

lapTimesCompleted = lapTime(1:lapsComplete);
isoAvgLapTime = cumulativeRaceTime(lapsComplete)/lapsComplete;

isoPace = cumsum(ones(1, length(lapTimesCompleted)) .* isoAvgLapTime);
isoPaceDelta = cumulativeRaceTime(1:lapsComplete) - isoPace;

figure(4)
plot(1:lapsComplete,isoPaceDelta,"LineWidth",1)
title('Endurance Race Laptime Delta to Reference Average Laptime')
xlabel('Lap Number')
ylabel('Delta to Average (s)')
grid on
xlim([1,lapsComplete])