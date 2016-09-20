% callback function when user interacts with the configureOutputs window
% this makes sure that the underlying kontroller objects updates to match what the user enters in the UI
function k = outputConfigCallback(k,src,event)
    
	if k.verbosity > 5
		disp('outputConfigCallback called')
	end

	% check it's OK
	s = cleanString(src.String);


	if any(strfind(src.Tag,'ao'))
		% this is a analogue output
		k.output_channel_names{find(strcmp(k.output_channels,src.Tag))} = s;
	else
		% this should be a digital output
		k.output_digital_channel_names{find(strcmp(k.output_digital_channels,src.Tag))} = s;
	end


	k.reconfigureSession;

end 