function QuitConfigOutputsCallback(~,~)
global handles
try
    delete(handles.ConfigureOutputsFigure); 
catch
end
try
    delete(handles.ConfigureDigitalOutputsFigure);
catch
end
