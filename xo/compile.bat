wla-gb -q -x -o main.o main.s
wla-gb -q -x -o interrupts.o interrupts.s
wlalink -S linkfile out.gb
pause
