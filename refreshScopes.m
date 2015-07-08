% refreshScopes
% plots new data to the scopes by rewriting pre-allocated data on a graph
% 
% created by Srinivas Gorur-Shandilya at 5:36 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = refreshScopes(src,event)
global handles

nsamples = str2double(get(src,'String'));
if isnan(nsamples)
    nsamples = 1000;
end

for i = 1:length(handles.plot_data)
    set(handles.plot_data(i),'XData',NaN(nsamples,1),'YData',NaN(nsamples,1));
end