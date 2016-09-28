% kontroller2 plugin
% manual-control
% DataRequired
% 
% plugin for kontroller
% part of the manual-control plugin
% this callback should be executed when data is requested

function [] = manualControlCallback(k,~,~)

% figure out how many outputs there are
noutputs = sum(~(cellfun(@any,(cellfun(@(x) strfind(x,'ai'),{k.session_handle.Channels.ID},'UniformOutput',false)))));

if ~noutputs
	disp('[ERR] No outputs configured')
	return
end

write_buffer = zeros(k.session_handle.NotifyWhenScansQueuedBelow,noutputs);

try
    for i = 1:length(k.handles.manual_control.sliders)
        write_buffer(:,i) = k.handles.manual_control.sliders(i).Value;
    end
catch
	disp('error 16 @ pollManualControl')
end

% queue some data
disp('[INFO] manualControlCallback::queuing output data...')
queueOutputData(k.session_handle,write_buffer);

