
%{
#include "syntaxique.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yyparse();

void yyerror(char *s);
extern int yylex();
extern FILE *yyin;

char decla[500];
char type[500];
char listInstructionSi[1000];
char listInstructionFor[1000];
%}
%union{ int valeur;}
%union{char variable[100];}
%union{char *texte;}
%token <valeur> NOMBRE
%token <variable> VARIABLE
%token PLUS MOINS
%token PLUSPETIT PLUSGRAND PLUSPETITEGALE PLUSGRANDEGALE
%token VIRGULE DEUXPOINTS
%token POUR ALLANT DE A FAIRE FINPOUR
%token SI SINON FINSI
%token AFFECTATION
%token ENTIER TYPE
%token FIN

%type <texte> Operation  Instruction Affectation Boucle 
%type <texte> ConditionSinon ConditionSi Declaration Declarations
%start Input
%%
Input: Programme
  ;
Programme: Declarations Instructions
  |
  ;
Instructions: Instruction FIN Instructions 
  |
  ;
Instruction:Declarations {printf("%s %s;\n",type,decla);strcpy(decla,"");}
  | Affectation {printf($1);}
  | Operation {printf($1);}
  | Boucle
  | ConditionSi
  ;
InstructionsSi:InstructionSi FIN InstructionsSi 
  |
  ;
InstructionSi:Declarations {strcat(decla,";\n");strcat(type," ");strcat(type,decla);strcat(listInstructionSi,type);strcpy(decla,"");}
  | Affectation {strcat(listInstructionSi,$1);}
  | Operation {strcat(listInstructionSi,$1);}
  | Boucle {strcat(listInstructionSi,$1);}
  | ConditionSi {strcat(listInstructionSi,$1);}
  ;

 InstructionsFor:InstructionFor FIN InstructionsFor 
  |
  ;
InstructionFor:Declarations {strcat(decla,";\n");strcat(type," ");strcat(type,decla);strcat(listInstructionFor,type);strcpy(decla,"");}
  | Affectation {strcat(listInstructionFor,$1);}
  | Operation {strcat(listInstructionFor,$1);}
  | Boucle {strcat(listInstructionFor,$1);}
  | ConditionSi {strcat(listInstructionFor,$1);}
  ;


Operation: NOMBRE PLUS NOMBRE { char num1[100],num2[100],final[100];
	sprintf(num1,"%d",$1);
	sprintf(num2,"%d",$3);
	strcat(num1," + ");
	strcat(num1,num2);
	strcat(num1,";\n");
	$$=num1;
	
}
  | NOMBRE MOINS NOMBRE { char num1[100],num2[100],final[100];
	sprintf(num1,"%d",$1);
	sprintf(num2,"%d",$3);
	strcat(num1," - ");
	strcat(num1,num2);
	strcat(num1,";\n");
	$$=num1;}
  | VARIABLE PLUS NOMBRE {
   char num1[100],final[100];
  	strcpy(final,$1);
	sprintf(num1,"%d",$3);
	strcat(final," + ");
	strcat(final,num1);
	strcat(final,";\n");
	$$=final;
}
  | VARIABLE MOINS NOMBRE { char num1[100],final[100];
  	strcpy(final,$1);
	sprintf(num1,"%d",$3);
	strcat(final," - ");
	strcat(final,num1);
	strcat(final,";\n");
	$$=final;}
  | NOMBRE PLUS VARIABLE { char num1[100],final[100];
  	strcpy(final,$3);
	sprintf(num1,"%d",$1);
	strcat(num1," + ");
	strcat(num1,final);
	strcat(num1,";\n");
	$$=num1;}
  | NOMBRE MOINS VARIABLE { char num1[100],final[100];
  	strcpy(final,$3);
	sprintf(num1,"%d",$1);
	strcat(num1," - ");
	strcat(num1,final);
	strcat(num1,";\n");
	$$=num1;}
  ;
Affectation: VARIABLE AFFECTATION Operation {char var1[100];char op[100];
	strcpy(op,$3);
  	strcpy(var1,$1);
	strcat(var1,"=");
	strcat(var1,op);
	$$=var1;}
  |VARIABLE AFFECTATION VARIABLE {char var1[100],var2[100];
  	strcpy(var1,$1);
  	strcpy(var2,$3);
	strcat(var1,"=");
	strcat(var1,var2);
	strcat(var1,";\n");
	$$=var1;}
  |VARIABLE AFFECTATION NOMBRE {char var1[100],num1[100];
  	strcpy(var1,$1);
	sprintf(num1,"%d",$3);
	strcat(var1,"=");
	strcat(var1,num1);
	strcat(var1,";\n");
	$$=var1;}
  ;

Declarations: Declaration Declarations {}
  |
  ;
Declaration: VARIABLE VIRGULE Declaration{strcat(decla,",");
strcat(decla,$1);

}
  | VARIABLE DEUXPOINTS ENTIER{strcat(decla,$1);
  strcpy(type,"int");
  }
  ;
Boucle: POUR VARIABLE ALLANT DE NOMBRE A NOMBRE FAIRE FIN InstructionsFor FINPOUR {
if($5>$7)
	printf("for(%s=%d;%s>%d;%s--){\n%s}",$2,$5,$2,$7,$2,listInstructionFor);

else
	printf("for(%s=%d;%s<%d;%s++){\n%s}",$2,$5,$2,$7,$2,listInstructionFor);

}

ConditionSi: SI VARIABLE PLUSPETIT NOMBRE FAIRE FIN InstructionsSi ConditionSinon FINSI{
		if($8!=NULL)
			printf("if(%s<%d){\n%s}else{\n%s}",$2,$4,listInstructionSi,$8);
		else
			 printf("if(%s<%d){\n%s}",$2,$4,listInstructionSi);
}
  | SI VARIABLE PLUSGRAND NOMBRE FAIRE FIN InstructionsSi ConditionSinon FINSI{
  		if($8!=NULL)
  			printf("if(%s<%d){\n%s}else{\n%s}",$2,$4,listInstructionSi,$8);
  		else
 			printf("if(%s<%d){\n%s}",$2,$4,listInstructionSi);}

  | SI VARIABLE PLUSPETITEGALE NOMBRE FAIRE FIN InstructionsSi ConditionSinon FINSI{
  		if($8!=NULL)
  			printf("if(%s<=%d){\n%s}else{\n%s}",$2,$4,listInstructionSi,$8);
  		else
 			printf("if(%s<=%d){\n%s}",$2,$4,listInstructionSi);}
  | SI VARIABLE PLUSGRANDEGALE NOMBRE FAIRE FIN InstructionsSi ConditionSinon FINSI{
   		if($8!=NULL)
  			printf("if(%s>=%d){\n%s}else{\n%s}",$2,$4,listInstructionSi,$8);
  		else
 			printf("if(%s>=%d){\n%s}",$2,$4,listInstructionSi);}
  | SI VARIABLE PLUSGRAND VARIABLE FAIRE FIN InstructionsSi ConditionSinon FINSI{
  		if($8!=NULL)
  			printf("if(%s>%s){\n%s}else{\n%s}",$2,$4,listInstructionSi,$8);
  		else
 			printf("if(%s>%s){\n%s}",$2,$4,listInstructionSi);}
  | SI VARIABLE PLUSPETITEGALE VARIABLE FAIRE FIN InstructionsSi ConditionSinon FINSI{
  		if($8!=NULL)
  			printf("if(%s<=%s){\n%s}else{\n%s}",$2,$4,listInstructionSi,$8);
  		else
 			printf("if(%s<=%s){\n%s}",$2,$4,listInstructionSi);}
  | SI VARIABLE PLUSGRANDEGALE VARIABLE FAIRE FIN InstructionsSi ConditionSinon FINSI{
  		if($8!=NULL)
  			printf("if(%s>=%s){\n%s}else{\n%s}",$2,$4,listInstructionSi,$8);
 		 else
 			printf("if(%s>=%s){\n%s}",$2,$4,listInstructionSi);}
  | SI VARIABLE PLUSPETIT VARIABLE FAIRE FIN InstructionsSi ConditionSinon FINSI{
  		if($8!=NULL)
  			printf("if(%s<%s){\n%s}else{\n%s}",$2,$4,listInstructionSi,$8);
 		 else
 			printf("if(%s<%s){\n%s}",$2,$4,listInstructionSi);
 			}
  ;
ConditionSinon: SINON FAIRE FIN Instruction FIN {$$=$4;}
  | {$$=NULL;}
  ;

%%


void yyerror(char *s) { printf("%s\n", s);}


int main(void)
{
  yyin = fopen("prog.txt", "r");
  yyparse();
  fclose(yyin);
  return 0;
}
