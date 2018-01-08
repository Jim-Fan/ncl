        # For test on syntax error handling
        set ra = 1
        set ,rb = ,100
        goto @nonexist if ra
@wrong  set rc = 10000
