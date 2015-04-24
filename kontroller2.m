% kontroller.m
% this is kontroller2, a complete re-write of the original kontroller
% 
% created by Srinivas Gorur-Shandilya at 6:02 , 10 April 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = kontroller2(varargin)
VersionName= 'Kontroller2 v_0_';
%% validate inputs
gui = 0;
RunTheseParadigms = [];
ControlParadigm = []; % stores the actual control signals for the different control paradigm
w = 1000; % 1kHz sampling  
if nargin == 0 
    % fine.
    gui = 1; % default to showing the GUI
elseif iseven(nargin)
    for ii = 1:nargin
        temp = varargin{ii};
        if ischar(temp)
            eval(strcat(temp,'=varargin{ii+1};'));
        end
    end
    clear ii
else
    error('Inputs need to be name value pairs')
end

% make the gui
handles = makeKontrollerGUI(VersionName);

% here are the core variables
InputChannelNames = cache('InputChannelNames');
if ~isempty(InputChannelNames)
    % add to the list of input channels
    temp = {};
    for i = 1:length(InputChannelNames)
        if ~isempty(InputChannelNames{i})
            temp{end+1} = InputChannelNames{i};
        end
    end
end
set(handles.InputChannelsList,'String',temp,'Value',1)
OutputChannelNames = cache('OutputChannelNames');
setappdata(handles.f1,'InputChannelNames',InputChannelNames);
setappdata(handles.f1,'OutputChannelNames',OutputChannelNames);

% look for DAQs
try
    d(1) = daq.getDevices(); % this line takes a long time when you run it for the first time...
catch
    d.Subsystems(1).ChannelNames = {'ai0','ai1','ai2','ai3','ai4','ai5','ai6','ai7','ai8','ai9','ai10','ai11'};
    d.Subsystems(2).ChannelNames = {'di0','di1'};
    d.Subsystems(3).ChannelNames = {'do0','do1','do2','do3','do4','do5','do6','do7'};
    d.Vendor.FullName = 'kontroller2 Demo';
    d.Model = 'Demo';
end

setappdata(handles.f1,'d',d);
setappdata(handles.f1,'handles',handles);

if length(d) == 1
    % only 1 daq
    set(handles.ChooseDAQControl,'String',d.Model,'Value',1);
    set(handles.ConfigureInputChannelButton,'Enable','on');
    set(handles.ConfigureOutputChannelButton,'Enable','on');
else
    disp('more than 1 daq. not coded.')
    % add to 
    keyboard
end

% set up a session
s = daq.createSession('ni');
setappdata(handles.f1,'s',s);

reconfigureSession(handles);


