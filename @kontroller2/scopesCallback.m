% kontroller2 plugin
% scopes
% dataAvailable
% 
% plugin for kontroller
% part of the scopes plugin
% this callback should be executed when data is available. 

function [k] = scopesCallback(k,src,event)

% figure out what to plot
for i = 1:length(k.handles.scopes.plot_data)
	this_tag = k.handles.scopes.plot_data(i).Tag;

	% look for this tag in the channels 
	channel_to_plot = find(strcmp(this_tag,{k.session_handle.Channels.Name}));

	new_y = event.Data(:,channel_to_plot);
	new_x = event.TimeStamps;
	l = length(new_x);

	k.handles.scopes.plot_data(i).XData = [k.handles.scopes.plot_data(i).XData(l+1:end) new_x'];
	k.handles.scopes.plot_data(i).YData = [k.handles.scopes.plot_data(i).YData(l+1:end) new_y'];


end
