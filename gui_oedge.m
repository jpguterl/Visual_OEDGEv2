function varargout = gui_oedge(varargin)
global S
S.error=0;

S.list_colormap=[{'parula','jet','hsv','hot','cool','spring','summer','autumn','winter','gray','bone','copper'	,'pink'	,'lines'	,'colorcube','prism','flag','white'}];
% GUI_OEDGE MATLAB code for gui_oedge.fig
%      GUI_OEDGE, by itself, creates a new GUI_OEDGE or raises the existing
%      singleton*.
%
%      H = GUI_OEDGE returns the handle to a new GUI_OEDGE or the handle to
%      the existing singleton*.
%
%      GUI_OEDGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_OEDGE.M with the given input arguments.
%
%      GUI_OEDGE('Property','Value',...) creates a new GUI_OEDGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_oedge_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_oedge_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_oedge

% Last Modified by GUIDE v2.5 20-Sep-2016 15:54:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_oedge_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_oedge_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before gui_oedge is made visible.
function gui_oedge_OpeningFcn(hObject, eventdata, handles, varargin)
global S
handles.output = hObject;

guidata(hObject, handles);
S.fig_gui=hObject

% UIWAIT makes gui_oedge wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_oedge_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;



function casename__Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.

function casename__CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function folder__Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function folder__CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_.
function handles=load__Callback(hObject, eventdata, handles)
global S

if S.error==0
S.casename=get(handles.casename_,'String');
S.folder=get(handles.folder_,'String');
load_config(S.configfile);
load_table(handles);
set(handles.pm_exp_,'String',S.cfg.expression);
load_data_code();

if isempty(S.filename_err)~=1
    set(handles.status_,'String',['Data cannot be loaded from: ' S.filename_err],'ForegroundColor','r');
else
%list_field(S.datvol)
set(handles.status_,'String','Data loaded','ForegroundColor',[0 .5 0] );
update_pm_datatype(handles);
s=get(handles.pm_datatype_,'String');
S.datamode=s{get(handles.pm_datatype_,'Value')}
update_list(handles);   
end
end



% --- Executes on button press in plot_.
function plot__Callback(hObject, eventdata, handles)
global S

S.newfig=get(handles.new_fig_,'Value');
S.logscale=get(handles.logscale_,'Value');

S.limits=get(handles.limits_,'Value');
S.color_map=S.list_colormap{get(handles.popupmenu1,'Value')};
S.plot_type=get(get(handles.bg_plot_,'SelectedObject'),'Value')
if (S.limits==1)
    S.lim=[str2num(get(handles.min_,'String')) str2num(get(handles.max_,'String'))];
else
   S.lim=[];
end



S.limplots=get(handles.lim_plots_,'Value');
if (S.limplots==1)
    S.srange=[str2num(get(handles.smin_,'String')) str2num(get(handles.smax_,'String'))];
else
   S.srange=[];
end


S.level=get(handles.level_on_,'Value'); 
if (S.level==1)
    S.level=[num2str(get(handles.level_,'String'))];
else
   S.level=[];
end   



%get value of list
str=get(handles.list_,'String');
%check how many fields are requested    
value_list=get(handles.list_,'Value');
    

%if not selection, skip everything
if isempty(find(value_list>0))~=1

%index in list of required qqt to plot
list_idx=value_list(find(value_list>0));
str=get(handles.list_,'String');
iplot=1;
disp(length(list_idx));
if S.newfig==0
clf;
end
for m=1:length(list_idx)
%get the field in field    
S.field=str{list_idx(m)};
disp(S.field);

if S.newfig==1
figure;
else
    
    N=length(list_idx)
    Nr=ceil(sqrt(N));nCols=Nr;nRows=Nr;
%     [blx, bly] = meshgrid( 0.05:0.9/nCols:0.9, 0.05:0.9/nRows:0.9 ) ;    
% hAxes = arrayfun( @(x,y) axes( 'Position', [x, y, 0.9*0.9/nCols, 0.8*0.9/nRows] ), blx, bly, 'UniformOutput', false ) ;
% axes( hAxes{m})
%gca
subplot(Nr,Nr,iplot);
iplot=iplot+1;
end
get_irings(handles);
get_plots(handles);
if strcmp(S.datamode,'vol')
    if get(handles.rb_plot_selected_,'Value')==1
    if get(handles.rb_plot2D_,'Value')==1
        disp('Plotting in 2D');
        plot_bgplasma(S.datvol,S.field,S.logscale,S.lim,S.level,S.color_map);
    elseif get(handles.rb_plots_,'Value')==1
        disp(['Plotting along Bfield for region' S.whichregion]);
        plot_bgplasma_line(S.datvol,S.field,S.iring,S.whichregion,S.group,S.srange,S.logscale)
    end
    else %formula
        formula=get(handles.formula_,'String');
        get_formula(handles,formula,0);
        try
        s=['exp =' S.formula];
        set(handles.formula_out_,'String',s);
        catch ME
        end
        if S.err_formula==0
        if get(handles.rb_plot2D_,'Value')==1
 plot_bgplasma(S.datvol,'formula',S.logscale,S.lim,S.level,S.color_map);
 gcf;title(['casename:' S.casename '; formula:' formula]);
    elseif get(handles.rb_plots_,'Value')==1
        disp(['Plotting along Bfield for region' S.whichregion]);
        plot_bgplasma_line(S.datvol,'formula',S.iring,S.whichregion,S.group,S.srange,S.logscale)
        end 
        end
    end       
end

end
% F=gcf;
% ax=F.Children;
% for m=1:length(ax)
% if isempty(ax(m).Title.String)==1 && strcmp(ax(m).Type,'colorbar')~=1
%     delete(ax(m));
% end
% end
end

% --- Executes on button press in new_fig_.
function new_fig__Callback(hObject, eventdata, handles)

% --- Executes on selection change in list_.
function list__Callback(hObject, eventdata, handles)

str=get(handles.list_,'String');
val=get(handles.list_,'Value');

disp(str)
disp(val)


% --- Executes during object creation, after setting all properties.
function list__CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function bg__CreateFcn(hObject, eventdata, handles)
global S;


function bg__SelectionChangeFcn(hObject, eventdata,handles)
global S


function update_list(handles)
global S
% Get Tag of selected object
    for i=1:length(S.cfg.dataplot)
        S.cfg.dataplot{i};
    if strcmp(S.datamode,S.cfg.dataplot{i})==1
        eval(['out=list_field(S.dat' S.cfg.dataplot{i} ');']);
        out
        set(handles.list_,'String',out);
    end
    end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global S
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S.newfig=get(handles.new_fig_,'Value');
if isfield(S,'datpol')
display_mesh(S.datpol,S.newfig);
else
    msgbox('Load data before plotting them...')
end



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global S
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
get_irings(handles) 
 display_ring(S.datvol,S.iring,S.whichregion,S.newfig)

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in logscale_.
function logscale__Callback(hObject, eventdata, handles)
% hObject    handle to logscale_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of logscale_


% --- Executes on button press in limits_.
function limits__Callback(hObject, eventdata, handles)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
global S
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',S.list_colormap);



% --- Executes during object creation, after setting all properties.
function min__CreateFcn(hObject, eventdata, handles)

%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','0');



% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function max__CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','1');

% --- Executes during object creation, after setting all properties.
function formula__CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function rb_plot_selected__CreateFcn(hObject, eventdata, handles)
global S;
S.plot_type=1;
set(hObject,'Value',1);




% --- Executes during object creation, after setting all properties.
function rb_plot_formula__CreateFcn(hObject, eventdata, handles)
global S;
set(hObject,'Value',0);



function level__Callback(hObject, eventdata, handles)
% hObject    handle to level_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of level_ as text
%        str2double(get(hObject,'String')) returns contents of level_ as a double


% --- Executes during object creation, after setting all properties.
function level__CreateFcn(hObject, eventdata, handles)
% hObject    handle to level_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in level_on_.
function level_on__Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function rb_vol__CreateFcn(hObject, eventdata, handles)
global S
set(hObject,'Value',1);
S.datamode='vol';

% --- Executes during object creation, after setting all properties.
function rb_target__CreateFcn(hObject, ~, handles)
set(hObject,'Value',0);


% --- Executes on button press in rb_target_.
% function rb_target__Callback(hObject, eventdata, handles)
% global S
% S.datamode='tar';
% set(handles.rb_vol_,'Value',0);
% update_list(handles);
% 
% % Hint: get(hObject,'Value') returns toggle state of rb_target_
% 
% 
% % --- Executes on button press in rb_vol_.
% function rb_vol__Callback(hObject, eventdata, handles)
% global S
% S.datamode='vol';
% set(handles.rb_target_,'Value',0);
% update_list(handles);


% --- Executes on button press in all_ring_.
function all_ring__Callback(hObject, eventdata, handles)
% hObject    handle to all_ring_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of all_ring_


% --- Executes during object creation, after setting all properties.
function all_ring__CreateFcn(hObject, eventdata, handles)
% hObject    handle to all_ring_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',1);


% --- Executes on button press in cbSOL_.
function cbSOL__Callback(hObject, eventdata, handles)
% hObject    handle to cbSOL_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbSOL_
set(handles.cbPFR_,'Value',0);
set(handles.cball_,'Value',0);
set(handles.cbCORE_,'Value',0);
set(handles.cbring_,'Value',0);

% --- Executes on button press in cbCORE_.
function cbCORE__Callback(hObject, eventdata, handles)
% hObject    handle to cbCORE_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.cbSOL_,'Value',0);
set(handles.cball_,'Value',0);
set(handles.cbPFR_,'Value',0);
set(handles.cbring_,'Value',0);
% Hint: get(hObject,'Value') returns toggle state of cbCORE_


% --- Executes on button press in cbPFR_.
function cbPFR__Callback(hObject, eventdata, handles)
% hObject    handle to cbPFR_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbPFR_
set(handles.cbSOL_,'Value',0);
set(handles.cball_,'Value',0);
set(handles.cbCORE_,'Value',0);
set(handles.cbring_,'Value',0);
% --- Executes during object creation, after setting all properties.
function cball__CreateFcn(hObject, eventdata, handles)
% hObject    handle to cball_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',1);


% --- Executes on button press in cball_.
function cball__Callback(hObject, eventdata, handles)
% hObject    handle to cball_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cball_
set(handles.cbring_,'Value',0);
set(handles.cbSOL_,'Value',0);
set(handles.cbPFR_,'Value',0);
set(handles.cbCORE_,'Value',0);


% --- Executes on button press in cbring_.
function cbring__Callback(hObject, eventdata, handles)
% hObject    handle to cbring_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbring_
set(handles.cball_,'Value',0);
set(handles.cbSOL_,'Value',0);
set(handles.cbPFR_,'Value',0);
set(handles.cbCORE_,'Value',0);

% --- Executes during object creation, after setting all properties.
function cbring__CreateFcn(hObject, eventdata, handles)
% hObject    handle to cbring_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function imin__Callback(hObject, eventdata, handles)
% hObject    handle to imin_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imin_ as text
%        str2double(get(hObject,'String')) returns contents of imin_ as a double


% --- Executes during object creation, after setting all properties.
function imin__CreateFcn(hObject, eventdata, handles)
% hObject    handle to imin_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imax__Callback(hObject, eventdata, handles)
% hObject    handle to imax_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imax_ as text
%        str2double(get(hObject,'String')) returns contents of imax_ as a double


% --- Executes during object creation, after setting all properties.
function imax__CreateFcn(hObject, eventdata, handles)
% hObject    handle to imax_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function get_irings(handles)
global S
s1=get(handles.cbSOL_,'Value');
s5=get(handles.cball_,'Value');
s3=get(handles.cbCORE_,'Value');
s4=get(handles.cbring_,'Value');
s2=get(handles.cbPFR_,'Value');
S.newfig=get(handles.new_fig_,'Value');
if s1==1
    S.whichregion=1;
    S.iring=[];
elseif s2==1
    S.whichregion=2;
    S.iring=[];
elseif s3==1
    S.whichregion=3;
    S.iring=[];
elseif s4==1
    S.whichregion=0;
    S.iring=[str2num(get(handles.imin_,'String')) str2num(get(handles.imax_,'String'))];
    if isfield(S,'datvol')==1
    if str2num(get(handles.imin_,'String'))<0
        set(handles.imin_,'String','0');
    end
    if str2num(get(handles.imax_,'String'))>S.datvol.Nring
        set(handles.imax_,'String',num2str(S.datvol.Nring));
    end  
    S.iring=[str2num(get(handles.imin_,'String')) str2num(get(handles.imax_,'String'))];
    end
elseif s5==1
    S.whichregion=0;
    S.iring=[];
else
   S.whichregion=0;
    S.iring=[]; 
end  
disp(['Selection for iring region is ', num2str(S.whichregion)])
disp(['Selection for iring value is ', num2str(S.iring)])

function get_plots(handles)
global S
s2=get(handles.cbunique_,'Value');
s1=get(handles.cbsubplot_,'Value');
s0=get(handles.cbsingle_,'Value');
S.newfig=get(handles.new_fig_,'Value');
if s0==1
    S.group=0;
elseif s1==1
    S.group=1;
elseif s2==1
    S.group=2;
else
   S.group=0; 
end


% --- Executes on button press in cbunique_.
function cbunique__Callback(hObject, eventdata, handles)
% hObject    handle to cbunique_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbunique_
set(handles.cbsubplot_,'Value',0);
set(handles.cbsingle_,'Value',0);

% --- Executes on button press in cbsingle_.
function cbsingle__Callback(hObject, eventdata, handles)
% hObject    handle to cbsingle_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbsingle_
set(handles.cbunique_,'Value',0);
set(handles.cbsubplot_,'Value',0);


% --- Executes on button press in cbsubplot_.
function cbsubplot__Callback(hObject, eventdata, handles)
% hObject    handle to cbsubplot_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbsubplot_

set(handles.cbunique_,'Value',0);
set(handles.cbsingle_,'Value',0);
% --- Executes on button press in lim_plots_.
function lim_plots__Callback(hObject, eventdata, handles)
% hObject    handle to lim_plots_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lim_plots_



function smin__Callback(hObject, eventdata, handles)
% hObject    handle to smin_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smin_ as text
%        str2double(get(hObject,'String')) returns contents of smin_ as a double


% --- Executes during object creation, after setting all properties.
function smin__CreateFcn(hObject, eventdata, handles)
% hObject    handle to smin_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function smax__Callback(hObject, eventdata, handles)
% hObject    handle to smax_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smax_ as text
%        str2double(get(hObject,'String')) returns contents of smax_ as a double


% --- Executes during object creation, after setting all properties.
function smax__CreateFcn(hObject, eventdata, handles)
% hObject    handle to smax_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function cbunique__CreateFcn(hObject, eventdata, handles)
% hObject    handle to cbunique_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',1);


% --------------------------------------------------------------------
function config__Callback(hObject, eventdata, handles)
% hObject    handle to config_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function config__CreateFcn(hObject, eventdata, handles)
% hObject    handle to config_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_config__Callback(hObject, eventdata, handles)
global S% hObject    handle to load_config_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,f] = uigetfile('*.ini', 'Pick a config file');
if f==1

S.configfile=[PathName FileName];
load_config(S.configfile);
load_table(handles);
set(handles.pm_exp_,'String',S.cfg.expression);
end
if S.error==1
set(handles.config_text_,['Cannot open:' PathName FileName],'ForegroundColor','r')
else
set(handles.config_text_,'String',[PathName FileName],'ForegroundColor',[0 0.5 0]);
end
% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function config_text__CreateFcn(hObject, eventdata, handles)
global S
folder=pwd;
set(hObject,'String',[ folder '/config.ini']);
S.configfile=[ folder '/config.ini'];

load_config(S.configfile);

if S.error==1
set(hObject,'String',['Cannot open:' folder '/config.ini'],'ForegroundColor','r')
else
set(hObject,'String',[folder '/config.ini'],'ForegroundColor',[0 0.5 0]);
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder=uigetdir();
if isempty(folder)~=1
    set(handles.folder_,'String',folder);
end

% --- Executes during object creation, after setting all properties.
function pushbutton8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
  % Convert indexed image and colormap to truecolor
%load icon.mat
%set(hObject,'Cdata',icon);


% --- Executes on selection change in pm_datatype_.
function pm_datatype__Callback(hObject, eventdata, handles)
global S
s=get(handles.pm_datatype_,'String');
S.datamode=s{get(handles.pm_datatype_,'Value')}
update_list(handles);  

% --- Executes during object creation, after setting all properties.
function pm_datatype__CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_datatype_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, ~, handles)
global S

close(S.fig_gui);clear global S;


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
global S;
display_separatrix(S.datvol);


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function formula__Callback(hObject, eventdata, handles)
%% 
try
        s=['exp =' S.formula];
        set(handles.formula_out_,'String',s);
        catch ME
        end
set(handles.rb_plot_formula_,'Value',1);
set(handles.rb_plot_selected_,'Value',0);
%% 


% --- Executes on selection change in pm_exp_.
function pm_exp__Callback(hObject, eventdata, handles)
global S
v=get(hObject,'Value');
set(handles.formula_,'String',S.cfg.expression{v});
set(handles.rb_plot_formula_,'Value',1);
set(handles.rb_plot_selected_,'Value',0);


% --- Executes during object creation, after setting all properties.
function pm_exp__CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_exp_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function load_config(configfile,verbose)
global S
S.cfg=[];

    fid=fopen(configfile)
if  fid==-1
    disp(['cannot open the config file' configfile]);
    S.error=1;
    return
end

if nargin<2
    verbose=0;
end
keyword{1}='datatype';
keyword{2}='dataplot';
keyword{3}='units';
keyword{4}='expression';
i=1;
while feof(fid)~=1
    str=strtrim(fgetl(fid));
    if regexp(str,'^[%$#]')==1
        %
    else
        if isempty(str)~=1
            string{i}=str;
            i=i+1;
        end
    end
end
Nk=length(keyword);
%load key word
S.cfg.keyword=keyword;
%find where keyword are
if verbose==1;
    string
end;
for k=1:Nk
    for i=1:length(string)
        if   strcmp(string{i},keyword{k})==1
            idx(k)=i;
            break;
        else
            idx(k)=-1;
        end
    end
end
% check if all keyword are found
ierr=find(idx==-1,1,'first');
if isempty(ierr)~=1
    error(['keyword entry missing in config file:' keyword{ierr}]);
end
%prepare index
for k=1:Nk
    istart=idx(k)+1;
    iend=istart;
    while iend<length(string)
        if isempty(find(idx==iend+1))~=1
            break;
        end
        iend=iend+1;
    end
index{k}=[istart:iend];
end
% for k=1:Nk
%     index{k}
% end
%let read the value
S.cfg.unit_value=[];
S.cfg.unit_name=[];
for k=1:Nk
    eval(['S.cfg.' keyword{k} '{1}=[];']);
end

for k=1:Nk

    % if not units
    if strcmp(keyword{k},'units')~=1
        for j=1:length(index{k})
            eval(['S.cfg.' keyword{k} '{' num2str(j) '}=string{' num2str(index{k}(j)) '};']);
        end
    if verbose==1;eval(['disp(S.cfg.' keyword{k} ');']);end    
    else
        for j=1:length(index{k})
            ind=index{k};
            C=strsplit(string{ind(j)},'=');
            eval(['S.cfg.unit_name{' num2str(j) '}=C{1};']);
            eval(['S.cfg.unit_value{' num2str(j) '}=C{2};']);
        end
    end
    
end

% plot
%string
if verbose==1;
    disp(S.cfg.unit_value)
disp(S.cfg.unit_name);
end

function load_data_code()
global S
S.filename_err=[];
for i=1:length(S.cfg.datatype)
str=S.cfg.datatype{i};
try
eval(['S.dat' str '=read_'  str '_bgp(S.casename,S.folder);']);
catch ME
    S.filename_err=[S.folder '/' S.casename '.' str '_bgp.dat'];
    disp(['issue with ' S.folder '/' S.casename '.' str '_bgp.dat'] );
    return
end 
end

function load_table(handles)
global S
for i=1:length(S.cfg.unit_name)
    s{i}=[S.cfg.unit_name{i} '    =   ' num2str(S.cfg.unit_value{i},'%1.4e') ];
  end
set(handles.text_unit_,'String',s);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over formula_.
function formula__ButtonDownFcn(hObject, eventdata, handles)
try
        s=['exp =' S.formula];
        set(handles.formula_out_,'String',s);
        catch ME
        end
set(handles.rb_plot_formula_,'Value',1);
set(handles.rb_plot_selected_,'Value',0);


% --- Executes on key press with focus on formula_ and none of its controls.
function formula__KeyPressFcn(hObject, eventdata, handles)
%% 
global S
try
        s=['exp =' S.formula];
        set(handles.formula_out_,'String',s);
        catch ME
        end
set(handles.rb_plot_formula_,'Value',1);
set(handles.rb_plot_selected_,'Value',0);
% hObject    handle to formula_ (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
