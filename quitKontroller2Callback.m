function QuitKontroller2Callback(src,event)

selection = questdlg('Are you sure you want to quit Kontroller?','Confirm quit.','Yes','No','Yes'); 
switch selection, 
  case 'Yes',
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