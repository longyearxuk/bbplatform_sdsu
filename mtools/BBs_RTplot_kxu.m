% [Modifications - by kxu4143]
% 06/04/2021: added Ridgecrest and changed some details:
%    BBdir = 'BBout_0604'
%    change DIR to EVEpath to save the whole path
%    change realnum format to 'rlz_xx'
%    moved the use of realnum into output path
%    added PLTdir to genegrate the directory
%    changed ave_dgm & ave_sgm ...
%      from (nstaxleng) matrices into (1xleng) array
% 06/04/2021: problem!
%    cannot find observed data for Ridgecrest-c and its rot50/rot100 files
%    'DDIR' is still incorrect!
% 06/30/2021: modified for the given observation data
%    modified EVEpath, BBdir, DATAdir, DDIR for obs data
%    modified the rd50 reading choices for obs data
% 07/01/2021:
%    re-arranged the path strings EVEpath & BBdir
%    re-arranged the PLTdir and pname to save pics together
% 08/10/2021:
%    added set(gcf, 'position') command to change the figure size
%    fixed the subplot(211) command to gca for single plots
% 08/13/2021:
%    added 2-input feature and calculate the ratios
%    cleared the unused features and read STATs from file

clear all;
close all;
set(0,'defaultaxesfontsize',13);

% stem names and I/O paths
EVENT	= 'Ridgecrestc';
RLZdir	= '/BBout_0728';	% path to compared rlzs
BSdir	= '/BBout_0728_rlz_00';	% path to baseline rlz
%
EVEpath	= '../sngl_rlz/ridgecrest19c';
%fSTAT = 'bbtstations_ridgecrest_c_v20_08_1.dat';
%
DATAdir	= [EVEpath];
PLTdir 	= [EVEpath '/figures'];
DDIR	= [DATAdir '/obs_data'];
TITLES = [EVENT ': Ratios'];
printname = [EVENT '_param_ratio'];
%
rlzs = 1;		% rlz start number
rlzc = 3;		% rlz counts for comparison

% --------------------------------------- %   
tic
% --------------------------------------- %   

% load station properties
fSTAT = 'station.list';
hSTAT = 13; cSTAT = 3;	% headlines and columns in STAT file
STATs = read_stats([EVEpath '/' fSTAT], hSTAT, cSTAT);
nsta=length(STATs);

load('ridgecrest_station_freq_range.mat');
Tmin = 1./Station_Freq_Range(:,2);
Tmax = 1./Station_Freq_Range(:,1);

% load psa properties (63 periods)
T =  [0.010 0.011 0.012 0.013 0.015 0.017 0.020 0.022 0.025 ...
      0.029 0.032 0.035 0.040 0.045 0.050 0.055 0.060 0.065 ...
      0.075 0.085 0.100 0.110 0.120 0.130 0.150 0.170 0.200 ...
      0.220 0.240 0.260 0.280 0.300 0.350 0.400 0.450 0.500 ...
      0.550 0.600 0.650 0.750 0.850 1.000 1.100 1.200 1.300 ...
      1.500 1.700 2.000 2.200 2.400 2.600 2.800 3.000 3.500 ...
      4.000 4.400 5.000 5.500 6.000 6.500 7.500 8.500 10.000];
T = T';
leng = length(T);

% --------------------------------------- %   
% read observation data    
% 'LOC' for 2-column ; 'BBP' for 4-column obs data 
dgmSA=zeros(nsta,leng);
for nn=1:nsta
  STAT=STATs{nn};
  dfilename=[DDIR '/'  STAT '.rd50'];
  [dgmSA(nn,1:leng)] = read_rd50_2(dfilename,'BBP');
end % end of data section
    
% start iterations through rlzs

mkdir (PLTdir);     	% generate the directory for plots
resMD=zeros(leng,rlzc);
resSA=zeros(leng,nsta);
for ii = rlzs : rlzs+rlzc-1

% record the rlz number
  if ii<10
    ii_str=['0' num2str(ii)];
  else
    ii_str=num2str(ii, '%02d');
  end
  realnum=['rlz_' ii_str];

% read synthetic data (all staions, 1 realization)
  sgmSA=zeros(nsta,leng);
  for ss=1:nsta
    STAT=STATs{ss};
    sfilename=[EVEpath RLZdir '_' realnum '/SA/' STAT '.rotd50'];
    [sgmSA(ss,1:leng)] = read_rd50_2(sfilename,'LOC');

    % compute residuals
    resSA(:,ss) = log(dgmSA(ss,:)./sgmSA(ss,:));
    
  end

% --------------------------------------- %   
% compute mean resSA from 1 realization
  nsta_inSA(1:leng,1:nsta)=1;
  ave_dgmSA=zeros(1,leng);
  ave_sgmSA=zeros(1,leng);
       
  for ss=1:nsta
    for mm=1:leng
      % eliminate Inf
      if abs(resSA(mm,ss)) == Inf
        resSA(mm,ss) = 0;
      end
  
      %set 0 if period outside limited period
      if (T(mm) > Tmax(ss)) || (T(mm) < Tmin(ss))
        resSA(mm,ss)=0;
        sgmSA(ss,mm)=1;
        dgmSA(ss,mm)=1;
        nsta_inSA(mm,ss)=0;
      end
    end
  end

  Tmax_nsta = sum(nsta_inSA');
  resMD = zeros(leng,1);
  for mm=1:leng
    ave_dgmSA(mm)=1;
    ave_sgmSA(mm)=1;
    if Tmax_nsta(mm) > 0
      resMD(mm) = sum(resSA(mm,:))/Tmax_nsta(mm);
      ave_dgmSA(mm)=exp(sum(log(dgmSA(:,mm)))/Tmax_nsta(mm));
      ave_sgmSA(mm)=exp(sum(log(sgmSA(:,mm)))/Tmax_nsta(mm));
    end
  end

% --------------------------------------- %   
% plot SAs for each realization

  figure;
  loglog(T,ave_dgmSA,'k','LineWidth',2, 'DisplayName', 'Data'); hold on;
  loglog(T,ave_sgmSA,'r','LineWidth',2, 'DisplayName', 'BBs');
  legend;    
  title(TITLES);
  xlabel('period [s]'); ylabel('rotD50 [g]');
  axis([0.01 10 10^-3 10^0]);
  hold off;
  pname = [PLTdir '/SA-' printname '-' realnum];
  %print('-dpdf', pname);
  print('-dpng', pname);

% --------------------------------------- %
% compute & plot GOF for each realization
% use Rob's approach for computing the standard error
  a1 = resSA.^2; b1 = sum(a1')';
  %size(b1)

  resSD = zeros(leng,1);
  res90 = zeros(leng,1);

  for mm=1:leng
      n = Tmax_nsta(mm);
      if n > 1
          ista = 1/(n-1);
          resSD(mm,1) = sqrt(ista*(b1(mm)-n.*resMD(mm).^2));

% 90% confidence intervals of the mean
           res90(mm,1) = 1.699*sqrt(1/n)*resSD(mm,1);   
       else
           resSD(mm,1) = 0;
           res90(mm,1) = 0;
       end
   end

   figure;
   set(gcf,'position',[0,0,500,210]);
   set(gcf,'color','white');
   maxX = 10.0;
   minX = 0.01;

   a = resMD+resSD; a2 = resMD+res90;
   b = resMD-resSD; b2 = resMD-res90;

   pp=patch([(T)' fliplr((T'))],[a' fliplr(b')],[0.8 0.8 0.8]);
   pp2 = get(pp,'parent'); set(pp2,'Xscale','log');
   hold on; box on;
   patch([(T)' fliplr((T'))],[a2' fliplr(b2')],[0.5 0.5 0.5]);
   plot((T),resMD,'k-','LineW',2);
   plot((T),zeros(size(T)),'r','LineW',2); % dashed line on y=0
   ll=legend('1-\sigma interval','90 % C.I.','median','BBs');
   set(ll,'FontS',10,'box','off', 'FontW', 'bo');

   set(gca,'Position', [0.08, 0.2, 0.88, 0.65]);
   set(gca,'LineW',2,'XTick',[0.01 0.05 0.1 0.2 0.3 0.5 1 1.5 2 3 4 5 7.5 10],...
     'XTicklabel',{'0.01' '0.05' '0.1' '0.2' '0.3' '0.5' '1' '1.5' '2' '3' '4' '5' '7.5' '10'},...
     'YTick',[-2.5 -2.0 -1.5 -1 -.5 0 .5 1 1.5 2.0 2.5],...
     'YTickLabel',{'-2.5' '-2.0' '-1.5' '-1' '-.5' '0' '.5' '1' '1.5' '2.0' '2.5'},...
     'Fontsize',11);
   xlabel('Period [s]'); ylabel('ln(obs/sim)','Fontsize',10,'FontW','bo');
   text(minX+0.01, -1.25,'RotD50','Fontsize',12,'FontW','bo');
   title(TITLES);
   axis([minX maxX -1.8 1.8]);
   grid on
   hold off

   pname = [PLTdir '/GOF-' printname '-' realnum];
   %print('-dpdf', pname);
   print('-dpng', pname);

   tocc=toc;
   disp(['** ' realnum ' Finished: Elapsed time is ' num2str(floor(100*tocc/60/60)/100) ' hrs'])
end

% --------------------------------------- %
tocc=toc;
disp(['** ' EVENT ' Finished: Elapsed time is ' num2str(floor(100*tocc/60/60)/100) ' hrs'])
