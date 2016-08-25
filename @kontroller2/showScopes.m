% plugin for kontroller2
% creates scopes UI
%
function [k] = showScopes(k,src,event)

if nargin == 1
	% this is not a callback from the scopes
	% determine what state we are currently in
	figure_exists = true;
	plot_exists = true;

	if isfield(k.handles,'scopes')
		if isfield(k.handles.scopes,'fig_handle')
			if ~isvalid(k.handles.scopes.fig_handle)
				figure_exists = false;
			end
		else
			figure_exists = false;
		end
	else
		figure_exists = false;
	end
	if ~figure_exists
		k.handles.scopes.fig_handle = figure('Position',[80 80 1300 800],'Toolbar','none','Menubar','none','resize','off','Name','Oscilloscope','NumberTitle','off');

		% make plots menu
		k.handles.scopes.menu1 = uimenu('Label','Channels');
		input_channel_names = k.input_channel_names(~cellfun(@isempty,k.input_channel_names));
		for i = 1:length(input_channel_names)
			uimenu(k.handles.scopes.menu1,'Label',input_channel_names{i},'Callback',@k.showScopes,'Checked','off');
		end

		% make a action menu
		k.handles.scopes.menu2 = uimenu('Label','Action');
		uimenu(k.handles.scopes.menu2,'Label','Duplicate selected channels','Callback',@k.showScopes);
	end
else
	switch src.Parent.Label
	case 'Channels'
		% flip the checked state on the src
		if strcmp(src.Checked,'on')
			src.Checked = 'off';
		else
			src.Checked = 'on';
		end

		% destroy all plots in the figure
		try
			delete(k.handles.scopes.plots);
		catch
		end
		try
			delete(k.handles.scopes.plot_data);
		catch
		end

		% make as many plots as needed. 
		plot_these = {k.handles.scopes.menu1.Children(strcmp('on',{k.handles.scopes.menu1.Children.Checked})).Label};
		nplots = length(plot_these);
		for i = 1:nplots
			k.handles.scopes.plots(i) = autoPlot(nplots,i,true);
			hold on
			ylabel(k.handles.scopes.plots(i),plot_these{i},'FontWeight','bold')
			k.handles.scopes.plot_data(i) = plot(k.handles.scopes.plots(i),NaN,NaN,'k');
			k.handles.scopes.plot_data(i).Tag = plot_these{i};
		end

	case 'Action'
		switch src.Label
		case 'Duplicate selected channels'
			% get the selected channels
			new_channels = {k.handles.scopes.menu1.Children(strcmp('on',{k.handles.scopes.menu1.Children.Checked})).Label};

			% label them as "copy" or append a number to them
			for i = 1:length(new_channels)
				if isempty(strfind(new_channels{i},'copy'))
					new_channels{i} = [new_channels{i} ' copy1'];
				else 
					old_index = new_channels{i}(strfind(new_channels{i},'copy')+4:end);
					new_index = mat2str(str2double(old_index)+1);
					new_channels{i} = strrep(new_channels{i},old_index,new_index);
				end
			end

			% add to menu items
			for i = 1:length(new_channels)
				uimenu(k.handles.scopes.menu1,'Label',new_channels{i},'Callback',@k.showScopes,'Checked','on');
			end
		end
	otherwise
		error('Unknown menu error #42')
	end


end


