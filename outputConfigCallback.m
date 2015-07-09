% outputConfigCallback
% callback when configuring outputs in the configure outputs UI
% 
% created by Srinivas Gorur-Shandilya at 5:35 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = outputConfigCallback(src,~)

global handles

% update OutputChannelNames
OutputChannelNames = getappdata(handles.f1,'OutputChannelNames');
DigitalOutputChannelNames = getappdata(handles.f1,'DigitalOutputChannelNames');

if any(handles.ConfigureOutputs == src)
    OutputChannelNames{handles.ConfigureOutputs == src} = get(src,'String');
    setappdata(handles.f1,'OutputChannelNames',OutputChannelNames);
    cache('OutputChannelNames',[]);
    cache('OutputChannelNames',OutputChannelNames);
elseif any(handles.ConfigureDigitalOutputs == src)
    DigitalOutputChannelNames{handles.ConfigureDigitalOutputs == src} = get(src,'String');
    setappdata(handles.f1,'DigitalOutputChannelNames',DigitalOutputChannelNames);
    cache('DigitalOutputChannelNames',[]);
    cache('DigitalOutputChannelNames',DigitalOutputChannelNames);
else
    % something very wrong
    disp('Something went wront with Configuring output channels #16')
    return
end


% add to the list of output channels
temp = {};
for i = 1:length(OutputChannelNames)
    if ~isempty(OutputChannelNames{i})
        temp{end+1} = OutputChannelNames{i};
    end
end

% don't forget the digital channels
for i = 1:length(DigitalOutputChannelNames)
    if ~isempty(DigitalOutputChannelNames{i})
        temp{end+1} = DigitalOutputChannelNames{i};
    end
end


set(handles.OutputChannelsList,'String',temp,'Value',1)

% rebuild the UI for manual control
rebuildManualControlUI;

% reconfigure session
reconfigureSession();