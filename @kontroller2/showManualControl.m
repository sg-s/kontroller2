% kontroller2 plugin
% showManualControl
% dataRequested 
% 
% rebuilds Manual Control Tab
% 
% created by Srinivas Gorur-Shandilya at 5:36 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = showManualControl(k,src,event)

% debug
if k.verbosity > 1
    disp([mfilename ' called.'])
end

output_channel_names = [k.output_channel_names; k.output_digital_channel_names];
output_channel_names = output_channel_names(~cellfun(@isempty,output_channel_names));
noutputs = length(output_channel_names);

if ~noutputs
    disp('No outputs configured. Nothing to control.')
    return
end

% UI parameters
w = .05;
x = .1;

if nargin == 1
    % not a callback

    % determine what state we are currently in
    figure_exists = true;

    if isfield(k.handles,'manual_control')
        if isfield(k.handles.manual_control,'fig_handle')
            if ~isvalid(k.handles.manual_control.fig_handle)
                figure_exists = false;
            end
        else
            figure_exists = false;
        end
    else
        figure_exists = false;
    end

    if ~figure_exists

        % make the figure
        k.handles.manual_control.fig_handle = figure('Position',[80 80 500 300],'Toolbar','none','Menubar','none','resize','off','Name','Manual Control','NumberTitle','off');

        for i = 1:noutputs

            k.handles.manual_control.sliders(i) = uicontrol(k.handles.manual_control.fig_handle,'style','slider','Value',0,'Units','normalized','Position',[.1+x .28 w .6]);
            k.handles.manual_control.slider_labels(i) = uicontrol(k.handles.manual_control.fig_handle,'style','text','String',output_channel_names{i},'Units','normalized','Position',[.1+x-(w) .17 3*w .1],'FontWeight','bold');

            % figure out if this is a digital or a analogue output
            if any(find(strcmp(output_channel_names{i},k.output_channel_names)))
                % analogue, nothing to do here
            elseif any(find(strcmp(output_channel_names{i},k.output_digital_channel_names)))
                % digital outputs
                k.handles.manual_control.sliders(i).SliderStep = [1 1];
            else
                error('#50 in showManualControl')
                
            end

            % add controls for upper and lower bounds
            k.handles.manual_control.slider_lb(i) = uicontrol(k.handles.manual_control.fig_handle,'style','edit','String','0','Units','normalized','Position',[.1+x .12 w .08],'Callback',@k.changeSliderBounds);
            k.handles.manual_control.slider_ub(i) = uicontrol(k.handles.manual_control.fig_handle,'style','edit','String','1','Units','normalized','Position',[.1+x .9 w .08],'Callback',@k.changeSliderBounds);

            x = x+(1/(noutputs+1));
        end

    end

else
    disp('38 not coded')
    keyboard
end



