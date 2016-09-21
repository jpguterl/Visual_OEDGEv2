function dat=read_pol_bgp(casename,folder,verbose)
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
    folder='.'
end
if nargin<3
verbose=0;
end
 
filename=[folder '/' casename '.pol_bgp.dat'];
if verbose==1;disp(['Opening the file ' filename]);end;
if exist(filename)==0
  error(['cannot open the file ' filename]); 
end
[fid,message]=fopen(filename,'r');
disp(message);
%skip 2 first line and get npolyp
fgetl(fid);
fgetl(fid);
npolyp = fscanf(fid,'%d');
dat.Npolygon=npolyp;
dat.casename=casename;
Nrow=npolyp;
if verbose==1;disp(['npolyp=' num2str(npolyp)]);end
%skip the header
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
 eval(['dat.' field '=data(:,' num2str(j) ');']);
end
 
 
 
fclose(fid);
disp('Polygon data loaded ...')
end