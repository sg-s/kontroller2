% saveCallback
% determines which mat file to save data to
% this function is called when you click on anything in the save tab in the
% main window
% its job is to pick a file to stream data to
% part of kontroller2

function [] = saveCallback(src,~)
global handles
if src == handles.SaveButton
    [FileName,PathName] = uiputfile('c:\data\');
    setappdata(handles.f1,'FileName',FileName);
    setappdata(handles.f1,'PathName',PathName);
    if ~isempty(FileName)
        set(handles.SaveEdit,'string',FileName);
        set(handles.MCSaveButton,'Enable','on')
    else
        set(handles.SaveEdit,'string','No file chosen.');
        set(handles.MCSaveButton,'Enable','off')
    end
    
    % reset the save_index  to 0
    setappdata(handles.f1,'save_index',0);
elseif src == handles.SaveEdit
    FileName = get(src,'String');
    setappdata(handles.f1,'FileName',FileName);
    if ~isempty(FileName)
        set(handles.MCSaveButton,'Enable','on');
        PathName = 'c:\data\';
    end
    
    % reset the save_index  to 0
    setappdata(handles.f1,'save_index',0);
else
    error('save_callback was called from an illegal source')
end