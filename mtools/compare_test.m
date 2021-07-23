clear all;
close all;
set(0,'defaultaxesfontsize',13);

print_flag = 1;
    % 0: no pdf
    % 1: in pdf
    TITLES = ('nps: data and BB 1 rlz');
    printname = 'len-compare-lenupdate4_0421_corr_test0_seed9537';

% don't change these two 
EVENTs={'nps/'};
METHODs={'sdsu/'};

% change these instead
EVENTsdo=1;
METHODsdo=1;

DIR1='_sdsu_apr2020/100s';
DIR2='_sdsu_apr2020/300s';
BBdir1='BBouts';
BBdir2='BBouts';

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
%        STATs(2:40) =  STATs(1);
     DDIR=[DATAdir 'obs_seis_nps_v19_06_2_100s/'];
     Mw=6.29;
        
    nsta=length(STATs);
% 	Rrups(1:nsta)=load([DDIR '/' 'Rrup.txt']); % oder is by Rrup in *.stl file
%     LPass(1:nsta)=load([DDIR '/' 'LPass.txt']); % oder is by Rrup in *.stl file
%     Tmax=1./LPass;
    
    % read data
    
    dgmSA=zeros(nsta,leng);
    
    for nn=1:nsta
        STAT=STATs{nn};
        dfilename=[DDIR '/'  STAT '.rd50'];
        [dgmSA(nn,1:leng)] = read_rd50_2(dfilename,'BBP');
    end % end of data section
    
	% read synthetics at all stations in each realization
    resMD=zeros(leng,do_rlz);
    resSA1=zeros(leng,nsta);
    
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
            
            sgmSA1=zeros(nsta,leng);
            sgmSA2=zeros(nsta,leng);

            for ss=1:nsta
                STAT=STATs{ss};
                sfilename1=[EVENTname DIR1 '/' realnum '/' BBdir1 '/SA/' STAT '.rotd50'];
                sfilename2=[EVENTname DIR2 '/' realnum '/' BBdir2 '/SA/' STAT '.rotd50'];
                if ss==1;
                    sfilename1
                end
                [sgmSA1(ss,1:leng)] = read_rd50_2(sfilename1,'LOC');
                [sgmSA2(ss,1:leng)] = read_rd50_2(sfilename2,'LOC');

                % compute residuals
                resSA1(:,ss) = log(dgmSA(ss,:)./sgmSA1(ss,:));
                resSA2(:,ss) = log(dgmSA(ss,:)./sgmSA2(ss,:));
%                 
%                 figure;
% %                 loglog(T,dgmSA(ss,:),'k','LineWidth',2); hold on;
% %                 loglog(T,sgmSA(ss,:),'r','LineWidth',2);
%                 semilogx(T,dgmSA(ss,:),'k','LineWidth',2); hold on;
%                 semilogx(T,sgmSA1(ss,:),'LineWidth',2);
%                 semilogx(T,sgmSA2(ss,:),'LineWidth',2);
%                 title(['SAs: 1rlz for ' EVENTname printname ',-' STAT]);
%                 legend('Data','BBs1','BBs2');
%                 xlabel('period [s]'); ylabel('rotD50 [g]');
%                 %axis([0.01 10 10^-3 10^0]);
%                 hold off;
%                 set(gcf,'color','white');
                
            end

            tocc=toc;
            disp(['** ' realnum ' Finished: Elapsed time is ' num2str(floor(100*tocc/60/60)/100) ' hrs'])
            
        end
        
        %% plot SAs comparison between Data and BBsynthetics
        
        ave_dgmSA=exp(mean(log(dgmSA)));
        ave_sgmSA1=exp(mean(log(sgmSA1)));
        ave_sgmSA2=exp(mean(log(sgmSA2)));
        
        figure;
        loglog(T,ave_dgmSA,'k','LineWidth',2); hold on;
        loglog(T,ave_sgmSA1,'LineWidth',2);
        loglog(T,ave_sgmSA2,'LineWidth',2);
        
        title(TITLES);
        legend('Data','100s','300s');
        xlabel('period [s]'); ylabel('rotD50 [g]');
        axis([0.01 10 10^-3 10^0]);
        hold off;
        set(gcf,'color','white');
        pname = ['SA-' printname];
        print('-dpdf', pname);
        
%         %% compute mean resSA from 1 realization
%         
%         nsta_inSA(1:leng,1:nsta)=1;
%         
%         for ss=1:nsta
%   
%             for mm=1:leng
%                 % eliminate Inf
%                 if abs(resSA(mm,ss)) == Inf
%                     resSA(mm,ss) = 0;
%                 end
%                 
%                 % set 0 if period > limited period
% %                 if T(mm) > Tmax(ss)
% %                     resSA(mm,ss)=0;
% %                     nsta_inSA(mm,ss)=0;
% %                 end
%             end
%         end
%         
%         Tmax_nsta = sum(nsta_inSA');
%         resMD = zeros(leng,1);
%         for mm=1:leng
%             if Tmax_nsta(mm) > 0
%                 resMD(mm) = sum(resSA(mm,:))/Tmax_nsta(mm);
%             end
%         end
%         
% %% compute mean of resMD from 50 realizations
% 
%         %%% here I use Rob's approach for computing the standard error
%         a1 = resSA.^2; b1 = sum(a1')';
%         size(b1)
%         
%         resSD = zeros(leng,1);
%         res90 = zeros(leng,1);
% 
%         for mm=1:leng
%             n = Tmax_nsta(mm);
%             if n > 1
%                 ista = 1/(n-1);
%                 resSD(mm,1) = sqrt(ista*(b1(mm)-n.*resMD(mm).^2));
% 
%                 %%% 90% confidence intervals of the mean
%                 res90(mm,1) = 1.699*sqrt(1/n)*resSD(mm,1);   
%             else
%                 resSD(mm,1) = 0;
%                 res90(mm,1) = 0;
%             end
%         end
%         
%         figure;
%         set(gcf,'color','white');
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
%         set(ll,'FontS',10,'box','off', 'FontW', 'bo');
%         plot((T),zeros(size(T)),'r','LineW',2); % dashed line on y=0
% 
%         set(s1,'LineW',2,'XTick',[0.01 0.05 0.1 0.2 0.3 0.5 1 1.5 2 3 4 5 7.5 10],...
%                'XTicklabel',{'0.01' '0.05' '0.1' '0.2' '0.3' '0.5' '1' '1.5' '2' '3' '4' '5' '7.5' '10'},...
%                'YTick',[-2.5 -2.0 -1.5 -1 -.5 0 .5 1 1.5 2.0 2.5],...
%                'YTickLabel',{'-2.5' '-2.0' '-1.5' '-1' '-.5' '0' '.5' '1' '1.5' '2.0' '2.5'},...
%                'Fontsize',11);
%         xlabel('Period [s]'); ylabel('ln(obs/sim)','Fontsize',10,'FontW','bo');
%         text(minX+0.01, -1.25,'RotD50','Fontsize',12,'FontW','bo');
%         title(TITLES);
%         axis([minX maxX -1.8 1.8]);
%         grid on
%         hold off
%         
%         pname = [EVENTname DIR '/' realnum '/figures/GOF-' printname];
%         print('-dpdf', pname);

       
        
            
        tocc=toc;
        disp(['** ' EVENT ' Finished: Elapsed time is ' num2str(floor(100*tocc/60/60)/100) ' hrs'])
	end
end

disp('Finished with Script')

