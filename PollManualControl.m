% PollManualControl
% this is called every time s needs some data
% for now, this is the only way to control outputs
function [WriteBuffer] = PollManualControl(s,~)

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