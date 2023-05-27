% Consider a 50 lap race, with a single tyre compound choice and no
% constraints on the number of pit stops available.
% During a pit sotp the tyres are changed to a fresh set of the same
% compound.
% Let's assume a pit stop takes 20 seconds to complete.

% We want to use an optimisation problem to determine the optimum number of
% pitstops in this 50 lap race by minimising the total race-time, assuming
% a linear decline in pace each lap as the tyres wear.

% For this, we will define the lap-time (pace) of the tyre for each lap,
% let's assume a 0.5 second decline in pace each lap on the tyre (for the
% sake of expecting the optimal strategy to feature at least one pit stop.)

% We need to define the following:

% lapNumber: (1 - 50)
% tyreAge: (1 - 50)
% lapTime: (n, n+0.5, n+1, ..., n+(49*0.5))
% pitTime: 20s

% Objective (minimise over 50 laps) raceTime = total lap times + total pit
% times

% Establish the logic such that we can choose to stop at any point, and 
% as many times we want, at which point the tyreAge returns to 1.


prob = optimproblem("Description","Single_Linear_Tyre_Pit_Number");

