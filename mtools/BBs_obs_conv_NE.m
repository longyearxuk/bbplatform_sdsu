function [gE, gN, npts, dt] = BBs_obs_conv_NE(infilename)

% [modified by kxu4143 from calculate_BBs_in_g]
% 06/30/2021: generated file
%    main feature: transfer acc from [cm/s/s] to [g]

    % read data from file
    fid = fopen(infilename);
    fclose(infilename);
    SpecFormat = '%f%f%f%f'; 	% input 4 columns
    INP = cell2mat(textscan(fid,SpecFormat,'CommentStyle', '#'));

    dt = INP(2,1)-INP(1,1);
    nt = size(INP,1);
    
    % acc [cm/s/s] to [g]
    [accN] = INP(:,2); 	% NS
    [accE] = INP(:,3); 	% EW
 
    gE = accE/982;
    gN = accN/982;
    
    % reshape into 5 columns
    npts = floor(nt/5)*5;
    
end
