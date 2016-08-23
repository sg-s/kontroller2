%% kontroller2
% complete rewrite of the kontroller package based on a class-based interface

classdef kontroller2 < handle

    properties
        sampling_rate = 1e4; % Hz
        version_name = 'automatically-generated';
        daq_handle
        session_handle

        plugins



        % hardware defined names of channels
        output_channels 
        input_channels
        input_channel_ranges
        output_digital_channels

        % user defined names for channels
        output_channel_names = {};
        input_channel_names = {};
        output_digital_channel_names = {};

        % UI
        handles % a structure that handles everything else

        % debug
        verbosity = 10;

    end % end properties 

    methods
        function k = kontroller2(k)

            % check that the plugins folder is on the path
            addpath([fileparts(fileparts(which(mfilename))) oss 'plugins']);

            % get a list of plugins 

            assert(ispc,'kontroller2 only works on Windows, because the DAQ toolbox only works on Windows.')

            %% check for MATLAB dependencies
            v = ver;
            v = struct2cell(v);
            j = find(strcmp('Data Acquisition Toolbox', v), 1);
            assert(~isempty(find(strcmp('Data Acquisition Toolbox', v), 1)),'kontroller needs the <a href="http://www.mathworks.com/products/daq/">DAQ toolbox</a> to run, which was not detected. ')

            % is there already a saved version? 
            if exist('current_state.k2','file') == 2
                load('current_state.k2','-mat')
            end

            opt.Input = 'file';
            k.version_name = dataHash(fileparts(which(mfilename)),opt);
            clear opt
            disp(['kontroller version: ' k.version_name])

            if ~nargout
                warning('kontroller2 called without assigning to a object. kontroller2 will create an object called "k" in the workspace')
                assignin('base','k',k);
            end

            try
                k.daq_handle = daq.getDevices;
            catch
                error('Error reading DAQ devices. Do you have a NI device? Drivers installed? The DAQ toolbox installed?')
            end

            disp(['Using device: ' k.daq_handle(1).Model])


            try
                k.input_channels =  k.daq_handle(1).Subsystems(1).ChannelNames;
                k.input_channel_ranges = 10*ones(length(k.input_channels),1);
                k.output_channels =  k.daq_handle(1).Subsystems(2).ChannelNames;
                k.output_digital_channels = k.daq_handle(1).Subsystems(3).ChannelNames;
            catch
                error('Something went wrong when trying to talk to the NI device. This is probably the hardware is reserved by something else. Try restarting MATLAB.')
            end

            % make sure the output and input channel names are correctly sized
            if length(k.output_channel_names) < length(k.output_channels)
                k.output_channel_names = repmat({''},length(k.output_channels),1);
            end

            if length(k.input_channel_names) < length(k.input_channels)
                k.input_channel_names = repmat({''},length(k.input_channels),1);
            end

            if length(k.output_digital_channel_names) < length(k.output_digital_channels)
                k.output_digital_channel_names = repmat({''},length(k.output_digital_channels),1);
            end

            


            % start a session
            k.session_handle = daq.createSession('ni');
            k.session_handle.Rate = k.sampling_rate;
            reconfigureSession(k)



        end % end creation function

        function k = configureInputs(k)
            k = makeConfigureInputsUI(k);

        end % end configureInputs

        function k = configureOutputs(k)
            k = makeConfigureOutputsUI(k);
        end


        function delete(k)

            release(k.session_handle)

            % save everything
            saveKontrollerState(k);

            delete(k)
        end

        function k = set.sampling_rate(k,value)
            assert(isint(value),'Sampling rate must be an integer')
            assert(value>0,'Sampling rate must be positive')
            assert(value<1e5,'Sampling Rate must be below 100kHz')
            assert(~isnan(value),'Sampling Rate must be an integer')
            assert(~isinf(value),'Sampling Rate must be an finite integer')
            k.sampling_rate = value;
            k.session_handle.Rate = k.sampling_rate;
        end % end set sampling_rate

        function k = set.input_channel_names(k,value)
            % first, assign it and get that out of the way
            k.input_channel_names = value;
            reconfigureSession(k);
        end


    end % end methods

end % end classdef