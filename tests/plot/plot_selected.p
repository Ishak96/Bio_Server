set key autotitle columnhead
set xrange [0:3500]
set yrange [0:120]
set xlabel "time (s)" font "Helvetica, 12"
set ylabel "% usage of cores" font "Helvetica, 12"
set title "CPU usage of glyphosate and dioxine server's" font "Helvetica, 15"
set terminal png size 3000,1500;
set output 'core_dioxine_glyphosate_cpu.png'
do for [i=1:3] {
    set style line i linewidth 3
}
plot for[n=2:3] 'data_physicat_glyphosate_dioxine.dat' u 1:n with lines