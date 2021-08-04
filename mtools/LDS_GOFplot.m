% this is originally cvV163-ratio-srhypo-mw-convseis-GfiltV163-ratio-srhypo-mw-convseis-Gfiltopied from g010_GOF_50rlzs.m
% the same as s03_GOF.m for 1 realization.
% for compute GOF from rotd50 files in sdsu local.
% GOF computation is from
% BBanalyze_V1_5_RSP_Tmax.m in SOBB_Landers/Rot_CalcRsp_20120919/.
% add plotting SAs comparisons mean_data vs. mean_BBs from all stations.
%
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

clear all;
close all;
set(0,'defaultaxesfontsize',13);

TITLES = ('Landers: fac-test');
printname = 'landers_fac_test';

% don't change these two 
EVENTs={'landers/'};
METHODs={'sdsu/'};

% change these instead
EVENTsdo=1;
METHODsdo=1;

%EVEpath='../Ridgecrest-c_xuk';
%BBdir='/test_0714/BBout_0714';
%DATAdir= [EVEpath '/BBin_0519'];
%PLTdir = [EVEpath '/test_0714/figures'];
%DDIR=[DATAdir '/Obs_rcc_0603/SA'];
EVEpath	= '../sngl_rlz/landers';
BBdir	= '/BBout_0728';
DATAdir	= [EVEpath];
PLTdir 	= [EVEpath '/figures']
DDIR	= [DATAdir '/obs_data'];
mkdir (PLTdir);      % generate the directory for plots

do_rlz=1;		% realization number

T =  [0.010 0.011 0.012 0.013 0.015 0.017 0.020 0.022 0.025 ...
      0.029 0.032 0.035 0.040 0.045 0.050 0.055 0.060 0.065 ...
      0.075 0.085 0.100 0.110 0.120 0.130 0.150 0.170 0.200 ...
      0.220 0.240 0.260 0.280 0.300 0.350 0.400 0.450 0.500 ...
      0.550 0.600 0.650 0.750 0.850 1.000 1.100 1.200 1.300 ...
      1.500 1.700 2.000 2.200 2.400 2.600 2.800 3.000 3.500 ...
      4.000 4.400 5.000 5.500 6.000 6.500 7.500 8.500 10.000];
T = T';
leng = length(T);

%% 

tic
for jj=EVENTsdo
    EVENT=EVENTs{jj};
    EVENTname=EVENT(1:length(EVENT)-1);
    STATs = {'4001-LCN'  '4011-WWT'  '4021-IND'  '4031-NYA' ...
        '4002-JOS'  '4012-BRS'  '4022-FTI'  '4032-116' ...
        '4003-MVH'  '4013-PSA'  '4023-H05'  '4033-NHO' ...
        '4004-CLW'  '4014-TPP'  '4024-ABY'  '4034-RO3' ...
        '4005-DSP'  '4015-MVP'  '4025-HOS'  '4035-FLO' ...
        '4006-YER'  '4016-29P'  '4026-BAK'  '4036-W15' ...
        '4007-FVR'  '4017-FFP'  '4027-BFS'  '4037-VER' ...
        '4008-FHS'  '4018-BLC'  '4028-PLC'  '4038-COM' ...
        '4009-NPF'  '4019-INJ'  '4029-RIV'  '4039-FEA' ...
        '4010-MCF'  '4020-SIL'  '4030-FAI'  '4040-PMN'};
    %
    load('ridgecrest_station_freq_range.mat');
    Tmin = 1./Station_Freq_Range(:,2);
    Tmax = 1./Station_Freq_Range(:,1);
        
    nsta=length(STATs);
    
    % read data
    
    dgmSA=zeros(nsta,leng);
    ave_dgmSA=zeros(1,leng);
    ave_sgmSA=zeros(1,leng);
    
    % 'LOC' for 2-column ; 'BBP' for 4-column obs data 
    for nn=1:nsta
        STAT=STATs{nn};
        dfilename=[DDIR '/'  STAT '.rd50'];
        [dgmSA(nn,1:leng)] = read_rd50_2(dfilename,'BBP');
    end % end of data section
    
	% read synthetics at all stations in each realization
    resMD=zeros(leng,do_rlz);
    resSA=zeros(leng,nsta);
    
	for kk=METHODsdo
        METHOD=METHODs{kk};

        disp([ EVENT ' - ' METHOD ])
        
        for ii=0:do_rlz - 1
            if ii<10
                ii_str=['0' num2str(ii)];
            else
                ii_str=num2str(ii, '%02d');
            end

            realnum=['rlz_' ii_str];
            
            sgmSA=zeros(nsta,leng);
            for ss=1:nsta
                STAT=STATs{ss};
                sfilename=[EVEpath BBdir '_' realnum '/SA/' STAT '.rotd50'];
                if ss==1;
                    sfilename
                end
                [sgmSA(ss,1:leng)] = read_rd50_2(sfilename,'LOC');

                % compute residuals
                resSA(:,ss) = log(dgmSA(ss,:)./sgmSA(ss,:));
    
            end

%%% compute mean resSA from 1 realization
            nsta_inSA(1:leng,1:nsta)=1;
        
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
        
%%% plot SAs comparison between Data and BBsynthetics
        
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
        
        
%%% compute & plot GOF for each realization
%%% here I use Rob's approach for computing the standard error
            a1 = resSA.^2; b1 = sum(a1')';
            %size(b1)
        
            resSD = zeros(leng,1);
            res90 = zeros(leng,1);

            for mm=1:leng
                n = Tmax_nsta(mm);
                if n > 1
                    ista = 1/(n-1);
                    resSD(mm,1) = sqrt(ista*(b1(mm)-n.*resMD(mm).^2));

%%% 90% confidence intervals of the mean
                    res90(mm,1) = 1.699*sqrt(1/n)*resSD(mm,1);   
                else
                    resSD(mm,1) = 0;
                    res90(mm,1) = 0;
                end
            end
        
            figure;
            set(gcf,'color','white');
            maxX = 10.0;
            minX = 0.01;

            s1 = subplot(211);
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

            set(s1,'LineW',2,'XTick',[0.01 0.05 0.1 0.2 0.3 0.5 1 1.5 2 3 4 5 7.5 10],...
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

        tocc=toc;
        disp(['** ' EVENT ' Finished: Elapsed time is ' num2str(floor(100*tocc/60/60)/100) ' hrs'])
	end
end

disp('Finished with Script')

