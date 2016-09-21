function field=list_field(dat,verbose)
if nargin<2
    verbose=0;
end
f=fieldnames(dat);
if verbose==1;disp(['Fields in alphabetical order: ']);end
q=1;
for i=1:length(f)
eval(['sz=size(dat.' f{i},');']);
eval(['testisnum=isnumeric(dat.' f{i} ');']);
if max(sz)>1 && isempty(regexp(f{i},'_$'))==1 && testisnum==1
field{q}=f{i};
q=q+1;
end
end
field=sort(field);
for q=1:length(field)
if verbose==1;disp(['   ' field{q}]);end
end
return
