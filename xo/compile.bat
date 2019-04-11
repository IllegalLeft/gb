wla-gb -q -x -o main.o main.s
wla-gb -q -x -o interrupts.o interrupts.s
wla-gb -q -x -o graphics.o graphics.s
wla-gb -q -x -o strings.o strings.s
wla-gb -q -x -o songs.o songs.s
wla-gb -q -x -o music.o music.s
wlalink -S linkfile out.gb
pause
