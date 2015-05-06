function [] = rebuildManualControlUI()
global handles

if isfield(handles,'ManualControlSliders')
    delete(handles.ManualControlSliders);
end
if isfield(handles,'ManualControlSliderLabels')
    delete(handles.ManualControlSliderLabels);
end


if ~isempty(get(handles.ManualControlTab,'Children'))
    delete(get(handles.ManualControlTab,'Children'))
end
% terra nova
OutputNames = get(handles.OutputChannelsList,'String');
noutputs = length(OutputNames);
maxwidth=.1;
w = .05;
x = .1;
if ~noutputs
    return
end
for i = 1:noutputs
    handles.ManualControlSliders(i) = uicontrol(handles.ManualControlTab,'style','slider','Value',0,'Units','normalized','Position',[.1+x .1 w .8]);
    handles.ManualControlSliderLabels(i) = uicontrol(handles.ManualControlTab,'style','text','String',OutputNames{i},'Units','normalized','Position',[.1+x-(w) .01 3*w .1]);
    x = x+(1/(noutputs+1));
end
