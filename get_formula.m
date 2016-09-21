function get_formula(handles,formula,verbose)
if nargin<3
    verbose=0;
end
global S
if strcmp(S.datamode,'vol')==1
        d='_';
    else
        d='';
    end
formula=strtrim(formula);
formula = regexprep(formula,'\*','.\*')
formula = regexprep(formula,'/','./')
formula = regexprep(formula,'\^','.\^')
for i=1:length(S.cfg.unit_value)
formula = regexprep(formula,S.cfg.unit_name{i},num2str(S.cfg.unit_value{i}));
end    
if verbose==1; disp(formula);end
fields=get(handles.list_,'String');

if verbose==1; disp(fields);end

formula0=formula;
formula_=formula;
S.formula=formula;
for i=1:length(fields)
newfield=['S.dat' S.datamode '.' fields{i}];
formula0 = regexprep(formula0,fields{i},newfield);
newfield=['S.dat' S.datamode '.' fields{i} '_'];
formula_ = regexprep(formula_,fields{i},newfield);
end
if verbose==1; disp(formula);end

S.err_formula=0;
try
   if strcmp(S.datamode,'vol')==1
eval(['S.dat' S.datamode '.formula_' '=' formula_ ';']);
   end
eval(['S.dat' S.datamode '.formula'  '=' formula0 ';']);
catch ME
    disp('Formula is not valid. Try again...');S.err_formula=1;
end

