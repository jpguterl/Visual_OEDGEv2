function display_separatrix(dat_vol,color)
%display_separatrix(dat_vol,color)
%by J.Guterl Sept 2016
if nargin<2
    color='c';
end
hold on
 ir=dat_vol.Irsep;
    x=dat_vol.R_(ir,1:dat_vol.Ncell(ir));
    y=dat_vol.Z_(ir,1:dat_vol.Ncell(ir));
    iring=y*0+ir;
plot3(x,y,iring,color);
hold on;
view([0,0,1])
end
