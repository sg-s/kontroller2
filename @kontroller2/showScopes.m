% plugin for kontroller2
% creates scopes UI
%
function [k] = showScopes(k)

% is there already a figure?
make_fig = false;
if isfield(k.handles,'scopes')
	if isfield(k.handles.scopes,'fig_handle')
		if ~isvalid(k.handles.scopes.fig_handle)
			make_fig = true;
		end
	else
		make_fig = true;
	end
else
	make_fig = true;
end
if make_fig
	k.handles.scopes.fig_handle = figure('Position',[80 80 1300 800],'Toolbar','none','Menubar','none','resize','off','Name','Oscilloscope','NumberTitle','off');

	% make plots menu
	k.handles.scopes.menu1 = uimenu('Label','Channels');

	input_channel_names = k.input_channel_names(~cellfun(@isempty,k.input_channel_names));
	for i = 1:length(input_channel_names)
		uimenu(k.handles.scopes.menu1,'Label',input_channel_names{i},'Callback',@k.showScopes);
	end

end


