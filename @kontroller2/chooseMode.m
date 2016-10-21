% chooseMode
% chooses which plugin to use to generate control signals to be written to the device
% only one can be chosen, for obvious reasons
% chooseMode is only used when using kontroller graphically

function [k] = chooseMode(k,src,event)

p = plugins(k);

use_these = (~cellfun(@isempty,{p.R_listeners}));
names = {p.name};

% also add a "scopes-only" mode
names = [names 'scopes-only'];
use_these = [use_these true];

if nargin == 1
	% create a small figure if needed 
	figure_exists = true;

	if isfield(k.handles,'modeChooser')
		if isfield(k.handles.modeChooser,'fig_handle')
			if ~isvalid(k.handles.modeChooser.fig_handle)
				figure_exists = false;
			end
		else
			figure_exists = false;
		end
	else
		figure_exists = false;
	end
	if ~figure_exists
		k.handles.modeChooser.fig_handle = figure('Position',[80 80 500 200],'Toolbar','none','Menubar','none','resize','off','Name','Choose Control Mode','NumberTitle','off');
		k.handles.modeChooser.mode_control = uicontrol(k.handles.modeChooser.fig_handle,'Units','normalized','Position',[.1 .1 .8 .8],'String',names(use_these),'Style','popupmenu','FontSize',20,'Callback',@k.chooseMode);
	end
else
	% this is a callback
	k.control_mode = src.String{(src.Value)};
end