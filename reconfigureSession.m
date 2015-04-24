function reconfigureSession(handles)
s = getappdata(handles.f1,'s');
d = getappdata(handles.f1,'d');
InputChannelNames = getappdata(handles.f1,'InputChannelNames');

w = str2double(get(handles.SamplingRateControl,'String'));
if isnan(w)
    warning('Invalid Sampling rate, will fall back to default of 1KHz')
    w = 1000;
end
s.Rate = w;
s.IsContinuous = true;

InputChannels = get(d.Subsystems(1),'ChannelNames');
if length(InputChannelNames)
    for i = 1:length(InputChannelNames)
        if ~isempty(InputChannelNames{i})
            s.addAnalogInputChannel('Dev1',InputChannels{i},'Voltage');
        end
    end
end

handles.dataListener = s.addlistener('DataAvailable',@DataRouter);
s.startBackground;


setappdata(handles.f1,'s',s);
