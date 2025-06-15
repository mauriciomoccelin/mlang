%{
#include "mlang.tab.h"  // Bison file generated
%}

%%
[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }

"if"            { return IF; }
"then"          { return THEN; }
"else"          { return ELSE; }
"for"           { return FOR; }
"to"            { return TO; }
"def"           { return DEF; }
"print"         { return PRINT; }

"("             { return '('; }
")"             { return ')'; }
"{"             { return '{'; }
"}"             { return '}'; }
","             { return ','; }

">"             { return GT; }
"<"             { return LT; }
"="             { return EQ; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }

[ \t\r\n]+      ; // Ignore whitespace

.               { return yytext[0]; }
%%
