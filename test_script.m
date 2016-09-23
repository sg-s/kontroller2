% test script, used for development

clear all
close all
rehash

k = kontroller2;

k.input_channel_names{3} = 'PID';
k.input_channel_names{4} = 'Ground';
k.input_channel_names{4} = 'MFC1';
k.output_channel_names{1} = 'MFC1_control';