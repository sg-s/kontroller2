% dataRouter is a function that routes data from and to 
function DataRouter(src,event)
global handles

if strcmp(event.EventName,'DataRequired')
    PollManualControl(src,event);
elseif strcmp(event.EventName,'DataAvailable')
    UpdateScopes(src,event);
end