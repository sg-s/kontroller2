% inputConfigCallback
% callback on configuring input channels
% 
% created by Srinivas Gorur-Shandilya at 5:33 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = inputConfigCallback(src,~)
global handles
 
% update InputChannelNames
InputChannelNames = getappdata(handles.f1,'InputChannelNames');
InputChannelNames{find(handles.ConfigureInputs == src)} = get(src,'String');
setappdata(handles.f1,'InputChannelNames',InputChannelNames);
cache('InputChannelNames',[]);
cache('InputChannelNames',InputChannelNames);

% colour it green if it's ground
if strcmpi('Ground',get(src,'String'))
     set(src,'ForegroundColor',[0 1 0]);
end

% add to the list of input channels
temp = {};
for i = 1:length(InputChannelNames)
    if ~isempty(InputChannelNames{i})
        temp{end+1} = InputChannelNames{i};
    end
end
set(handles.InputChannelsList,'String',temp,'Value',1)

% reconfigure session
reconfigureSession;