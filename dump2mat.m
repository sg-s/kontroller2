% dump2mat.m
% dump2mat reads the dump file (e.g. output.k2) and appends the data there to the data structure in a mat file. 
% 
% 
% created by Srinivas Gorur-Shandilya at 5:32 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = dump2mat()
global handles

% get the number of input and output channels
input_channels = get(handles.InputChannelsList,'String');
output_channels = get(handles.OutputChannelsList,'String');
path_name = getappdata(handles.f1,'path_name');
file_name = getappdata(handles.f1,'file_name');
nchannels = length(input_channels);
mchannels = length(output_channels);

f = fopen('input.k2','r');
if f < 0
    error('error in dump2mat: dump not found. Data will not be properly saved, though you can manually recover the data from the binary dump, if it is exists.')
end

dump = fread(f,'double');
dump = reshape(dump,nchannels+1,length(dump)/(nchannels+1))'; % remember, the last row is the timestamp
fclose(f);

keyboard
mchannels = length(control_signals);
f = fopen('dump2.bin','r');
if f < 0
    error('error in dump2mat: dump2 not found. Data will not be properly saved, though you can manually recover the data from the binary dump, if it is exists.')
end
ControlSignals = fread(f,'double');
ControlSignals = reshape(ControlSignals,mchannels,length(ControlSignals)/(mchannels))'; % remember, the last row is the timestamp
fclose(f);


if isempty(PathName)
    PathName = 'c:\data\';
end

if exist([PathName FileName]) == 2
    % file exists. load and append new data
    load([PathName FileName]);
    
    temp = fieldnames(data);
    eval(strcat('load_here=length(data.',temp{1},')+1;'))
    
    % add the data
    for i = 1:length(variable_names)
        if ~strcmp(variable_names{i},'Ground')
            eval(strcat('data.',variable_names{i},'{',mat2str(load_here),'}=d(:,i);'));
        end
    end
    
    % add the timestamps too
    data.TimeStamps{load_here} = d(:,end);
    
    
    disp('need to add dump2')
    keyboard
    
    % save the data
    save([PathName FileName],'data','-append')
    
    
else
    % file does not exist
    % prepare the data structure
    for i = 1:length(variable_names)
        eval(strcat('data.',variable_names{i},'={};'))
    end
    % dont forget the timestamps
    data.TimeStamps = {};
    % remove the ground because we dont save it
    data = rmfield(data,'Ground');
    data = orderfields(data);
    
    % add the data
    for i = 1:length(variable_names)
        if ~strcmp(variable_names{i},'Ground')
            eval(strcat('data.',variable_names{i},'{1}=d(:,i);'));
        end
    end
    
    % add the timestamps too
    data.TimeStamps{1} = d(:,end);
    
    disp('need to add dump2')
    keyboard
    
    % save the data
    save([PathName FileName],'data')
    
end

% delete the dump after you're done

