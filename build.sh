bison -d mlang.y
flex mlang.l
gcc lex.yy.c mlang.tab.c -o mlang_compiler -lfl
