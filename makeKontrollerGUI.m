% makeKontrollerGUI
% 
% created by Srinivas Gorur-Shandilya at 6:07 , 10 April 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function handles = makeKontrollerGUI(VersionName)

handles.f1 = figure('Position',[20 60 450 700],'Toolbar','none','Menubar','none','Name',strrep(VersionName,'_',''),'NumberTitle','off','Resize','off','HandleVisibility','on','CloseRequestFcn',@QuitKontroller2Callback);


% konsole
handles.Konsole = uicontrol('Position',[15 600 425 90],'Style','text','String','Kontroller is starting...','FontName','Courier','HorizontalAlignment','left');


% inputs and outputs
handles.ConfigureInputChannelButton = uicontrol('Position',[15 540 140 50],'Style','pushbutton','Enable','off','String','Configure Inputs','FontSize',10,'Callback',@ConfigureInputChannels);
handles.ConfigureOutputChannelButton = uicontrol('Position',[300 540 140 50],'Style','pushbutton','Enable','off','String','Configure Outputs','FontSize',10,'Callback',@ConfigureOutputChannels);
handles.InputChannelsPanel = uipanel('Title','Input Channels','FontSize',12,'units','pixels','pos',[15 330 200 200]);
handles.OutputChannelsPanel = uipanel('Title','Output Channels','FontSize',12,'units','pixels','pos',[235 330 200 200]);

% control tab group
handles.TabGroup = uitabgroup(handles.f1,'Units','points','Position',[10 10 425 300]);
handles.ParadigmTab = uitab(handles.TabGroup,'Title','Configure Paradigms');
handles.ManualControlTab = uitab(handles.TabGroup,'Title','Manual Control');
handles.MetadataTab = uitab(handles.TabGroup,'Title','Metadata');

    return

        ConfigureControlSignalsButton = uicontrol('Position',[305 540 140 50],'Style','pushbutton','Enable','off','String','Configure Control','FontSize',10,'Callback',@ConfigureControlSignals);

    PlotInputsList = {};
    PlotOutputsList = {};
    PlotInputs = uicontrol(InputChannelsPanel,'Position',[3 3 230 170],'Style','listbox','Min',0,'Max',2,'String',PlotInputsList,'FontSize',11);
    OutputChannelsPanel = uipanel('Title','Output Channels','FontSize',12,'units','pixels','pos',[265 330 170 130]);
    PlotOutputs = uicontrol(OutputChannelsPanel,'Position',[3 3 165 100],'Style','listbox','Min',0,'Max',2,'String',PlotOutputsList,'FontSize',11);

    % paradigm panel
    ControlParadigmList = {}; % stores a list of different control paradigm names. e.g., control, test, odour1, etc.
    ParadigmPanel = uipanel('Title','Control Paradigms','FontSize',12,'units','pixels','pos',[15 30 170 200]);
    ParadigmListDisplay = uicontrol(ParadigmPanel,'Position',[3 3 155 105],'Style','listbox','Enable','on','String',ControlParadigmList,'FontSize',12,'Min',0,'Max',2,'Callback',@ControlParadigmListCallback);
    SaveControlParadigmsButton = uicontrol(ParadigmPanel,'Position',[3,120,45,30],'Style','pushbutton','String','Save','Callback',@SaveControlParadigms);
    ViewControlParadigmButton = uicontrol(ParadigmPanel,'Position',[52,120,45,30],'Style','pushbutton','String','View','Callback',@ViewControlParadigm);
    RemoveControlParadigmsButton = uicontrol(ParadigmPanel,'Position',[100,120,60,30],'Style','pushbutton','String','Remove','Callback',@RemoveControlParadigms);
    ParadigmNameDisplay = uicontrol(ParadigmPanel,'Position',[3,150,150,25],'Style','text','String','No Controls configured');


    SamplingRateControl = uicontrol(f1,'Position',[133 5 50 20],'Style','edit','String',mat2str(w),'Callback',@SamplingRateCallback);
    uicontrol(f1,'Position',[20 5 100 20],'Style','text','String','Sampling Rate');
    RunTrialButton = uicontrol(f1,'Position',[320 5 110 50],'Enable','off','BackgroundColor',[0.8 0.9 0.8],'Style','pushbutton','String','RUN w/o saving','FontWeight','bold','Callback',@RunTrial);

    FileNameDisplay = uicontrol(f1,'Position',[200,60,230,50],'Style','edit','String','No destination file selected','Callback',@SaveToFileTextEdit);
    if ~demo_mode
        FileNameSelect = uicontrol(f1,'Position',[200,5,100,50],'Style','pushbutton','String','Write to...','Callback',@SelectDestinationCallback);
    else
        FileNameSelect = uicontrol(f1,'Position',[200,5,100,50],'Style','pushbutton','String','Load data...','Callback',@LoadKontrollerData);
    end

    AutomatePanel = uipanel('Title','Automate','FontSize',12,'units','pixels','pos',[205 120 230 200]);
    uicontrol(AutomatePanel,'Style','text','FontSize',8,'String','Repeat selected paradigms','Position',[1 120 100 50])
    uicontrol(AutomatePanel,'Style','text','FontSize',8,'String','times','Position',[150 110 50 50])
    RepeatNTimesControl = uicontrol(AutomatePanel,'Style','edit','FontSize',8,'String','1','Position',[110 140 30 30]);
    RunProgramButton = uicontrol(AutomatePanel,'Position',[4 5 110 30],'Enable','off','Style','pushbutton','String','RUN PROGRAM','Callback',@RunProgram);
    PauseProgramButton = uicontrol(AutomatePanel,'Position',[124 5 80 30],'Enable','off','Style','togglebutton','String','PAUSE','Callback',@PauseProgram);
    AbortProgramButton = uicontrol(AutomatePanel,'Position',[124 40 80 30],'Enable','off','Style','togglebutton','String','ABORT');

    uicontrol(AutomatePanel,'Style','text','FontSize',8,'String','Do this between trials:','Position',[1 70 100 50])
    InterTrialIntervalControl = uicontrol(AutomatePanel,'Style','edit','FontSize',8,'String','pause(20)','Position',[110 100 100 30]);
    RandomizeControl = uicontrol(AutomatePanel,'Style','popupmenu','String',{'Randomise','Interleave','Block','Reverse Block','Custom'},'Value',2,'FontSize',8,'Position',[5 50 100 20],'Callback',@RandomiseControlCallback);


    ManualControlButton = uicontrol(f1,'Position',[12 240 170 30],'Enable','on','Style','pushbutton','String','Manual Control','Callback',@ManualControlCallback);
    MetadataButton = uicontrol(f1,'Position',[12 280 170 30],'Enable','on','Style','pushbutton','String','Add Metadata...','Callback',@MetadataCallback);

    wh.ProgressRatio  =0.5;
    % waitbar(0.5,wh,'Generating global variables...'); figure(wh)
    if demo_mode
        StartScopes = uicontrol(f1,'Position',[260 465 150 50],'Style','pushbutton','Enable','off','String','Clear Scopes','FontSize',12,'Callback',@ClearScopes);
    else
        StartScopes = uicontrol(f1,'Position',[260 465 150 50],'Style','pushbutton','Enable','off','String','Start Scopes','FontSize',12,'Callback',@ScopeCallback);
    end
    
    scsz = get(0,'ScreenSize');
    scope_fig = figure('Position',[500 100 scsz(3)-500 scsz(4)-200],'Toolbar','none','Name','Oscilloscope','NumberTitle','off','Resize','on','Visible','off','CloseRequestFcn',@QuitKontrollerCallback); hold on; 
    
    
    % scope figure controls
    ParadigmMenu = uimenu(scope_fig,'Label','Paradigm','Enable','off');
    TrialMenu = uimenu(scope_fig,'Label','Trial #','Enable','off');
    uicontrol(scope_fig,'Style','text','FontSize',8,'String','Plot only last','Position',[100 scsz(4)-220 100 20])
    plot_only_control=uicontrol(scope_fig,'Style','edit','FontSize',8,'String','Inf','Position',[200 scsz(4)-220 70 22]);
    uicontrol(scope_fig,'Style','text','FontSize',8,'String','samples','Position',[270 scsz(4)-220 100 20])
