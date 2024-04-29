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

number_of_pitstops = input("Select Number of Pitstops (1 or 2): ");
starting_tyre = input("Select Starting Tyre (C4, C3 or C2): ", "s");

if number_of_pitstops == 1

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

elseif number_of_pitstops == 2

if starting_tyre == "C4" %C4-C4-C2, C4-C2-C2, C4-C2-C4, C4-C4-C3, C4-C3-C3, C4-C3-C4
    raceTimesArray_C4C4C2 = zeros(length(totalLapNumber)-2,length(totalLapNumber)-1);
    raceTimesArray_C4C2C4 = zeros(1,length(totalLapNumber)-1);
    raceTimesArray_C4C2C2 = zeros(1,length(totalLapNumber)-1);
    raceTimesArray_C4C4C3 = zeros(1,length(totalLapNumber)-1);
    raceTimesArray_C4C3C4 = zeros(1,length(totalLapNumber)-1);
    raceTimesArray_C4C3C3 = zeros(1,length(totalLapNumber)-1);
    for pitLap1 = 1:totalLapNumber-2
        for pitLap2 = pitLap1+1:totalLapNumber-1
        fuel_Corrected_Stint1 = C4laptime(tyreAge(1:pitLap1));
        fuel_Corrected_Stint2_C4 = C4DegLaptime(tyreAge(1:(pitLap2-pitLap1))) - fuelLapCorrections(lapNumber(pitLap1+1:pitLap2));
        fuel_Corrected_Stint2_C3 = C3DegLaptime(tyreAge(1:(pitLap2-pitLap1))) - fuelLapCorrections(lapNumber(pitLap1+1:pitLap2));
        fuel_Corrected_Stint2_C2 = C2DegLaptime(tyreAge(1:(pitLap2-pitLap1))) - fuelLapCorrections(lapNumber(pitLap1+1:pitLap2));
        fuel_Corrected_Stint3_C4 = C4DegLaptime(tyreAge(1:(totalLapNumber-pitLap2))) - fuelLapCorrections(lapNumber(pitLap2+1:totalLapNumber));
        fuel_Corrected_Stint3_C3 = C3DegLaptime(tyreAge(1:(totalLapNumber-pitLap2))) - fuelLapCorrections(lapNumber(pitLap2+1:totalLapNumber));
        fuel_Corrected_Stint3_C2 = C2DegLaptime(tyreAge(1:(totalLapNumber-pitLap2))) - fuelLapCorrections(lapNumber(pitLap2+1:totalLapNumber));
        raceTimesArray_C4C4C2(pitLap2,pitLap1) = sum(fuel_Corrected_Stint1) + sum(fuel_Corrected_Stint2_C4) + sum(fuel_Corrected_Stint3_C2) + number_of_pitstops*pitTime;
        raceTimesArray_C4C2C4(pitLap2,pitLap1) = sum(fuel_Corrected_Stint1) + sum(fuel_Corrected_Stint2_C2) + sum(fuel_Corrected_Stint3_C4) + number_of_pitstops*pitTime;
        raceTimesArray_C4C2C2(pitLap2,pitLap1) = sum(fuel_Corrected_Stint1) + sum(fuel_Corrected_Stint2_C2) + sum(fuel_Corrected_Stint3_C2) + number_of_pitstops*pitTime;
        raceTimesArray_C4C4C3(pitLap2,pitLap1) = sum(fuel_Corrected_Stint1) + sum(fuel_Corrected_Stint2_C4) + sum(fuel_Corrected_Stint3_C3) + number_of_pitstops*pitTime;
        raceTimesArray_C4C3C4(pitLap2,pitLap1) = sum(fuel_Corrected_Stint1) + sum(fuel_Corrected_Stint2_C3) + sum(fuel_Corrected_Stint3_C4) + number_of_pitstops*pitTime;
        raceTimesArray_C4C3C3(pitLap2,pitLap1) = sum(fuel_Corrected_Stint1) + sum(fuel_Corrected_Stint2_C3) + sum(fuel_Corrected_Stint3_C3) + number_of_pitstops*pitTime;
        end
    end
    strategyOptions = [min(raceTimesArray_C4C4C2(raceTimesArray_C4C4C2 > 0)), min(raceTimesArray_C4C2C4(raceTimesArray_C4C2C4 > 0)), min(raceTimesArray_C4C2C2(raceTimesArray_C4C2C2 > 0)), min(raceTimesArray_C4C4C3(raceTimesArray_C4C4C3 > 0)), min(raceTimesArray_C4C3C4(raceTimesArray_C4C3C4 > 0)), min(raceTimesArray_C4C3C3(raceTimesArray_C4C3C3 > 0))];
    figure(2)
    bar(["C4-C4-C2", "C4-C2-C4", "C4-C2-C2", "C4-C4-C3", "C4-C3-C4", "C4-C3-C3"], strategyOptions)
    ylim([min(strategyOptions)-50, max(strategyOptions)+50])
    title("Optimal 2-Stop Strategies")
    ylabel("Race Time (s)")
    optimal2StopTime = min(strategyOptions);
    optimal2StopIndex = find(strategyOptions == optimal2StopTime);
    if numel(optimal2StopIndex) ~= 1
        optimal2StopIndex = optimal2StopIndex(1);
    end
    if optimal2StopIndex == 1
        optimalRaceTime = min(raceTimesArray_C4C4C2(raceTimesArray_C4C4C2 > 0));
        [optimalPitLap2, optimalPitLap1] = find(raceTimesArray_C4C4C2 == optimalRaceTime);
        plotData = raceTimesArray_C4C4C2;
        plotData(plotData==0) = nan; % replace 0 elements with NaN
        disp(strcat("Optimal 2 Stop Strategy: C4 -> C4 on Lap: ", num2str(optimalPitLap1), " and C4 -> C2 on Lap: ", num2str(optimalPitLap2)))
    elseif optimal2StopIndex == 2
        optimalRaceTime = min(raceTimesArray_C4C2C4(raceTimesArray_C4C2C4 > 0));
        [optimalPitLap2, optimalPitLap1] = find(raceTimesArray_C4C2C4 == optimalRaceTime);
        plotData = raceTimesArray_C4C2C4;
        plotData(plotData==0) = nan; % replace 0 elements with NaN
        disp(strcat("Optimal 2 Stop Strategy: C4 -> C2 on Lap: ", num2str(optimalPitLap1), " and C2 -> C4 on Lap: ", num2str(optimalPitLap2)))
    elseif optimal2StopIndex == 3
        optimalRaceTime = min(raceTimesArray_C4C2C2(raceTimesArray_C4C2C2 > 0));
        [optimalPitLap2, optimalPitLap1] = find(raceTimesArray_C4C2C2 == optimalRaceTime);
        plotData = raceTimesArray_C4C2C2;
        plotData(plotData==0) = nan; % replace 0 elements with NaN
        disp(strcat("Optimal 2 Stop Strategy: C4 -> C2 on Lap: ", num2str(optimalPitLap1), " and C2 -> C2 on Lap: ", num2str(optimalPitLap2)))
    elseif optimal2StopIndex == 4
        optimalRaceTime = min(raceTimesArray_C4C4C3(raceTimesArray_C4C4C3 > 0));
        [optimalPitLap2, optimalPitLap1] = find(raceTimesArray_C4C4C3 == optimalRaceTime);
        plotData = raceTimesArray_C4C4C3;
        plotData(plotData==0) = nan; % replace 0 elements with NaN
        disp(strcat("Optimal 2 Stop Strategy: C4 -> C4 on Lap: ", num2str(optimalPitLap1), " and C4 -> C3 on Lap: ", num2str(optimalPitLap2)))
    elseif optimal2StopIndex == 5
        optimalRaceTime = min(raceTimesArray_C4C3C4(raceTimesArray_C4C3C4 > 0));
        [optimalPitLap2, optimalPitLap1] = find(raceTimesArray_C4C3C4 == optimalRaceTime);
        plotData = raceTimesArray_C4C3C4;
        plotData(plotData==0) = nan; % replace 0 elements with NaN
        disp(strcat("Optimal 2 Stop Strategy: C4 -> C3 on Lap: ", num2str(optimalPitLap1), " and C3 -> C4 on Lap: ", num2str(optimalPitLap2)))
    elseif optimal2StopIndex == 6
        optimalRaceTime = min(raceTimesArray_C4C3C3(raceTimesArray_C4C3C3 > 0));
        [optimalPitLap2, optimalPitLap1] = find(raceTimesArray_C4C3C3 == optimalRaceTime);
        plotData = raceTimesArray_C4C3C3;
        plotData(plotData==0) = nan; % replace 0 elements with NaN
        disp(strcat("Optimal 2 Stop Strategy: C4 -> C3 on Lap: ", num2str(optimalPitLap1), " and C3 -> C3 on Lap: ", num2str(optimalPitLap2)))
    end
    figure(3)
    mesh(plotData)
    colorbar
    xlabel("1st Pit Stop Lap Number")
    ylabel("2nd Pit Stop Lap Number")
    zlabel("Race Time (s)")
    title("Total Race Time vs 1st and 2nd Pit Stop Laps")
    grid on
end

end

