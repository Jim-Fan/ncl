        # Find nth Fibonacci number iteratively
        # fab(1) = 1
        # fab(2) = 1
        # fab(n) = fab(n-1) + fab(n-2)

        # Input:  RN, the nth fibonacci number to find
        #         Decrement to zero upon completion
        # Output: RC

        # Problem observed: Compilation doesn't stop at syntax error

        set RN = 50
        set RA = 1
        set RB = 1
        
        set RC = RN <= 2
        goto @done if RC
        set RN = RN - 2

@loop:  set RC = RA + RB
        set RA = RB
        set RB = RC
        set RN = RN - 1
        goto @loop if RN

@done:  set RC = RC
