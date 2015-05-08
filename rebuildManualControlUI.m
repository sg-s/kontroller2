function [] = rebuildManualControlUI()
global handles

if isfield(handles,'ManualControlSliders')
    delete(handles.ManualControlSliders);
end

if isfield(handles,'ManualControlSliderLabels')
    delete(handles.ManualControlSliderLabels);
end

if isfield(handles,'ManualControlSliderLB')
    delete(handles.ManualControlSliderLB);
end

if isfield(handles,'ManualControlSliderUB')
    delete(handles.ManualControlSliderUB);
end

if ~isempty(get(handles.ManualControlTab,'Children'))
    delete(get(handles.ManualControlTab,'Children'))
end
% terra nova
OutputNames = get(handles.OutputChannelsList,'String');
noutputs = length(OutputNames);

% get the names of the analogue and digital output channels
OutputChannelNames = getappdata(handles.f1,'OutputChannelNames');
DigitalOutputChannelNames = getappdata(handles.f1,'DigitalOutputChannelNames');

w = .05;
x = .1;
if ~noutputs
    return
end
for i = 1:noutputs
    % figure out if this is a digital or a analogue output
    if any(find(strcmp(OutputNames{i},OutputChannelNames)))
        % analogue
        handles.ManualControlSliders(i) = uicontrol(handles.ManualControlTab,'style','slider','Value',0,'Units','normalized','Position',[.1+x .18 w .7]);
        handles.ManualControlSliderLabels(i) = uicontrol(handles.ManualControlTab,'style','text','String',OutputNames{i},'Units','normalized','Position',[.1+x-(w) .08 3*w .1]);
    
        % add controls for upper and lower bounds
        handles.ManualControlSliderLB(i) = uicontrol(handles.ManualControlTab,'style','edit','String','0','Units','normalized','Position',[.1+x .02 w .08],'Callback',@ChangeSliderBounds);
        handles.ManualControlSliderUB(i) = uicontrol(handles.ManualControlTab,'style','edit','String','1','Units','normalized','Position',[.1+x .9 w .08],'Callback',@ChangeSliderBounds);
    
        
    elseif any(find(strcmp(OutputNames{i},DigitalOutputChannelNames)))
        % digital
        handles.ManualControlSliders(i) = uicontrol(handles.ManualControlTab,'style','slider','Value',0,'Units','normalized','Position',[.1+x .18 w .7]);
        set(handles.ManualControlSliders(i),'SliderStep',[.9 .9]);
        handles.ManualControlSliderLabels(i) = uicontrol(handles.ManualControlTab,'style','text','String',OutputNames{i},'Units','normalized','Position',[.1+x-(w) .08 3*w .1]);
    
        % add controls for upper and lower bounds
        handles.ManualControlSliderLB(i) = uicontrol(handles.ManualControlTab,'style','text','String','0','Units','normalized','Position',[.1+x .02 w .08],'Enable','off');
        handles.ManualControlSliderUB(i) = uicontrol(handles.ManualControlTab,'style','text','String','1','Units','normalized','Position',[.1+x .9 w .08],'Enable','off');
    
    else
        error('#50 in rebuildManualControlUI')
        
    end
    x = x+(1/(noutputs+1));
end
