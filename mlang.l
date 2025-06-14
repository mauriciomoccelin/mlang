%{
#include "mlang.tab.h"  // Bison file generated
%}

%%
[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
"if"            { return IF; }
"then"          { return THEN; }
"for"           { return FOR; }
"to"            { return TO; }
"print"         { return PRINT; }
[a-zA-Z]+       { yylval.str = strdup(yytext); return ID; }
">"             { return GT; }
"<"             { return LT; }
"="             { return EQ; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }
[ \t\n]         ;  // Ignore spaces
.               { return yytext[0]; }
%%
