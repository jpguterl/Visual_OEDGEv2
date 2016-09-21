function display_mesh(dat_pol,newfig)
%display_mesh(dat_poly,newfig=0|1)
%by J.Guterl Sept 2016 
if nargin<2
    newfig=0;
end
disp(['Npolygon=' num2str(dat_pol.Npolygon)]);
    if newfig==1
        figure;
        run d3dlim.m
        plot(xlim_,ylim_);
        hold on;
    end
    
i=1:dat_pol.Npolygon;
x=[dat_pol.R1(i) dat_pol.R2(i) dat_pol.R3(i) dat_pol.R4(i) dat_pol.R1(i)]';
y=[dat_pol.Z1(i) dat_pol.Z2(i) dat_pol.Z3(i) dat_pol.Z4(i) dat_pol.Z1(i)]';
plot(x,y,'k');
hold on;
end
