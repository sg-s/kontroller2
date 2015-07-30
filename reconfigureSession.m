% reconfigureSession
% reconfigures the DAQ session every time we add or remove a channel, or change the sampling rate
% part of the kontroller2 package
% 
% 
% created by Srinivas Gorur-Shandilya at 5:36 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = reconfigureSession()
global handles 
s = getappdata(handles.f1,'s');

if s.IsRunning
    s.stop;
    s.release;
end


clear('s');
s = daq.createSession('ni');

d = getappdata(handles.f1,'d');
InputChannelNames = getappdata(handles.f1,'InputChannelNames');
OutputChannelNames = getappdata(handles.f1,'OutputChannelNames');
DigitalOutputChannelNames = getappdata(handles.f1,'DigitalOutputChannelNames');

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

% configure digital outputs
DigitalOutputChannels = get(d.Subsystems(3),'ChannelNames');
if ~isempty(DigitalOutputChannelNames)
    for i = 1:length(DigitalOutputChannelNames)
        if ~isempty(DigitalOutputChannelNames{i})
            % add if not already added
            if ~any(find(strcmp({s.Channels.ID},DigitalOutputChannels{i}))) || isempty({s.Channels.ID})
                s.addDigitalChannel('Dev1',DigitalOutputChannels{i}, 'OutputOnly');
                noutputs = noutputs+1;
            end
        end
    end
end


% configure listeners
if isfield(handles,'dataListener')
    delete(handles.dataListener);
end
handles.dataListener = s.addlistener('DataAvailable',@dataRouter);

if isfield(handles,'grabDataListener')
    delete(handles.grabDataListener);
end
handles.grabDataListener = s.addlistener('DataRequired',@dataRouter);

% set frequency of DataRequired Event
s.NotifyWhenScansQueuedBelow = 2000; % in number of samples
s.NotifyWhenDataAvailableExceeds = 1000;


% queue some filler data
WriteBuffer = zeros(s.NotifyWhenScansQueuedBelow,noutputs);

setappdata(handles.f1,'s',s);
setappdata(handles.f1,'WriteBuffer',WriteBuffer);

% start the task if something is configured
if ~isempty(WriteBuffer)
    s.queueOutputData(WriteBuffer);
end
if length(get(handles.InputChannelsList,'String'))
    s.startBackground;
end

keyboard

