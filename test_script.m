% test script, used for development

delete('current_state.k2')

cd('c:\')
try
	rmdir('c:\code\kontroller2\','s')
catch
end
copyfile('\\tsclient\kontroller2\','c:\code\kontroller2\')
cd('c:\code\kontroller2\')

clear all
close all
rehash


k = kontroller2;
k.sampling_rate = 10000;

k.input_channel_names{3} = 'Test_1_In';
k.input_channel_names{4} = 'Test_2_In';

k.output_channel_names{3} = 'Test_1_Out';
k.output_channel_names{4} = 'Test_2_Out';

k.output_digital_channel_names{3} = 'digt_test';

k.control_mode = 'manual-control';
k.data_path = 'c:\data\kontroller2_test.k2data';


k.showScopes;
k.showManualControl;