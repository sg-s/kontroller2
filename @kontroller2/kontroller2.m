%% kontroller2
% complete rewrite of the kontroller package based on a class-based interface

classdef kontroller2 < handle

    properties
        version_name = 'automatically-generated';
        build_number = 'automatically-generated if you have git installed';

        % DAQ-specific
        sampling_rate = 1e4; % Hz
        daq_handle
        session_handle

        control_mode

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
        function k = kontroller2

            % get the build_number
            k.build_number = ['v' strtrim(fileread([fileparts(fileparts(which(mfilename))) oss 'build_number']))];

            assert(ispc,'kontroller2 only works on Windows, because the DAQ toolbox only works on Windows.')

            % make sure a kontroller object doesn't already exist
            base_var = evalin('base','whos'); 
            assert(~any(find(strcmp('kontroller2',{base_var.class}))),'kontroller2 objects exist on the base workspace. Make sure you clear them from the workspace before initializing a new kontroller2 object')

            %% check for MATLAB dependencies
            v = ver;
            v = struct2cell(v);
            assert(~isempty(find(strcmp('Data Acquisition Toolbox', v), 1)),'kontroller needs the <a href="http://www.mathworks.com/products/daq/">DAQ toolbox</a> to run, which was not detected. ')

            % is there already a saved version? 
            if exist('current_state.k2','file') == 2
                try
                    load('current_state.k2','-mat');
                catch er
                    if strcmp(er.identifier,'MATLAB:load:unableToReadMatFile')
                        disp('Corrupted .k2 file, deleting...')
                        delete('current_state.k2')
                    else
                        warning('kontroller2 could not load the current_state.k2 file for some reason.')
                    end
                end
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
            k.session_handle.IsContinuous = true;
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
            if k.verbosity > 5
                disp('kontroller2::delete called')
            end

            if ~isempty(k.session_handle)
                release(k.session_handle)
            end

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

            % make sure that name is not already reserved 
            all_names = [k.output_channel_names; value];
            all_names = all_names(~cellfun(@isempty,all_names));
            assert(numel(unique(all_names)) == numel(all_names), 'Non unique input or output channel names. All names have to be unique.')

            % first, assign it and get that out of the way
            k.input_channel_names = value;
            reconfigureSession(k);
        end

        function k = set.output_channel_names(k,value)

            % make sure that name is not already reserved 
            all_names = [k.input_channel_names; value];
            all_names = all_names(~cellfun(@isempty,all_names));
            assert(numel(unique(all_names)) == numel(all_names), 'Non unique input or output channel names. All names have to be unique.')

            % first, assign it and get that out of the way
            k.output_channel_names = value;
            reconfigureSession(k);
        end

        function k = start(k)
            k.session_handle.startBackground;
        end % end start

        function k = stop(k)
            k.session_handle.stop;
        end % end stop


    end % end methods

end % end classdef
