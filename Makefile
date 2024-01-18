
dev:
	@echo "Brahmadevara Sai Yashwanth"
	@echo "180010010@iitdh.ac.in"
compiler:
	bison -d -o microParser.c microParser.y
	flex microLexer.l
	gcc -o compiler microParser.c lex.yy.c main.c
clean:
	rm -f lex.yy.c
	rm -f microParser.h
	rm -f microParser.c