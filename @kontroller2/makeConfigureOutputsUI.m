%% makeConfigureOutputsUI
% makes the UI to configure input channels 
% the UX is largely inherited from kontroller (v1)
% 
function k = makeConfigureOutputsUI(k)
   
disp('Generating UI to configure outputs...')

all_output_channels = [k.output_channels; k.output_digital_channels];
all_output_channel_names = [k.output_channel_names; k.output_digital_channel_names];

n_output_channels = length(all_output_channels);
Height = 700;

k.handles.configure_output_channels_figure = figure('Position',[80 80 550 Height+50],'Toolbar','none','Menubar','none','resize','off','Name','Configure Output Channels','NumberTitle','off');

assert(iseven(n_output_channels),'kontroller error 677: Odd number of channels, cannot handle this');

nspacing = Height/(n_output_channels/2);

% generate UIcontrol edit boxes
n = n_output_channels;
for i = 1:n/2  
    % left side
    if any(strfind(all_output_channels{i},'ao'))
    	uicontrol(k.handles.configure_output_channels_figure,'Position',[160 10+Height-i*nspacing 100 20],'Style', 'text','String',all_output_channels{i},'FontSize',12,'FontWeight','bold');
    else
    	uicontrol(k.handles.configure_output_channels_figure,'Position',[160 10+Height-i*nspacing 100 20],'Style', 'text','String',all_output_channels{i},'FontSize',12);
    end
    uicontrol(k.handles.configure_output_channels_figure,'Position',[40 10+Height-i*nspacing 100 20],'Style', 'edit','FontSize',12,'Callback',@k.outputConfigCallback,'Tag',all_output_channels{i},'String',all_output_channel_names{i});
    

    % right side
    uicontrol(k.handles.configure_output_channels_figure,'Position',[400 10+Height-i*nspacing 100 20],'Style', 'edit','FontSize',12,'Callback',@k.outputConfigCallback,'Tag',all_output_channels{n/2+i});
    if any(strfind(all_output_channels{n/2+i},'ao'))
    	    uicontrol(k.handles.configure_output_channels_figure,'Position',[300 10+Height-i*nspacing 100 20],'Style', 'text','String',all_output_channels{n/2+i},'FontSize',12,'FontWeight','bold');
    else
    	uicontrol(k.handles.configure_output_channels_figure,'Position',[300 10+Height-i*nspacing 100 20],'Style', 'text','String',all_output_channels{n/2+i},'FontSize',12,'String',all_output_channel_names{n/2+i});
    end

end


