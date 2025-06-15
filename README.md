# mlang

A minimal interpreted language created for learning compiler design, inspired by principles from classic compiler books. Includes a lexer, parser, expression evaluation, conditionals, and basic control flow. Built with Flex and Bison.

## Create an file

```c
// test.ml
x = 5;

if x > 0 then {
    print x;
    print x + 1;
}

for i = 1 to 3 then {
    print i;
    print i * i;
}

def add(a, b) {
    print a + b;
}

a = 2;
b = 3;
add(a, b);
```

> Remove comments before run.

## Build and Run
```bash
# Compile
docker buildx build -t mlang:latest .

# Run the interactive container bash
docker run -it mlang:latest bash

# Inside the container, run the compilador with the test.ml file
./mlang_compiler < test.ml
```