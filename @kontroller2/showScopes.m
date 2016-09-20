% kontroller2 plugin
% scopes
% 
% 
% plugin for kontroller2
% creates scopes UI
%
function [k] = showScopes(k,src,event)

% debug
if k.verbosity > 1
    disp([mfilename ' called.'])
end

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
			uimenu(k.handles.scopes.menu1,'Label',input_channel_names{i},'Callback',@showScopes,'Checked','off');
		end

		% make a action menu
		k.handles.scopes.menu2 = uimenu('Label','Action');
		uimenu(k.handles.scopes.menu2,'Label','Duplicate selected channels','Callback',@k.showScopes);
		uimenu(k.handles.scopes.menu2,'Label','Start scopes','Callback',@k.showScopes);
		uimenu(k.handles.scopes.menu2,'Label','Stop scopes','Callback',@k.showScopes);

		% make a control for the buffer length:
		k.handles.scopes.buffer_control = uicontrol(k.handles.scopes.fig_handle,'Style','edit','String','10000','Units','normalized','Position',[.95 .95 .05 .03],'Callback',@k.showScopes);
		uicontrol(k.handles.scopes.fig_handle,'Style','text','String','buffer length:','Units','normalized','Position',[.85 .94 .1 .03])
	end
else
	switch src.Type
	case 'uimenu'
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
				buffer_length = str2double(k.handles.scopes.buffer_control.String);
				k.handles.scopes.plot_data(i) = plot(k.handles.scopes.plots(i),NaN(buffer_length,1),NaN(buffer_length,1),'k');
				this_tag = plot_these{i};
				if any(strfind(this_tag,'copy'))
					this_tag = strtrim(this_tag(1:strfind(this_tag,'copy')-1));
				end
				k.handles.scopes.plot_data(i).Tag = this_tag;
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
			case 'Start scopes'
				k.start;
			case 'Stop scopes'
				k.stop;
			end
		end % end switch src.Parent.Label
	case 'uicontrol'
		if src == k.handles.scopes.buffer_control
			% validate the input
			buffer_length = str2double(src.String);
			assert(~isnan(buffer_length),'buffer length should be a number')
			assert(buffer_length > 100,'buffer length should be at least 100 samples long')
			assert(isint(buffer_length),'buffer length should be an integer')
			for i = 1:length(k.handles.scopes.plot_data)
				k.handles.scopes.plot_data(i).XData = NaN(buffer_length,1);
				k.handles.scopes.plot_data(i).YData = NaN(buffer_length,1);
			end
		else
			error('unknown uicontrol error #110')
		end
	otherwise
		error('Unknown class of callback, error #113')
	end


end


