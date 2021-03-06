%% kontroller2
% MATLAB class 

classdef kontroller2 < handle & matlab.mixin.CustomDisplay

    properties
        % meta
        version_name = 'automatically-generated';
        build_number = 'automatically-generated';

        % DAQ-specific
        sampling_rate = 1e4; % Hz
        daq_handle
        session_handle

        % operations
        control_mode
        save_data = true;
        data_path
        last_timestamp_logged = 0;
        data = []; % stores the data, in kontroller2 format 
        last_outputs_written % stores values of the output channels, when last written to

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

    methods (Access = protected)
        function displayScalarObject(k)
            url = 'https://github.com/sg-s/kontroller2/';
            fprintf(['<a href="' url '">kontroller</a> object']);
            fprintf([' (build ' k.build_number ')\n'])
            fprintf(['[+] connected to ' k.daq_handle.Description '\n'])
            fprintf(['[+] sampling rate is ' oval(k.sampling_rate) ' samples/sec\n'])

            fprintf('\n')
            cprintf('_text',  'Output Channels:\n');
            for i = 1:length(k.output_channel_names)
                if ~isempty(k.output_channel_names{i})
                    fprintf(['[' k.output_channels{i} ']            ' k.output_channel_names{i} '\n'])
                end
            end
            for i = 1:length(k.output_digital_channel_names)
                if ~isempty(k.output_digital_channel_names{i})
                    fprintf(['[' k.output_digital_channels{i} ']    ' k.output_digital_channel_names{i} '\n'])
                end
            end

            fprintf('\n')
            cprintf('_text',  'Input Channels:\n');
            for i = 1:length(k.input_channel_names)
                if ~isempty(k.input_channel_names{i})
                    fprintf(['[' k.input_channels{i} ']            ' k.input_channel_names{i} '\n'])
                end
            end

            fprintf('\n')
            plugins(k)
            

        end % end displayScalarObject
   end % end protected methods

    methods
        function k = kontroller2

            % get the build_number
            k.build_number = ['v' strtrim(fileread([fileparts(fileparts(which(mfilename))) oss 'build_number']))];

            assert(ispc,'[ERR] kontroller2 only works on Windows, because the DAQ toolbox only works on Windows.')

            % make sure a kontroller object doesn't already exist
            base_var = evalin('base','whos'); 
            assert(~any(find(strcmp('kontroller2',{base_var.class}))),'[ERR] kontroller2 objects exist on the base workspace. Make sure you clear them from the workspace before initializing a new kontroller2 object')

            %% check for MATLAB dependencies
            v = ver;
            v = struct2cell(v);
            assert(~isempty(find(strcmp('Data Acquisition Toolbox', v), 1)),'[ERR] kontroller needs the <a href="http://www.mathworks.com/products/daq/">DAQ toolbox</a> to run, which was not detected. ')

            % is there already a saved version? 
            if exist('current_state.k2','file') == 2
                try
                    load('current_state.k2','-mat');
                catch er
                    if strcmp(er.identifier,'MATLAB:load:unableToReadMatFile')
                        cprintf('red','[WARN] ')
                        fprintf('Corrupted .k2 file, deleting...\n')
                        delete('current_state.k2')
                    else
                        cprintf('red','[WARN] ')
                        fprintf('kontroller2 could not load the current_state.k2 file for some reason.\n')
                    end
                end
            end


            opt.Input = 'file';
            k.version_name = dataHash(fileparts(which(mfilename)),opt);
            clear opt
            cprintf('green', '[INFO] ')
            cprintf('text',['kontroller version: ' k.version_name '\n'])

            if ~nargout
                cprintf('red','[WARN] ')
                cprintf('text','kontroller2 called without assigning to a object. kontroller2 will create an object called "k" in the workspace\n')
                assignin('base','k',k);
            end

            try
                k.daq_handle = daq.getDevices;
            catch
                error('[ERR] Error reading DAQ devices. Do you have a NI device? Drivers installed? The DAQ toolbox installed?')
            end

            cprintf('green','[INFO] ')
            cprintf('text',['Using device: ' k.daq_handle(1).Model '\n'])


            try
                k.input_channels =  k.daq_handle(1).Subsystems(1).ChannelNames;
                k.input_channel_ranges = 10*ones(length(k.input_channels),1);
                k.output_channels =  k.daq_handle(1).Subsystems(2).ChannelNames;
                k.output_digital_channels = k.daq_handle(1).Subsystems(3).ChannelNames;
            catch
                error('[ERR]  Something went wrong when trying to talk to the NI device. This is probably the hardware is reserved by something else. Try restarting MATLAB.')
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
                cprintf('green','[INFO] ')
                cprintf('text','kontroller2 -> delete called \n')
            end

            if ~isempty(k.session_handle)
                release(k.session_handle);
            end

            % save everything
            saveKontrollerState(k);

            % make sure there are no dumps on disk
            wipeDumps(k);

            delete(k)
        end


        function k = set.control_mode(k,value)
            k.control_mode = value;
            k.reconfigureSession;
        end

        function k = set.sampling_rate(k,value)
            assert(isint(value),'[ERR] Sampling rate must be an integer')
            assert(value>0,'[ERR] Sampling rate must be positive')
            assert(value<1e5,'[ERR] Sampling Rate must be below 100kHz')
            assert(~isnan(value),'[ERR] Sampling Rate must be an integer')
            assert(~isinf(value),'[ERR] Sampling Rate must be an finite integer')
            k.sampling_rate = value;
            k.session_handle.Rate = k.sampling_rate;
        end % end set sampling_rate

        function k = set.input_channel_names(k,value)

            % make sure that name is not already reserved 
            all_names = [k.output_channel_names; value];
            all_names = all_names(~cellfun(@isempty,all_names));
            assert(numel(unique(all_names)) == numel(all_names), '[ERR] Non unique input or output channel names. All names have to be unique.')

            % first, assign it and get that out of the way
            k.input_channel_names = value;

            % figure out who's calling
            v = dbstack;
            if any(strcmp('inputConfigCallback',{v.name}))
                reconfigureSession(k);
            end
        end

        function k = set.output_channel_names(k,value)

            % make sure that name is not already reserved 
            all_names = [k.input_channel_names; value];
            all_names = all_names(~cellfun(@isempty,all_names));
            assert(numel(unique(all_names)) == numel(all_names), '[ERR] Non unique input or output channel names. All names have to be unique.')

            % first, assign it and get that out of the way
            k.output_channel_names = value;

            % figure out who's calling
            v = dbstack;
            if any(strcmp('outputConfigCallback',{v.name}))
                reconfigureSession(k);
            end
        end

        function k = start(k)
            cprintf('green','[INFO] ');
            cprintf('text','Starting acquisition...\n');

            % make sure there are no dumps on disk
            wipeDumps(k);

            % generate handles for input and output dumps
            k.handles.input_dump = fopen('input.k2','W');
            k.handles.output_dump = fopen('output.k2','W');
 
            % check if data is queued, and queue if needed
            noutputs = sum(~(cellfun(@any,(cellfun(@(x) strfind(x,'ai'),{k.session_handle.Channels.ID},'UniformOutput',false)))));
            if k.session_handle.ScansQueued == 0 && noutputs > 0
                write_buffer = repmat(k.last_outputs_written,k.session_handle.NotifyWhenScansQueuedBelow,1);
                queueOutputData(k.session_handle,write_buffer);
            end

            k.session_handle.startBackground;
        end % end start

        function k = stop(k)
            cprintf('green','[INFO] ')
            cprintf('text','Stopping acquisition...\n')
            k.session_handle.stop;

            % close the dump files
            fclose(k.handles.input_dump);
            fclose(k.handles.output_dump);

            % remember the last values we wrote to the device
            k =  determineLastOutputsWritten(k);

            % if a data_path is configured, convert the dump into a .k2data file 
            if isempty(k.data_path)
                % don't save dump
                cprintf('red','[WARN] ')
                cprintf('text','No data_path configured, discarding data dump...\n')
            else
                cprintf('green','[INFO] ')
                cprintf('text','Assembling data dump into a .k2data file...\n')
                dump2mat(k)
            end


        end % end stop


    end % end methods

end % end classdef
