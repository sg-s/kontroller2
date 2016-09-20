%% plugins.m
% shows the installed plugins with associated methods
% 
function p = plugins(k)

p.name = '';
p.A_listeners = '';
p.R_listeners = '';
p.method_names = {};
p(1) = [];

if ~nargout
    disp('The following plugins for kontroller have been installed:')
end

m = dir([fileparts(which(mfilename)) oss '*.m']);

for i = 1:length(m)
    % read the file
    t = lineRead([fileparts(which(mfilename)) oss m(i).name]);

    if ~any(strfind(t{1},'kontroller2 plugin'))
        continue
    end

    
    name = strtrim(strrep(t{2},'%',''));
    if any(find(strcmp({p.name},name)))
        c = find(strcmp({p.name},name));
    else
        c = length(p)+1;
        p(c).name = name;
    end
    event_trigger = strtrim(strrep(t{3},'%',''));
    if any(strfind(event_trigger,'dataAvailable'))
        p(c).A_listeners = m(i).name(1:end-2);
    end
    if any(strfind(event_trigger,'dataRequested'))
        p(c).R_listeners = m(i).name(1:end-2);
    end
    if isempty(event_trigger)
        p(c).method_names{length(p(c).method_names)+1} = m(i).name(1:end-2);
    end
end

if ~nargout
    for i = 1:length(p)
        if ~isempty(p(i).A_listeners) && isempty(p(i).R_listeners)
            disp(['+ ' p(i).name '  (triggered by: dataAvailable)'])
        elseif isempty(p(i).A_listeners) && ~isempty(p(i).R_listeners)
            disp(['+ ' p(i).name '  (triggered by: dataRequested)'])
        else
            disp(['+ ' p(i).name '  (triggered by: dataAvailable, dataRequested)'])
        end
        for j = 1:length(p(i).method_names)
            disp(['-> ' p(i).method_names{j}])
        end
    end
end
