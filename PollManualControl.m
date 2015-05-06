% PollManualControl
% this is called every time s needs some data
function [] = PollManualControl(s,event)

global handles
WriteBuffer = getappdata(handles.f1,'WriteBuffer');
noutputs = size(WriteBuffer,2);
for i = 1:length(handles.ManualControlSliders)
    WriteBuffer(:,i) = get(handles.ManualControlSliders(i),'Value');
end
s.queueOutputData(WriteBuffer);