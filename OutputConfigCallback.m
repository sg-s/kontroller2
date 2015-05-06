function [] = OutputConfigCallback(src,~)

global handles

% update OutputChannelNames
OutputChannelNames = getappdata(handles.f1,'OutputChannelNames');
OutputChannelNames{find(handles.ConfigureOutputs == src)} = get(src,'String');
setappdata(handles.f1,'OutputChannelNames',OutputChannelNames);
cache('OutputChannelNames',[]);
cache('OutputChannelNames',OutputChannelNames);



% add to the list of output channels
temp = {};
for i = 1:length(OutputChannelNames)
    if ~isempty(OutputChannelNames{i})
        temp{end+1} = OutputChannelNames{i};
    end
end
set(handles.OutputChannelsList,'String',temp,'Value',1)

% rebuild the UI for manual control
rebuildManualControlUI;

% reconfigure session
reconfigureSession();