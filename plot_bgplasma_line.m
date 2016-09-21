function plot_bgplasma_line(dat_vol,field,irings,whichregion,group,range,logscale)
%plot_bgplasma_line(dat_vol,field,[irings],group=0,range)
%group=0 new figure for each graph
%     =1 figure containing 12 subplots
%      =2 superposition on one figure;
%by J.Guterl Sept 2016
display(['Starting plotting along s']);
maxplot=12;
if nargin<2
    error('missing input arguments');
end
if nargin<3
    irings=[1:dat_vol.Nring];
end

Nring=dat_vol.Nring;

if nargin<4
    whichregion=0;
end

if isempty(irings)==1
if whichregion==1 % SOL
    irings=dat_vol.Irsep:dat_vol.Irwall;
elseif whichregion==2
    irings=dat_vol.Irwall+1:dat_vol.Nring; %PFC
elseif whichregion==3
    irings=1:dat_vol.Irsep-1; %CORE
else
    irings=[1:dat_vol.Nring];
end
end

if max(irings)>Nring || min(irings)<1
    error('Ring number are out of bound');
end
disp(['Plotting along s for region : ' ,num2str(whichregion)])
disp(['and irings : ' ,num2str(irings)])
if nargin<5
    group=0;
end
if nargin<6 
    range=[];
end
if isempty(range)~=1 && length(range)>1
    if range(1)==range(2)
        range=[];
    end
else
   range=[]; 
end
if nargin<7
    logscale=0;
end
Nplot=length(irings);
display(['Nplots =' num2str(Nplot) ]);
eval(['data=dat_vol.' field '_;']);
if group~=0
    figure;
end
iplot=1;


for ir=irings
if group==0
    figure;
end
idx=1:dat_vol.Ncell(ir);
if iplot>12
    iplot=1;
    figure;
end
if group==1
subplot(4,3,iplot)
end
if logscale==0
plot(dat_vol.s_(ir,idx),data(ir,idx),'DisplayName',['ir=' num2str(ir)]);hold on;
else
semilogy(dat_vol.s_(ir,idx),data(ir,idx),'DisplayName',['ir=' num2str(ir)]);hold on;
end
xlabel('s[m]');ylabel(field);legend('-DynamicLegend','Location','NorthEast');
    if isempty(range)~=1
        range
        xlim([range(1) range(2)]);
    end
if iplot==1
    title([dat_vol.casename, ', ir=' num2str(ir)]);
else
    title(['ir=' num2str(ir)]);
end
if group==1
iplot=iplot+1;
end
end


end
