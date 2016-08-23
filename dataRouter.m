% dataRouter
% dataRouter is a function that routes data from and to 
% kontroller 
% 
% 
% created by Srinivas Gorur-Shandilya at 5:32 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function dataRouter(src,event)
global handles

if strcmp(event.EventName,'DataRequired')
    error('not coded')
    % WriteBuffer = pollManualControl(src,event);
    
    % output_dump_handle = getappdata(handles.f1,'output_dump_handle');
    % if isempty(output_dump_handle)
    %     % no need to save this shit
    % else
    %     % save this shit
    %     fwrite(output_dump_handle,WriteBuffer','double');
       
    % end
    % disp(datestr(now))
    
elseif strcmp(event.EventName,'DataAvailable')
    updateScopes(src,event);
    
    % see if we need to stream data to file
    input_dump_handle = getappdata(handles.f1,'input_dump_handle');
    
    if isempty(input_dump_handle)
        % no need to save this shit
    else
        % save this shit
        d = [event.Data event.TimeStamps]';
        fwrite(input_dump_handle,d,'double');
       
    end
    
end