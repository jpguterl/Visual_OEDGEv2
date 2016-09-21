function dat_=reshape_field(dat,verbose)
%function dat_=reshape_field(dat,verbose)

if nargin<2
    verbose=0;
end
Nring=dat.Nring;
Ncell=dat.Ncell;
Nmax=max(Ncell);
dat_=dat;
field_ = fieldnames(dat);
for p=1:length(field_)
    field=field_{p};
    if verbose==1;disp(['Processing field ' field]);end
if isfield(dat,field)==1 && strcmp(field,'Nring')~=1 && strcmp(field,'Ncell')~=1 && strcmp(field,'Irsep')~=1 ...
           && strcmp(field,'Irwall')~=1 && strcmp(field,'casename')~=1 


eval(['tmp=dat.' field ';']);% field '=zeros(' num2str(Nmax) ',' num2str(Ncell) ');']);
array=zeros(Nring,Nmax);
q=1;
for ir=1:Nring
    for ik=1:Ncell(ir)
    array(ir,ik)=tmp(q);
    q=q+1;
    end
end

eval(['dat_.' field '_=array;']);%(dat. 'field' ',[' num2str(Nrow) ',' num2str(Ncol) ']);'])
else
if verbose ==1;warning(['skipping the field ' field]);end
end
end
end