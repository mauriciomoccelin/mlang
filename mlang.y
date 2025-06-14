%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Symbol table
typedef struct {
    char* name;
    int value;
} Symbol;

Symbol symbols[100];
int sym_count = 0;

int lookup(char* id) {
    for (int i = 0; i < sym_count; i++) {
        if (strcmp(symbols[i].name, id) == 0) {
            return symbols[i].value;
        }
    }
    return 0; // Default value if not found
}

void yyerror(const char *s);
int yylex();
%}

%union {
    int num;
    char* str;
}

%type <num> expr

%token <str> ID
%token <num> NUMBER
%token IF THEN ELSE EQ GT LT PLUS MINUS MUL DIV PRINT

%left GT LT
%left MUL DIV
%left PLUS MINUS
%token FOR TO

%define parse.error verbose

%precedence THEN

%%
program:
    | program statement
    ;

statement:
    ID EQ expr ';'          { 
        // Store variable in the symbol table
        symbols[sym_count].name = strdup($1);
        symbols[sym_count].value = $3;
        sym_count++;
        printf("Assignment: %s = %d\n", $1, $3); 
    }
    | IF expr THEN statement %prec THEN { 
        if ($2) printf("Condition is true\n"); 
        else printf("Condition is false\n");
    }
    | FOR ID EQ expr TO expr THEN statement {
        // Initialize loop variable
        int start = $4;
        int end = $6;
        char* var = strdup($2);

        for (int i = start; i <= end; i++) {
            // Update or add the variable to the symbol table
            int found = 0;
            for (int j = 0; j < sym_count; j++) {
                if (strcmp(symbols[j].name, var) == 0) {
                    symbols[j].value = i;
                    found = 1;
                    break;
                }
            }
            if (!found && sym_count < 100) {
                symbols[sym_count].name = strdup(var);
                symbols[sym_count].value = i;
                sym_count++;
            }

            // Execute the loop body
            printf("[FOR] %s = %d\n", var, i);
            yyparse();
        }
        free(var);
    }
    | PRINT expr ';'         { printf("Print: %d\n", $2); }
    ;

expr:
    NUMBER                   { $$ = $1; }
    | ID                     { $$ = lookup($1); }
    | expr PLUS expr         { $$ = $1 + $3; }
    | expr MINUS expr        { $$ = $1 - $3; }
    | expr MUL expr          { $$ = $1 * $3; }
    | expr DIV expr          { $$ = $1 / $3; }
    | expr GT expr           { $$ = $1 > $3; }
    | expr LT expr           { $$ = $1 < $3; }
    | '(' expr ')'           { $$ = $2; }
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}
