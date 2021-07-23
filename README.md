# BBplatform_sdsu
```
BBplatform written by Kim Olsen and Nan Wang, version 20210503 with multisegment updates.
a log file to track procedures for running the BBcode
originated: 2021/03/29 by Ke Xu (kxu4143@sdsu.edu)
```

### changelog:
  ```
  - 2021/03/29: generated file and started in ‘file structure’ part
  - 2021/07/08: modified for changed file structures
  - 2021/07/23: added into github and inserted some new comments
  ```

## 1/ Running tips
- 1.1. Start a simulation  

  - (1) Preparations: install gfortran compiler

  - (2) Check and compile the bbplatform codes:  
    ```
    cd BB_code_multi0503
    csh compile.sh
    cp BBtoolbox-newrl-rupspeed-new-randomiseed.exe ~/YOUR/RUNNING/DIRECTORY/.
    ```

  - (3) Check and modify the input/output paths
    * [in 2.3-(1): testDATE.bbpar]
    ```
    - /* OUTPUT DIRECTORY */
    - /* VELOCITY MODEL FILE */
    - /* STATIONS FILE */
    - /* 2ND STATIONS FILE */ (*.dat, optional)
    - /* EXTENDED FAULT-MODEL FILE */
    - /* SCATTERING PARAMETERS FILE */
    - /* SRF FILE */
    - /* CORRELATION FILES */ (*.bin, optional)
    ```
    
    * [in 2.2-(2): /* STATIONS FILE */]
    ```
    - /* INPUT DIRECTORY */ (for input LF results)
    ```

  - (4) Run code and provide the .bbpar file
    ```
    cd  ~/YOUR/RUNNING/DIRECTORY/.
    ./BBtoolbox-newrl-rupspeed-new-randomiseed.exe
    [keyboard input: testDATE.bbpar]
    ```

  - (5) Post-processing: observations
    * Modify and run BBs_obs_conv_NE.m & BBs_obs_rd50_kxu.m
      (Not needed when observation rd50's are provided)

  - (6) Post-processing: comparisons
    * Modify and run BBs_hyb_rd50_kxu.m
    ```
    cd mtools
    # transfer hyb results into rd50
    # modify:
    # EVENTsdo, METHODsdo (current simulation)
    # EVEpath, BBdir (paths to output files)
    # rls, rlz (start & number of realizations)
    matlab -nodisplay
    BBs_hyb_rd50_kxu
    ```

    * Modify and run BBs_GOFplot_kxu.m
    ```
    cd mtools
    # plot GOF for rd50 with observations
    # modify:
    # EVENTs, METHODs (current simulation)
    # EVEpath, BBdir (paths to output files)
    # DATAdir, DDIR (paths to observation data)
    # PLTdir (path to output figures)
    # do_rlz (total number of realizations)
    #
    # !! Check 90:95 for the correct input file formats !!
    #
    matlab -nodisplay
    BBs_GOFplot_kxu
    ```

- 1.2. Notes on realizations

  - (1) Changes made for realizations:  
    * iseed & cseed [in 2.2-(1) scattering.dat].  

    * seed value in SRC files [not included in bbplatform].  
    ```
    # SRC files are used by GP rupture generator & LF simulations
    # SRC files determine:
    # /* rake */ in .bbpar file
    # rupture speed and slip distributions in SRF file
    # difference in extened_fault file
    # difference in LF simulations
    ```

    * other param/data files remain unchanged.  
      (.bbpar, bbtstations.dat, vmod.txt, observation data)

## 2/ file structure: [bbplatform_sdsu]
- 2.1. BB_code_multi0503/.  
The main codes for BB calculations, with new features added for correlations, rupture speed and multi-segment subfaults by Nan Wang (nwang@sdsu.edu).
Version: 2021-05-03
(Last version: correlation_update_05100202_Rupspeed_10062020)

  - (1) ./CorrelationMatrixGenerator/.  
Contains Matlab codes to generate input correlation files, used for correlation feature, files including:  

    * SDSU_BBP_CorrelationMatrixGenerator.m: main code;  

    * nearestSPD.m: a function to find the nearest Symmetric Positive Definite matrix, used in correlation generator;  

    * B_EAS_2020.mat and empirical_coeff.mat: input coefficients used in correlation generator in Matlab;  

    * *.bin: generated matrix files, Ksp1, Ksp2, Ksp3 for spatial correlations, and Kinf for inter-freq correlations.  

  - (2) f90 code files updated for correlations, rupspeed, and multi-segments:  

    * main_bbtoolbox_0315_corr.f90:  
      main Fortran program to be compiled.  

    * composition_lenupdate0421_corr_rupspeed.f90:  
      functions & subroutines for frequency-domain composition given LF & HF simulations, including the amplitude & phase matching. With some minor changes for debugging (setting fixed Vrup_ratio).  

    * correlation_lenupdate_corr.f90:

    * io_0315_lenupdate0421_corr_multi0503.f90:

    * scattering_0328_corr.f90:

    * source_0315_lenupdate0421_multi0503.f90:

    * module_bbtoolbox_0328_lenupdate0421_corr_rupspeed.f90:

    * module_interface_corr.f90


  - (3) Some other f90/c code files used that are not updated:  

    * coda_lenupdate0421.f90:

    * convolution_lenupdate0421.f90

    * error.f90

    * filtering.f90:

    * fourier.f90:

    * geometry.f90

    * integ_diff.f90

    * interpolation_lenupdate0421.f90

    * random.f90

    * ray3DJHfor.c


- 2.2/ EVENT_NAME/BBin_DATE/.  
  Parameter files and recordings data used in the simulation, specified for one event, containing information for source subfaults, media structure, scattering settings, LF simulation results, and observed time series.  

  - (1) parameter files modified for correlation calculations: 

    * scattering_corr.dat:  
      scattering model parameters, including random seeds and time/freq factors.
    
      - corr_flag: changed to have three options: 0, 1, 2, option 2 is added for spatial correlation;
      - cseed: for inter-freq correlation.

  - (2) other supporting parameter files:  

    * bbtstations_EVENT_VERSION.dat:  
      specifications for station files used in broadband simulations (directory, format, names, X-Y-Z locations);

    * extended_fault:  
      source fault locations (separated in 118 sections in this case);

    * sdsu-REGION_VERSION-vmod.txt:  
      SDSU format velocity model for BB Platform (1D model);

    * xyz_EVENT_VERSION.srf:  
      SRF file used to set the source time functions for all subfaults, headers include: segment_num, subfault_num; lon, lat, size; strike, dip, dtop, shyp, dhyp, total points of multiple segments; insides include: subfault locations, areas, tony, dt, slip1, and time series.

  - (3) ./LF_ch/: LF-band simulation results used in BBP.  

    * NUMBER-SITE-lf.bbp:  
      bbp-data files recording the LF seismic data simulated for each site;

    * LF_cm2m.py:  
      python script to change the units and formats in LF data files;

  - (4) ./Obs_rcc_DATE/: Observed seismic recordings for output comparisons.  

    * NUMBER-SITE.bbp:  
      original seismic recording time series for each site;

    * NUMBER-SITE_E/N.acc:  
      acceleration series generated by Matlab scripts, for result comparisons;

    * ./SA/ NUMBER-SITE.rotd50 & ./SA/ NUMBER-SITE.psa5:  
      spectral amplitudes data generated by Matlab scripts, for result comparisons;

- 2.3/ EVENT_NAME/test_DATE/.  
  Executive program, parameter files, and correlation bin files for a specific set of running test. BB output data files and corresponding figures are also generated and stored here.

  - (1) supporting parameter files:  

    * testDATE.bbpar: The main parameter file, directing to all needed files.  
      - Input correlation file names are added at the last four lines. [Kinf_*.bin] for inter-freq correlation; [Ksp*.bin] for spatial correlation;
      - Directory and filenames: output, velocity model, fault model, scattering param, SRF file;
      - Params: hypocenter location, magnitude, source mechanism, rake angle, gridding in ray tracing;
      - Other choices: modality flag, source TF mode, verbose mode?

    * Kinf*.bin & Ksp*.bin: correlation matrix files generated and moved from 1.1(1);  

  - (2) running files:

    * BBtoolbox-newrl-rupspeed-new-randomiseed.exe:  
      program compiled in BBcode directory and moved here for running;

    * run.log:  
      a log-file to record the parameters/properties and time spent during the computation process.

  - (3) outputs:

    * ./figures/:  
      Resulting figures generated by Matlab scripts.

    * ./BBout_DATE_rlz_NR/:  
      Output files for a specific test and realization number, needed to be generated before running a realization.

- 2.4/ mtools/.  
	Matlab codes for pre- and post-processing for input/output data.  

  - (1) New Matlab scripts for pre & post processing:

    * BBS_obs_conv_NE.m:  
      function used in RotD50 calculation, to convert the original .bbp recordings into N-E acceleration time series;

    * BBs_obs_rd50_kxu.m:  
      Calculate RotD50 for observation data;

    * BBs_hyb_rd50_kxu.m:  
      Calculate RotD50 & PSAs for hybrid simulation results;

    * BBs_GOFplot_kxu.m:  
      Draw GOF and PSA plots to compare simulated and observed data.

  - (2) Functions, subroutines and parameters used for these calculations:  

    * ./Rot_CalcRsp_20120919/:  
      Fortran codes to calculate RotD50 from acc time series, the compiled program used in 1.4(1) Matlab scripts;

    * read_rd50_2.m:  
      read RotD50 data from file with specific format

    * calculate_BBs_in_g.m:  
      convert original data into acc time series in unit [g];

    * vel2acc.m:  
      convert velocity time series to accelerations;

    * EVENT_station_freq_range.mat:  
      the frequency ranges for all stations to be calculated & compared

  - (3) Former Matlab scripts with other functions (not currently used though)  

    * compare_test.m:  
      compare results from different settings and output folders;

    * plot_acc.m & plot_dat.m:  
      plot the acc & vel times series & plot all data available for 100s and 300s results (What’s that mean?)

    * s02_BBs_vel2acc_to_rd50_1rlz_new.m && s03_GOF_1rlz_new.m:  
      Former versions for RotD50 calculation and GOF plotting.
