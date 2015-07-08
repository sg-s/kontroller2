% updateScopes
% rebuilds Scopes UI, adding or removing subplots as needed
% 
% created by Srinivas Gorur-Shandilya at 5:38 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = updateScopes(~,event)

% this plots new data to the scopes. 

global handles

plot_these = get(handles.InputChannelsList,'Value');
for i = 1:length(plot_these)
    temp = [handles.plot_data(i).YData(:); event.Data(:,plot_these(i))];
    temp(1:length(event.Data)) = [];
    temp2 = [handles.plot_data(i).XData(:); event.TimeStamps];
    temp2(1:length(event.Data)) = [];
    set(handles.plot_data(i),'YData',temp,'XData',temp2);
end
