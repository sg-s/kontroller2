%% configureInputChannels
% makes the UI to configure input channels 
% the UX is largely inherited from kontroller (v1)
% 
function k = configureInputChannels(k)
   
disp('Generating UI to configure inputs...')

n_input_channels = length(k.input_channels);
Height = 600;

k.handles.configure_input_channels_figure = figure('Position',[80 80 450 Height+50],'Toolbar','none','Menubar','none','resize','off','Name','Configure Analogue Input Channels','NumberTitle','off');
uicontrol(k.handles.configure_input_channels_figure,'Position',[25 600 400 40],'style','text','String','To reduce channel cross-talk, label shorted channels as "Ground". These will not be recorded from.','FontSize',8);

assert(iseven(n_input_channels),'kontroller error 676: Odd number of channels, cannot handle this');

nspacing = Height/(n_input_channels/2);

% generate UIcontrol edit boxes
n = n_input_channels;
for i = 1:n/2  
    % left side
    uicontrol(k.handles.configure_input_channels_figure,'Position',[40 10+Height-i*nspacing 100 20],'Style', 'edit','FontSize',12,'Callback',@k.inputConfigCallback,'Tag',k.input_channels{i});
    uicontrol(k.handles.configure_input_channels_figure,'Position',[7 10+Height-i*nspacing 25 20],'Style', 'edit','String',mat2str(k.input_channel_ranges(i)),'FontSize',10,'Callback',@k.inputConfigCallback,'Tag',['range_' k.input_channels{i}]);
    uicontrol(k.handles.configure_input_channels_figure,'Position',[160 10+Height-i*nspacing 50 20],'Style', 'text','String',k.input_channels{i},'FontSize',12);

    % right side
    uicontrol(k.handles.configure_input_channels_figure,'Position',[300 10+Height-i*nspacing 100 20],'Style', 'edit','FontSize',12,'Callback',@k.inputConfigCallback,'Tag',k.input_channels{n/2+i});
    uicontrol(k.handles.configure_input_channels_figure,'Position',[407 10+Height-i*nspacing 25 20],'Style', 'edit','String',mat2str(k.input_channel_ranges(n/2+i)),'FontSize',10,'Callback',@k.inputConfigCallback,'Tag',['range_' k.input_channels{n/2+i}]);
    uicontrol(k.handles.configure_input_channels_figure,'Position',[220 10+Height-i*nspacing 50 20],'Style', 'text','String',k.input_channels{n/2+i},'FontSize',12);
end


