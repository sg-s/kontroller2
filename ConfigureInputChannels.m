function [] =ConfigureInputChannels(src,~)

% get the DAQ structure and handles sructure
d = getappdata(get(src,'Parent'),'d'); 
global handles

n = get(d.Subsystems(1),'NumberOfChannelsAvailable');
Height = 600;
handles.ConfigureInputsFigure = figure('Position',[80 80 450 Height+50],'Toolbar','none','Menubar','none','resize','off','Name','Configure Analogue Input Channels','NumberTitle','off');
uicontrol(handles.ConfigureInputsFigure,'Position',[25 600 400 40],'style','text','String','To reduce channel cross-talk, label shorted channels as "Ground". These will not be recorded from.','FontSize',8);
a = axes; hold on
set(a,'Visible','off');

% check cache for ChannelNames
InputChannelNames = getappdata(handles.f1,'InputChannelNames');
InputChannelRanges = getappdata(handles.f1,'InputChannelRanges');

if isempty(InputChannelNames)
    InputChannelNames = cell(n,1);
end
if isempty(InputChannelRanges)
    InputChannelRanges = cell(n,1);
end

InputChannels = get(d.Subsystems(1),'ChannelNames');

if floor(n/2)*2 == n
    % even n
    nspacing = Height/(n/2);
    % generate UIcontrol edit boxes
    for i = 1:n/2  % left side
        this_channel = i;
        
        uicontrol(handles.ConfigureInputsFigure,'Position',[160 10+Height-i*nspacing 50 20],'Style', 'text','String',InputChannels{i},'FontSize',12);
        handles.ConfigureInputs(this_channel) = uicontrol(handles.ConfigureInputsFigure,'Position',[40 10+Height-i*nspacing 100 20],'Style', 'edit','String',InputChannelNames{i},'FontSize',12,'Callback',@InputConfigCallback);
        if isempty(InputChannelRanges{i})
             handles.ConfigureInputsRange(this_channel) = uicontrol(handles.ConfigureInputsFigure,'Position',[7 10+Height-i*nspacing 25 20],'Style', 'edit','String','','FontSize',10,'Callback',@InputConfigCallback);
        else
            handles.ConfigureInputsRange(this_channel) = uicontrol(handles.ConfigureInputsFigure,'Position',[7 10+Height-i*nspacing 25 20],'Style', 'edit','String',mat2str(InputChannelRanges{i}),'FontSize',10,'Callback',@InputConfigCallback);
        end    
        if isempty(InputChannelNames{i})
        else
            if strcmpi(get(handles.ConfigureInputs(this_channel),'String'),'Ground')
                 set(handles.ConfigureInputs(this_channel),'ForegroundColor','g')
            else
                 set(handles.ConfigureInputs(this_channel),'ForegroundColor','k')
            end
        end
        
    end
    for i = 1:n/2  % left side
        this_channel = i+n/2;
        
        uicontrol(handles.ConfigureInputsFigure,'Position',[220 10+Height-i*nspacing 50 20],'Style', 'text','String',InputChannels{this_channel},'FontSize',12);
        handles.ConfigureInputs(this_channel) = uicontrol(handles.ConfigureInputsFigure,'Position',[300 10+Height-i*nspacing 100 20],'Style', 'edit','String',InputChannelNames{this_channel},'FontSize',12,'Callback',@InputConfigCallback);
        if isempty(InputChannelRanges{this_channel})
             handles.ConfigureInputsRange(this_channel) = uicontrol(handles.ConfigureInputsFigure,'Position',[407 10+Height-i*nspacing 25 20],'Style', 'edit','String','','FontSize',10,'Callback',@InputConfigCallback);
        else
            handles.ConfigureInputsRange(this_channel) = uicontrol(handles.ConfigureInputsFigure,'Position',[407 10+Height-i*nspacing 25 20],'Style', 'edit','String',mat2str(InputChannelRanges{i}),'FontSize',10,'Callback',@InputConfigCallback);
        end    
        if isempty(InputChannelNames{this_channel})
        else
            if strcmpi(get(handles.ConfigureInputs(this_channel),'String'),'Ground')
                 set(handles.ConfigureInputs(this_channel),'ForegroundColor','g')
            else
                 set(handles.ConfigureInputs(this_channel),'ForegroundColor','k')
            end
        end
        
    end

else
    error('Kontroller error 676: Odd number of channels, cannot handle this')
end

setappdata(handles.f1,'InputChannelNames',InputChannelNames);
setappdata(handles.ConfigureInputsFigure,'handles',handles);

% add to the list of input channels
temp = {};
for i = 1:length(InputChannelNames)
    if ~isempty(InputChannelNames{i})
        temp{end+1} = InputChannelNames{i};
    end
end
set(handles.InputChannelsList,'String',temp,'Value',1)
