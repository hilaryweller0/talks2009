ncedit compday.134.225.1.161.309.2.50.19.nc

2 Nov 2008

makecpt -C$GMTU/colours/white_blue_red -T0/30/2 -D -Z > ppt.cpt
grdimage compday.134.225.1.161.309.2.50.19.nc -JQ0/18c -Rd \
         -Cppt.cpt -K > ppt.eps
pscoast -J -R -Dc -W -Bf0 -K -O >> ppt.eps
psscale -D9/-0.2/17/0.3h -Cppt.cpt -Ef -S -O >> ppt.eps

convert -density 100% -trim ppt.eps ppt.png
