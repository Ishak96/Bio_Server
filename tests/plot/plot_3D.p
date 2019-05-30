set key off
set title "3D CPU usage and power consumption by time" font "Helvetica, 15"
set terminal png size 3000,1500;
set output '3D_charge_consommation.png'

splot 'xyz.dat' using 1:2:3 w l
