% toggle_save_button.m
% this m file is called when you press the save button in the manual
% control tab
% its sole job is to switch the label of the save button so that you know
% that it's saving
% it also increments the save_index by 1 every time it is pressed to save,
% so that we write subsequent acquitisons to different cell positions in
% the saved data
function [] = toggle_save_button(src,~)
global handles
if strcmp(get(src,'String'),'Save')
    set(src,'String','Saving...')
    save_index = getappdata(handles.f1,'save_index') + 1;
    setappdata(handles.f1,'save_index',save_index);
elseif strcmp(get(src,'String'),'Saving...')
    set(src,'String','Save')
else
    error('toggle_save_button was called by an unexpected function')
end