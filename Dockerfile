FROM ubuntu:latest

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends build-essential bison flex libfl-dev \
  && rm -rf /var/lib/apt/lists/*

COPY . /home
VOLUME /home
WORKDIR /home

RUN bison -d mlang.y
RUN flex mlang.l
RUN gcc lex.yy.c mlang.tab.c -o mlang_compiler -lfl

RUN chmod +x ./mlang_compiler
