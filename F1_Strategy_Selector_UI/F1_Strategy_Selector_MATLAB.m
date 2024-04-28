%% Calculating the Optimal Pit Strategy and Pit Lap in F1 Strategy
% 3 Tyre Compounds, Initially consider only 1-stop races.

fuelQuantity = 110;  %kg
totalLapNumber = input("Total Number of Laps: "); %laps
lapNumber = 1:totalLapNumber;
timePerKg = 0.035;   %seconds

fuelConsumption = fuelQuantity/totalLapNumber;   %kg/lap

fuelCorrectionFactor = fuelConsumption .* timePerKg; %seconds/lap

fuelLapCorrections = fuelCorrectionFactor .* (lapNumber-1);

%% Defining Arbitrary Tyre Wear Factors

C4Wear = linspace(0.08,0.3,totalLapNumber); 
C3Wear = linspace(0.04,0.2,totalLapNumber);
C2Wear = linspace(0.04,0.12,totalLapNumber); 

tyreAge = 1:totalLapNumber; %laps

%% Calculating Tyre Degradation Laptime Impact

C4InitialLaptime = 96.3;
C3InitialLaptime = 97;
C2InitialLaptime = 97.8;

C4DegLaptime = C4InitialLaptime + (C4Wear .* (tyreAge-1));
C3DegLaptime = C3InitialLaptime + (C3Wear .* (tyreAge-1));
C2DegLaptime = C2InitialLaptime + (C2Wear .* (tyreAge-1));

%% Calculating Tyre and Fuel Effected Laptimes for Full Distance Tyre Model

C4laptime = C4InitialLaptime + (C4Wear .* (tyreAge-1)) - fuelLapCorrections(lapNumber);
C3laptime = C3InitialLaptime + (C3Wear .* (tyreAge-1)) - fuelLapCorrections(lapNumber);
C2laptime = C2InitialLaptime + (C2Wear .* (tyreAge-1)) - fuelLapCorrections(lapNumber);

%% Defining Average Pit Time Loss

pitTime = 20;  %seconds

%% 
% Plotting the tyre model to visualise the tyre life and pace over the full 
% race distance.

figure(1)
plot(lapNumber,C4DegLaptime,"r","LineWidth",1)
hold on
plot(lapNumber,C3DegLaptime,"Color","#EDB120","LineWidth",1)
plot(lapNumber,C2DegLaptime,"Color","#4DBEEE","LineWidth",1)
xlabel("Lap Number")
ylabel("Laptime (s)")
xlim([1,totalLapNumber])
ylim([C4InitialLaptime-0.5, C4DegLaptime(end)+0.5])
title("Tyre Degradation Model")
legend(["C4", "C3", "C2"])
grid on
hold off

%% Evaluate Race Times for all pit laps
% Parameter sweep for pitstop laps

starting_tyre = input("Select Starting Tyre (C4, C3 or C2): ", "s");

if starting_tyre == "C4"
    raceTimesArray_C4C3 = zeros(1,length(totalLapNumber)-1);
    raceTimesArray_C4C2 = zeros(1,length(totalLapNumber)-1);
    for pitLap = 1:totalLapNumber-1
        fuel_Corrected_Stint1 = C4laptime(tyreAge(1:pitLap));
        fuel_Corrected_Stint2_C3 = C3DegLaptime(tyreAge(1:(totalLapNumber-pitLap))) - fuelLapCorrections(lapNumber(pitLap+1:totalLapNumber));
        fuel_Corrected_Stint2_C2 = C2DegLaptime(tyreAge(1:(totalLapNumber-pitLap))) - fuelLapCorrections(lapNumber(pitLap+1:totalLapNumber));
        raceTimesArray_C4C3(pitLap) = sum(fuel_Corrected_Stint1) + sum(fuel_Corrected_Stint2_C3) + pitTime;  %seconds
        raceTimesArray_C4C2(pitLap) = sum(fuel_Corrected_Stint1) + sum(fuel_Corrected_Stint2_C2) + pitTime;  %seconds
    end
    if min(raceTimesArray_C4C3) <= min(raceTimesArray_C4C2)
        optimalRaceTime = min(raceTimesArray_C4C3);
        optimalPitLap = find(raceTimesArray_C4C3 == optimalRaceTime);
        disp(strcat('Optimal 1 Stop Strategy: C4 -> C3 on Lap: ', num2str(optimalPitLap)))
    else
        optimalRaceTime = min(raceTimesArray_C4C2);
        optimalPitLap = find(raceTimesArray_C4C2 == optimalRaceTime);
        disp(strcat('Optimal 1 Stop Strategy: C4 -> C2 on Lap: ', num2str(optimalPitLap)))
    end
    figure(2)
    plot(1:totalLapNumber-1, raceTimesArray_C4C3,"Color","#EDB120","LineWidth",1)
    hold on
    plot(1:totalLapNumber-1, raceTimesArray_C4C2,"Color","#4DBEEE","LineWidth",1)
    title('Total Race Time vs Pitstop Lap')
    xlabel('Pit Stop Lap')
    ylabel('Total Race Time (s)')
    xlim([1,totalLapNumber])
    legend(["C4 -> C3","C4 -> C2"],"Location","best")
    grid on
end

if starting_tyre == "C3"
    raceTimesArray_C3C2 = zeros(1,length(totalLapNumber)-1);
    raceTimesArray_C3C4 = zeros(1,length(totalLapNumber)-1);
    for pitLap = 1:totalLapNumber-1
        fuel_Corrected_Stint1 = C3laptime(tyreAge(1:pitLap));
        fuel_Corrected_Stint2_C2 = C2DegLaptime(tyreAge(1:(totalLapNumber-pitLap))) - fuelLapCorrections(lapNumber(pitLap+1:totalLapNumber));
        fuel_Corrected_Stint2_C4 = C4DegLaptime(tyreAge(1:(totalLapNumber-pitLap))) - fuelLapCorrections(lapNumber(pitLap+1:totalLapNumber));
        raceTimesArray_C3C2(pitLap) = sum(fuel_Corrected_Stint1) + sum(fuel_Corrected_Stint2_C2) + pitTime;  %seconds
        raceTimesArray_C3C4(pitLap) = sum(fuel_Corrected_Stint1) + sum(fuel_Corrected_Stint2_C4) + pitTime;  %seconds
    end
    if min(raceTimesArray_C3C2) <= min(raceTimesArray_C3C4)
        optimalRaceTime = min(raceTimesArray_C3C2);
        optimalPitLap = find(raceTimesArray_C3C2 == optimalRaceTime);
        disp(strcat('Optimal 1 Stop Strategy: C3 -> C2 on Lap: ', num2str(optimalPitLap)))
    else
        optimalRaceTime = min(raceTimesArray_C3C4);
        optimalPitLap = find(raceTimesArray_C3C4 == optimalRaceTime);
        disp(strcat('Optimal 1 Stop Strategy: C3 -> C4 on Lap: ', num2str(optimalPitLap)))
    end
    figure(2)
    plot(1:totalLapNumber-1, raceTimesArray_C3C4,"r","LineWidth",1)
    hold on
    plot(1:totalLapNumber-1, raceTimesArray_C3C2,"Color","#4DBEEE","LineWidth",1)
    title('Total Race Time vs Pitstop Lap')
    xlabel('Pit Stop Lap')
    ylabel('Total Race Time (s)')
    xlim([1,totalLapNumber])
    legend(["C3 -> C4","C3 -> C2"],"Location","best")
    grid on
end

if starting_tyre == "C2"
    raceTimesArray_C2C3 = zeros(1,length(totalLapNumber)-1);
    raceTimesArray_C2C4 = zeros(1,length(totalLapNumber)-1);
    for pitLap = 1:totalLapNumber-1
        fuel_Corrected_Stint1 = C2laptime(tyreAge(1:pitLap));
        fuel_Corrected_Stint2_C3 = C3DegLaptime(tyreAge(1:(totalLapNumber-pitLap))) - fuelLapCorrections(lapNumber(pitLap+1:totalLapNumber));
        fuel_Corrected_Stint2_C4 = C4DegLaptime(tyreAge(1:(totalLapNumber-pitLap))) - fuelLapCorrections(lapNumber(pitLap+1:totalLapNumber));
        raceTimesArray_C2C3(pitLap) = sum(fuel_Corrected_Stint1) + sum(fuel_Corrected_Stint2_C3) + pitTime;  %seconds
        raceTimesArray_C2C4(pitLap) = sum(fuel_Corrected_Stint1) + sum(fuel_Corrected_Stint2_C4) + pitTime;  %seconds
    end
    if min(raceTimesArray_C2C3) <= min(raceTimesArray_C2C4)
        optimalRaceTime = min(raceTimesArray_C2C3);
        optimalPitLap = find(raceTimesArray_C2C3 == optimalRaceTime);
        disp(strcat('Optimal 1 Stop Strategy: C2 -> C3 on Lap: ', num2str(optimalPitLap)))
    else
        optimalRaceTime = min(raceTimesArray_C2C4);
        optimalPitLap = find(raceTimesArray_C2C4 == optimalRaceTime);
        disp(strcat('Optimal 1 Stop Strategy: C2 -> C4 on Lap: ', num2str(optimalPitLap)))
    end
    figure(2)
    plot(1:totalLapNumber-1, raceTimesArray_C2C4,"r","LineWidth",1)
    hold on
    plot(1:totalLapNumber-1, raceTimesArray_C2C3,"Color","#EDB120","LineWidth",1)
    title('Total Race Time vs Pitstop Lap')
    xlabel('Pit Stop Lap')
    ylabel('Total Race Time (s)')
    xlim([1,totalLapNumber])
    legend(["C2 -> C4","C2 -> C3"],"Location","best")
    grid on
end
