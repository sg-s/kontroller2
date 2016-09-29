% kontroller2 plugin
% scopes
% DataAvailable
% 
% plugin for kontroller
% part of the scopes plugin
% this callback should be executed when data is available. 

function [k] = scopesCallback(k,~,event)

% first check if there is anything new

try
	if (event.TimeStamps(end)) > k.handles.scopes.plot_data(1).XData(end)
	else
		return
	end
catch
	return
end

try
	if ~isvalid(k.handles.scopes.fig_handle)
		return
	end
catch
	return
end

% figure out what to plot
for i = 1:length(k.handles.scopes.plot_data)
	this_tag = k.handles.scopes.plot_data(i).Tag;

	% look for this tag in the channels 
	channel_to_plot = (strcmp(this_tag,{k.session_handle.Channels.Name}));

	new_y = event.Data(:,channel_to_plot);
	new_x = event.TimeStamps;
	
	l = find(new_x > k.handles.scopes.plot_data(i).XData(end),1,'first');

	k.handles.scopes.plot_data(i).XData = [k.handles.scopes.plot_data(i).XData(length(new_x) - l+2:end) new_x(l:end)'];
	k.handles.scopes.plot_data(i).YData = [k.handles.scopes.plot_data(i).YData(length(new_x) - l+2:end) new_y(l:end)'];
end
