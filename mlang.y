%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
    return 0;
}

void yyerror(const char *s);
int yylex();
%}

%union {
    int num;
    char* str;
}

%token <str> ID
%token <num> NUMBER
%token IF THEN ELSE FOR TO DEF PRINT
%token EQ GT LT PLUS MINUS MUL DIV

%type <num> expr
%type <num> expr_list

%left GT LT
%left PLUS MINUS
%left MUL DIV

%define parse.error verbose
%start program

%%

program:
    statement_list
    ;

statement_list:
    /* empty */
    | statement_list statement
    ;

statement:
    ID EQ expr ';' {
        symbols[sym_count].name = strdup($1);
        symbols[sym_count].value = $3;
        sym_count++;
        printf("Assignment: %s = %d\n", $1, $3);
    }
    | IF expr THEN block {
        if ($2) printf("Condition is true\n");
        else printf("Condition is false\n");
    }
    | FOR ID EQ expr TO expr THEN block {
        char* var = strdup($2);
        for (int i = $4; i <= $6; i++) {
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
            printf("[FOR] %s = %d\n", var, i);
            // Ideal: execute a stored block
        }
        free(var);
    }
    | PRINT expr ';' { printf("Print: %d\n", $2); }
    | DEF ID '(' param_list ')' block {
        printf("Function '%s' declared (not stored).\n", $2);
    }
    | ID '(' expr_list ')' ';' {
        printf("Calling function '%s' with arguments (not yet executed).\n", $1);
    }
    ;

block:
    '{' statement_list '}'
    ;

param_list:
    /* empty */
    | ID
    | param_list ',' ID
    ;

expr_list:
    expr
    | expr_list ',' expr
    ;

expr:
    NUMBER               { $$ = $1; }
    | ID                { $$ = lookup($1); }
    | expr PLUS expr     { $$ = $1 + $3; }
    | expr MINUS expr    { $$ = $1 - $3; }
    | expr MUL expr      { $$ = $1 * $3; }
    | expr DIV expr      { $$ = $1 / $3; }
    | expr GT expr       { $$ = $1 > $3; }
    | expr LT expr       { $$ = $1 < $3; }
    | '(' expr ')'       { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}
