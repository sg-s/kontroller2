function [k] = determineLastOutputsWritten(k)

% get the number of output channels
noutputs = sum(~(cellfun(@any,(cellfun(@(x) strfind(x,'ai'),{k.session_handle.Channels.ID},'UniformOutput',false)))));


f = fopen('output.k2','r');
output_dump = fread(f,'double');
fclose(f);
output_dump = reshape(output_dump,noutputs,length(output_dump)/(noutputs))';

k.last_outputs_written = output_dump(end,:);