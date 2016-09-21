function plot_bgplasma(datvol,field_,logscale,limits,level,color_map)
%plot_bgplasma(datvol,[field1;field2],logscale=0(default)|1,[limcolorlow limcolorhigh](optional),level)
%by J.Guterl Sept 2016
if nargin<3
    logscale=0;
end
if nargin <2
    error('missing input arguments');
end
if nargin<3
    logscale=0;
end
if nargin<4
    limits=[];
end
if isempty(limits)==1
    limit_on=0;
else
    limit_on=1;
end
if nargin<5
    level_on=0;
end
if isempty(level)==1
    level_on=0;
end
if nargin<6
    color_map='bone';
end
Nfield=size(field_,1);
disp(['# fields called:' num2str(Nfield)]);
for p=1:Nfield
    field=field_(p,:);
    disp(['Plotting the field ''' field ''' ...']);
%load d3d contour
run d3dlim.m
%refine number of points for d3d contour
[xlim_,ylim_]=refine_d3dlim(xlim_,ylim_,1);
%find external boundary of simulations, including the wall
ir=datvol.Irwall;
 x=datvol.R_(ir,1:datvol.Ncell(ir));
    y=datvol.Z_(ir,1:datvol.Ncell(ir));
    d=(y(end)-ylim_).^2+(x(end)-xlim_).^2;
    idminwall=find(d==min(d));
    d=(y(1)-ylim_).^2+(x(1)-xlim_).^2;
    idmaxwall=find(d==min(d));
    if idmaxwall<idminwall
        disp('inverse');
        idmaxwall=length(xlim); %need to be debug....
    end
    ir=datvol.Irwall+1; %first surface in private flux region akak the known which intersects the wall
    xPFC=datvol.R_(ir,1:datvol.Ncell(ir));
    yPFC=datvol.Z_(ir,1:datvol.Ncell(ir));
    d=(yPFC(end)-ylim_).^2+(xPFC(end)-xlim_).^2;
    idminPFC=find(d==min(d));
    d=(yPFC(1)-ylim_).^2+(xPFC(1)-xlim_).^2;
    idmaxPFC=find(d==min(d));
    
    xlast=[x xlim_(idminwall:idminPFC)  xPFC  xlim_(idmaxPFC:idmaxwall)  x(1)];
    ylast=[y ylim_(idminwall:idminPFC)  yPFC  ylim_(idmaxPFC:idmaxwall) y(1)]; %PFC needs debug
    %find the internal boundary for simulation
    ir=1;
    xfirst=datvol.R_(ir,1:datvol.Ncell(ir));
    yfirst=datvol.Z_(ir,1:datvol.Ncell(ir));
    %figure;plot(xfirst,yfirst,xlast,ylast,'r');
    
    eval(['data=datvol.' field ';']);
    R=unique(datvol.R);
    Z=unique(datvol.Z);
    R=R(R>0);

%create interpolation function for the requested data
F = scatteredInterpolant(datvol.R,datvol.Z,data);
d=10;
[RR,ZZ] = meshgrid(R(1:d:end),Z(1:d:end));
data_ = F(RR,ZZ);
% verify if points are in the simulation domain. If not, put Nan value to
% data_
in=inpolygon(RR,ZZ,xlast,ylast);
iq=find(in==0);
    data_(iq)=NaN;
in=inpolygon(RR,ZZ,xfirst,yfirst);
iq=find(in==1);
    data_(iq)=NaN;
    
    
% finally plot the contour
%linear scale
if logscale==0
[C,h]=contourf(RR,ZZ,data_);colorbar;
shading flat;
eval(['colormap(' color_map ');']);  
if level_on==1
h.LevelStep=level;
end
h.LineStyle='none';
if limit_on
caxis([limits(1) limits(2)]);
end

%log10 
else
[C,h]=contourf(RR,ZZ,log10(abs(data_)));

if level_on==1
h.LevelStep=log10(level);
end;

h.LineStyle='none';
shading flat
if limit_on==1
range(1)=(limits(1));range(2)=(limits(2));
else
range=([(min(min(abs(data_)))) (max(max(abs(data_))))]);
end
caxis(log10([range(1) range(end)]));
c=logspace(log10(range(1)),log10(range(2)),6);
eval(['colormap(' color_map ');']);  

colorbar('FontSize',11,'YTick',log10(c),'YTickLabel',c);
end

hold on;
plot(xlast,ylast,'r');
plot(xfirst,yfirst,'r');
plot(xlim_,ylim_,'k');
title(['Case:' datvol.casename '; ' field]);
axis equal;
xlabel('R[m]');ylabel('Z[m]');

end
end