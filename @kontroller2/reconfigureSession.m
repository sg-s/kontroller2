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

if k.verbosity > 5
	disp('reconfigureSession called')
end

if k.session_handle.IsRunning
    k.session_handle.stop;
end

% remove all channels from the session
if isempty({k.session_handle.Channels.ID})
	if k.verbosity > 5
    	disp('reconfigureSession:: no channels exist in session')
    end
else
	if k.verbosity > 5
    	disp('reconfigureSession:: channels exist in session, need to be removed')
    end

    try
    	removeChannel(k.session_handle,(1:length(k.session_handle.Channels)));
    catch
    	% a stupid error blocks execution when we run removeChannel. It tries to set DurationInSeconds, but it shouldn't. this is because we queued data for a channel that we then want to remove. see https://github.com/sg-s/kontroller2/issues/23
    end
end

% now add the analogue inputs to the session
add_these = k.input_channels(~cellfun(@isempty,k.input_channel_names));
input_channel_names =  k.input_channel_names(~cellfun(@isempty,k.input_channel_names));
for i = 1:length(add_these)
	if k.verbosity > 1
		disp(['Adding analogue input channel: ' add_these{i}])
	end
    ch = k.session_handle.addAnalogInputChannel(k.daq_handle.ID,add_these{i},'Voltage');
    ch.Name = input_channel_names{i};
end

% now add the analogue outputs to the session
add_these = k.output_channels(~cellfun(@isempty,k.output_channel_names));
output_channel_names =  k.output_channel_names(~cellfun(@isempty,k.output_channel_names));
for i = 1:length(add_these)
	if k.verbosity > 1
		disp(['Adding analogue output channel: ' add_these{i}])
	end
    ch = k.session_handle.addAnalogOutputChannel(k.daq_handle.ID,add_these{i},'Voltage');
    ch.Name = output_channel_names{i};
end

% now add the digital outputs to the session
add_these = k.output_digital_channels(~cellfun(@isempty,k.output_digital_channel_names));
output_digital_channel_names =  k.output_digital_channel_names(~cellfun(@isempty,k.output_digital_channel_names));
for i = 1:length(add_these)
	if k.verbosity > 1
		disp(['Adding digital output channel: ' add_these{i}])
	end
    ch = k.session_handle.addDigitalChannel(k.daq_handle.ID,add_these{i},'OutputOnly');
    ch.Name = output_digital_channel_names{i};
end

% make it run as fast as possible (on this computer, that is 20Hz)
k.session_handle.NotifyWhenScansQueuedBelow = k.sampling_rate/20;
k.session_handle.NotifyWhenDataAvailableExceeds = k.sampling_rate/20;


p = k.plugins;

for i = 1:length(p)
	if k.verbosity > 1
		disp(['Configuring plugin: ' p(i).name])
	end

	% configure data available listeners
	if ~isempty(p(i).A_listeners)
		k.handles.dataListener(i) = k.session_handle.addlistener('DataAvailable',str2func(p(i).A_listeners));
	end
end



% figure out how many outputs there are
noutputs = sum(~(cellfun(@any,(cellfun(@(x) strfind(x,'ai'),{k.session_handle.Channels.ID},'UniformOutput',false)))));
% why the fuck is this so complicated?

% queue some empty data
if noutputs
	write_buffer = zeros(k.sampling_rate/20,noutputs);
	queueOutputData(k.session_handle,write_buffer);
end



