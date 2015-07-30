% samplingRateCallback.m
% callback for text box on sampling rate box
% 
% created by Srinivas Gorur-Shandilya at 9:53 , 30 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = samplingRateCallback(src,~)

global handles

w = get(src,'String');
w = str2double(w);
if ~isnan(w)
	cache('SamplingRate',[]);
	cache('SamplingRate',w);
else
	beep;
	set(src,'String',1000);
end
