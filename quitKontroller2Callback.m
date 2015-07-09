% quitKontroller2Callback
% callback on attempting to close kontroller2 main windows. 
% 
% created by Srinivas Gorur-Shandilya at 5:30 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function quitKontroller2Callback(src,event)
global handles
selection = questdlg('Are you sure you want to quit Kontroller?','Confirm quit.','Yes','No','Yes'); 
switch selection, 
  case 'Yes',
        s = getappdata(handles.f1,'s');
        s.stop;
        figHandles = findobj('Type','figure');
        delete_me = [];
        for i = 1:length(figHandles)
            if any(strfind(figHandles(i).Name,'Kontroller2'))
                delete_me = [delete_me i];
            end
        end
        delete(figHandles(delete_me));
  case 'No'
  return 
end
end