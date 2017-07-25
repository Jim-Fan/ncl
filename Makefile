ncl: parser.tab.c lexer.yy.c ncl.h ncl.c main.c
	gcc -std=c99 -g -o $@ lexer.yy.c parser.tab.c ncl.c main.c \
	&& \
	ctags *.[lyhc]

lexer.yy.c: lexer.l
	flex -o $@ -i $<

parser.tab.c: parser.y
	bison -d -Weverything $< -o $@

clean:
	rm -f *.tab.[hc] *.yy.[hc] *.o *~ *.exe *.stackdump tags
