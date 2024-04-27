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
    def __init__(self,soft_laptime, medium_laptime, hard_laptime,  starting_compound ,soft_deg = 0.155, medium_deg = 0.115, hard_deg = 0.1):
        self.soft_initial_laptime = soft_laptime
        self.medium_initial_laptime = medium_laptime
        self.hard_initial_laptime = hard_laptime
        self.starting_compound = starting_compound
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

    def get_soft_initial_laptime(self):
        return self.soft_initial_laptime      

    def get_medium_initial_laptime(self):
        return self.medium_initial_laptime 

    def get_hard_initial_laptime(self):
        return self.hard_initial_laptime

    def get_starting_compound(self):
        return self.starting_compound

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

    define_tyre_information(self, tm):
        Handles tyre information input from user and sets the tyre compound attributes accordingly.        

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
        print("Enter Starting Tyre Name")
        print("-------------------------------")
        for x in TYRES:
            print(f"{x} : {TYRES.get(x)}")
        print("X : Exit")
        print()
        print(
            f"Current Starting Tyre: {tm.get_starting_compound()}, {TYRES.get(tm.get_starting_compound())}")
        print("-------------------------------")

    def choose_starting_tyre(self, starting_tyre_number_str):
        """
        Handles starting tyre input from user sets the starting tyre accordingly.
        """
        try:
            starting_tyre = int(starting_tyre_number_str)
            if starting_tyre not in TYRES.keys():
                raise ValueError
        except ValueError:
            print()
            print(
                "Error: invalid tyre compound selected. Please enter a valid tyre compound from the list provided.")
        else:
            self.tm.set_starting_compound(starting_tyre)

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
                self.choose_starting_tyre(starting_tyre_str)   

if __name__ == '__main__':
    tm = TyreModel(soft_laptime=None, medium_laptime=None, hard_laptime=None, starting_compound=None)
    cmd = CommandLine(tm)
    cmd.userinput()
