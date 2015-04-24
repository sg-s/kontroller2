function [] =ConfigureOutputChannels(~,~)

% get the DAQ structure and handles sructure
global handles
d = getappdata(handles.f1,'d'); 

% do the analgue outputs
OutputChannels =  d(1).Subsystems(2).ChannelNames;
n = length(OutputChannels);

Height = (n/2)*50;
handles.ConfigureOutputsFigure = figure('Position',[80 80 450 Height+50],'Toolbar','none','Menubar','none','resize','off','Name','Configure Analogue Input Channels','NumberTitle','off');
uicontrol(handles.ConfigureOutputsFigure,'Position',[25 600 400 40],'style','text','String','To reduce channel cross-talk, label shorted channels as "Ground". These will not be recorded from.','FontSize',8);
a = axes; hold on
set(a,'Visible','off');

% check cache for ChannelNames
OutputChannelNames = getappdata(handles.f1,'OutputChannelNames');

if isempty(OutputChannelNames)
    OutputChannelNames = cell(n,1);
end



if floor(n/2)*2 == n
    % even n
    nspacing = Height/(n/2);
    % generate UIcontrol edit boxes
    for i = 1:n/2  % left side
        this_channel = i;
        
        uicontrol(handles.ConfigureOutputsFigure,'Position',[160 10+Height-i*nspacing 50 20],'Style', 'text','String',OutputChannels{i},'FontSize',12);
        handles.ConfigureOutputs(this_channel) = uicontrol(handles.ConfigureOutputsFigure,'Position',[40 10+Height-i*nspacing 100 20],'Style', 'edit','String',OutputChannelNames{i},'FontSize',12,'Callback',@OutputConfigCallback); 
  
        
    end
    for i = 1:n/2  % left side
        this_channel = i+n/2;
        
        uicontrol(handles.ConfigureOutputsFigure,'Position',[220 10+Height-i*nspacing 50 20],'Style', 'text','String',OutputChannels{this_channel},'FontSize',12);
        handles.ConfigureOutputs(this_channel) = uicontrol(handles.ConfigureOutputsFigure,'Position',[300 10+Height-i*nspacing 100 20],'Style', 'edit','String',OutputChannelNames{this_channel},'FontSize',12,'Callback',@OutputConfigCallback);

        
    end

else
    error('Kontroller error 676: Odd number of channels, cannot handle this')
end

setappdata(handles.f1,'OutputChannelNames',OutputChannelNames);

% add to the list of input channels
temp = {};
for i = 1:length(OutputChannelNames)
    if ~isempty(OutputChannelNames{i})
        temp{end+1} = OutputChannelNames{i};
    end
end
set(handles.OutputChannelsList,'String',temp,'Value',1)