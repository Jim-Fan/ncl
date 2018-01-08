            # Ackermann Function
            # See also: https://en.wikipedia.org/wiki/Ackermann_function
            #
            # Input: RM, RN
            # Output: RA
            #
            # Outcome:
            # 1) With stack size 128, stack overflow at:
            #      M=4, no hope
            #      M=3, N=5
            #      M=2, N=64
            #      M=1, N=128
            # 2) No error found for smaller input

            #set RM = 4
            #set RN = 1

            #set RM = 3
            #set RN = 5

            #set RM = 2
            #set RN = 64

            set RM = 1
            set RN = 127

            set RA = 0      # result
            set RP = 0      # count recursion depth
            set RC = 0      # test jump condition

@ackerman:  set RC = RM > 0
            goto @m if RC
            set RA = RN + 1
            goto @done if RA        # unconditional jump

@m:         set RC = RN > 0
            goto @n if RC
            set RM = RM - 1
            set RN = 1
            goto @ackerman if RN    # unconditional jump

@n:         push RM
            set RP = RP + 1         # count how deep recursion is

            # Do recursive call
            set RN = RN - 1
            goto @ackerman if RP    # unconditional jump

@done:      set RC = RP == 0
            goto @tdone if RC
            set RP = RP - 1
            pop RM
            set RN = RA         # set RN to last recursive call result
            set RM = RM - 1
            goto @ackerman if RA    # unconditional jump

@tdone:     set RA = RA
