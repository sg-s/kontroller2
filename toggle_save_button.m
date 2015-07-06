% toggle_save_button.m
% this m file is called when you press the save button in the manual
% control tab
% it has two tasks:
% 1. switch the label of the save button so that you know
% that it's saving
% 2.  opens a binary dump file to stream the data that we grab from the DAQ
% device. 
function [] = toggle_save_button(src,~)

global handles
if strcmp(get(src,'String'),'Save')
    set(src,'String','Saving...')
    binary_dump_handle = fopen('dump.bin','w');
    setappdata(handles.f1,'binary_dump_handle',binary_dump_handle);
elseif strcmp(get(src,'String'),'Saving...')
    set(src,'String','Save')
    binary_dump_handle = getappdata(handles.f1,'binary_dump_handle');
    fclose(binary_dump_handle);
    binary_dump_handle = [];
    setappdata(handles.f1,'binary_dump_handle',binary_dump_handle);
    
    % now extract the dump and re-save it into a nice .mat file
    dump2mat(get(handles.InputChannelsList,'String'),getappdata(handles.f1,'PathName'),getappdata(handles.f1,'FileName'));
    
else
    error('toggle_save_button was called by an unexpected function')
end