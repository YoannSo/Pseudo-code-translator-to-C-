CC=gcc
LDFLAGS=-lfl -lm
EXEC_NAME=mon_analyseur
OBJETS=syntaxique.o lexical.o

.y.c:
	  bison -d $<
	  mv $*.tab.c $*.c 
	  mv $*.tab.h $*.h

.l.c:
	flex $<
	mv lex.yy.c $*.c

.c.o:
	$(CC) -c $<

all:  $(EXEC_NAME)

$(EXEC_NAME): $(OBJETS)
	  $(CC) -o $@ $^ $(LDFLAGS)

clean:
	rm $(OBJETS) $(EXEC_NAME)
