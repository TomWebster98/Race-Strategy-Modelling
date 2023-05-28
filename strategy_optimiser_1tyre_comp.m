% Consider a 50 lap race, with a single tyre compound choice and 
% constraining the pit allowance to a single stop.
% During a pit sotp the tyres are changed to a fresh set of the same
% compound.
% Let's assume a pit stop takes 20 seconds to complete.

% We want to use an optimisation problem to determine the optimum pit lap
% in this 50 lap race by minimising the total race-time, assuming
% a linear decline in pace each lap as the tyres wear.

% For this, we will define the lap-time (pace) of the tyre for each lap,
% let's assume a consistent 0.5s decline in pace each lap on the tyre.

% We need to define the following:

% lapNumber: (1 - 50)
% tyreAge: (1 - 50)
% lapTime: (n, n+0.5, n+1, ..., n+(49*0.5))
% pitTime: 20s (After which, the tyreAge is 1 and grows linearly again.)

% Objective (minimise over 50 laps) raceTime = total lap times + pit time.

% Establish the logic such that we can choose to stop at any point, and 
% only once, at which point the tyreAge returns to 1. (Expect therefore the
% optimal stop to be at the half way point of the race.

prob = optimproblem("Description","Single_Linear_Tyre_Pit_Lap","ObjectiveSense","minimize");

% We need the solver to look at graphical plots for total race time when
% pitting on Laps 1-49 and decide which option is fastest.






