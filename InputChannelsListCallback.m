function InputChannelsListCallback(src,event)

global handles

% check if # of requested input channels differs from the # of subplots
poss_axes = get(handles.scope_fig,'Children');
nplots = 0;
for i = 1:length(poss_axes)
    if strcmp(class(poss_axes(i)),'matlab.graphics.axis.Axes')
        nplots=  nplots+1;
    end
end
if nplots == length(get(handles.InputChannelsList,'Value'))
    return
end

% wipe all the subplots in scope_fig
poss_axes = get(handles.scope_fig,'Children');
delete_me = [];
for i = 1:length(poss_axes)
    if strcmp(class(poss_axes(i)),'matlab.graphics.axis.Axes')
        delete_me = [delete_me i];
    end
end
delete(poss_axes(delete_me));


% make as many plots as requested
nplots = length(get(handles.InputChannelsList,'Value'));
handles.scope_plots = [];
figure(handles.scope_fig)
for i = 1:nplots
    handles.scope_plots(i) = autoplot(nplots,i);
    handles.plot_data(i) = plot(NaN,NaN);
    set(handles.plot_data(i),'XData',NaN(str2double(get(handles.scope_NSamples,'String')),1),'YData',NaN(str2double(get(handles.scope_NSamples,'String')),1));
    
end