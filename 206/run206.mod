2017-08-27 
오후 01:04
;; 1. Based on:
;; 2. Description: Final PK model
;; x1. Author: user
;; 3. Label:
$PROBLEM    Final PK model
$INPUT      ID TIMEM=DROP TIME RAWDV=DROP DV AMT IIMIN=DROP II ADDL
            CMT DOSE=DROP OXY=DROP SEX PERIOD=DROP WATER=DROP MDV
            AGE=DROP HT=DROP WT SCR=DROP AST=DROP ALT=DROP
; Units

;; DV = g/L

;; AMT = g
$DATA      PKdata_ver5.csv IGNORE=#
$SUBROUTINE ADVAN6 TOL=6
$MODEL      NCOMP=2 COMP=(DEPOT) COMP=(CENTRAL)
$PK 
;;; VMSEX-DEFINITION START
IF(SEX.EQ.1) VMSEX = 1  ; Most common
IF(SEX.EQ.2) VMSEX = ( 1 + THETA(8))
;;; VMSEX-DEFINITION END

;;; VM-RELATION START
VMCOV=VMSEX
;;; VM-RELATION END

;;; VCWT-DEFINITION START
VCWT = ( 1 + THETA(7)*(WT - 69))
;;; VCWT-DEFINITION END

;;; VC-RELATION START
VCCOV=VCWT
;;; VC-RELATION END

; Population parameter
TVKA = THETA(1)
TVVC = THETA(2)
TVVC = VCCOV*TVVC
TVVM = THETA(3)
TVVM = VMCOV*TVVM
TVKM = THETA(4)

; Individual parameter
KA = TVKA; * EXP(ETA(1))
VC = TVVC * EXP(ETA(1))
VM = TVVM * EXP(ETA(2))
KM = TVKM; * EXP(ETA(2))

S2 = VC
;KEL = CL/VC

$DES 
CONC = A(2)/VC
DADT(1) =  -KA*A(1)
DADT(2) = KA*A(1) - VM*CONC/(KM+CONC)

$ERROR 
IPRED = F
    W = SQRT(THETA(5)**2*IPRED**2 + THETA(6)**2)
    Y = IPRED + W*EPS(1)
 IRES = DV-IPRED
IWRES = IRES/W

$THETA  (0,8.09658) ; 1.KA
 (0,73.6782) ; 2.VC
 (0,9.64917) ; 3.Vmax
 (0,0.0408837) ; 4. Km
 (0,0.179277) ; Prop.RE (sd)
 (0,0.001) FIX ; Add.RE (sd)
$THETA  (-0.111,0.016739,0.045) ; VCWT1
$THETA  (-1,-0.235138,5) ; VMSEX1
$OMEGA  0.0498046  ;         VC
 0.0116147  ;         VM
;0.47 2.71  ; KM
$SIGMA  1  FIX  ; Proportional error PK
$ESTIMATION METHOD=1 INTER MAXEVAL=5000 NOABORT NSIG=3 SIGL=6 PRINT=5
; Xpose
$TABLE      ID TIME DV MDV IPRED IWRES CWRES ONEHEADER NOPRINT
            FILE=sdtab206
$TABLE      ID VC KA VM KM ETA(1) ETA(2) ONEHEADER NOPRINT
            FILE=patab206
;$TABLE ID SEX ONEHEADER NOPRINT FILE=catab206

;$TABLE ID AGE HT WT SCR AST ALT ONEHEADER NOPRINT FILE=cotab206
$COVARIANCE

  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
  
License Registered to: Chungnam National University
Expiration Date:    14 JAN 2018
Current Date:       27 AUG 2017
Days until program expires : 142
1NONLINEAR MIXED EFFECTS MODEL PROGRAM (NONMEM) VERSION 7.3.0
 ORIGINALLY DEVELOPED BY STUART BEAL, LEWIS SHEINER, AND ALISON BOECKMANN
 CURRENT DEVELOPERS ARE ROBERT BAUER, ICON DEVELOPMENT SOLUTIONS,
 AND ALISON BOECKMANN. IMPLEMENTATION, EFFICIENCY, AND STANDARDIZATION
 PERFORMED BY NOUS INFOSYSTEMS.

 PROBLEM NO.:         1
 Final PK model
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:     1141
 NO. OF DATA ITEMS IN DATA SET:  11
 ID DATA ITEM IS DATA ITEM NO.:   1
 DEP VARIABLE IS DATA ITEM NO.:   3
 MDV DATA ITEM IS DATA ITEM NO.:  9
0INDICES PASSED TO SUBROUTINE PRED:
  11   2   4   0   0   5   7   0   0   0   6
0LABELS FOR DATA ITEMS:
 ID TIME DV AMT II ADDL CMT SEX MDV WT EVID
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 KA VC VM KM IPRED IWRES
0FORMAT FOR DATA:
 (E3.0,E12.0,2E6.0,E12.0,4E2.0,E5.0,1F2.0)

 TOT. NO. OF OBS RECS:      823
 TOT. NO. OF INDIVIDUALS:     53
0LENGTH OF THETA:   8
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   2
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   1
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
 LOWER BOUND    INITIAL EST    UPPER BOUND
  0.0000E+00     0.8097E+01     0.1000E+07
  0.0000E+00     0.7368E+02     0.1000E+07
  0.0000E+00     0.9649E+01     0.1000E+07
  0.0000E+00     0.4088E-01     0.1000E+07
  0.0000E+00     0.1793E+00     0.1000E+07
  0.1000E-02     0.1000E-02     0.1000E-02
 -0.1110E+00     0.1674E-01     0.4500E-01
 -0.1000E+01    -0.2351E+00     0.5000E+01
0INITIAL ESTIMATE OF OMEGA:
 0.4980E-01
 0.0000E+00   0.1161E-01
0INITIAL ESTIMATE OF SIGMA:
 0.1000E+01
0SIGMA CONSTRAINED TO BE THIS INITIAL ESTIMATE
0COVARIANCE STEP OMITTED:        NO
 EIGENVLS. PRINTED:              NO
 SPECIAL COMPUTATION:            NO
 COMPRESSED FORMAT:              NO
 SIGDIGITS ETAHAT (SIGLO):                  -1
 SIGDIGITS GRADIENTS (SIGL):                -1
 RELATIVE TOLERANCE (TOL):                  -1
 ABSOLUTE TOLERANCE-ADVAN 9,13 ONLY (ATOL): -1
 EXCLUDE COV FOR FOCE (NOFCOV):              NO
 RESUME COV ANALYSIS (RESUME):               NO
0TABLES STEP OMITTED:    NO
 NO. OF TABLES:           2
 SEED NUMBER (SEED):    11456
 RANMETHOD:
 MC SAMPLES (ESEED):    300
 WRES SQUARE ROOT TYPE:            EIGENVALUE
0-- TABLE   1 --
 PRINTED:                NO
 HEADERS:               ONE
 FILE TO BE FORWARDED:   NO
 FORMAT:                S1PE11.4
 LFORMAT:
 RFORMAT:
0USER-CHOSEN ITEMS:
 ID TIME DV MDV IPRED IWRES CWRES
0-- TABLE   2 --
 PRINTED:                NO
 HEADERS:               ONE
 FILE TO BE FORWARDED:   NO
 FORMAT:                S1PE11.4
 LFORMAT:
 RFORMAT:
0USER-CHOSEN ITEMS:
 ID VC KA VM KM ETA1 ETA2
1DOUBLE PRECISION PREDPP VERSION 7.3.0

 GENERAL NONLINEAR KINETICS MODEL (ADVAN6)
0MODEL SUBROUTINE USER-SUPPLIED - ID NO. 9999
0MAXIMUM NO. OF BASIC PK PARAMETERS:   4
0COMPARTMENT ATTRIBUTES
 COMPT. NO.   FUNCTION   INITIAL    ON/OFF      DOSE      DEFAULT    DEFAULT
                         STATUS     ALLOWED    ALLOWED    FOR DOSE   FOR OBS.
    1         DEPOT        ON         YES        YES        YES        NO
    2         CENTRAL      ON         YES        YES        NO         YES
    3         OUTPUT       OFF        YES        NO         NO         NO
0NRD VALUE FROM SUBROUTINE TOL:   6
1
 ADDITIONAL PK PARAMETERS - ASSIGNMENT OF ROWS IN GG
 COMPT. NO.                             INDICES
              SCALE      BIOAVAIL.   ZERO-ORDER  ZERO-ORDER  ABSORB
                         FRACTION    RATE        DURATION    LAG
    1            *           *           *           *           *
    2            5           *           *           *           *
    3            *           -           -           -           -
             - PARAMETER IS NOT ALLOWED FOR THIS MODEL
             * PARAMETER IS NOT SUPPLIED BY PK SUBROUTINE;
               WILL DEFAULT TO ONE IF APPLICABLE
0DATA ITEM INDICES USED BY PRED ARE:
   EVENT ID DATA ITEM IS DATA ITEM NO.:     11
   TIME DATA ITEM IS DATA ITEM NO.:          2
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   4
   INTERVAL DATA ITEM IS DATA ITEM NO.:      5
   ADDL. DOSES DATA ITEM IS DATA ITEM NO.:   6
   COMPT. NO. DATA ITEM IS DATA ITEM NO.:    7

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
0DES SUBROUTINE USES COMPACT STORAGE MODE.
1


 #TBLN:      1
 #METH: First Order Conditional Estimation with Interaction

 ESTIMATION STEP OMITTED:                 NO  
 ANALYSIS TYPE:                           POPULATION
 CONDITIONAL ESTIMATES USED:              YES 
 CENTERED ETA:                            NO  
 EPS-ETA INTERACTION:                     YES 
 LAPLACIAN OBJ. FUNC.:                    NO  
 NO. OF FUNCT. EVALS. ALLOWED:            5000
 NO. OF SIG. FIGURES REQUIRED:            3
 INTERMEDIATE PRINTOUT:                   YES 
 ESTIMATE OUTPUT TO MSF:                  NO  
 ABORT WITH PRED EXIT CODE 1:             NO  
 IND. OBJ. FUNC. VALUES SORTED:           NO  
 NUMERICAL DERIVATIVE 
       FILE REQUEST (NUMDER):             NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP): 0           
 ETA HESSIAN EVALUATION METHOD (ETADER):  0           
 INITIAL ETA FOR MAP ESTIMATION (MCETA):  0           
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):    6           
 GRADIENT SIGDIGITS OF 
       FIXED EFFECTS PARAMETERS (SIGL):   6           
 EXCLUDE TITLE (NOTITLE):                 NO 
 EXCLUDE COLUMN LABELS (NOLABEL):         NO 
 NOPRIOR SETTING (NOPRIOR):               OFF
 NOCOV SETTING (NOCOV):                   OFF
 DERCONT SETTING (DERCONT):               OFF
 ABSOLUTE TOLERANCE-ADVAN 9,13 ONLY(ATOL):-100        
 FINAL ETA RE-EVALUATION (FNLETA):        ON 
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS 
       IN SHRINKAGE (ETASTYPE):           NO 
 NON-INFL. ETA CORRECTION (NONINFETA):    OFF
 FORMAT FOR ADDITIONAL FILES (FORMAT):    S1PE12.5
 PARAMETER ORDER FOR OUTPUTS (ORDER):     TSOL
 ADDITIONAL CONVERGENCE TEST (CTYPE=4)?:  NO
 EM OR BAYESIAN METHOD USED:                NONE


 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=PREDI
 RES=RESI
 WRES=WRESI
 IWRS=IWRESI
 IPRD=IPREDI
 IRS=IRESI

 MONITORING OF SEARCH:


0ITERATION NO.:    0    OBJECTIVE VALUE:  -2477.21427061810        NO. OF FUNC. EVALS.:   9
 CUMULATIVE NO. OF FUNC. EVALS.:        9
 NPARAMETR:  8.0966E+00  7.3678E+01  9.6492E+00  4.0884E-02  1.7928E-01  1.6739E-02 -2.3514E-01  4.9805E-02  1.1615E-02
 PARAMETER:  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01
 GRADIENT:   1.3842E-02  2.4111E+00  5.3762E+00  1.5983E-02  1.7119E-01  2.3799E-01  1.1076E+00 -7.5399E-04 -2.9891E-03

0ITERATION NO.:    4    OBJECTIVE VALUE:  -2477.21427101116        NO. OF FUNC. EVALS.:  14
 CUMULATIVE NO. OF FUNC. EVALS.:       96
 NPARAMETR:  8.0965E+00  7.3678E+01  9.6491E+00  4.0889E-02  1.7928E-01  1.6739E-02 -2.3514E-01  4.9805E-02  1.1615E-02
 PARAMETER:  9.9994E-02  1.0000E-01  9.9996E-02  1.0014E-01  9.9999E-02  9.9996E-02  1.0000E-01  1.0000E-01  1.0002E-01
 GRADIENT:   1.3952E-04 -4.5411E-03 -2.9977E-02  1.0904E-03  3.6343E-03  4.5275E-04 -1.2416E-02 -1.9827E-03 -1.3826E-03

 #TERM:
0MINIMIZATION SUCCESSFUL
 HOWEVER, PROBLEMS OCCURRED WITH THE MINIMIZATION.
 REGARD THE RESULTS OF THE ESTIMATION STEP CAREFULLY, AND ACCEPT THEM ONLY
 AFTER CHECKING THAT THE COVARIANCE STEP PRODUCES REASONABLE OUTPUT.
 NO. OF FUNCTION EVALUATIONS USED:       96
 NO. OF SIG. DIGITS IN FINAL EST.:  3.1

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.

 ETABAR:        -6.1782E-03  6.4498E-03
 SE:             2.9476E-02  1.3257E-02
 N:                      53          53

 P VAL.:         8.3398E-01  6.2659E-01

 ETAshrink(%):   2.9236E+00  9.5943E+00
 EBVshrink(%):   3.8670E+00  1.1215E+01
 EPSshrink(%):   5.3806E+00

 #TERE:
 Elapsed estimation time in seconds:    10.95
 Elapsed covariance time in seconds:    24.39
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 #OBJT:**************                       MINIMUM VALUE OF OBJECTIVE FUNCTION                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    -2477.214       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         8.10E+00  7.37E+01  9.65E+00  4.09E-02  1.79E-01  1.00E-03  1.67E-02 -2.35E-01
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


            ETA1      ETA2   
 
 ETA1
+        4.98E-02
 
 ETA2
+        0.00E+00  1.16E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


            EPS1   
 
 EPS1
+        1.00E+00
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


            ETA1      ETA2   
 
 ETA1
+        2.23E-01
 
 ETA2
+        0.00E+00  1.08E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


            EPS1   
 
 EPS1
+        1.00E+00
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                            STANDARD ERROR OF ESTIMATE                          ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8     
 
         1.87E+00  2.65E+00  7.03E-01  4.27E-02  7.20E-03 .........  2.03E-03  2.87E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


            ETA1      ETA2   
 
 ETA1
+        1.04E-02
 
 ETA2
+       .........  5.39E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


            EPS1   
 
 EPS1
+       .........
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


            ETA1      ETA2   
 
 ETA1
+        2.33E-02
 
 ETA2
+       .........  2.50E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


            EPS1   
 
 EPS1
+       .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                          COVARIANCE MATRIX OF ESTIMATE                         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        3.50E+00
 
 TH 2
+       -5.04E-01  7.04E+00
 
 TH 3
+       -4.79E-01 -9.73E-02  4.95E-01
 
 TH 4
+       -3.16E-02 -5.26E-06  2.89E-02  1.83E-03
 
 TH 5
+       -3.58E-04  6.49E-03  1.88E-04  3.38E-05  5.18E-05
 
 TH 6
+       ......... ......... ......... ......... ......... .........
 
 TH 7
+       -1.74E-04  3.71E-03 -7.43E-05  4.15E-07  3.01E-06 .........  4.12E-06
 
 TH 8
+        8.09E-04  7.01E-03 -1.16E-02 -5.58E-04  1.53E-05 ......... -4.27E-06  8.25E-04
 
 OM11
+       -2.10E-03  1.10E-02  3.19E-03  2.12E-04  1.97E-05 .........  5.50E-06 -5.85E-05  1.08E-04
 
 OM12
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        1.26E-03  3.13E-03  1.43E-04 -2.84E-05 -4.91E-06 .........  1.52E-06 -3.16E-05  1.60E-06 .........  2.90E-05
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                          CORRELATION MATRIX OF ESTIMATE                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        1.87E+00
 
 TH 2
+       -1.02E-01  2.65E+00
 
 TH 3
+       -3.64E-01 -5.21E-02  7.03E-01
 
 TH 4
+       -3.96E-01 -4.63E-05  9.61E-01  4.27E-02
 
 TH 5
+       -2.66E-02  3.39E-01  3.72E-02  1.10E-01  7.20E-03
 
 TH 6
+       ......... ......... ......... ......... ......... .........
 
 TH 7
+       -4.58E-02  6.89E-01 -5.20E-02  4.78E-03  2.06E-01 .........  2.03E-03
 
 TH 8
+        1.51E-02  9.19E-02 -5.76E-01 -4.55E-01  7.42E-02 ......... -7.32E-02  2.87E-02
 
 OM11
+       -1.08E-01  4.00E-01  4.36E-01  4.76E-01  2.63E-01 .........  2.61E-01 -1.96E-01  1.04E-02
 
 OM12
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+        1.25E-01  2.19E-01  3.78E-02 -1.23E-01 -1.27E-01 .........  1.39E-01 -2.04E-01  2.86E-02 .........  5.39E-03
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************               FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION              ********************
 ********************                      INVERSE COVARIANCE MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      TH 6      TH 7      TH 8      OM11      OM12      OM22      SG11  

 
 TH 1
+        3.76E-01
 
 TH 2
+        5.81E-02  3.78E-01
 
 TH 3
+        6.54E-01  3.15E-01  6.71E+01
 
 TH 4
+       -6.24E-01 -2.70E+00 -1.00E+03  1.61E+04
 
 TH 5
+       -6.43E+00 -2.33E+01  9.71E+01 -1.83E+03  2.37E+04
 
 TH 6
+       ......... ......... ......... ......... ......... .........
 
 TH 7
+        1.07E+01 -2.71E+02  1.66E+03 -2.31E+04  5.98E+03 .........  5.29E+05
 
 TH 8
+        6.47E+00 -5.00E+00  2.27E+02 -2.70E+03 -3.34E+01 .........  1.23E+04  2.65E+03
 
 OM11
+       -1.23E+01 -2.55E+01  2.84E-01 -1.99E+03 -1.75E+03 .........  3.05E+03  5.22E+01  1.57E+04
 
 OM12
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 OM22
+       -2.03E+01 -4.13E+01 -1.20E+03  1.91E+04  4.28E+03 ......... -1.55E+04 -1.27E+03  8.35E+01 .........  6.45E+04
 
 SG11
+       ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... ......... .........
 
 #CPUT: Total CPU Time in Seconds,       36.063
Stop Time: 
2017-08-27 
오후 01:05
