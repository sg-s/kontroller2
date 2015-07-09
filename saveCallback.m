% saveCallback
% determines which mat file to save data to
% this function is called when you click on anything in the save tab in the
% main window
% its job is to pick a file to stream data to
% part of kontroller2

function [] = saveCallback(src,~)
global handles
if src == handles.SaveButton
    [file_name,path_name] = uiputfile('c:\data\');
    setappdata(handles.f1,'file_name',file_name);
    setappdata(handles.f1,'path_name',path_name);
    if ~isempty(file_name)
        set(handles.SaveEdit,'string',file_name);
        set(handles.MCSaveButton,'Enable','on')
    else
        set(handles.SaveEdit,'string','No file chosen.');
        set(handles.MCSaveButton,'Enable','off')
    end
    
    % reset the save_index  to 0
    setappdata(handles.f1,'save_index',0);
elseif src == handles.SaveEdit
    file_name = get(src,'String');
    setappdata(handles.f1,'file_name',file_name);
    if ~isempty(file_name)
        set(handles.MCSaveButton,'Enable','on');
        path_name = 'c:\data\';
        setappdata(handles.f1,'path_name',path_name);
    end

    
else
    error('save_callback was called from an illegal source')
end