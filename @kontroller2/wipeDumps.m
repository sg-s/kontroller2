function [] = wipeDumps(k)

fclose('all')
if exist('input.k2','file') == 2
    delete('input.k2')
end
if exist('output.k2','file') == 2
    delete('output.k2')
end