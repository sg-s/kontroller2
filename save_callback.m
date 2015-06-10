% this function is called when you click on anything in the save tab in the
% main window
% its job is to pick a file to stream data to
% part of kontroller2

function [] = save_callback(src,~)
global handles
if src == handles.SaveButton
    [FileName,PathName] = uiputfile('c:\data\');
    setappdata(handles.f1,'FileName',FileName);
    setappdata(handles.f1,'PathName',PathName);
    if ~isempty(FileName)
        set(handles.SaveEdit,'string',FileName);
    else
        set(handles.SaveEdit,'string','No file chosen.');
    end
elseif src == handles.SaveEdit
    FileName = get(src,'String');
    setappdata(handles.f1,'FileName',FileName);
else
    error('save_callback was called from an illegal source')
end