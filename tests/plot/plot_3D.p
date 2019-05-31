set key off
set xrange [0:3000]
set yrange [125:160]
set zrange [0:110]
set tics font ", 25"
set key font ",20"
set ytics 10
set xtics 200
set ztics 10

set title "3D CPU usage and power consumption by time" font "Helvetica, 15"
set terminal png size 3000,1500;
set output '3D_charge_consommation.png'

splot 'xyz.dat' using 1:2:3 lw 4 title  "3D plot"
