set key autotitle columnhead

set xtics axis	
set ytics axis
set border 0
set grid back ls 12

set xrange [0:7500]
set yrange [0:33]
set tics font ",25"
set key font ",20"
set ytics 1
set xtics 300

set tics scale 3
set mxtics 5
set mytics 1

set lmargin 12

set xlabel "Time (S)" font "Helvetica, 30" offset 0,-3,0
set ylabel "Number of activated core" font "Helvetica, 30" offset -2,0,0

set title "The curves of inputs on (activation / desactivation) tests Dioxine server" font "Helvetica, 30"
set terminal png size 4000,1500;
set output 'input_dioxine_on_off.png'

plot 'input_dioxine_3.dat' using 1:3 title "input" w l lw 4