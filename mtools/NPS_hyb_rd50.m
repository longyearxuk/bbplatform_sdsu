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
    'lomap/';'landers1seg/';'ch/';'ar/';'ridgec/'};
METHODs={'csm/';'ucsb/';'exsim/';'gp/';'sdsu/'};

% change these instead
EVENTsdo=[3];
METHODsdo=5;

%EVEpath='../Ridgecrest-c_xuk';
%BBdir='/test_0714/BBout_0714';
EVEpath = '../sngl_rlz/nps';
BBdir   = '/BBout_0728';

rls=0;		% start of realization num
rlz=1;		% number of realizations

tic
for jj=EVENTsdo
    EVENT=EVENTs{jj};
    STATs = {'9001-NPS'  '9009-H08'  '9017-SNY'  '9026-H01' ...
        '9002-WWT'  '9010-JOS'  '9018-H04'  '9027-TFS' ...
        '9003-DSP'  '9011-CFR'  '9019-ARM'  '9028-RIV' ...
        '9004-CAB'  '9012-HCP'  '9020-ARS'  '9029-LMR' ...
        '9005-PSA'  '9013-H06'  '9021-IND'  '9030-PLC' ...
        '9006-MVH'  '9014-H05'  '9022-AZF'  '9031-HES' ...
        '9007-FVR'  '9015-LDR'  '9024-H02'  '9032-CLJ' ...
        '9008-SIL'  '9016-INO'  '9025-ATL'};
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
