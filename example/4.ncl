        # Test cases for new comparison operator
        # Left hand side registers should be 0 or 1 at halt

        set RA = 99
        set RB = 50
        set RC = 10

        set RD = RA == RB
        set RE = RB == 1024
        set RX = RB == RB
        set RY = RB == 50

        set RF = RB > RA
        set RG = RB > RC
        set RH = RB > 0
        set RI = RB > 4096
        set RZ = RB > RB

        set RJ = RB >= RA
        set RK = RB >= RC
        set RL = RB >= 0
        set RM = RB >= 1024
        set RN = RB >= RB
