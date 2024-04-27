class TyreModel:
    """
    A class to model the different tyre compounds.

    ...

    Attributes
    ----------
    soft_compound_initial : float
        Initial laptime of the soft compound tyre.

    medium_compound_initial : float
        Initial laptime of the medium compound tyre.

    hard_compound_initial : float
        Initial laptime of the hard compound tyre. 

    soft_compound_degradation : float
        Soft tyre degradation in time/lap.

    medium_compound_degradation : float
        Medium tyre degradation in time/lap.

    hard_compound_degradation : float
        Hard tyre degradation in time/lap.

    starting_tyre : str
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

    """

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
    tyres : 
        Instance of TyreModel.

    Methods
    -------
    menu(self):
        Prints the full list of tyres from the TYRES dictionary.

    define_tyre_information(self, tyres):
        Handles tyre information input from user and sets the tyre compound attributes accordingly.        

    choose_starting_tyre(self, tyres):
        Handles starting tyre input from user sets the starting tyre accordingly.
      

    """
