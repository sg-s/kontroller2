% callback function when user interacts with the configureInput window

function k = inputConfigCallback(k,src,event)
    
	% check it's OK
	s = cleanString(src.String);

	k.input_channel_names{find(strcmp(k.input_channels,src.Tag))} = s;


end 