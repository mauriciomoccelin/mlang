# mlang

A minimal interpreted language created for learning compiler design, inspired by principles from classic compiler books. Includes a lexer, parser, expression evaluation, conditionals, and basic control flow. Built with Flex and Bison.

## Create an file

```c
// test.ml
# Variable assignment
x = 10;
y = 2;

# Arithmetic operations
z = x + y * 3;

# Conditional
if z > 15 then print z;

# For loop from 1 to 5
for i = 1 to 5 then print i;
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