% this is originally cvV163-ratio-srhypo-mw-convseis-GfiltV163-ratio-srhypo-mw-convseis-Gfiltopied from g010_GOF_50rlzs.m
% the same as s03_GOF.m for 1 realization.
% for compute GOF from rotd50 files in sdsu local.
% GOF computation is from
% BBanalyze_V1_5_RSP_Tmax.m in SOBB_Landers/Rot_CalcRsp_20120919/.
% add plotting SAs comparisons mean_data vs. mean_BBs from all stations.

clear all;
close all;
set(0,'defaultaxesfontsize',13);

print_flag = 1;
    % 0: no pdf
    % 1: in pdf
    TITLES = ('nps: rupture speed -- GP2016');
    printname = 'rupspeed-new-random-3703-76%';

% don't change these two 
EVENTs={'nps/'};
METHODs={'sdsu/'};

% change these instead
EVENTsdo=1;
METHODsdo=1;

DIR='_sdsu_Sep2020/new_rup_speed';
BBdir='BBouts';

DATAdir='DATA/';

do_rlz=1; % realization number

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
    STATs={ '9001-NPS' '9002-WWT' '9003-DSP' '9004-CAB' '9005-PSA' '9006-MVH' ...
            '9007-FVR' '9008-SIL' '9009-H08' '9010-JOS' '9011-CFR' ...
            '9012-HCP' '9013-H06' '9014-H05' '9015-LDR' '9016-INO' ...
            '9017-SNY' '9018-H04' '9019-ARM' '9020-ARS' '9021-IND' ...
            '9022-AZF' '9024-H02' '9025-ATL' '9026-H01' '9027-TFS' ...
            '9028-RIV' '9029-LMR' '9030-PLC' '9031-HES' '9032-CLJ'};

%      STATs={ '27001-1809' '27002-5419' '27003-32076' '27004-43158' '27005-APL' ...
%             '27006-AVM' '27007-CCA' '27008-CCC' '27009-CGO' '27010-CLC' ...
%             '27011-CWC' '27012-DAW' '27013-DTP' '27014-EDW2' '27015-FDR' ...
%             '27016-FUR' '27017-GSC' '27018-HAR' '27019-HYS' '27020-ISA' ...
%             '27021-JRC2' '27022-LDR' '27023-LMR2' '27024-LRL' '27025-MPM' ...
%             '27026-PUT' '27027-Q0056' '27028-Q0068' '27029-RRX' '27030-SBB2' ...
%             '27031-SHO' '27032-SLA' '27033-SPG2' '27034-SRT' '27035-TEH' ...
%             '27036-TEJ' '27037-TOW2' '27038-TPO' '27039-WAS2' '27040-WBM' ...
%             '27041-WBS' '27042-WCS2' '27043-WHF' '27044-WMF' '27045-WNM' ...
%             '27046-WOR' '27047-WRC2' '27048-WRV2' '27049-WVP2'};
     load('nps_station_freq_range.mat');
     Tmin = 1./Station_Freq_Range(:,2);
     Tmax = 1./Station_Freq_Range(:,1);
     DDIR=[DATAdir 'obs_seis_nps_v19_06_2_100s/'];
        
    nsta=length(STATs);
% 	Rrups(1:nsta)=load([DDIR '/' 'Rrup.txt']); % oder is by Rrup in *.stl file
%     LPass(1:nsta)=load([DDIR '/' 'LPass.txt']); % oder is by Rrup in *.stl file
%     Tmax=1./LPass;
    
    % read data
    
    dgmSA=zeros(nsta,leng);
    ave_dgmSA=zeros(nsta,leng);
    ave_sgmSA=zeros(nsta,leng);
            
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
                ii_str=num2str(ii);
            end

            realnum=['100000' ii_str];
            
            sgmSA=zeros(nsta,leng);
            

            for ss=1:nsta
                STAT=STATs{ss};
                sfilename=[EVENTname DIR '/' realnum '/' BBdir '/SA/' STAT '.rotd50'];
                if ss==1;
                    sfilename
                end
                [sgmSA(ss,1:leng)] = read_rd50_2(sfilename,'LOC');

                % compute residuals
                resSA(:,ss) = log(dgmSA(ss,:)./sgmSA(ss,:));
                
                
%                 figure;
% %                 loglog(T,dgmSA(ss,:),'k','LineWidth',2); hold on;
% %                 loglog(T,sgmSA(ss,:),'r','LineWidth',2);
%                 semilogx(T,dgmSA(ss,:),'k','LineWidth',2); hold on;
%                 semilogx(T,sgmSA(ss,:),'r','LineWidth',2);
%                 title(['SAs: 1rlz for ' EVENTname printname ',-' STAT]);
%                 legend('Data','BBs');
%                 xlabel('period [s]'); ylabel('rotD50 [g]');
%                 %axis([0.01 10 10^-3 10^0]);
%                 hold off;
%                 set(gcf,'color','white');
                
            end

            tocc=toc;
            disp(['** ' realnum ' Finished: Elapsed time is ' num2str(floor(100*tocc/60/60)/100) ' hrs'])
            
        end
        

        
        %% compute mean resSA from 1 realization
        
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
            ave_dgmSA(:,mm)=1;
            ave_sgmSA(:,mm)=1;
            if Tmax_nsta(mm) > 0
                resMD(mm) = sum(resSA(mm,:))/Tmax_nsta(mm);
                %resMD(mm) = sum(resSA(mm,:))/31;
                ave_dgmSA(:,mm)=exp(sum(log(dgmSA(:,mm)))/Tmax_nsta(mm));
                ave_sgmSA(:,mm)=exp(sum(log(sgmSA(:,mm)))/Tmax_nsta(mm));
            end
        end
        
        %% plot SAs comparison between Data and BBsynthetics
        
%          ave_dgmSA=exp(mean(log(dgmSA)));
%          ave_sgmSA=exp(mean(log(sgmSA)));
        
        figure;
        loglog(T,ave_dgmSA,'k','LineWidth',2); hold on;
        loglog(T,ave_sgmSA,'r','LineWidth',2);
%         plot(T,ave_dgmSA,'k','LineWidth',2); hold on;
%         plot(T,ave_sgmSA,'r','LineWidth',2);
        legend('Data','BBs');        
        title(TITLES);
        xlabel('period [s]'); ylabel('rotD50 [g]');
        axis([0.01 10 10^-3 10^0]);
        hold off;
%         set(gcf,'color','white');
        pname = [EVENTname DIR '/' realnum '/figures/SA-' printname];
        print('-dpdf', pname);
        
        
%% compute mean of resMD from 50 realizations

        %%% here I use Rob's approach for computing the standard error
        a1 = resSA.^2; b1 = sum(a1')';
        size(b1)
        
        resSD = zeros(leng,1);
        res90 = zeros(leng,1);

        for mm=1:leng
            n = Tmax_nsta(mm);
            if n > 1
                ista = 1/(n-pr1);
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
        ll=legend('1-\sigma interval','90 % C.I.','median');
        set(ll,'FontS',10,'box','off', 'FontW', 'bo');
        plot((T),zeros(size(T)),'r','LineW',2); % dashed line on y=0

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
        
        pname = [EVENTname DIR '/' realnum '/figures/GOF-' printname];
        print('-dpdf', pname);

        
        
% %% for test from 1 realization        
%         
%         %%% here I use Rob's approach for computing the standard error
%         a1 = resSA.^2; b1 = sum(a1')'; 
% 
%         for m=1:leng
%             n = nsta_inSA(m,1);
%             if n > 1
%                 ista = 1/(n-1);
%                 resSD(m,1) = sqrt(ista*(b1(m)-n.*resMD(m).^2));
% 
%                 %%% 90% confidence intervals of the mean
%                 res90(m,1) = 1.699*sqrt(1/n)*resSD(m,1);   
%             else
%                 resSD(m,1) = 0;
%                 res90(m,1) = 0;
%             end
%         end
%         
%         figure(1)
% 
%         maxX = 10.0;
%         minX = 0.01;
% 
%         s1 = subplot(211);
%         a = resMD+resSD; a2 = resMD+res90;
%         b = resMD-resSD; b2 = resMD-res90;
% 
%         pp=patch([(T)' fliplr((T'))],[a' fliplr(b')],[0.8 0.8 0.8]);
%         pp2 = get(pp,'parent'); set(pp2,'Xscale','log');
%         hold on; box on;
%         patch([(T)' fliplr((T'))],[a2' fliplr(b2')],[0.5 0.5 0.5]);
%         plot((T),resMD,'k-','LineW',2);
%         ll=legend('1-\sigma interval','90 % C.I.','median');
%         set(ll,'Fontsize',10,'box','off', 'FontW', 'bo');
%         plot((T),zeros(size(T)),'r','LineW',2); % dashed line on y=0
% 
%         set(s1,'LineW',2,'XTick',[0.01 0.05 0.1 0.2 0.3 0.5 1 1.5 2 3 4 5 7.5 10],...
%                'XTicklabel',{'0.01' '0.05' '0.1' '0.2' '0.3' '0.5' '1' '1.5' '2' '3' '4' '5' '7.5' '10'},...
%                'YTick',[-2.5 -2.0 -1.5 -1 -.5 0 .5 1 1.5 2.0 2.5],...
%                'YTickLabel',{'-2.5' '-2.0' '-1.5' '-1' '-.5' '0' '.5' '1' '1.5' '2.0' '2.5'},...
%                'Fontsize',11);
%         ylabel('Model Bias Log (obs/sim)','Fontsize',10,'FontW','bo');
%         text(minX+0.01, -1.25,'RotD50','Fontsize',12,'FontW','bo');
% %         title(sprintf('%s-corrected data and %s', OBSDIR, pBBSDIR));
%         axis([minX maxX -1.8 1.8]);
%         grid on
%         hold off
        
%%
        % compute mean of resMD from 50 realizations
        
            
        tocc=toc;
        disp(['** ' EVENT ' Finished: Elapsed time is ' num2str(floor(100*tocc/60/60)/100) ' hrs'])
	end
end

disp('Finished with Script')

