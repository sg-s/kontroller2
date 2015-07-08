% dataRouter is a function that routes data from and to 
function DataRouter(src,event)
global handles

if strcmp(event.EventName,'DataRequired')
    WriteBuffer = PollManualControl(src,event);
    
    binary_dump_handle2 = getappdata(handles.f1,'binary_dump_handle2');
    if isempty(binary_dump_handle2)
        % no need to save this shit
    else
        % save this shit
        fwrite(binary_dump_handle2,WriteBuffer','double');
       
    end
    
elseif strcmp(event.EventName,'DataAvailable')
    UpdateScopes(src,event);
    
    % see if we need to stream data to file
    binary_dump_handle = getappdata(handles.f1,'binary_dump_handle');
    
    if isempty(binary_dump_handle)
        % no need to save this shit
    else
        % save this shit
        d = [event.Data event.TimeStamps]';
        fwrite(binary_dump_handle,d,'double');
       
    end
    
end