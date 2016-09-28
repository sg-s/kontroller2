% kontroller2 plugin
% manual-control
%
%
% changeSliderBounds.m
% changes the bounds of manual control sliders based on text edit fields above or below slider. 
% 
% created by Srinivas Gorur-Shandilya at 5:29 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function changeSliderBounds(k,src,~)

if any (k.handles.manual_control.slider_lb == src)
    new_value = str2double(get(src,'String'));
    if isnan(new_value)
        return
    else
        if new_value < get(k.handles.manual_control.sliders(k.handles.manual_control.slider_lb == src),'Max')
        else
            new_value = get(k.handles.manual_control.sliders(k.handles.manual_control.slider_lb == src),'Max') - 1;   
            set(src,'String',mat2str(new_value));
        end
        set(k.handles.manual_control.sliders(k.handles.manual_control.slider_lb == src),'Min',new_value);
    end
elseif any (k.handles.manual_control.slider_ub == src)
    new_value = str2double(get(src,'String'));
    if isnan(new_value)
        return
    else
        if new_value > get(k.handles.manual_control.sliders(k.handles.manual_control.slider_ub == src),'Min')
        else
            new_value = get(k.handles.manual_control.sliders(k.handles.manual_control.slider_ub == src),'Min') + 1;
            set(src,'String',mat2str(new_value));
        end
        set(k.handles.manual_control.sliders(k.handles.manual_control.slider_ub == src),'Max',new_value);
    end
else
    % wtf? ignore
end