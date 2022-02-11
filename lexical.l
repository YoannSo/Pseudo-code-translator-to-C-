%{
#include "syntaxique.h"
#include "stdlib.h"
#include <string.h>

%}
NOMBRE [1-9][0-9]*
alpha [a-zA-Z]*
blancs [ \t]+
%%
{NOMBRE} {
	yylval.valeur=atoi(yytext);
	return(NOMBRE);
}

{blancs} 
"\n" return(FIN);
"<-" {return(AFFECTATION);};

"+" return(PLUS);
"-" return(MOINS);
"< " {return(PLUSPETIT);}
">" return(PLUSGRAND);
"<=" return(PLUSPETITEGALE);
">=" return(PLUSGRANDEGALE);
"," return(VIRGULE);
":" {return(DEUXPOINTS);}
"entier" {return(ENTIER);}


"Si" return(SI);
"Sinon" return(SINON);
"FinSi" return(FINSI);
"Pour" return(POUR);
"FinPour" return(FINPOUR);
"Faire" return(FAIRE);
"Allant" return(ALLANT);
"de" return(DE);
"a" return(A);
{alpha} {strcpy(yylval.variable,yytext);return(VARIABLE);}

%%
int yywrap(void){
	return 1;
}