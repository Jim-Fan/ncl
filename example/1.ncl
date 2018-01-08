        set ra = 10
        set rb = 0
@loop:  set rb = rb + ra
        set ra = ra - 1
        goto @loop if ra
