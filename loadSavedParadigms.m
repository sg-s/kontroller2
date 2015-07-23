% loadSavedParadigms.m
% loads saved paradigms from disk. 
% ported from kontroller
% 
% created by Srinivas Gorur-Shandilya at 3:58 , 23 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = loadSavedParadigms(~,~)
global handles

% figure out the number of outputs
OutputNames = get(handles.OutputChannelsList,'String');
noutputs = length(OutputNames);

% get the path to the control paradigm we need to load
[FileName,PathName] = uigetfile('*_Kontroller_paradigm*');
temp=load(strcat(PathName,FileName));

% check that this Control Paradigm has the same number of outputs as there are output channels
[nol,~]=size(temp.ControlParadigm(1).Outputs);
if nol == noutputs
    % alles gut
else
    % AAARGHRHRH
    errordlg('Error: The Paradigm you tried to load does not have the same number of outputs as the number of outputs currently configured. Either load a new Control Paradigm, or change the number of OutputChannels to match this paradigm.','Kontroller cannot do this.')
    return
end 

ControlParadigm=temp.ControlParadigm;
clear temp

% now update the list
ControlParadigmList = {};
for i = 1:length(ControlParadigm)
    ControlParadigmList = [ControlParadigmList ControlParadigm(i).Name];
end
set(handles.ParadigmListDisplay,'String',ControlParadigmList)

set(handles.Konsole,'String','Controls have been configured. ')

% update run button
if isempty(SaveToFile)
    set(RunTrialButton,'enable','on','String','RUN w/o saving','BackgroundColor',[0.9 0.1 0.1]);
else
    set(RunTrialButton,'enable','on','String','RUN and SAVE','BackgroundColor',[0.1 0.9 0.1]);
end
delete(fcs)

% show the name
set(ParadigmNameDisplay,'String',strrep(FileName,'_Kontroller_Paradigm.mat',''))
