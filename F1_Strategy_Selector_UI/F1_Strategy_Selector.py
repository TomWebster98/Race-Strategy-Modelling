class TyreModel:
    """
    A class to model the different tyre compounds.

    ...

    Attributes
    ----------
    soft_initial_laptime : float
        Initial laptime of the soft compound tyre.

    medium_initial_laptime : float
        Initial laptime of the medium compound tyre.

    hard_initial_laptime : float
        Initial laptime of the hard compound tyre. 

    soft_compound_degradation : float
        Soft tyre degradation in time/lap.

    medium_compound_degradation : float
        Medium tyre degradation in time/lap.

    hard_compound_degradation : float
        Hard tyre degradation in time/lap.

    starting_tyre : int
        Starting tyre compound for the race.      

    Methods
    -------
    set_soft_initial_laptime(self, soft_initial_laptime):
        Sets the soft compound initial laptime to soft_initial_laptime.

    set_medium_initial_laptime(self, medium_initial_laptime):
        Sets the soft compound initial laptime to medium_initial_laptime.

    set_hard_initial_laptime(self, hard_initial_laptime):
        Sets the soft compound initial laptime to hard_initial_laptime.

    set_starting_compound(self, first_compound):
        Sets the starting compound to first_compound.

    get_soft_initial_laptime(self):
        Returns the soft compound initial laptime.        

    get_medium_initial_laptime(self):
        Returns the medium compound initial laptime. 

    get_hard_initial_laptime(self):
        Returns the hard compound initial laptime.

    get_starting_compound(self):
        Returns the starting compound.

    get_soft_compound_degradation(self):
        Returns the soft compound degradation in s/lap.   

    get_medium_compound_degradation(self):
        Returns the medium compound degradation in s/lap.

    get_hard_compound_degradation(self):
        Returns the hard compound degradation in s/lap.

    """
    def __init__(self,soft_deg = 0.155, medium_deg = 0.115, hard_deg = 0.1):
        self.soft_initial_laptime = None
        self.medium_initial_laptime = None
        self.hard_initial_laptime = None
        self.starting_compound = None
        self.total_lap_number = None
        self.optimal_strategy = None
        self.optimal_pitlap = None
        self.soft_compound_degradation = soft_deg
        self.medium_compound_degradation = medium_deg
        self.hard_compound_degradation = hard_deg

    def set_soft_initial_laptime(self, soft_initial_laptime):
        self.soft_initial_laptime = soft_initial_laptime

    def set_medium_initial_laptime(self, medium_initial_laptime):
        self.medium_initial_laptime = medium_initial_laptime

    def set_hard_initial_laptime(self, hard_initial_laptime):
        self.hard_initial_laptime = hard_initial_laptime

    def set_starting_compound(self, first_compound):
        self.starting_compound = first_compound

    def set_total_lap_number(self, total_lap_number):
        self.total_lap_number = total_lap_number

    def set_optimal_strategy(self, optimal_strategy):
        self.optimal_strategy = optimal_strategy

    def set_optimal_pitlap(self, optimal_pitlap):
        self.optimal_pitlap = optimal_pitlap

    def get_soft_initial_laptime(self):
        return self.soft_initial_laptime      

    def get_medium_initial_laptime(self):
        return self.medium_initial_laptime 

    def get_hard_initial_laptime(self):
        return self.hard_initial_laptime

    def get_starting_compound(self):
        return self.starting_compound
    
    def get_total_lap_number(self):
        return self.total_lap_number
    
    def get_optimal_strategy(self):
        return self.optimal_strategy
    
    def get_optimal_pitlap(self):
        return self.optimal_pitlap

    def get_soft_compound_degradation(self):
        return self.soft_compound_degradation   

    def get_medium_compound_degradation(self):
        return self.medium_compound_degradation

    def get_hard_compound_degradation(self):
        return self.hard_compound_degradation


TYRES = {

    1: "Soft",
    2: "Medium",
    3: "Hard",

}


class CommandLine:
    """
    A class to model the command line user interface.

    ...

    Attributes
    ----------
    tm : 
        Instance of TyreModel.

    Methods
    -------
    menu(self):
        Prints the list of tyres from the TYRES dictionary as well as the current starting tyre.     

    choose_starting_tyre(self, tm):
        Handles starting tyre input from user sets the starting tyre accordingly.

    def userinput(self):
        Handles looping for repeated user inputs to change through starting tyre strategies.
      
    """
    def __init__(self, tm):
        self.tm = tm

    def menu(self, tm):
        """
        Prints the list of tyres from the TYRES dictionary as well as the current starting tyre.
        """
        print()
        print("Enter Starting Tyre Number")
        print("-------------------------------")
        for x in TYRES:
            print(f"{x} : {TYRES.get(x)}")
        print("X : Exit")
        print()
        print(
            f"Current Starting Tyre: {tm.get_starting_compound()}, {TYRES.get(tm.get_starting_compound())}")
        print(f"Calculating Optimal Strategy for a {tm.get_total_lap_number()} Lap Race")
        print(f"Optimal Strategy: {tm.get_optimal_strategy()}")
        print(f"Optimal Pit Lap: {tm.get_optimal_pitlap()}")
        print("-------------------------------")

    def define_tyre_info(self, starting_tyre_number_str, total_lap_number_str, soft_initial_laptime_str, medium_initial_laptime_str, hard_initial_laptime_str):
        """
        Handles tyre information input and total lap number from user and sets the attributed in TyreModel accordingly.
        """
        try:
            starting_tyre = int(starting_tyre_number_str)
            total_lap_number = int(total_lap_number_str)
            soft_initial_laptime = float(soft_initial_laptime_str)
            medium_initial_laptime = float(medium_initial_laptime_str)
            hard_initial_laptime = float(hard_initial_laptime_str)
            if starting_tyre not in TYRES.keys():
                raise ValueError
            if total_lap_number < 40 or total_lap_number > 70:
                raise ValueError
        except ValueError:
            print()
            print(
                "Error: invalid tyre compound, total lap number or initial laptime value selected.")
        else:
            self.tm.set_starting_compound(starting_tyre)
            self.tm.set_total_lap_number(total_lap_number)
            self.tm.set_soft_initial_laptime(soft_initial_laptime)
            self.tm.set_medium_initial_laptime(medium_initial_laptime)
            self.tm.set_hard_initial_laptime(hard_initial_laptime)
            self.strategy_calculations()
                        
    def userinput(self):
        """
        Handles looping for repeated user inputs to change through starting tyre strategies.
        """
        running = True
        while (running):
            self.menu(tm)
            starting_tyre_str = input("Starting Tyre Compound: ")
            starting_tyre_str = starting_tyre_str.strip()
            if starting_tyre_str == "X" or starting_tyre_str == "x":
                print()
                print("Finished")
                print()
                running = False
            else:
                total_lap_number_str = input("Total Number of Racing Laps (40-70): ")
                total_lap_number_str = total_lap_number_str.strip()
                soft_initial_laptime_str = input("Soft Tyre Initial Laptime (s): ")
                soft_initial_laptime_str = soft_initial_laptime_str.strip()
                medium_initial_laptime_str = input("Medium Tyre Initial Laptime (s): ")
                medium_initial_laptime_str = medium_initial_laptime_str.strip()
                hard_initial_laptime_str = input("Hard Tyre Initial Laptime (s): ")
                hard_initial_laptime_str = hard_initial_laptime_str.strip()              
                self.define_tyre_info(starting_tyre_str, total_lap_number_str, soft_initial_laptime_str, medium_initial_laptime_str, hard_initial_laptime_str)   

    def strategy_calculations(self):
        """
        Calculates optimal strategy for defined starting tyre compound, initial laptimes and degradation.
        """
        soft_laptimes = []
        medium_laptimes = []
        hard_laptimes = []
        for tyreAge in range(1,self.tm.get_total_lap_number(),1):
            soft_laptimes.append(self.tm.get_soft_initial_laptime() + (self.tm.get_soft_compound_degradation() * (tyreAge-1)))
            medium_laptimes.append(self.tm.get_medium_initial_laptime() + (self.tm.get_medium_compound_degradation() * (tyreAge-1)))
            hard_laptimes.append(self.tm.get_hard_initial_laptime() + (self.tm.get_hard_compound_degradation() * (tyreAge-1)))

        if self.tm.get_starting_compound == 1:
            soft_medium_racetimes = []
            soft_hard_racetimes = []
            for pitLap in range(1, self.tm.get_total_lap_number(), 1):
                stint1_times = soft_laptimes[0:pitLap+1]
                stint2_times_Med = medium_laptimes[0:(self.tm.get_total_lap_number()-pitLap)]
                stint2_times_Hard = hard_laptimes[0:(self.tm.get_total_lap_number()-pitLap)]
                soft_medium_racetimes.append(sum(stint1_times) + sum(stint2_times_Med))
                soft_hard_racetimes.append(sum(stint1_times) + sum(stint2_times_Hard))
            optimal_softmed_time = min(soft_medium_racetimes)
            optimal_softmed_pitlap = soft_medium_racetimes.index(optimal_softmed_time) + 1
            optimal_softhard_time = min(soft_hard_racetimes)
            optimal_softhard_pitlap = soft_hard_racetimes.index(optimal_softhard_time) + 1
            if optimal_softmed_time <= optimal_softhard_time:
                self.tm.set_optimal_strategy("Soft -> Medium")
                self.tm.set_optimal_pitlap(optimal_softmed_pitlap)
            else:
                self.tm.set_optimal_strategy("Soft -> Hard")
                self.tm.set_optimal_pitlap(optimal_softhard_pitlap)                

if __name__ == '__main__':
    tm = TyreModel()
    cmd = CommandLine(tm)
    cmd.userinput()
