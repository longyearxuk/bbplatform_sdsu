% read rd50 at a station
%
% imput
%   fname: filename
% output
%   SAs: rotD50
function [rd50] = read_rd50_2(fname,flag)

% T =  [0.010 0.011 0.012 0.013 0.015 0.017 0.020 0.022 0.025 ...
%       0.029 0.032 0.035 0.040 0.045 0.050 0.055 0.060 0.065 ...
%       0.075 0.085 0.100 0.110 0.120 0.130 0.150 0.170 0.200 ...
%       0.220 0.240 0.260 0.280 0.300 0.350 0.400 0.450 0.500 ...
%       0.550 0.600 0.650 0.750 0.850 1.000 1.100 1.200 1.300 ...
%       1.500 1.700 2.000 2.200 2.400 2.600 2.800 3.000 3.500 ...
%       4.000 4.400 5.000 5.500 6.000 6.500 7.500 8.500 10.000];
% T = T';

rd50(1:63) = NaN;

fid = fopen(fname, 'r');

 
% read header lines in rd50 file
for j = 1:4
    line1 = fgetl(fid);
end

% for rd50 from BBPlatform
if strcmp(flag,'BBP')

    % read rd50
    for j = 1:63
        line1 = fgetl(fid);
        cont1 = sscanf(line1, '%f');
        rd50(j) = cont1(4);
    end
    
elseif strcmp(flag,'LOC')
    
    % read rotd50 in sdsu local
    for j = 1:63
        line1 = fgetl(fid);
        cont1 = sscanf(line1, '%f');
        rd50(j) = cont1(2);
    end

end

fclose(fid);

end % endfunction
