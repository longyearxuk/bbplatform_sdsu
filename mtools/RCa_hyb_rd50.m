% the same as change_BBs_unit_vel2acc.m
% for 1 realization
% change BB.X.hyb [m/s] to acc [g] for RotD50 computation.
% copy RotD50Fast for SOBBouts_V163 (working directory)
% and compute rotD50 in SOBBouts_V163/SA/.
%
% need to change directory name from SOBBouts_V163.
%
% [Modifications - by kxu4143]
% 06/04/2021: added Ridgecrest and changed some details:
%    EVENTsdo = [11]
%    BBdir = 'BBout_0604'
%    change EVEname to EVEpath to save the whole path
%    change realnum format to 'rlz_xx'
%    moved the use of realnum into output path
%    added SAdir to genegrate the directory
% 07/01/2021:
%    rearranged the path strings EVEpath & BBdir
%    added rls to start from non-zero realizations

clear all;
% close all;

set(0,'defaultaxesfontsize',13);

% don't change these two 
EVENTs={'laquila/';'whittier/';'nps/';'tottori/';'niigata/';'nr/'; ...
    'lomap/';'landers1seg/';'ch/';'ar/';'ridgea/'};
METHODs={'csm/';'ucsb/';'exsim/';'gp/';'sdsu/'};

% change these instead
EVENTsdo=[11];
METHODsdo=5;

%EVEpath='../Ridgecrest-c_xuk';
%BBdir='/test_0714/BBout_0714';
EVEpath = '../sngl_rlz/ridgecrest19a';
BBdir   = '/BBout_0728';

rls=0;		% start of realization num
rlz=1;		% number of realizations

tic
for jj=EVENTsdo
    EVENT=EVENTs{jj};
    STATs = {'26001-1809' '26018-HAR' '26035-TEH' ...
        '26002-5419' '26019-HYS' '26036-TEJ' ... 
        '26003-32076' '26020-ISA' '26037-TOW2' ...
        '26004-43158' '26021-JRC2' '26038-TPO' ...
        '26005-APL' '26022-LDR' '26039-WAS2' ...
        '26006-AVM' '26023-LMR2' '26040-WBM' ...
        '26007-CCA' '26024-LRL' '26041-WBS' ...
        '26008-CCC' '26025-MPM' '26042-WCS2' ... 
        '26009-CGO' '26026-PUT' '26043-WHF' ...
        '26010-CLC' '26027-Q0056' '26044-WMF' ...
        '26011-CWC' '26028-Q0068' '26045-WNM' ...
        '26012-DAW' '26029-RRX' '26046-WOR' ... 
        '26013-DTP' '26030-SBB2' '26047-WRC2' ...
        '26014-EDW2' '26031-SHO' '26048-WRV2' ...
        '26015-FDR' '26032-SLA' '26049-WVP2' ...
        '26016-FUR' '26033-SPG2' ...
        '26017-GSC' '26034-SRT'};
%     
    for kk=METHODsdo
        METHOD=METHODs{kk};
        disp([ EVENT ' - ' METHOD ])
            
        for ii=rls:rls+rlz-1 % for realizations, just keep the same routine

            if ii<10
                ii_str=['0' num2str(ii)];
            else
                ii_str=num2str(ii,'%02d');
            end

            realnum=['rlz_' ii_str];
            SAdir = [EVEpath BBdir '_' realnum '/SA/'];
            BACKdir = ['../../../../mtools'];
            mkdir (SAdir);	% generate the directory for SA files
                
            for ss=1: length(STATs)

                STAT=STATs{ss};

                % input LF velocity files (simplified)
                VELpath=[EVEpath BBdir '_' realnum '/' 'BB.' STAT '.hyb' ]

                % output acceleration files (simplified)
                THpath=[EVEpath BBdir '_' realnum  '/' STAT ];
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
		FNAME = [SAdir 'rotd50_inp.cfg'];

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
            RDname = 'Rot_CalcRsp_20120919/RotD50Fast';
            copyfile (RDname, SAdir);
            
            % run RotD50Fast*
            cd (SAdir);
            cmd = ['./RotD50Fast'];
            system(cmd);
            display 'DONE compute RD50'
            cd (BACKdir);

        end
        tocc=toc;
        disp(['** ' realnum ' Finished: Elapsed time is ' num2str(floor(100*tocc/60/60)/100) ' hrs'])
    end
end
