% pollManualControl
% asks the ManualControl tab for states to write to the control buffer
% 
% this is called every time s needs some data
% for now, this is the only way to control outputs
function [WriteBuffer] = pollManualControl(s,~)

global handles
WriteBuffer = getappdata(handles.f1,'WriteBuffer');
noutputs = size(WriteBuffer,2);
try
    for i = 1:length(handles.ManualControlSliders)
        WriteBuffer(:,i) = get(handles.ManualControlSliders(i),'Value');
    end
catch
    % it's probably OK
end
s.queueOutputData(WriteBuffer);