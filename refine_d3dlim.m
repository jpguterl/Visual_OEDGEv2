function [x_,y_]=refine_d3dlim(xlim,ylim,N)
if nargin<3
    N=1;
end
for p=1:N
    q=1;
    for i=1:length(xlim)-1
    x_(q)=xlim(i);
    y_(q)=ylim(i);
    q=q+1;
    x_(q)=(xlim(i)+xlim(i+1))/2;
    y_(q)=(ylim(i)+ylim(i+1))/2;
    q=q+1;
    end
    x_(q)=xlim(end);
    y_(q)=ylim(end);
xlim=x_;
ylim=y_;
end
end