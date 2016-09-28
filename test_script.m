% test script, used for development

clear all
close all
rehash

k = kontroller2;
k.sampling_rate = 1000;

k.input_channel_names{2} = 'MFC1_Flow';
k.input_channel_names{1} = 'Ground';
k.output_channel_names{2} = 'MFC1';
k.control_mode = 'manual-control';

k.showScopes;
k.showManualControl;