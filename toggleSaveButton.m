% toggleSaveButton.m
% callback when pressing the "save" button on the manual control tab
% 
% this m file is called when you press the save button in the manual
% control tab
% it has two tasks:
% 1. switch the label of the save button so that you know
% that it's saving
% 2.  opens a binary dump file to stream the data that we grab from the DAQ
% device. 
function [] = toggleSaveButton(src,~)

global handles
if strcmp(get(src,'String'),'Save')
    set(src,'String','Saving...')
    input_dump_handle = fopen('input.k2','W');
    setappdata(handles.f1,'input_dump_handle',input_dump_handle);
    output_dump_handle = fopen('output.k2','W');
    setappdata(handles.f1,'output_dump_handle',output_dump_handle);
elseif strcmp(get(src,'String'),'Saving...')
    set(src,'String','Save')
    
    % close the input dump file
    input_dump_handle = getappdata(handles.f1,'input_dump_handle');
    fclose(input_dump_handle);
    input_dump_handle = [];
    setappdata(handles.f1,'input_dump_handle',input_dump_handle);
    
    % close the output dump handle
    output_dump_handle = getappdata(handles.f1,'output_dump_handle');
    fclose(output_dump_handle);
    output_dump_handle = [];
    setappdata(handles.f1,'output_dump_handle',output_dump_handle);
    
    % now extract the dump and re-save it into a nice .mat file
    dump2mat;
    
else
    error('toggle_save_button was called by an unexpected function')
end