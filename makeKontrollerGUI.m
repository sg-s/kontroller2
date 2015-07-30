% makeKontrollerGUI
% makes the GUI for kontroller2 when it starts up
% 
% created by Srinivas Gorur-Shandilya at 6:07 , 10 April 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function handles = makeKontrollerGUI(VersionName)

handles.f1 = figure('Position',[20 60 450 700],'Toolbar','none','Menubar','none','Name',strrep(VersionName,'_',''),'NumberTitle','off','Resize','off','HandleVisibility','on','CloseRequestFcn',@quitKontroller2Callback);



% set the app data
d = [];
setappdata(handles.f1,'d',d);

% konsole
handles.Konsole = uicontrol('Position',[15 600 425 90],'Style','text','String','Kontroller is starting...','FontName','Courier','HorizontalAlignment','left');


% inputs and outputs
handles.ConfigureInputChannelButton = uicontrol('Position',[15 540 140 50],'Style','pushbutton','Enable','off','String','Configure Inputs','FontSize',10,'Callback',@configureInputChannels);
handles.ConfigureOutputChannelButton = uicontrol('Position',[300 540 140 50],'Style','pushbutton','Enable','off','String','Configure Outputs','FontSize',10,'Callback',@configureOutputChannels);
handles.InputChannelsPanel = uipanel('Title','Input Channels','FontSize',12,'units','pixels','pos',[15 330 200 200]);
handles.InputChannelsList = uicontrol(handles.InputChannelsPanel,'Style','listbox','Min',0,'Max',2,'FontSize',12,'units','pixels','Units','normalized','Position',[0 0 1 1],'String','','Callback',@inputChannelsListCallback);
handles.OutputChannelsPanel = uipanel('Title','Output Channels','FontSize',12,'units','pixels','pos',[235 330 200 200]);
handles.OutputChannelsList = uicontrol(handles.OutputChannelsPanel,'Style','listbox','Min',0,'Max',2,'FontSize',12,'units','pixels','Units','normalized','Position',[0 0 1 1],'String','');


% daq controls
handles.ChooseDAQControl = uicontrol(handles.f1,'Style','popupmenu','String',{'Demo DAQ'},'Value',1,'FontSize',8,'Position',[160 550 140 40],'Callback',@chooseDAQControlCallback);
uicontrol(handles.f1,'Position',[170 530 20 30],'Style','text','String','w=');
w = cache('SamplingRate');
if ~isempty(w) && ~isnan(w)
    w = mat2str(w);
else
    w = '1000';
end
handles.SamplingRateControl = uicontrol(handles.f1,'Position',[195 540 50 25],'Style','edit','String',w,'Callback',@samplingRateCallback);

% control tab group
if ispc
    handles.TabGroup = uitabgroup(handles.f1,'Units','points','Position',[10 10 320 230]);
    handles.ParadigmTab = uitab(handles.TabGroup,'Title','Paradigm Control');
    handles.ManualControlTab = uitab(handles.TabGroup,'Title','Manual Control');
    handles.SaveTab = uitab(handles.TabGroup,'Title','Save');
    handles.MetadataTab = uitab(handles.TabGroup,'Title','Metadata');

    % paradigm tab
    handles.ConfigureControlSignalsButton = uicontrol(handles.ParadigmTab,'Position',[10 220 180 30],'Style','pushbutton','Enable','on','String','Configure Control','FontSize',10,'Callback',@loadSavedParadigms);

    % run, pause and abort
    handles.RunButton = uicontrol(handles.ParadigmTab,'Position',[10 10 100 30],'Style','pushbutton','Enable','off','String','Run','FontSize',10,'Callback',@runTrial);
    handles.PauseButton = uicontrol(handles.ParadigmTab,'Position',[170 10  100 30],'Style','pushbutton','Enable','off','String','Pause','FontSize',10,'Callback',@pauseTrial);
    handles.AbortButton = uicontrol(handles.ParadigmTab,'Position',[280 10 100 30],'Style','pushbutton','Enable','off','String','Abort','FontSize',10,'Callback',@abort);

    % save tab
    handles.SaveButton = uicontrol(handles.SaveTab,'Position',[280 10 100 30],'Style','pushbutton','Enable','on','String','Save to...','FontSize',10,'Callback',@saveCallback);
    handles.SaveEdit = uicontrol(handles.SaveTab,'Position',[10 10 200 30],'Style','edit','Enable','on','String','no file chosen','FontSize',10,'Callback',@saveCallback);
    

end    

% make scopes
scsz = get(0,'ScreenSize');
handles.scope_fig = figure('Position',[500 100 scsz(3)-500 scsz(4)-200],'Toolbar','none','Name','Kontroller2 Oscilloscope','NumberTitle','off','Resize','on','Visible','on','CloseRequestFcn',@quitKontroller2Callback); hold on; 
uicontrol(handles.scope_fig,'Style','text','FontSize',8,'String','Plot only last','Position',[100 scsz(4)-220 100 20])
handles.scope_NSamples=uicontrol(handles.scope_fig,'Style','edit','FontSize',8,'String','1000','Position',[200 scsz(4)-220 70 22],'Callback',@refreshScopes);
uicontrol(handles.scope_fig,'Style','text','FontSize',8,'String','samples','Position',[270 scsz(4)-220 100 20])
handles.plot_data(1) = plot(NaN,NaN);
set(handles.plot_data(1),'XData',NaN(str2double(get(handles.scope_NSamples,'String')),1),'YData',NaN(str2double(get(handles.scope_NSamples,'String')),1));
    

