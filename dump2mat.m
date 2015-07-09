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
    error('error in dump2mat: input.k2 not found. Data will not be properly saved, though you can manually recover the data from the binary dump, if it is exists.')
end

data_dump = fread(f,'double');
data_dump = reshape(data_dump,nchannels+1,length(data_dump)/(nchannels+1))'; % remember, the last row is the timestamp
fclose(f);

f = fopen('output.k2','r');
if f < 0
    error('error in dump2mat: output.k2 not found. Data will not be properly saved, though you can manually recover the data from the binary dump, if it is exists.')
end
control_signals = fread(f,'double');
control_signals = reshape(control_signals,mchannels,length(control_signals)/(mchannels))'; % remember, the last row is the timestamp
fclose(f);


if isempty(path_name)
    path_name = 'c:\data\';
end

if exist([path_name file_name]) == 2
    % file exists. load and append new data
    load([path_name file_name]);
    
    temp = fieldnames(data);
    eval(strcat('load_here=length(data.',temp{1},')+1;'))
    
    % add the data
    for i = 1:length(input_channels)
        if ~strcmp(input_channels{i},'Ground')
            eval(strcat('data.',input_channels{i},'{',mat2str(load_here),'}=data_dump(:,i);'));
        end
    end
    
    % add the timestamps too
    data.TimeStamps{load_here} = data_dump(:,end);
    
    % now add the control signals
    for i = 1:length(output_channels)
        eval(strcat('data.control_',output_channels{i},'{',mat2str(load_here),'}=control_signals(:,i);'));
    end
    
    % save the data
    save([path_name file_name],'data','-append')
    
    
else
    % file does not exist
    load_here = 1;
    % prepare the data structure
    for i = 1:length(input_channels)
        eval(strcat('data.',input_channels{i},'={};'))
    end
    % dont forget the timestamps
    data.TimeStamps = {};
    % remove the ground because we dont save it
    data = rmfield(data,'Ground');
    data = orderfields(data);
    
    % add the data
    for i = 1:length(input_channels)
        if ~strcmp(input_channels{i},'Ground')
            eval(strcat('data.',input_channels{i},'{1}=data_dump(:,i);'));
        end
    end
    
    % add the timestamps too
    data.TimeStamps{1} = data_dump(:,end);
    
    for i = 1:length(output_channels)
        eval(strcat('data.control_',output_channels{i},'{',mat2str(load_here),'}=control_signals(:,i);'));
    end
    
    % save the data
    save([path_name file_name],'data')
    
end

% delete the dump after you're done

