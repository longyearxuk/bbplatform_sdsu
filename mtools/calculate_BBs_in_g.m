function [gE, gN, npts, dt] = calculate_BBs_in_g(infilename)

    INP = load(infilename);
    dt = INP(2,1)-INP(1,1);
    nt = size(INP,1);
    
    % velocity [m/s] to [m/s/s] to [g]
    [accN] = vel2acc(INP(:,2), dt); % NS
    [accE] = vel2acc(INP(:,3), dt); % EW
%    [accZ] = vel2acc(INP(:,4), dt);
    
%% test plots comparison fabio's ID.sta.acc.bbp and accE/N/Z
%     a = round(25/dt);
%     t = INP(:,1);
%     if n < 2
%         WDIR = ('../from_fabio/test_bb4/tmpdata/BBs_acc');
%         wname = files(4:size(files,2)-4);
%         wfilename = sprintf('%s/9368988.%s.acc.bbp',WDIR,wname);
%         wacc = load(wfilename); % [cm/s/s]
%         figure(n)
%         subplot(311);plot(t(1:a),wacc(1:a,3)/100);hold on;plot(t(1:a),accE(1:a),'r');
%         title(sprintf('station: %s in [m/s/s]  (blue=BBPlatform, red=SDSU)',wname));
%         subplot(312);plot(t(1:a),wacc(1:a,2)/100);hold on;plot(t(1:a),accN(1:a),'r');
%         subplot(313);plot(t(1:a),wacc(1:a,4)/100);hold on;plot(t(1:a),accZ(1:a),'r');
%         
%     end
% end
%% 
    gE = accE/9.82;
    gN = accN/9.82;
%    gZ = accZ/9.82;
    
    % reshape into 5 columns
    npts = floor(nt/5)*5;
    
end
