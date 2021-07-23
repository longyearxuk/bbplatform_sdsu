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
% 06/29/2021: modified to be used for observation data:
%    removed the realization loops
%    changed the main path to a sigle 'OBSpath'

clear all;
% close all;

set(0,'defaultaxesfontsize',13);

% don't change these two 
EVENTs={'laquila/';'whittier/';'nps/';'tottori/';'niigata/';'nr/'; ...
    'lomap/';'landers1seg/';'ch/';'ar/';'ridgec/'};
METHODs={'csm/';'ucsb/';'exsim/';'gp/';'sdsu/'};

% change these instead
EVENTsdo=[11];
METHODsdo=5;

OBSpath='../Ridgecrest-c_xuk/BBin_0519/Obs_rcc_0603';

tic
for jj=EVENTsdo
    EVENT=EVENTs{jj};
    STATs={ '28001-5419' '28002-32076' '28003-43158' '28004-APL' ...
             '28005-AVM' '28006-CCA' '28007-CCC' '28008-CGO' '28009-CLC' ...
             '28010-CWC' '28011-DAW' '28012-DTP' '28013-EDW2' '28014-FDR' ...
             '28015-FUR' '28016-GSC' '28017-HAR' '28018-HYS' '28019-ISA' ...
             '28020-JRC2' '28021-LDR' '28022-LMR2' '28023-LRL' '28024-MPM' ...
             '28025-PUT' '28026-Q0068' '28027-RRX' '28028-SBB2' ...
             '28029-SHO' '28030-SLA' '28031-SPG2' '28032-SRT' '28033-TEH' ...
             '28034-TEJ' '28035-TOW2' '28036-TPO' '28037-WAS2' '28038-WBM' ...
             '28039-WBS' '28040-WCS2' '28041-WHF' '28042-WMF' '28043-WNM' ...
             '28044-WOR' '28045-WRC2' '28046-WRV2' '28047-WVP2'};
%     
    for kk=METHODsdo
        METHOD=METHODs{kk};
        disp([ EVENT ' - ' METHOD ])
            
        % generate the directory for SA files
        SAdir = [OBSpath '/SA/'];
        mkdir (SAdir);
                
        for ss=1: length(STATs)

            STAT=STATs{ss};

            % input LF velocity files (simplified)
            VELpath=[OBSpath '/' STAT '.bbp'];

            % output acceleration files (simplified)
            THpath=[OBSpath  '/' STAT ];
            EWpath=[THpath '_E.acc'];
            NSpath=[THpath '_N.acc'];

            [gE, gN, npts, dt] = BBs_obs_conv_NE(VELpath);

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

    end
end
tocc=toc;
disp(['** Finished: Elapsed time is ' num2str(floor(100*tocc/60/60)/100) ' hrs'])
