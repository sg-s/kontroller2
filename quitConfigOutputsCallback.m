% quitConfigOutputsCallback.m
% callback on closing the configure outputs windows. 
% 
% created by Srinivas Gorur-Shandilya at 5:30 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function quitConfigOutputsCallback(~,~)
global handles
try
    delete(handles.ConfigureOutputsFigure); 
catch
end
try
    delete(handles.ConfigureDigitalOutputsFigure);
catch
end
