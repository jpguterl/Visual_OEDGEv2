function display_ring(dat_vol,iring,whichregion,newfig)
%display_ring(dat_vol,[iring](optional),whichregion=0(all)|1(SOL)|2(PFR)|3(CORE),newfig=0|1)
%by J.Guterl Sept 2016
if nargin<2
iring=1:dat_vol.Nring;
end
if isempty(iring)==1
iring=1:dat_vol.Nring;
end
if nargin<3
    whichregion=0;
end

if nargin<4
    newfig=0;
end

if whichregion>0
if whichregion==1 % SOL
    iring=dat_vol.Irsep:dat_vol.Irwall;
end
if whichregion==2
    iring=dat_vol.Irwall+1:dat_vol.Nring; %PFC
end
if whichregion==3
    iring=1:dat_vol.Irsep-1; %CORE
end
end
    if newfig==1
        figure;
        run d3dlim.m;
        plot(xlim_,ylim_,'k');
        hold on;
    end
    disp(['iring=' num2str(iring)]);




hold on;
for ir=iring
    x=dat_vol.R_(ir,1:dat_vol.Ncell(ir));
    y=dat_vol.Z_(ir,1:dat_vol.Ncell(ir));
    iring=y*0+ir;
plot3(x,y,iring,'r');hold on;


end
axis equal;
view([0,0,1])
end
