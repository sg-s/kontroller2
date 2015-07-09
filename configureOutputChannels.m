% configureOutputChannels.m 
% creates UI for configuring outputs.
% 
% this function is called when you click the "configure outputs" on the main window
% its job is to make the UI for analogue and digital output channel
% choosers
% it spawns 2 figures, and links the figures to other callbacks that modify
% the session variable "s" with the new channels you want to write to. 
% part of kontroller2

function [] = configureOutputChannels(~,~)

% get the DAQ structure and handles sructure
global handles
d = getappdata(handles.f1,'d'); 

% do the analgue outputs
OutputChannels =  d(1).Subsystems(2).ChannelNames;
n = length(OutputChannels);

Height = (n/2)*50;
handles.ConfigureOutputsFigure = figure('Position',[80 80 450 Height],'Toolbar','none','Menubar','none','resize','off','Name','Configure Analogue Output Channels','NumberTitle','off','CloseRequestFcn',@quitConfigOutputsCallback);
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
        handles.ConfigureOutputs(this_channel) = uicontrol(handles.ConfigureOutputsFigure,'Position',[40 10+Height-i*nspacing 100 20],'Style', 'edit','String',OutputChannelNames{i},'FontSize',12,'Callback',@outputConfigCallback); 
   
    end
    for i = 1:n/2  % left side
        this_channel = i+n/2;
        
        uicontrol(handles.ConfigureOutputsFigure,'Position',[220 10+Height-i*nspacing 50 20],'Style', 'text','String',OutputChannels{this_channel},'FontSize',12);
        handles.ConfigureOutputs(this_channel) = uicontrol(handles.ConfigureOutputsFigure,'Position',[300 10+Height-i*nspacing 100 20],'Style', 'edit','String',OutputChannelNames{this_channel},'FontSize',12,'Callback',@outputConfigCallback);

    end

else
    error('Kontroller error 676: Odd number of channels, cannot handle this')
end

setappdata(handles.f1,'OutputChannelNames',OutputChannelNames);

% add to the list of output channels
temp = {};
for i = 1:length(OutputChannelNames)
    if ~isempty(OutputChannelNames{i})
        temp{end+1} = OutputChannelNames{i};
    end
end
set(handles.OutputChannelsList,'String',temp,'Value',1)

%% now the digital output channels

DigitalOutputChannels =  d(1).Subsystems(3).ChannelNames;

% make the digital outputs
n = length(DigitalOutputChannels);

% check cache for ChannelNames
DigitalOutputChannelNames = getappdata(handles.f1,'DigitalOutputChannelNames');

if isempty(DigitalOutputChannelNames)
    DigitalOutputChannelNames = cell(n,1);
end

Height = 700;
handles.ConfigureDigitalOutputsFigure = figure('Position',[550 150 550 Height],'Resize','off','Toolbar','none','Menubar','none','Name','Configure Digital Output Channels','NumberTitle','off','CloseRequestFcn',@quitConfigOutputsCallback);
a = axes; hold on
set(a,'Visible','off');

if floor(n/2)*2 == n
    % even n
    nspacing = Height/(n/2);
    % generate UIcontrol edit boxes
    for i = 1:n/2  % left side
        this_channel = i;
        
        uicontrol(handles.ConfigureDigitalOutputsFigure,'Position',[160 10+Height-i*nspacing 100 20],'Style', 'text','String',DigitalOutputChannels{i},'FontSize',12);
        handles.ConfigureDigitalOutputs(this_channel) = uicontrol(handles.ConfigureDigitalOutputsFigure,'Position',[40 10+Height-i*nspacing 100 20],'Style', 'edit','String',DigitalOutputChannelNames{i},'FontSize',12,'Callback',@outputConfigCallback); 
   
    end
    for i = 1:n/2  % left side
        this_channel = i+n/2;
        
        uicontrol(handles.ConfigureDigitalOutputsFigure,'Position',[280 10+Height-i*nspacing 100 20],'Style', 'text','String',DigitalOutputChannels{this_channel},'FontSize',12);
        handles.ConfigureDigitalOutputs(this_channel) = uicontrol(handles.ConfigureDigitalOutputsFigure,'Position',[390 10+Height-i*nspacing 100 20],'Style', 'edit','String',DigitalOutputChannelNames{this_channel},'FontSize',12,'Callback',@outputConfigCallback);

    end

else
    error('Kontroller error 676-digital: Odd number of channels, cannot handle this')
end
