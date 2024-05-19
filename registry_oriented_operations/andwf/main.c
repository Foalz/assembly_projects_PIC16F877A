mkdir name && echo 'list p=16F877 \ninclude "p16f877.inc"\n;Write your code here\nEND' >> $_/main.asm
&& echo '\
  void main(){\
    return;\
  }' >> $_/main.c
