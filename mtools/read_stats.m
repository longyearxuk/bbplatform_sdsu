% a matlab file to read station names from a formatted station list file

% input
%  fname: filename
%  hdln: headline numbers
%  clmn: column number for STATs
% output
%  STATs: station names

function [STATs] = read_stats(fname, hdln, clmn)

  fid = fopen(fname, 'r');

  % generate empty string array
  STATs = "";
  i = 1;	% initiate line marker

  % read header lines
  for j = 1:hdln
    hline = fgetl(fid);
  end

  % read STATs as strings
  while ~feof(fid)
    cline = fgetl(fid);
    ctext = split(cline);
    STATs(i) = ctext{clmn};
    i = i+1;
  end

  fclose(fid);

end	% end function
