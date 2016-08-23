%% saveKontrollerState
% saves the current state of kontroller (by saving the entire object) in the current working directory
function saveKontrollerState(k)

k.handles = [];
k.daq_handle = [];
save('current_state.k2','k');
