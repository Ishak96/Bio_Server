set key off

set grid back ls 12

set xrange [0:3000]
set yrange [125:160]
set zrange [0:65]
set tics font ", 25"
set key font ",20"
set ytics 5
set xtics 200
set ztics 10

set lmargin 12

set xlabel "Time (S)" font "Helvetica, 30" offset 0,-1,0
set ylabel "Power consumption (watts) " font "Helvetica, 30" offset 0,-4,0
set zlabel "Charge og the CPU's (%)" font "Helvetica, 30" offset -2,0,0 rotate by 90

set title "3D CPU usage (%), power consumption (watts) by time of Dioxine" font "Helvetica, 30"
set terminal png size 3000,1500;
set output '3D_charge_consommation.png'

splot 'xyz.dat' using 1:2:3 w l lw 4 title  "3D plot"
