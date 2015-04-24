function [] = RefreshScopes(src,event)
global handles

nsamples = str2double(get(src,'String'));
if isnan(nsamples)
    nsamples = 1000;
end

for i = 1:length(handles.plot_data)
    set(handles.plot_data(i),'XData',NaN(nsamples,1),'YData',NaN(nsamples,1));
end