% reconfigureSession
% reconfigures the session in a kontroller2 object
% so that the session_handle reflects the properties of the kontroller2 object
% everytime this is called, it wipes all session info and rebuilds the session from scratch
% 
function k = reconfigureSession(k)

if isempty(k.session_handle)
    % session not yet initialised, there's nothing we can do here
    return
end

if k.session_handle.IsRunning
    k.session_handle.stop;
end

% remove all channels from the session
if isempty({k.session_handle.Channels.ID})
    disp('reconfigureSession:: no channels exist in session')
else
    disp('reconfigureSession:: channels exist in session, need to be removed')
    removeChannel(k.session_handle,(1:length(k.session_handle.Channels)));
end

% now add the analogue inputs to the session
add_these = k.input_channels(find(~cellfun(@isempty,k.input_channel_names)));
for i = 1:length(add_these)
    k.session_handle.addAnalogInputChannel(k.daq_handle.ID,add_these{i},'Voltage');
end


% configure listeners
k.handles.dataListener = k.session_handle.addlistener('DataAvailable',@k.dataRouter);
k.handles.dataListener = k.session_handle.addlistener('DataAvailable',@k.k2p_A_scopesCallback);



% % configure analgoue outputs
% OutputChannels = get(d.Subsystems(2),'ChannelNames');
% noutputs = 0;
% if ~isempty(OutputChannelNames)
%     for i = 1:length(OutputChannelNames)
%         if ~isempty(OutputChannelNames{i})
%             % add if not already added
%             if ~any(find(strcmp({s.Channels.ID},OutputChannels{i}))) || isempty({s.Channels.ID})
%                 s.addAnalogOutputChannel('Dev1',OutputChannels{i},'Voltage');
%                 noutputs = noutputs+1;
%             end
%         end
%     end
% end

% % configure digital outputs
% DigitalOutputChannels = get(d.Subsystems(3),'ChannelNames');
% if ~isempty(DigitalOutputChannelNames)
%     for i = 1:length(DigitalOutputChannelNames)
%         if ~isempty(DigitalOutputChannelNames{i})
%             % add if not already added
%             if ~any(find(strcmp({s.Channels.ID},DigitalOutputChannels{i}))) || isempty({s.Channels.ID})
%                 s.addDigitalChannel('Dev1',DigitalOutputChannels{i}, 'OutputOnly');
%                 noutputs = noutputs+1;
%             end
%         end
%     end
% end




% if isfield(handles,'grabDataListener')
%     delete(handles.grabDataListener);
% end
% handles.grabDataListener = s.addlistener('DataRequired',@dataRouter);

% % % set frequency of DataRequired Event
% s.NotifyWhenScansQueuedBelow = 1000; % in number of samples
% s.NotifyWhenDataAvailableExceeds = 1000;


% % queue some filler data
% WriteBuffer = zeros(s.NotifyWhenScansQueuedBelow,noutputs);

% setappdata(handles.f1,'s',s);
% setappdata(handles.f1,'WriteBuffer',WriteBuffer);

% % start the task if something is configured
% if ~isempty(WriteBuffer)
%     s.queueOutputData(WriteBuffer);
% end
% if length(get(handles.InputChannelsList,'String'))
%     s.startBackground;
% end


