        # Verify NUMBER, REG and stack are unsigned int (32-bit)
        #
        # Outcome of time (as on commit 59e9379):
        # real    1m36.481s
        # user    1m36.468s
        # sys     0m0.015s
        #
        # Compare to tight loop in C using below code:
        # unsigned i = 0xFFFFFFFF;
        # unsigned j = 0x0;
        # while (i) { i = i - 1; j = j+1;}
        #
        # Outcome of time:
        # real    0m9.742s
        # user    0m9.718s
        # sys     0m0.015s

        # Underflow REG
        set RA = 0
        set RA = ra - 1

        # Use RA as handy max number provider

        # Overflow REG
        # Expect: RB = 0xFFFFFFFF, RC = 0
        set RB = RA
        set RC = RB + 1

        # Loop through 0 to max value
        # Expect: RD = 0xFFFFFFFF, RE = 0
        set RD = 0
        set RE = RA
@loop:  set RD = RD + 1
        set RE = RE - 1
        goto @loop if RE
