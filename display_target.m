function display_target(dat_tar,dat_vol,itarget,newfig)
%display_target(dat_target,dat_vol,[itarget](optional),whichregion=0(all)|1(SOL)|2(PFR)|3(CORE),newfig=0|1)

if nargin<3
itarget=1:dat_tar.Ntarget;
end
if isempty(itarget)==1
itarget=1:dat_tar.Ntarget;
end
if nargin<4
    newfig=0;
end

    if newfig==1
        figure;
    end
disp(['itarget=' num2str(itarget)]);
run d3dlim.m
plot(xlim_,ylim_,'k');
hold on;
iringsolPFR=[dat_vol.Irsep:dat_vol.Irwall dat_vol.Irwall+1:dat_vol.Nring];
for ir=iringsolPFR
    xin=dat_vol.R_(ir,1);
    yin=dat_vol.Z_(ir,1);
    xout=dat_vol.R_(ir,dat_vol.Ncell(ir));
    yout=dat_vol.Z_(ir,dat_vol.Ncell(ir));
    idin=dat_vol.itid_(ir,1);
    idout=dat_vol.otid_(ir,1);
    text(xin,yin,num2str(idin));
    text(xout,yout,num2str(idout));
end

end
