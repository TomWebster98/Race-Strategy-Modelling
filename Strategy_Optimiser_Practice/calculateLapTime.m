function lapTime = calculateLapTime(initialLaptime, tyreWear, tyreAge, fuelLapCorrections, lapNumber)
    lapTime = initialLaptime + (tyreWear .* (tyreAge-1)) - fuelLapCorrections(lapNumber);
end
