% kontroller.m
% this is kontroller2, a complete re-write of the original kontroller
% 
% created by Srinivas Gorur-Shandilya at 6:02 , 10 April 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = kontroller2(varargin)
VersionName= 'Kontroller2 v_1_';
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

%% check for dependencies 


% make the gui
handles = makeKontrollerGUI(VersionName);
