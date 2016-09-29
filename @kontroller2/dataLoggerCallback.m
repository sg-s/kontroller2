% kontroller2 plugin
% data-logger
% DataAvailable
% 

function [] = dataLoggerCallback(k,~,event)

D = event.Data;
T = event.TimeStamps;

x = find(T > k.last_timestamp_logged,1,'first');
fwrite(k.handles.input_dump, [D(x:end,:) T(x:end)]','double');
k.last_timestamp_logged = max(T);