% changeSliderBounds.m
% changes the bounds of manual control sliders based on text edit fields above or below slider. 
% 
% created by Srinivas Gorur-Shandilya at 5:29 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function changeSliderBounds(src,~)
global handles
if any (handles.ManualControlSliderLB == src)
    new_value = str2double(get(src,'String'));
    if isnan(new_value)
        return
    else
        if new_value < get(handles.ManualControlSliders(handles.ManualControlSliderLB == src),'Max')
        else
            new_value = get(handles.ManualControlSliders(handles.ManualControlSliderLB == src),'Max') - 1;   
            set(src,'String',mat2str(new_value));
        end
        set(handles.ManualControlSliders(handles.ManualControlSliderLB == src),'Min',new_value);
    end
elseif any (handles.ManualControlSliderUB == src)
    new_value = str2double(get(src,'String'));
    if isnan(new_value)
        return
    else
        if new_value > get(handles.ManualControlSliders(handles.ManualControlSliderUB == src),'Min')
        else
            new_value = get(handles.ManualControlSliders(handles.ManualControlSliderUB == src),'Min') + 1;
            set(src,'String',mat2str(new_value));
        end
        set(handles.ManualControlSliders(handles.ManualControlSliderUB == src),'Max',new_value);
    end
else
    % wtf? ignore
end