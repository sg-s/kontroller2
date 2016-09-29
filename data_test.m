% test of different data formats 

ntrials = 20;
trial_length = floor(1e3 + 1e5*rand(ntrials,1));

% cell_data
disp('Testing cell data')
clear cell_data
cell_data.x{1} = [];
save('cell_data.mat','cell_data','-v7.3')
tic
for i = 1:ntrials
	textbar(i,ntrials)
	cell_data.x{i} = randn(trial_length(i),1);
	cell_data.y{i} = randn(trial_length(i),1);
	cell_data.z{i} = randn(trial_length(i),1);

	% save
	save('cell_data.mat','cell_data','-append')
end
toc

% structure array
disp('Testing structure data')
clear sdata
sdata(1).x = [];
save('sdata.mat','sdata','-v7.3')
tic
for i = 1:ntrials
	textbar(i,ntrials)
	sdata(i).x = randn(trial_length(i),1);
	sdata(i).y = randn(trial_length(i),1);
	sdata(i).z = randn(trial_length(i),1);

	% save
	save('sdata.mat','sdata','-append')
end
toc

delete('sdata.mat')
delete('cell_data.mat')
