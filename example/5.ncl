@begin:     set RA = 1
            goto @fukuoka if RA

@tokyo:     set RA = 2
            goto @osaka if RA

@osaka:     set RA = 3
            goto @hongkong if RA

@kyoto:     set RA = 4
            goto @osaka if RA

@fukuoka:   set RA = 2
            goto @taiwan if RA

@hongkong:  set RA = 9
