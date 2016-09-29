% dump2mat.m
% dump2mat reads the dump file (e.g. output.k2) and appends the data there to the data structure in a mat file. 
% 
% 
% created by Srinivas Gorur-Shandilya at 5:32 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = dump2mat(k)

% get the number of input and output channels
ninputs = sum(cellfun(@any,(cellfun(@(x) strfind(x,'ai'),{k.session_handle.Channels.ID},'UniformOutput',false))));
noutputs = sum(~(cellfun(@any,(cellfun(@(x) strfind(x,'ai'),{k.session_handle.Channels.ID},'UniformOutput',false)))));

f = fopen('input.k2','r');
if f < 0
    cprintf('red','[INFO] ')
    cprintf('text','error in dump2mat: input.k2 not found. Data will not be properly saved, though you can manually recover the data from the binary dump, if it is exists.\n')
    return
end

input_dump = fread(f,'double');
fclose(f);
input_dump = reshape(input_dump,ninputs+1,length(input_dump)/(ninputs+1))';

f = fopen('output.k2','r');
if f < 0
    cprintf('red','[INFO] ')
    cprintf('text','error in dump2mat: output.k2 not found. Data will not be properly saved, though you can manually recover the data from the binary dump, if it is exists.\n')
    return
end

f = fopen('output.k2','r');
output_dump = fread(f,'double');
fclose(f);
output_dump = reshape(output_dump,noutputs,length(output_dump)/(noutputs))';

% offset 
signal_offset = k.session_handle.NotifyWhenScansQueuedBelow;
for i = 1:size(output_dump,2)
    output_dump(:,i) = circshift(output_dump(:,i),signal_offset);
end

% trim. just because it's in the output_dump doesn't mean it's been written -- it just means it's been queued. 
output_dump = output_dump(1:length(input_dump),:);

% assemble into the data field
c = length(k.data)+1;
use_these_names = k.output_channel_names(~cellfun(@isempty,k.output_channel_names));
for i = 1:length(use_these_names)
    k.data(c).(use_these_names{i}) = output_dump(:,i);
end
use_these_names = k.input_channel_names(~cellfun(@isempty,k.input_channel_names));
for i = 1:length(use_these_names)
    k.data(c).(use_these_names{i}) = input_dump(:,i);
end

data = k.data;
if exist(k.data_path,'file') == 2
    if k.verbosity > 5
        cprintf('green','[INFO] ')
        cprintf('text','Appending to existing data file...\n')
    end
    save(k.data_path,'data','-append');
else
    if k.verbosity > 5
        cprintf('green','[INFO] ')
        cprintf('text','Creating new data file...\n')
    end
    save(k.data_path,'data','-v7.3');
end

