% dump2mat.m
% this is part of kontroller2.m
% dump2mat reads the dump file (dump.bin) and appends the data there to the
% data structure in a mat file. 

function [] = dump2mat(variable_names,PathName,FileName)
nchannels = length(variable_names);
f = fopen('dump.bin','r');
if f < 0
    error('error in dump2mat: dump not found. Data will not be properly saved, though you can manually recover the data from the binary dump, if it is exists.')
end

d = fread(f,'double');
d = reshape(d,nchannels+1,length(d)/(nchannels+1))'; % remember, the last row is the timestamp

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
    
    % save the data
    save([PathName FileName],'data')
    
end

% delete the dump after you're done

