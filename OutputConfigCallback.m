function [] = OutputConfigCallback(src,~)

global handles

% update OutputChannelNames
OutputChannelNames = getappdata(handles.f1,'OutputChannelNames');
OutputChannelNames{find(handles.ConfigureOutputs == src)} = get(src,'String');
setappdata(handles.f1,'OutputChannelNames',OutputChannelNames);
cache('OutputChannelNames',[]);
cache('OutputChannelNames',OutputChannelNames);

% colour it green if it's ground
if strcmpi('Ground',get(src,'String'))
     set(src,'ForegroundColor',[0 1 0]);
end

% add to the list of input channels
temp = {};
for i = 1:length(OutputChannelNames)
    if ~isempty(OutputChannelNames{i})
        temp{end+1} = OutputChannelNames{i};
    end
end
set(handles.OutputChannelsList,'String',temp,'Value',1)

% reconfigure session
reconfigureSession(handles);