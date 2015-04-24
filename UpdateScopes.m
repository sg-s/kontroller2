function [] = UpdateScopes(~,event)

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
