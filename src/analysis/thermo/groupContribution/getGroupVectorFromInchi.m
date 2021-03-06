function group_def = getGroupVectorFromInchi(inchi, silent, debug)
% USAGE:
%
%    group_def = getGroupVectorFromInchi(inchi, silent, debug)
%
% INPUTS:
%    inchi:
%    silent:
%    debug:     0: No verbose output,
%               1: Progress information only (no warnings),
%               2: Progress and warnings
%
% OUTPUT:
%    group_def:

if nargin < 2
    silent = true;
end

if isempty(inchi)
    group_def = [];
    return;
end

fullpath = which('getGroupVectorFromInchi.m');
fullpath = regexprep(fullpath,'getGroupVectorFromInchi.m','');

if silent
    cmd = ['python2 ' fullpath 'inchi2gv.py -s -i '];
else
    cmd = ['python2 ' fullpath 'inchi2gv.py -i '];
end

if ~ispc
    [rval, group_def] = system([cmd, '"', inchi, '"']);
else
    [rval, group_def] = system([cmd, inchi]);
end

if rval == 0 % && ~strcmp('Traceback', group_def(1:9))
    group_def = regexp(group_def,'(\d+,\s){162}\d+','match');
    if ~isempty(group_def)
        group_def = group_def{:};
        group_def = regexp(group_def, ',', 'split');
        group_def = group_def(~cellfun('isempty',group_def));
        group_def = str2double(group_def);
    else
        group_def = [];
    end
else
    if debug > 1
        fprintf('%s\n',['Warning: getGroupVectorFromInchi did not succeed for: ' inchi])
    end
    group_def = [];
end
