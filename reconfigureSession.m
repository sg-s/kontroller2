% reconfigureSession
% part of the kontroller2 package
function [] = reconfigureSession()
global handles 
s = getappdata(handles.f1,'s');
WriteBugger = getappdata(handles.f1,'WriteBuffer');

if s.IsRunning
    s.stop;
end

d = getappdata(handles.f1,'d');
InputChannelNames = getappdata(handles.f1,'InputChannelNames');
OutputChannelNames = getappdata(handles.f1,'OutputChannelNames');

w = str2double(get(handles.SamplingRateControl,'String'));
if isnan(w)
    warning('Invalid Sampling rate, will fall back to default of 1KHz')
    w = 1000;
end
s.Rate = w;
s.IsContinuous = true;

% configure analogue inputs
InputChannels = get(d.Subsystems(1),'ChannelNames');
if ~isempty(InputChannelNames)
    for i = 1:length(InputChannelNames)
        if ~isempty(InputChannelNames{i})
            % add if not already added
            if ~any(find(strcmp({s.Channels.ID},InputChannels{i}))) || isempty({s.Channels.ID})
                s.addAnalogInputChannel('Dev1',InputChannels{i},'Voltage');
            end
        end
    end
end

% configure analgoue outputs
OutputChannels = get(d.Subsystems(2),'ChannelNames');
noutputs = 0;
if ~isempty(OutputChannelNames)
    for i = 1:length(OutputChannelNames)
        if ~isempty(OutputChannelNames{i})
            % add if not already added
            if ~any(find(strcmp({s.Channels.ID},OutputChannels{i}))) || isempty({s.Channels.ID})
                s.addAnalogOutputChannel('Dev1',OutputChannels{i},'Voltage');
                noutputs = noutputs+1;
            end
        end
    end
end

% configure listeners
if isfield(handles,'dataListener')
    delete(handles.dataListener);
end
handles.dataListener = s.addlistener('DataAvailable',@DataRouter);

if isfield(handles,'grabDataListener')
    delete(handles.grabDataListener);
end
handles.grabDataListener = s.addlistener('DataRequired',@DataRouter);

% queue some filler data
WriteBuffer = zeros(s.NotifyWhenScansQueuedBelow,noutputs);

% start the task
s.queueOutputData(WriteBuffer);
s.startBackground;


setappdata(handles.f1,'s',s);
setappdata(handles.f1,'WriteBuffer',WriteBuffer);
