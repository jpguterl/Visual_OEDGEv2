function dat=read_vol_bgp(casename,folder,verbose)
%read_poly_bgp(casename,folder,verbose)
%by J.Guterl Sept 2016
if nargin<1
    error('casename required');
end
if nargin<2
    folder='.';
    verbose=0;
end
if strcmp(folder,'')==1
    folder='.';
end
if nargin<3
verbose=0;
end

filename=[folder '/' casename '.vol_bgp.dat'];
if verbose==1;disp(['Opening the file ' filename]);end;
if exist(filename)==0
  error(['cannot open the file ' filename]);  
end
[fid,message]=fopen(filename,'r');
disp(message);
%skip 2 first line and get Nring and irsep
fgetl(fid);
fgetl(fid);
tmp= fscanf(fid,'%d %d');Nring=tmp(1);Irsep=tmp(2);Irwall=tmp(3);
dat.Nring=Nring;
dat.Irsep=Irsep;
dat.Irwall=Irwall
dat.casename=casename;
if verbose==1;disp(['Nring=' num2str(Nring)]);end
if verbose==1;disp(['Irsep=' num2str(Irsep)]);end
if verbose==1;disp(['Irwall=' num2str(Irwall)]);end
%skip line
fgetl(fid);
fmt='%d';
for i=1:Nring-1
    fmt=[fmt ' %d'];
end
tmp=textscan(fid,fmt,1);
Ncell=cell2mat(tmp);
dat.Ncell=Ncell;
if verbose==1;disp(['Ncell=' num2str(Ncell)]);end
fmt='%s';
for i=1:50
    fmt=[fmt '%s'];
end

head = textscan(fid,fmt,1);
for i=1:length(head)
    
    if isempty(cell2mat((head{i})))==1
        break
    end
    Ncol=i;
end
if verbose==1;disp(['Ncol=' num2str(Ncol)] ); end 
fmt='%f';
for i=1:Ncol-1
    fmt=[fmt ' %f'];
end
dat_=textscan(fid,fmt);
data=cell2mat(dat_);

for j=1:Ncol
field=cell2mat(head{j});
  if verbose==1;disp(field);end
  if strcmp(field,'cotanalpha')==1
      field='alpha';
      tmpdata=atan(1./data(:,j))*180/pi;
 eval(['dat.' field '=tmpdata;']);
  else
     eval(['dat.' field '=data(:,' num2str(j) ');']);  
  end
end
%reshape some fields

dat=reshape_field(dat);
fclose(fid);
disp('Volume data loaded ...');
end