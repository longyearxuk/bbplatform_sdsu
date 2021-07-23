%% Correlation Matrix Generator for San Diego State University Broadband Ground-Motion Simulation Module on SCEC BBP(MATLAB version)
% Author: Nan Wang
% Date: 05/06/2020
% Dependencies: nearestSPD.m
% Input files: empirical_coeff.mat, B_EAS_2020.mat
% Output files: Kinf.bin, Ksp1.bin, Ksp2.bin, Ksp3.bin

%% Input BB LF information (same parameter names as in BBcode)
% Input LF time step
ts_dt = 0.1;
% Input LF total number of time points
wts_npts = 1000;
% Compute input LF time-series length, this is how BBcode compute the LF timelength (starts at 0 second), could directly input this value if known, ignoring ts_dt and wts_npts.
wts_len = (wts_npts-1)*ts_dt;

%% Compute frequency step (df) used for correlation matrix elements
% Fixed parameters
tmp_npts = 32768;
tmp_lf_len = 102.3750;
% Compute total number of time point used in BB computation
n = ceil(wts_len/tmp_lf_len);
v_npts = (tmp_npts-1)*n+1;
npts = v_npts;
exponent = log(npts) / log(2.0);
if (exponent ~= fix(exponent))  
    npts = 2^(ceil(exponent));
end
% Compute dt and df
dt = tmp_lf_len/(tmp_npts-1);
df = 1 / (npts * dt);

%% Matrix interpolation to match the BB df
%% ========= For interfrequency correlation ====================================================
tic
% Read in empirical frequency vector and correlation matrix
load('empirical_coeff.mat');
% Maximum and minimum empirical frequency of correlation implementation
fcorrmax_inf = max(emp_f);
fcorrmin_inf = min(emp_f);
% Compute corresponding index of minimum empirical frequency and its range
nks_inf = ceil(fcorrmin_inf/df); % index in f that is less than empirical frequency value, should start computation at nks+1 (f vector in BBcode starts at 0 Hz)
nk_inf = floor(fcorrmax_inf/df) + 1 - nks_inf;  % number of index in f that is within the empirical frequency value range
% Generate interpolation mesh grid
ff_inf = df*(nks_inf:nks_inf+nk_inf-1);
[ffx_inf,ffy_inf] = meshgrid(ff_inf);
[empfx_inf,empfy_inf] = meshgrid(emp_f);
% Interpolation
Cint_inf = interp2(empfx_inf,empfy_inf,emp_coeff,ffx_inf,ffy_inf);
% Change diagonal elements to 1. Changing diagonal elements to 1 should be able to make Cint positive definite in practical, if not, use the following optional step.
for j = 1:length(ff_inf)
    Cint_inf(j,j) = 1;
end
% % Optional step: make sure Cint is positive definite
% % Cint_inf = nearestSPD(Cint_inf);
% Cholesky decomposition, keep the lower triangular matrix
Kinf = chol(Cint_inf,'lower');
toc
%% Save to bin file (order: nk, nks, Kinf; to match the io in BBcode)
% Note that Fortran and Matlab both use Column-major ordering, should also use Column-major ordering here in Python
fid1=fopen('Kinf.bin', "w");
fwrite(fid1, nk_inf, 'uint'); fclose(fid1);
fid1=fopen('Kinf.bin', "a");
fwrite(fid1, nks_inf, 'uint'); fclose(fid1);
fid1=fopen('Kinf.bin', "a");
fwrite(fid1, Kinf, 'real*4');
fclose(fid1);
% ========= End for interfrequency correlation =================================================

%% ========= For spatial correlation ============================================================
% Read in empirical frequency vector and correlation matrices(3)
tic
load('B_EAS_2020.mat');
% Maximum and minimum empirical frequency of correlation implementation
fcorrmax_sp = max(F_B);
fcorrmin_sp = min(F_B);
% Compute corresponding index of minimum empirical frequency and its range
nks_sp = ceil(fcorrmin_sp/df); % index in f that is less than empirical frequency value, should start computation at nks+1 (f vector in BBcode starts at 0 Hz)
nk_sp = floor(fcorrmax_sp/df) + 1 - nks_sp;  % number of index in f that is within the empirical frequency value range
% Generate interpolation mesh grid
ff_sp = df*(nks_sp:nks_sp+nk_sp-1);
[ffx_sp,ffy_sp] = meshgrid(ff_sp);
[empfx_sp,empfy_sp] = meshgrid(F_B);
% Interpolation
Bint_sp1 = interp2(empfx_sp,empfy_sp,b1,ffx_sp,ffy_sp);
Bint_sp2 = interp2(empfx_sp,empfy_sp,b2,ffx_sp,ffy_sp);
Bint_sp3 = interp2(empfx_sp,empfy_sp,b3,ffx_sp,ffy_sp);
% Make sure Bint is positive definite
Bint_sp1 = nearestSPD(Bint_sp1);
Bint_sp2 = nearestSPD(Bint_sp2);
Bint_sp3 = nearestSPD(Bint_sp3);
% Cholesky decomposition, keep the lower triangular matrix
Ksp1 = chol(Bint_sp1,'lower');
Ksp2 = chol(Bint_sp2,'lower');
Ksp3 = chol(Bint_sp3,'lower');
toc
%% Save to bin file 
% Note that Fortran and Matlab both use Column-major ordering, should also use Column-major ordering here in Python
% Ksp1 (order: nk, nks, Ksp1; to match the io in BBcode), only Ksp1.bin has nk nks
fid1 = fopen('Ksp1.bin', "w");
fwrite(fid1, nk_sp, 'uint'); fclose(fid1);
fid1 = fopen('Ksp1.bin', "a");
fwrite(fid1, nks_sp, 'uint'); fclose(fid1);
fid1 = fopen('Ksp1.bin', "a");
fwrite(fid1, Ksp1, 'real*4');
fclose(fid1);
% Ksp2
fid2 = fopen('Ksp2.bin', "w");
fwrite(fid2, Ksp2, 'real*4');
fclose(fid2);
% Ksp3
fid3 = fopen('Ksp3.bin', "w");
fwrite(fid3, Ksp3, 'real*4');
fclose(fid3);
% ========= End for spatial correlation ========================================================
