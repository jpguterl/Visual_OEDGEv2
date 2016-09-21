function update_pm_datatype(handles)
global S
for i=1:length(S.cfg.dataplot)
set(handles.pm_datatype_,'String',S.cfg.dataplot);
end