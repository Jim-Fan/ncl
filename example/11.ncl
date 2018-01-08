        # Test use of HALT

        # halt          # remove this to test below

        set RA = 0      # set to non-zero if run below
        goto @h if RA
        set RB = 9999
        set RC = 88
        set RD = 9
@h:     halt
