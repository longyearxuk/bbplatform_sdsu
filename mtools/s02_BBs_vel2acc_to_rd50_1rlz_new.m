% the same as change_BBs_unit_vel2acc.m
% for 1 realization
% change BB.X.hyb [m/s] to acc [g] for RotD50 computation.
% copy RotD50Fast for SOBBouts_V163 (working directory)
% and compute rotD50 in SOBBouts_V163/SA/.
%
% need to change directory name from SOBBouts_V163.

clear all;
% close all;

set(0,'defaultaxesfontsize',13);

% don't change these two 
EVENTs={'laquila/';'whittier/';'nps/';'tottori/';'niigata/';'nr/'; ...
    'lomap/';'landers1seg/';'ch/';'ar/'};
METHODs={'csm/';'ucsb/';'exsim/';'gp/';'sdsu/'};

% change these instead
EVENTsdo=[3];
METHODsdo=5;

BBdir='BBouts';

rlz=1;

tic
for jj=EVENTsdo
    EVENT=EVENTs{jj};
    EVEname='nps_sdsu_Sep2020/new_rup_speed'; %EVENT(1:length(EVENT)-1);
    STATs={ '9001-NPS' '9002-WWT' '9003-DSP' '9004-CAB' '9005-PSA' '9006-MVH' ...
            '9007-FVR' '9008-SIL' '9009-H08' '9010-JOS' '9011-CFR' ...
            '9012-HCP' '9013-H06' '9014-H05' '9015-LDR' '9016-INO' ...
            '9017-SNY' '9018-H04' '9019-ARM' '9020-ARS' '9021-IND' ...
            '9022-AZF' '9024-H02' '9025-ATL' '9026-H01' '9027-TFS' ...
            '9028-RIV' '9029-LMR' '9030-PLC' '9031-HES' '9032-CLJ'};
    
%     EVEname='ridgecrest_sdsu_Sep2020/new_rup_speed'; %EVENT(1:length(EVENT)-1);
%     STATs={ '27001-1809' '27002-5419' '27003-32076' '27004-43158' '27005-APL' ...
%             '27006-AVM' '27007-CCA' '27008-CCC' '27009-CGO' '27010-CLC' ...
%             '27011-CWC' '27012-DAW' '27013-DTP' '27014-EDW2' '27015-FDR' ...
%             '27016-FUR' '27017-GSC' '27018-HAR' '27019-HYS' '27020-ISA' ...
%             '27021-JRC2' '27022-LDR' '27023-LMR2' '27024-LRL' '27025-MPM' ...
%             '27026-PUT' '27027-Q0056' '27028-Q0068' '27029-RRX' '27030-SBB2' ...
%             '27031-SHO' '27032-SLA' '27033-SPG2' '27034-SRT' '27035-TEH' ...
%             '27036-TEJ' '27037-TOW2' '27038-TPO' '27039-WAS2' '27040-WBM' ...
%             '27041-WBS' '27042-WCS2' '27043-WHF' '27044-WMF' '27045-WNM' ...
%             '27046-WOR' '27047-WRC2' '27048-WRV2' '27049-WVP2'};
%     
    for kk=METHODsdo
        METHOD=METHODs{kk};
        disp([ EVENT ' - ' METHOD ])
            
        for ii=0:rlz-1 % for realizations, just keep the same routine

            if ii<10
                ii_str=['0' num2str(ii)];
            else
                ii_str=num2str(ii);
            end

            realnum=['100000' ii_str];
                
            for ss=1: length(STATs)

                STAT=STATs{ss};

                % input LF velocity files
                VELpath=[EVEname '/' realnum '/' BBdir '/' 'BB.' STAT '.hyb' ]

                % output acceleration files
                THpath=[EVEname '/' realnum '/' BBdir '/' STAT ];
                EWpath=[THpath '_E.acc'];
                NSpath=[THpath '_N.acc'];

                [gE, gN, npts, dt] = calculate_BBs_in_g(VELpath);

                fidE = fopen(EWpath,'w');
                fidN = fopen(NSpath,'w');

                % Efiles
                fprintf(fidE, '%s\n%s\n%s\n%s\n%s\n', '% header 1','% header 2', ...
                            '% header 3', '% header 4', '% header 5');
                fprintf(fidE, '%d %f %s\n', npts,dt,'NPTS, DT');
                for i = 1:npts/5
                    k = (i-1)*5;
                    fprintf(fidE, '%f %f %f %f %f\n', ...
                        gE(k+1),gE(k+2),gE(k+3),gE(k+4),gE(k+5));
                end

                % Nfiles
                fprintf(fidN, '%s\n%s\n%s\n%s\n%s\n', '% header 1','% header 2', ...
                            '% header 3', '% header 4', '% header 5');
                fprintf(fidN, '%d %f %s\n', npts,dt,'NPTS, DT');
                for i = 1:npts/5
                    k = (i-1)*5;
                    fprintf(fidN, '%f %f %f %f %f\n', ...
                        gN(k+1),gN(k+2),gN(k+3),gN(k+4),gN(k+5));
                end

                % create rotd50_inp.cfg
                % 3 headers
                % 2 inputfiles (E and N)
                % 2 outputfiles (rotd50 and psa5)

                INDIR = '..';
                FNAME = [EVEname '/' realnum '/' BBdir '/SA/rotd50_inp.cfg'];

                if ss==1
                    fidC = fopen(FNAME,'w');
                    fprintf(fidC, '%d %s\n', 2, 'Interp');
                    fprintf(fidC, '%d %s\n', length(STATs), 'Npairs');
                    fprintf(fidC, '%d %s\n', 5, 'Nhead');
                end
                fprintf(fidC, '%s/%s_E.acc\n', INDIR, STAT);
                fprintf(fidC, '%s/%s_N.acc\n', INDIR, STAT);
                fprintf(fidC, '%s.rotd50\n', STAT);
                fprintf(fidC, '%s.psa5\n', STAT);
            end

            fclose(fidC);
            fclose(fidE);
            fclose(fidN);
            display 'DONE create rotd50_inp.cfg'
            
            % copy RotD50Fast* under SA/
            SAdir = [EVEname '/' realnum '/' BBdir '/SA/'];
            RDname = 'Rot_CalcRsp_20120919/RotD50Fast';
            copyfile (RDname, SAdir);
            
            % run RotD50Fast*
            cd (SAdir);
            cmd = ['./RotD50Fast'];
            system(cmd);
            display 'DONE compute RD50'
            %cd ('BB_1rlz_17_3/');

        end
        tocc=toc;
        disp(['** ' realnum ' Finished: Elapsed time is ' num2str(floor(100*tocc/60/60)/100) ' hrs'])
    end

end

