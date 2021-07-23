% close all;
% clear all;

EVENT = 'nps';
TIL = 'nps';
savename = 'lenupdate4_test22_compdfnpts_codadfnpts_lflencoda_taperconvseis_codax300_taperlf_taperlen10th_scoda300c1_codatw300_taperrealbb_outputlen_timestep4_seed6104';
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
lf300s=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'lf_int.dat']);
lf100s=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'lf_int.dat']);
scattgram_before300s=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'scattgram_before.dat']);
scattgram_before100s=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'scattgram_before.dat']);
scattgram_after300s=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'scattgram_after.dat']);
scattgram_after100s=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'scattgram_after.dat']);
pp300s=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'pp.dat']);
pp100s=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'pp.dat']);
u1300s=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'u1.dat']);
u1100s=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'u1.dat']);
u2300s=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'u2.dat']);
u2100s=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'u2.dat']);
conv_seis300s=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'conv_seis.dat']);
conv_seis100s=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'conv_seis.dat']);
conv_seistimeratio300s=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'conv_seistimeratio.dat']);
conv_seistimeratio100s=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'conv_seistimeratio.dat']);
Am_hf300s=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'Am_hf.dat']);
Am_hf100s=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'Am_hf.dat']);
Am_lf300s=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'Am_lf.dat']);
Am_lf100s=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'Am_lf.dat']);
Acc_hf300s=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'Acc_hf.dat']);
Acc_hf100s=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'Acc_hf.dat']);
scale300s = load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'scale.dat']);
scale100s = load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'scale.dat']);
bbf300s = load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'f.dat']);
bbf100s = load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'f.dat']);
%%%[Av_hf1,Av_hf11,ratio,fscale_11,fscale_22,win_fr,sca_index,targ_index,df] = scale
% t100s=vel100s(:,1);
% t300s=vel300s(:,1);
% dt100s = t100s(2)-t100s(1);
% dt300s = t300s(2)-t300s(1);
vel300s=load([EVENT '_sdsu_apr2020/300s/10000000/' BBdir300s 'BB.9001-NPS.hyb']);
vel100s=load([EVENT '_sdsu_apr2020/100s/10000000/' BBdir100s 'BB.9001-NPS.hyb']);

dt100s = vel100s(2,1)-vel100s(1,1);
dt300s = vel300s(2,1)-vel300s(1,1);
dt100s = dt100s./4;
dt300s = dt300s./4;
t100s=0:dt100s:(length(lf100s)-1)*dt100s;
t300s=0:dt300s:(length(lf300s)-1)*dt300s;

% len = 30;
% nlen = floor(len/dt);
% nt0=find(vel100s(:,2)~=0,1);

%%
figure;
hold on;
plot(t100s,lf100s,'color',[49 99 206]/256)
plot(t300s,lf300s,'--','color',[202 51 0]/256)
legend('100s','300s')
% xlim([0 100])
% ylim([-8 8])
box on;
xlabel('Time (s)')
ylabel('lf_int')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');
% print('-dpdf',['compare_' savename '_lfint']);

%%
figure;
hold on;
plot(t100s,scattgram_before100s,'color',[49 99 206]/256)
plot(t300s,scattgram_before300s,'--','color',[202 51 0]/256)
legend('100s','300s')
xlim([0 100])
% ylim([-8 8])
box on;
xlabel('Time (s)')
ylabel('scattgram before')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');

%%%% FAS
% scattgram_after100s(32769:131072) = scattgram_after300s(32769:131072);
Ntotal100s=length(scattgram_before100s);      % seismogram series length
Ntotal300s=length(scattgram_before300s);

Nnyq100s=Ntotal100s/2+1;      % Nyquist for Uf(f)
df100s=1./(dt100s*Ntotal100s);
f100s=df100s*(0:Nnyq100s-1);
Nf100s=length(f100s);      %  Maximum index for frequency plots

Nnyq300s=Ntotal300s/2+1;      % Nyquist for Uf(f)
df300s=1./(dt300s*Ntotal300s);
f300s=df300s*(0:Nnyq300s-1);
Nf300s=length(f300s);      %  Maximum index for frequency plots


uf_100s=fft(scattgram_before100s);
U_100s=abs(uf_100s(1:Nf100s));

uf_300s=fft(scattgram_before300s);
U_300s=abs(uf_300s(1:Nf300s));

figure;
loglog(f100s,U_100s,'color',[49 99 206]/256)
hold on;
loglog(f300s,U_300s,'--','color',[202 51 0]/256)
legend('100s','300s')
% xlim([0.1 20])
% ylim([0.01 10000])
xlabel('Frequency (Hz)')
ylabel('fft scattgram before')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');


%%
figure;
hold on;
plot(t100s,scattgram_after100s,'color',[49 99 206]/256)
plot(t300s,scattgram_after300s,'--','color',[202 51 0]/256)
legend('100s','300s')
xlim([0 100])
% ylim([-8 8])
box on;
xlabel('Time (s)')
ylabel('scattgram after')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');

%%%% FAS
% test = scattgram_after300s;
% test(32769:end) = 0;%test(32769:end)./1000;
Ntotal100s=length(scattgram_after100s);      % seismogram series length
Ntotal300s=length(scattgram_after300s);

Nnyq100s=Ntotal100s/2+1;      % Nyquist for Uf(f)
df100s=1./(dt100s*Ntotal100s);
f100s=df100s*(0:Nnyq100s-1);
Nf100s=length(f100s);      %  Maximum index for frequency plots

Nnyq300s=Ntotal300s/2+1;      % Nyquist for Uf(f)
df300s=1./(dt300s*Ntotal300s);
f300s=df300s*(0:Nnyq300s-1);
Nf300s=length(f300s);      %  Maximum index for frequency plots


uf_100s=fft(scattgram_after100s);
U_100s=abs(uf_100s(1:Nf100s));

uf_300s=fft(scattgram_after300s);
U_300s=abs(uf_300s(1:Nf300s));

figure;
loglog(f100s,U_100s,'color',[49 99 206]/256)
hold on;
loglog(f300s,U_300s,'--','color',[202 51 0]/256)
legend('100s','300s')
% xlim([0.1 20])
% ylim([0.01 10000])
xlabel('Frequency (Hz)')
ylabel('fft scattgram')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');

%%
figure;
hold on;
plot(t100s,scattgram_after100s./scattgram_before100s,'color',[49 99 206]/256)
plot(t300s,scattgram_after300s./scattgram_before300s,'--','color',[202 51 0]/256)
legend('100s','300s')
xlim([0 100])
% ylim([-8 8])
box on;
xlabel('Time (s)')
ylabel('scattgram after')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');

%%
figure;
hold on;
plot(pp100s,'color',[49 99 206]/256)
plot(pp300s,'--','color',[202 51 0]/256)
legend('100s','300s')
% xlim([0 100])
% ylim([-8 8])
box on;
xlabel('Time (s)')
ylabel('pp')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');

%%
figure;
hold on;
plot(0:20476,u1100s,'color',[49 99 206]/256)
plot([0:81903]./4,u1300s,'--','color',[202 51 0]/256)
legend('100s','300s')
% xlim([0 100])
% ylim([-8 8])
box on;
xlabel('Time (s)')
ylabel('u1')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');

%%
figure;
hold on;
plot(0:20476,u2100s,'color',[49 99 206]/256)
plot([0:4:81903]./4,u2300s(1:4:81904),'--','color',[202 51 0]/256)
legend('100s','300s')
% xlim([0 100])
% ylim([-8 8])
box on;
xlabel('Time (s)')
ylabel('u2')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');

%%
figure;
loglog(bbf100s(1:16384),Am_hf100s(1:16384),'color',[49 99 206]/256)
hold on;
loglog(bbf300s(1:65536),Am_hf300s(1:65536),'--','color',[202 51 0]/256)
legend('100s','300s')
% xlim([0.1 20])
% ylim([0.01 10000])
xlabel('Frequency (Hz)')
ylabel('Am hf ns (m/s)')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');
% print('-dpdf',['compare_' savename '_FAS']);

%%
figure;
loglog(bbf100s(1:16384),Am_lf100s(1:16384),'color',[49 99 206]/256)
hold on;
loglog(bbf300s(1:65536),Am_lf300s(1:65536),'--','color',[202 51 0]/256)
legend('100s','300s')
% xlim([0.1 20])
% ylim([0.01 10000])
xlabel('Frequency (Hz)')
ylabel('Am lf ns (m/s)')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');

%%
figure;
loglog(bbf100s(1:16384),Acc_hf100s(1:16384),'color',[49 99 206]/256)
hold on;
% Acc_hf300s_real=Am_hf300s(1:65536).*2.*pi.*bbf300s(1:65536)./4*3;
% loglog(bbf300s(1:65536)./4*3,Acc_hf300s_real(1:65536),'--','color',[202 51 0]/256)
loglog(bbf300s(1:65536),Acc_hf300s(1:65536),'--','color',[202 51 0]/256)
legend('100s','300s')
% xlim([0.1 20])
% ylim([0.01 10000])
xlabel('Frequency (Hz)')
ylabel('Acc hf ns (m/s)')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');

%%
figure;
plot(bbf100s,'color',[49 99 206]/256)
hold on;
plot(bbf300s,'--','color',[202 51 0]/256)
legend('100s','300s')

%%
figure;
plot(t100s,lf100s+conv_seis100s,'color',[49 99 206]/256)
hold on;
plot(t300s,lf300s+conv_seis300s,'--','color',[202 51 0]/256)
legend('100s','300s')
ylabel('lf + hf w/o ratio')
xlim([0 200])


%%
figure;
plot(t100s,lf100s+conv_seis100s*scale100s(3),'color',[49 99 206]/256)
hold on;
plot(t300s,lf300s+conv_seistimeratio300s*scale300s(3),'--','color',[202 51 0]/256)
legend('100s','300s')
ylabel('lf + hf w ratio')
xlim([0 200])

%%
figure;
plot(t100s,conv_seis100s,'color',[49 99 206]/256)
hold on;
plot(t300s,conv_seis300s,'--','color',[202 51 0]/256)
legend('100s','300s')
ylabel('conv_seis')
% xlim([0 20])

%% Fft

tn = 1000;%floor(32768/5);
a=1:tn;
taperend = 0.5 .* (1 + cos(2 .* pi .* a ./ (2*tn)) );
test = conv_seis300s;%timeratio300s;
% test(end-tn+1:end) = test(end-tn+1:end).*taperend';
conv_seistimeratio100s = lf100s+conv_seis100s;%.*scale100s(3);
conv_seistimeratio300s = lf300s+test;%conv_seis300s;%.*scale300s(3);

Ntotal100s=length(conv_seistimeratio100s);      % seismogram series length
Ntotal300s=length(conv_seistimeratio300s);

Nnyq100s=Ntotal100s/2+1;      % Nyquist for Uf(f)
df100s=1./(dt100s*Ntotal100s);
f100s=df100s*(0:Nnyq100s-1);
Nf100s=length(f100s);      %  Maximum index for frequency plots

Nnyq300s=Ntotal300s/2+1;      % Nyquist for Uf(f)
df300s=1./(dt300s*Ntotal300s);
f300s=df300s*(0:Nnyq300s-1);
Nf300s=length(f300s);      %  Maximum index for frequency plots


uf_100s=fft(conv_seistimeratio100s);
U_100s=abs(uf_100s(1:Nf100s));

uf_300s=fft(conv_seistimeratio300s);
U_300s=abs(uf_300s(1:Nf300s));

figure;
loglog(f100s,U_100s,'color',[49 99 206]/256)
hold on;
loglog(f300s,U_300s,'--','color',[202 51 0]/256)
legend('100s','300s')
% xlim([0.1 20])
% ylim([0.01 10000])
xlabel('Frequency (Hz)')
ylabel('fft conv_seis')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');
%%
%%%% test
tn = 800;
a=1:tn;
taperend = 0.5 .* (1 + cos(2 .* pi .* a ./ (2*tn)) );
% taperend = taperend.^2;
taperstart = 0.5 .* (1 - cos(2 .* pi .* a ./ (2*tn)) );
% taperstart = taperstart.^2;
tt = 1:4:131072;
test = conv_seis300s(tt);
test(end-tn+1:end) = test(end-tn+1:end).*taperend';%test(32769:end)./1000;
% test(1:tn) = test(1:tn).*taperstart';
Ntotal100s=length(conv_seis300s);      % seismogram series length
Ntotal300s=length(test);

Nnyq100s=Ntotal100s/2+1;      % Nyquist for Uf(f)
df100s=1./(dt100s*Ntotal100s);
f100s=df100s*(0:Nnyq100s-1);
Nf100s=length(f100s);      %  Maximum index for frequency plots

Nnyq300s=Ntotal300s/2+1;      % Nyquist for Uf(f)
df300s=1./(dt300s*Ntotal300s);
f300s=df300s*(0:Nnyq300s-1);
Nf300s=length(f300s);      %  Maximum index for frequency plots


uf_100s=fft(conv_seis300s);
U_100s=abs(uf_100s(1:Nf100s));

uf_300s=fft(test);
U_300s=abs(uf_300s(1:Nf300s));

figure;
loglog(f100s,U_100s,'color',[49 99 206]/256)
hold on;
loglog(f300s,U_300s,'--','color',[202 51 0]/256)
legend('300s','test')
% xlim([0.1 20])
% ylim([0.01 10000])
xlabel('Frequency (Hz)')
ylabel('fft conv_seis test')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');


%%
figure;
plot(t100s,lf100s,'color',[49 99 206]/256)
hold on;
plot(t300s,lf300s,'--','color',[202 51 0]/256)
legend('100s','300s')

%% Fft
tn = 100;%floor(32768/5);
a=1:tn;
taperend = 0.5 .* (1 + cos(2 .* pi .* a ./ (2*tn)) );
test = lf300s;%timeratio300s;
test(end-tn+1:end) = test(end-tn+1:end).*taperend';
test100s = lf100s;
test100s(end-tn+1:end) = test100s(end-tn+1:end).*taperend';

Ntotal100s=length(test100s);      % seismogram series length
Ntotal300s=length(test);

Nnyq100s=Ntotal100s/2+1;      % Nyquist for Uf(f)
df100s=1./(dt100s*Ntotal100s);
f100s=df100s*(0:Nnyq100s-1);
Nf100s=length(f100s);      %  Maximum index for frequency plots

Nnyq300s=Ntotal300s/2+1;      % Nyquist for Uf(f)
df300s=1./(dt300s*Ntotal300s);
f300s=df300s*(0:Nnyq300s-1);
Nf300s=length(f300s);      %  Maximum index for frequency plots


uf_100s=fft(test100s);
U_100s=abs(uf_100s(1:Nf100s));

uf_300s=fft(test);
U_300s=abs(uf_300s(1:Nf300s));

figure;
loglog(f100s,U_100s,'color',[49 99 206]/256)
hold on;
loglog(f300s,U_300s,'--','color',[202 51 0]/256)
legend('100s','300s')
% xlim([0.1 20])
% ylim([0.01 10000])
xlabel('Frequency (Hz)')
ylabel('fft lf')
set(gcf,'Position',[1 400 500 300]);
set(gca,'fontname','Arial');

