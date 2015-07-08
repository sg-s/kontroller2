function ChangeSliderBounds(src,~)
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