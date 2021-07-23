close all;
clear all;

EVENT = 'nps';
TIL = 'nps';
savename = 'lenupdate4_0421_corr_test0_seed9537';
BBdir100s = 'BBouts/';
BBdir300s = 'BBouts/';

switch EVENT
      case 'lomap' % OK
            STATs={ '8001-CLS' '8002-LGP' '8003-LEX' '8004-STG' '8005-WVC' '8006-G01' ...
                    '8007-GIL' '8008-BRN' '8009-GOF' '8010-G03' '8011-SJTE' '8012-WAH' ...
                    '8020-G06' '8016-LOB' '8014-UC2' '8021-ADL' '8022-AND' '8026-CYC' ...
                    '8015-GMR' '8013-HSP' '8025-SGI' '8017-SLC' '8024-SJW' '8019-WDS' ...
                    '8018-SG3' '8023-CLR' '8040-BES' '8032-SUF' '8028-XSP' '8036-BVW' ...
                    '8030-A3E' '8037-DFS' '8027-BVF' '8038-BVR' '8033-BVU' '8029-RIN' ...
                    '8031-CFH' '8034-BRK' '8035-GGB' '8039-PTB'};
%                 DIR='lomap_V162_0118';
        case 'landers' % change
            STATs={ '4001-LCN' '4002-JOS' '4003-MVH' '4004-CLW' '4005-DSP' '4006-YER' ...
                    '4007-FVR' '4008-FHS' '4009-NPF' '4010-MCF' '4011-WWT' '4012-BRS' ...
                    '4013-PSA' '4014-TPP' '4015-MVP' '4016-29P' '4017-FFP' '4018-BLC' ...
                    '4019-INJ' '4020-SIL' '4021-IND' '4022-FTI' '4023-H05' '4024-ABY' ...
                    '4025-HOS' '4026-BAK' '4027-BFS' '4028-PLC' '4029-RIV' '4040-PMN' ...
                    '4039-FEA' '4033-NHO' '4030-FAI' '4038-COM' '4035-FLO' '4031-NYA' ...
                    '4037-VER' '4036-W15' '4034-RO3' '4032-116'};
%                 DIR='landers_V162_0118';
        case 'niigata' % change
            STATs={ '17001' '17002' '17003' '17004' '17005' '17015' '17017' ...
                    '17012' '17008' '17014' '17011' '17006' '17013' '17007' ...
                    '17016' '17009' '17010' '17029' '17021' '17023' '17026' ...
                    '17027' '17024' '17020' '17025' '17018' '17028' '17022' ...
                    '17019' '17036' '17037' '17039' '17033' '17038' '17035' ...
                    '17040' '17031' '17030' '17032' '17034'};
%                 DIR='niigata_V162_0118';
        case 'nps' % change
            STATs={ '9001-NPS' '9002-WWT' '9003-DSP' '9004-CAB' '9005-PSA' '9006-MVH' ...
                    '9007-FVR' '9008-SIL' '9009-H08' '9010-JOS' '9011-CFR' ...
                    '9012-HCP' '9013-H06' '9014-H05' '9015-LDR' '9016-INO' ...
                    '9017-SNY' '9018-H04' '9019-ARM' '9020-ARS' '9021-IND' ...
                    '9022-AZF' '9024-H02' '9025-ATL' '9026-H01' '9027-TFS' ...
                    '9028-RIV' '9029-LMR' '9030-PLC' '9031-HES' '9032-CLJ'};
%                 DIR='nps_V162_0118';
        case 'nr' % change
            STATs={ '2001-SCE' '2002-SYL' '2004-JGB' '2005-LDM' '2006-PAC' '2007-PUL' '2008-PKC' ...
                    '2010-SPV' '2019-RO3' '2013-LOS' '2011-GLE' '2018-KAT' '2017-SSU' '2014-MU2' ...
                    '2020-NYA' '2015-TUJ' '2012-WON' '2016-H12' '2024-TPF' '2025-PEL' ...
                    '2021-FLE' '2028-FIG' '2022-PIC' '2030-VER' '2026-LV3' '2023-ANA' ...
                    '2027-ATB' '2029-CAS' '2032-LBR' '2039-LAN' '2031-OAK' '2034-LBC' ...
                    '2037-SEA' '2038-RMA' '2033-ACI' '2036-FEA' '2035-MJH' '2040-SBG'};
%                 DIR='nr_17_3_DEV_sdsu';
        case 'whittier' % change
            STATs={ '5003-A-GRN' '5010-A-NHO' '5006-A-CYP' '5007-A-PAS' '5001-A-LUR' '5004-A-CIR' ...
                    '5008-A-JAB' '5002-A-VER' '5005-A-KRE' '5009-A-EJS' '5014-A-ALT' '5011-A-BRC' ...
                    '5016-A-NOR' '5015-A-GR2' '5013-A-GRA' '5019-A-WST' '5017-A-GLP' '5020-A-ORN' ...
                    '5012-A-116' '5025-A-BRL' '5026-A-PEL' '5022-A-OR2' '5029-A-STN' '5027-A-NYA' ...
                    '5024-A-WON' '5028-A-TUJ' '5023-A-LBR' '5021-A-PMN' '5030-A-GLE' ...
                    '5035-A-MUL' '5034-A-SAR' '5037-A-SER' '5039-A-RO3' '5038-A-SEC' ...
                    '5032-A-TOR' '5033-A-KAG' '5031-A-RO2' '5040-A-ANG' '5036-A-EUC'};
%                 DIR='whittier_V162_0118';
        case 'tottori' % change
            STATs={ '15001' '15002' '15003' '15004' '15005' '15017' '15008' '15020' ...
                    '15021' '15006' '15011' '15018' '15019' '15013' '15015' '15010' ...
                    '15016' '15014' '15007' '15009' '15023' '15012' '15022' '15024' ...
                    '15040' '15027' '15036' '15039' '15025' '15030' '15033' '15037' ...
                    '15031' '15032' '15029' '15038' '15034' '15026' '15035' '15028'};
%                 DIR='tottori_V162_0118';
        case 'ch' % add
            STATs={ '25029' '25040' '25028' '25027' '25022' '25024' '25017' '25013' ...
                    '25010' '25015' '25031' '25014' '25005' '25006' '25001' '25007' ...
                    '25035' '25012' '25032' '25036' '25030' '25004' '25034' '25019' ...
                    '25008' '25018' '25025' '25026' '25037' '25021' '25002' '25033' ...
                    '25011' '25038' '25039' '25016' '25020' '25003' '25023' '25009'};
%                 DIR='ch_V162_0118';
        case 'ar' % add
            STATs={ '24017' '24018' '24011' '24006' '24026' '24034' '24039' '24004' ...
                    '24035' '24015' '24003' '24013' '24002' '24007' '24012' '24022' ...
                    '24025' '24021' '24023' '24019' '24024' '24036' '24037' '24010' ...
                    '24005' '24008' '24001' '24016' '24031' '24009' '24040' '24032' ...
                    '24027' '24014' '24029' '24028' '24038' '24030' '24033' '24020'};
%                 DIR='ar_V162_0118';
end

%%
for ss=1
    STAT=STATs{ss};
station=['BB.' STAT '.hyb'];
vel300sall=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s,station]);
vel100sall=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s,station]);
tn = 1000;
a=1:tn;
taperend = 0.5 .* (1 + cos(2 .* pi .* a ./ (2*tn)) );
vel100s = vel100sall(:,2);
vel300s = vel300sall(:,2);
% vel100s(end-tn+1:end) = vel100s(end-tn+1:end).*taperend';
% vel300s(end-tn+1:end) = vel300s(end-tn+1:end).*taperend';
t100s=vel100sall(:,1);
t300s=vel300sall(:,1);

dt100s = t100s(2)-t100s(1);
dt300s = t300s(2)-t300s(1);
[acc_ns_300s]=vel2acc(vel300s, dt300s);
[acc_ns_100s]=vel2acc(vel100s, dt100s);


figure;
% len = 30;
% nlen = floor(len/dt);
% nt0=find(vel100s(:,2)~=0,1);
subplot(2,1,1)
plot(t300s,vel300s,'k')
% plot(t300s(nt0:nt0+nlen)-t300s(nt0),vel300s(nt0:nt0+nlen,2),'k')
legend('300s')
xlim([0 100])
ylim([-0.4 0.4])
xlabel('Time (s)')
ylabel('velocity (m/s)')
title([TIL '-' STAT])

subplot(2,1,2)
plot(t100s,vel100s,'k')
% plot(t100s(nt0:nt0+nlen)-t100s(nt0),vel100s(nt0:nt0+nlen,2),'k')
legend('100s')
xlim([0 100])
ylim([-0.4 0.4])
xlabel('Time (s)')
ylabel('velocity (m/s)')
print('-dpdf',['compare_' savename '_vel']);

% subplot(3,1,3)
% plot(t100s,vel100s(:,2))
% hold on;
% plot(t300s,vel300s(:,2))
% legend('100s','300s')
% %xlim([0 100])
% xlabel('Time (s)')
% ylabel('vel (m/s)')



% figure(50)
% subplot(2,1,1)
% plot(t300s,vel300s(:,2))
% hold on;
% plot(t100s,vel100s(:,2))
% legend('300s','100s')
% %xlim([0 100])
% xlabel('Time (s)')
% ylabel('vel (m/s)')
% 
% subplot(2,1,2)
% plot(t300s,vel300s(:,2))
% hold on;
% plot(t100s,vel100s(:,2))
% legend('300s','100s')
% xlim([0 30])
% xlabel('Time (s)')
% ylabel('vel (m/s)')

% figure;
% subplot(3,1,1)
% plot(t300s,acc_ns_300s)
% hold on
% plot(t100s,acc_ns_100s)
% legend('300s','100s')
% %xlim([0 100])
% %ylim([-4 4])
% xlabel('Time (s)')
% ylabel('acc (m/s/s)')
% 
% subplot(3,1,2)
% plot(t300s,acc_ns_300s)
% hold on
% plot(t100s,acc_ns_100s)
% legend('300s','100s')
% %xlim([0 30])
% %ylim([-4 4])
% xlabel('Time (s)')
% ylabel('acc (m/s/s)')

% figure;
% subplot(2,1,1)
% plot(t300s(nt0:nt0+nlen)-t300s(nt0),acc_ns_300s(nt0:nt0+nlen),'k')
% legend('300s')
% xlim([0 len])
% ylim([-8 8])
% xlabel('Time (s)')
% ylabel('acceleration (m/s/s)')
% % title([TIL '-' STAT])
% 
% subplot(2,1,2)
% plot(t100s(nt0:nt0+nlen)-t100s(nt0),acc_ns_100s(nt0:nt0+nlen),'k')
% legend('100s')
% xlim([0 len])
% ylim([-8 8])
% xlabel('Time (s)')
% ylabel('acceleration (m/s/s)')
% 
% % print('-dpdf','paper_FAScorr_acc');


figure;
hold on;
% plot(t100s(nt0:nt0+nlen)-t100s(nt0),acc_ns_100s(nt0:nt0+nlen),'color',[49 99 206]/256)
% plot(t300s(nt0:nt0+nlen)-t300s(nt0),acc_ns_300s(nt0:nt0+nlen),'--','color',[202 51 0]/256)
plot(t100s,acc_ns_100s,'color',[49 99 206]/256)
plot(t300s,acc_ns_300s,'--','color',[202 51 0]/256)
legend('100s','300s')
xlim([0 100])
% ylim([-8 8])
box on;
xlabel('Time (s)')
ylabel('Acceleration (m/s/s)')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');
print('-dpdf',['compare_' savename '_acc']);





% subplot(3,1,3)
% plot(t100s,acc_ns_100s)
% hold on
% plot(t300s,acc_ns_300s)
% legend('100s','300s')
% %xlim([0 100])
% %ylim([-4 4])
% xlabel('Time (s)')
% ylabel('acc (m/s/s)')

% figure(30)
% subplot(2,1,1)
% plot(t300s,acc_ns_300s,'k')
% legend('300s')
% xlim([0 30])
% %ylim([-4 4])
% xlabel('Time (s)')
% ylabel('acc (m/s/s)')
% 
% subplot(2,1,2)
% plot(t100s,acc_ns_100s,'k')
% legend('100s')
% xlim([0 30])
% %ylim([-4 4])
% xlabel('Time (s)')
% ylabel('acc (m/s/s)')

%%
%%%% FAS
Ntotal100s=length(acc_ns_100s);      % seismogram series length
Ntotal300s=length(acc_ns_300s);
t100s=dt100s*(0:Ntotal100s-1);
t300s=dt300s*(0:Ntotal300s-1);

Nnyq100s=Ntotal100s/2+1;      % Nyquist for Uf(f)
df100s=1./(dt100s*Ntotal100s);
f100s=df100s*(0:Nnyq100s-1);
Nf100s=length(f100s);      %  Maximum index for frequency plots

Nnyq300s=Ntotal300s/2+1;      % Nyquist for Uf(f)
df300s=1./(dt300s*Ntotal300s);
f300s=df300s*(0:Nnyq300s-1);
Nf300s=length(f300s);      %  Maximum index for frequency plots


uf_100s=fft(acc_ns_100s);
U_100s=abs(uf_100s(1:Nf100s));

uf_300s=fft(acc_ns_300s);
U_300s=abs(uf_300s(1:Nf300s));

% figure;
% loglog(f,U_300s)
% hold on;
% loglog(f,U_100s)
% legend('300s','100s')
% % xlim([0 30])
% xlabel('Frequency (Hz)')
% ylabel('FAS_{ns}')
% title([EVENT '-' STAT])
% 
% uf=fft(vel300s(:,2));
% U=abs(uf(1:Nf));
% 
% uf100s=fft(vel100s(:,2));
% U100s=abs(uf100s(1:Nf));

% figure; 
% subplot(2,1,1)
% loglog(f,U_300s,'k')
% legend('300s','location','northwest')
% xlim([0.1 20])
% ylim([0.01 1000])
% xlabel('Frequency (Hz)')
% ylabel('FAS_{ns} (m/s)')
% % title([TIL '-' STAT])
% subplot(2,1,2)
% loglog(f,U_100s,'k')
% legend('100s','location','northwest')
% xlim([0.1 20])
% ylim([0.01 1000])
% xlabel('Frequency (Hz)')
% ylabel('FAS_{ns} (m/s)')
% % print('-dpdf','paper_FAScorr_FAS');






figure;
loglog(f100s,U_100s,'color',[49 99 206]/256)
hold on;
loglog(f300s,U_300s,'--','color',[202 51 0]/256)
legend('100s','300s')
% xlim([0.1 20])
% ylim([0.01 10000])
xlabel('Frequency (Hz)')
ylabel('FAS_{ns} (m/s)')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');
print('-dpdf',['compare_' savename '_FAS']);
% 
% % subplot(2,1,2)
% % plot(f,U100s)
% % hold on
% % plot(f,U)
% % legend('100s','300s')
% % xlim([0 2])
% % xlabel('Frequency (Hz)')
% % %ylabel('FFT')

end