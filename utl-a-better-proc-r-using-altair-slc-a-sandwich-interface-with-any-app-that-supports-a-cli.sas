%let pgm=utl-a-better-proc-r-using-altair-slc-a-sandwich-interface-with-any-app-that-supports-a-cli;

%stop_submission;

A better proc r using altair slc a sandwich interface with any app that supports a cli

Too long to post to a listserv, see github

macros on end and in this repository
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories


This is a less flexible implementation then the previous macro wrapper solution.
The code is less complex.

github
https://github.com/rogerjdeangelis/utl-a-better-proc-r-using-altair-slc-macro-to-interface-with-any-app-that-supports-a-cli


THIS TECHNIQUE CAN BE USED WITH

     perl
     powershell
     python
     matlab (octave clone)
     spss ( pspp clone)
     excel
     most sql dialects
     (any application that supports a CLI)

/*****************************************************************************************************************/
/*        INPUT              |             PROCESS                       |                OUTPUT                 */
/* :/sd1/class.sas7bdat      | %utl_slc_rbegin;                          |   greetings=Greetings from R          */
/*                           | cards4;                                   |                                       */
/* NAME    SEX HEIGHT WEIGHT |   library(haven)                          |   TABLE WORK.CLASS                    */
/*                           |    library(dplyr)                         |   PREDICT WEIGHT USING HEIGHT         */
/* Alfred   M    14    69.0  |    want <- read_sas("&tblinp")            |                                       */
/* Alice    F    13    56.5  |    modl <- lm(WEIGHT ~ HEIGHT, data=want) |     NAME SEX HEIGHT WEIGHT   PREDICT  */
/* Barbara  F    13    65.3  |    want$PREDICT<-modl$fitted.values       |   Alfred   M   69.0  112.5 126.00617  */
/* Carol    F    14    62.8  |    writeClipboard("Greetings from R")     |    Alice   F   56.5   84.0  77.26829  */
/* Henry    M    14    63.5  |    &tblout <- want                        |  Barbara   F   65.3   98.0 111.57976  */
/* James    M    12    57.3  | ;;;;                                      |    Carol   F   62.8  102.5 101.83218  */
/* Jane     F    12    59.8  | %utl_slc_rend(                            |    Henry   M   63.5  102.5 104.56150  */
/* Janet    F    15    62.5  |    tblinp=d:/sd1/class.sas7bdat           |    James   M   57.3   83.0  80.38752  */
/* Jeffrey  M    13    62.5  |   ,tblout=class                           |     Jane   F   59.8   84.5  90.13509  */
/* John     M    12    59.0  |   ,return=greetings                       |    Janet   F   62.5  112.5 100.66247  */
/* Joyce    F    11    51.3  |   ,resolve=Y);                            |  Jeffrey   M   62.5   84.0 100.66247  */
/* Judy     F    14    64.3  |                                           |     John   M   59.0   99.5  87.01587  */
/* Louise   F    12    56.3  | %put &=greetings;                         |    Joyce   F   51.3   50.5  56.99333  */
/* Mary     F    15    66.5  |                                           |     Judy   F   64.3   90.0 107.68073  */
/* Philip   M    16    72.0  |                                           |   Louise   F   56.3   77.0  76.48849  */
/* Robert   M    12    64.8  |                                           |     Mary   F   66.5  112.0 116.25859  */
/* Ronald   M    15    67.0  |                                           |   Philip   M   72.0  150.0 137.70326  */
/* Thomas   M    11    57.5  |                                           |   Robert   M   64.8  128.0 109.63024  */
/* William  M    15    66.5  |                                           |   Ronald   M   67.0  133.0 118.20811  */
/*                           |                                           |   Thomas   M   57.5   85.0  81.16732  */
/*                           |                                           |  William   M   66.5  112.0 116.25859  */
/* &_init_;                  |                                           |                                       */
/* options ps=200;           |                                           |                                       */
/* libname sd1 sas7bdat      |                                           |                                       */
/*  "d:/sd1";                |                                           |                                       */
/* data sd1.class;           |                                           |                                       */
/* input                     |                                           |                                       */
/*  name$ sex$               |                                           |                                       */
/*   height weight;          |                                           |                                       */
/* cards4;                   |                                           |                                       */
/* Alfred  M 69.0 112.5      |                                           |                                       */
/* Alice   F 56.5  84.0      |                                           |                                       */
/* Barbara F 65.3  98.0      |                                           |                                       */
/* Carol   F 62.8 102.5      |                                           |                                       */
/* Henry   M 63.5 102.5      |                                           |                                       */
/* James   M 57.3  83.0      |                                           |                                       */
/* Jane    F 59.8  84.5      |                                           |                                       */
/* Janet   F 62.5 112.5      |                                           |                                       */
/* Jeffrey M 62.5  84.0      |                                           |                                       */
/* John    M 59.0  99.5      |                                           |                                       */
/* Joyce   F 51.3  50.5      |                                           |                                       */
/* Judy    F 64.3  90.0      |                                           |                                       */
/* Louise  F 56.3  77.0      |                                           |                                       */
/* Mary    F 66.5 112.0      |                                           |                                       */
/* Philip  M 72.0 150.0      |                                           |                                       */
/* Robert  M 64.8 128.0      |                                           |                                       */
/* Ronald  M 67.0 133.0      |                                           |                                       */
/* Thomas  M 57.5  85.0      |                                           |                                       */
/* William M 66.5 112.0      |                                           |                                       */
/* ;;;;                      |                                           |                                       */
/* run;quit;                 |                                           |                                       */
/*****************************************************************************************************************/


THERE ARE TWO FLAWS WITH THE SLC PROC R AND SAS PROC R

   1 proc r does not support a macro wrapper
   2 proc r does not provide r packages
      a  read a sas or wpd dataset
      b  create a sas datastep
   3 Proc R cannot access sas macro variables.
     The following fails in slc and sas

     %let slcvar=2;
     proc r;
     submit;
     x=&slcvar
     print(x)
     endsubmit;
     run;quit;

     > x=&slcvar
     Error: unexpected '&' in "x=&"
     > print(x)
     Error: object 'x' not found


STEPS IN USING A MACRO TO CALL R (WORKS FOR ME. MAY NEED MORE TESTING)

   0  Currently only one input and one output work SAS dataset is supported.
      Howevr the macro can return a sas macro variable with text or r objects.

   1  Using a command pipe you can stream the R program though the R interpreter

   2  Using CARDS4 allows clear R statement text

   3  The R program can contain macro calls and macro variables.
      However you have to set the resolve argument to "Y" in the second macro
      to resolve the macro triggers.
      Note SAS 'proc R' and slc 'Proc R' do not allow any kind of block submit
         None of these are supported
            a macro wrapper
            b call execute
            c embedded macro variable
            d dosubl and %dosubl
         The only way to to pass 'information' to R is to
           create a complete slc proc r program, resolved triggers,
           and then %include the file.

   4  The R haven package is used to read sas datasets for R processing.
      This is an improvement over 'proc r' because you can read sas datasets conditionally.
      In addition haven R can read sas format catalogs.

   5  There is no r package to create sas datasets The slc macro saves the entire R workspace,
      in the permanent hardcoded file, d:/wpswrk/workspace.RData. Subsequently, a proc r program
      is created that loads the workspace abd creates the sas dataset.

   6  The dsecond macro uses the clipboard to return text or objects created by R

   7  The r workspace, d:/wpswrk/workspace.RData, is then deleted.

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

&_init_;
options ps=200;
libname sd1 sas7bdat
 "d:/sd1";
data sd1.class;
input
 name$ sex$
  height weight;
cards4;
Alfred  M 69.0 112.5
Alice   F 56.5  84.0
Barbara F 65.3  98.0
Carol   F 62.8 102.5
Henry   M 63.5 102.5
James   M 57.3  83.0
Jane    F 59.8  84.5
Janet   F 62.5 112.5
Jeffrey M 62.5  84.0
John    M 59.0  99.5
Joyce   F 51.3  50.5
Judy    F 64.3  90.0
Louise  F 56.3  77.0
Mary    F 66.5 112.0
Philip  M 72.0 150.0
Robert  M 64.8 128.0
Ronald  M 67.0 133.0
Thomas  M 57.5  85.0
William M 66.5 112.0
;;;;
run;quit;

proc print data=sd1.have
  width=min;
run;quit;


Altair SLC

Obs     NAME      SEX    HEIGHT    WEIGHT

  1    Alfred      M      69.0      112.5
  2    Alice       F      56.5       84.0
  3    Barbara     F      65.3       98.0
  4    Carol       F      62.8      102.5
  5    Henry       M      63.5      102.5
  6    James       M      57.3       83.0
  7    Jane        F      59.8       84.5
  8    Janet       F      62.5      112.5
  9    Jeffrey     M      62.5       84.0
 10    John        M      59.0       99.5
 11    Joyce       F      51.3       50.5
 12    Judy        F      64.3       90.0
 13    Louise      F      56.3       77.0
 14    Mary        F      66.5      112.0
 15    Philip      M      72.0      150.0
 16    Robert      M      64.8      128.0
 17    Ronald      M      67.0      133.0
 18    Thomas      M      57.5       85.0
 19    William     M      66.5      112.0

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC     11:31 Thursday, November 13, 2025

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿;;;;
           ^
ERROR: Expected a statement keyword : found "ï"

NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.023
      cpu time  : 0.015


NOTE: AUTOEXEC processing completed

1
2         &_init_;
3         options ps=200;
4         libname sd1 sas7bdat
NOTE: Library sd1 assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\sd1

5          "d:/sd1";
6         data sd1.class;
7         input
8          name$ sex$
9           height weight;
10        cards4;

NOTE: Data set "SD1.class" has 19 observation(s) and 4 variable(s)
NOTE: The data step took :
      real time : 0.014
      cpu time  : 0.015


11        Alfred  M 69.0 112.5
12        Alice   F 56.5  84.0
13        Barbara F 65.3  98.0
14        Carol   F 62.8 102.5
15        Henry   M 63.5 102.5
16        James   M 57.3  83.0
17        Jane    F 59.8  84.5
18        Janet   F 62.5 112.5
19        Jeffrey M 62.5  84.0
20        John    M 59.0  99.5
21        Joyce   F 51.3  50.5
22        Judy    F 64.3  90.0
23        Louise  F 56.3  77.0
24        Mary    F 66.5 112.0
25        Philip  M 72.0 150.0
26        Robert  M 64.8 128.0
27        Ronald  M 67.0 133.0
28        Thomas  M 57.5  85.0
29        William M 66.5 112.0
30        ;;;;
31        run;quit;
32
33        proc print data=sd1.class
34          width=min;
35        run;quit;
NOTE: 19 observations were read from "SD1.class"
NOTE: Procedure print step took :
      real time : 0.012
      cpu time  : 0.000


36
ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 0.106
      cpu time  : 0.062


 /*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

proc datasets lib=work;
 delete class;
run;quit;

%symdel greeetings/ nowarn;

%utlfkil(d:/wpswrk/workspace.RData);

%utl_slc_rbegin;
cards4;
  library(haven)
   library(dplyr)
   want <- read_sas("&tblinp")
   modl <- lm(WEIGHT ~ HEIGHT, data=want)
   want$PREDICT<-modl$fitted.values
   writeClipboard("Greetings from R")
   &tblout <- want
;;;;
%utl_slc_rend(
   tblinp=d:/sd1/class.sas7bdat
  ,tblout=class
  ,return=greetings
  ,resolve=Y);

%utlfkil(d:/wpswrk/workspace.RData);

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

 Altair SLC     11:34 Thursday, November 13, 2025    2
>   library(haven)
>    library(dplyr)
>    want <- read_sas("d:/sd1/class.sas7bdat")
>    modl <- lm(WEIGHT ~ HEIGHT, data=want)
>    want$PREDICT<-modl$fitted.values
>    writeClipboard("Greetings from R")
>    class <- want
> save.image(file = 'd:/wpswrk/workspace.RData')
>

Altair SLC     11:34 Thursday, November 13, 2025    3

      NAME SEX HEIGHT WEIGHT   PREDICT
1   Alfred   M   69.0  112.5 126.00617
2    Alice   F   56.5   84.0  77.26829
3  Barbara   F   65
4    Carol   F   62.8  102.5 101.83218
5    Henry   M   63.5  102.5 104.56150
6    James   M   57.3   83.0  80.38752
7     Jane   F   59.8   84.5  90.13509
8    Janet   F   62.5  112.5 100.66247
9  Jeffrey   M   62.5   84.0 100.66247
10    John   M   59.0   99.5  87.01587
11   Joyce   F   51.3   50.5  56.99333
12    Judy   F   64.3   90.0 107.68073
13  Louise   F   56.3   77.0  76.48849
14    Mary   F   66.5  112.0 116.25859
15  Philip   M   72.0  150.0 137.70326
16  Robert   M   64.8  128.0 109.63024
17  Ronald   M   67.0  133.0 118.20811
18  Thomas   M   57.5   85.0  81.16732
19 William   M   66.5  112.0 116.25859
[1] "class" "modl"  "want"

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC     12:26 Thursday, November 13, 2025

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿;;;;
           ^
ERROR: Expected a statement keyword : found "ï"

NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.031
      cpu time  : 0.031


NOTE: AUTOEXEC processing completed


                                           Altair SLC     12:26 Thursday, November 13, 2025    2

                                     The DATASETS Procedure

                                           Directory

                              Libref           WORK
                              Engine           WPD
                              Physical Name    d:\wpswrk\_TD22716
1         proc datasets lib=work;
NOTE: No matching members in directory
2          delete class;
3         run;quit;
NOTE: WORK.CLASS (memtype="DATA") was not found, and has not been deleted
NOTE: Procedure datasets step took :
      real time : 0.015
      cpu time  : 0.000


4
5         %symdel greeetings/ nowarn;
6
7         %utlfkil(d:/wpswrk/workspace.RData);
The file d:/wpswrk/workspace.RData does not exist
8
9         %utl_slc_rbegin;
10        cards4;

NOTE: The file 'c:\temp\r_pgm.sas' is:
      Filename='c:\temp\r_pgm.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=14:24:42 Sep 27 2025,
      Last Accessed=12:26:31 Nov 13 2025,
      Last Modified=12:26:31 Nov 13 2025,
      Lrecl=32767, Recfm=V

  library(haven)
   library(dplyr)
   want <- read_sas("&tblinp")
   modl <- lm(WEIGHT ~ HEIGHT, data=want)
   want$PREDICT<-modl$fitted.values

2                                          Altair SLC     12:26 Thursday, November 13, 2025

   writeClipboard("Greetings from R")
   &tblout <- want
NOTE: 8 records were written to file 'c:\temp\r_pgm.sas'
      The minimum record length was 46
      The maximum record length was 80
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


11          library(haven)
12           library(dplyr)
13           want <- read_sas("&tblinp")
14           modl <- lm(WEIGHT ~ HEIGHT, data=want)
15           want$PREDICT<-modl$fitted.values
16           writeClipboard("Greetings from R")
17           &tblout <- want
18        ;;;;
19        %utl_slc_rend(
20           tblinp=d:/sd1/class.sas7bdat
21          ,tblout=class
22          ,return=greetings
23          ,resolve=Y);

NOTE: The infile 'c:\temp\r_pgm.sas' is:
      Filename='c:\temp\r_pgm.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=622,
      Create Time=14:24:42 Sep 27 2025,
      Last Accessed=12:26:31 Nov 13 2025,
      Last Modified=12:26:31 Nov 13 2025,
      Lrecl=32767, Recfm=V

NOTE: The file 'c:\temp\r_pgmx.sas' is:
      Filename='c:\temp\r_pgmx.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=11:34:47 Sep 03 2025,
      Last Accessed=12:26:31 Nov 13 2025,
      Last Modified=12:26:31 Nov 13 2025,
      Lrecl=32767, Recfm=V

NOTE: 8 records were read from file 'c:\temp\r_pgm.sas'
      The minimum record length was 46
      The maximum record length was 80
NOTE: 8 records were written to file 'c:\temp\r_pgmx.sas'
      The minimum record length was 46
      The maximum record length was 94
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.015



3                                          Altair SLC     12:26 Thursday, November 13, 2025


NOTE: The infile rut is:
      Unnamed Pipe Access Device,
      Process=D:\r451\bin\r.exe --vanilla --quiet --no-save < c:/temp/r_pgmx.sas,
      Lrecl=32767, Recfm=V

>   library(haven)
>    library(dplyr)
>    want <- read_sas("d:/sd1/class.sas7bdat")
>    modl <- lm(WEIGHT ~ HEIGHT, data=want)
>    want$PREDICT<-modl$fitted.values
>    writeClipboard("Greetings from R")
>    class <- want
> save.image(file = 'd:/wpswrk/workspace.RData')
>
NOTE: 9 records were written to file PRINT

NOTE: 9 records were read from file rut
      The minimum record length was 2
      The maximum record length was 96
Stderr output:

Attaching package: 'dplyr'

The following objects are masked from 'package:stats':

    filter, lag

The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union

NOTE: The data step took :
      real time : 1.090
      cpu time  : 0.000



NOTE: The infile 'c:\temp\r_pgm.sas' is:
      Filename='c:\temp\r_pgm.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=622,
      Create Time=14:24:42 Sep 27 2025,
      Last Accessed=12:26:31 Nov 13 2025,
      Last Modified=12:26:31 Nov 13 2025,
      Lrecl=32767, Recfm=V

  library(haven)
   library(dplyr)
   want <- read_sas("&tblinp")
   modl <- lm(WEIGHT ~ HEIGHT, data=want)
   want$PREDICT<-modl$fitted.values
   writeClipboard("Greetings from R")

4                                          Altair SLC     12:26 Thursday, November 13, 2025

   &tblout <- want
save.image(file = 'd:/wpswrk/workspace.RData')
NOTE: 8 records were read from file 'c:\temp\r_pgm.sas'
      The minimum record length was 46
      The maximum record length was 80
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000



NOTE: The infile clp is:
      Clipboard

xxxxxx  Greetings from R
NOTE: 1 record was read from file clp
      The minimum record length was 16
      The maximum record length was 16
NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.000


WARNING: The filename "ft15f001" has not been assigned
WARNING: The filename "r_pgm" has not been assigned

NOTE: The file tmp is:
      Filename='d:\wpswrk\_TD22716\#LN00001',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=12:26:33 Nov 13 2025,
      Last Accessed=12:26:33 Nov 13 2025,
      Last Modified=12:26:33 Nov 13 2025,
      Lrecl=32767, Recfm=V

NOTE: 9 records were written to file tmp
      The minimum record length was 4
      The maximum record length was 33
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.015


Start of %INCLUDE(level 1) tmp is file d:\wpswrk\_TD22716\#LN00001
24      +  options set=RHOME 'D:\d451';
25      +  proc R;
26      +  submit;
27      +  load('d:/wpswrk/workspace.RData')
28      +  want
29      +  ls()
30      +  endsubmit;
NOTE: Using R version 4.5.1 (2025-06-13 ucrt) from d:\r451


5                                          Altair SLC     12:26 Thursday, November 13, 2025

NOTE: Submitting statements to R:

> load('d:/wpswrk/workspace.RData')
> want
> ls()

NOTE: Processing of R statements complete

31      +  import r=class data=class;
NOTE: Creating data set 'WORK.class' from R data frame 'class'
NOTE: Data set "WORK.class" has 19 observation(s) and 5 variable(s)

32      +  run;quit;
NOTE: Procedure R step took :
      real time : 0.365
      cpu time  : 0.000


End of %INCLUDE(level 1) tmp

NOTE: The infile clp is:
      Clipboard

macro variable greetings = Greetings from R
NOTE: 1 record was read from file clp
      The minimum record length was 16
      The maximum record length was 16
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.015


33
34        %utlfkil(d:/wpswrk/workspace.RData);

                                           Altair SLC     12:26 Thursday, November 13, 2025    5

                                     The DATASETS Procedure

                                           Directory

                              Libref           WORK
                              Engine           WPD
                              Physical Name    d:\wpswrk\_TD22716

                                            Members

                         Member     Member
               Number    Name       Type          File Size      Date Last Modified

             ----------------------------------------------------------------------

                    1    CLASS      DATA               8192      13NOV2025:12:26:33
                    2    SASMACR    CATALOG           36864      13NOV2025:12:26:31
35        proc datasets lib=work;
36         delete class;
37        run;quit;
NOTE: Deleting "WORK.CLASS" (memtype="DATA")
NOTE: Procedure datasets step took :
      real time : 0.034
      cpu time  : 0.031


38
39        %symdel greeetings/ nowarn;
40
41        %utlfkil(d:/wpswrk/workspace.RData);
The file d:/wpswrk/workspace.RData does not exist
42
43        %utl_slc_rbegin;
44        cards4;

NOTE: The file 'c:\temp\r_pgm.sas' is:

6                                          Altair SLC     12:26 Thursday, November 13, 2025

      Filename='c:\temp\r_pgm.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=14:24:42 Sep 27 2025,
      Last Accessed=12:26:33 Nov 13 2025,
      Last Modified=12:26:33 Nov 13 2025,
      Lrecl=32767, Recfm=V

  library(haven)
   library(dplyr)
   want <- read_sas("&tblinp")
   modl <- lm(WEIGHT ~ HEIGHT, data=want)
   want$PREDICT<-modl$fitted.values
   writeClipboard("Greetings from R")
   &tblout <- want
NOTE: 8 records were written to file 'c:\temp\r_pgm.sas'
      The minimum record length was 46
      The maximum record length was 80
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


45          library(haven)
46           library(dplyr)
47           want <- read_sas("&tblinp")
48           modl <- lm(WEIGHT ~ HEIGHT, data=want)
49           want$PREDICT<-modl$fitted.values
50           writeClipboard("Greetings from R")
51           &tblout <- want
52        ;;;;
53        %utl_slc_rend(
54           tblinp=d:/sd1/class.sas7bdat
55          ,tblout=class
56          ,return=greetings
57          ,resolve=Y);

NOTE: The infile 'c:\temp\r_pgm.sas' is:
      Filename='c:\temp\r_pgm.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=622,
      Create Time=14:24:42 Sep 27 2025,
      Last Accessed=12:26:33 Nov 13 2025,
      Last Modified=12:26:33 Nov 13 2025,
      Lrecl=32767, Recfm=V

NOTE: The file 'c:\temp\r_pgmx.sas' is:
      Filename='c:\temp\r_pgmx.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=11:34:47 Sep 03 2025,
      Last Accessed=12:26:33 Nov 13 2025,
      Last Modified=12:26:33 Nov 13 2025,

7                                          Altair SLC     12:26 Thursday, November 13, 2025

      Lrecl=32767, Recfm=V

NOTE: 8 records were read from file 'c:\temp\r_pgm.sas'
      The minimum record length was 46
      The maximum record length was 80
NOTE: 8 records were written to file 'c:\temp\r_pgmx.sas'
      The minimum record length was 46
      The maximum record length was 94
NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.000



NOTE: The infile rut is:
      Unnamed Pipe Access Device,
      Process=D:\r451\bin\r.exe --vanilla --quiet --no-save < c:/temp/r_pgmx.sas,
      Lrecl=32767, Recfm=V

>   library(haven)
>    library(dplyr)
>    want <- read_sas("d:/sd1/class.sas7bdat")
>    modl <- lm(WEIGHT ~ HEIGHT, data=want)
>    want$PREDICT<-modl$fitted.values
>    writeClipboard("Greetings from R")
>    class <- want
> save.image(file = 'd:/wpswrk/workspace.RData')
>
NOTE: 9 records were written to file PRINT

NOTE: 9 records were read from file rut
      The minimum record length was 2
      The maximum record length was 96
Stderr output:

Attaching package: 'dplyr'

The following objects are masked from 'package:stats':

    filter, lag

The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union

NOTE: The data step took :
      real time : 1.110
      cpu time  : 0.000



NOTE: The infile 'c:\temp\r_pgm.sas' is:
      Filename='c:\temp\r_pgm.sas',

8                                          Altair SLC     12:26 Thursday, November 13, 2025

      Owner Name=T7610\Roger,
      File size (bytes)=622,
      Create Time=14:24:42 Sep 27 2025,
      Last Accessed=12:26:33 Nov 13 2025,
      Last Modified=12:26:33 Nov 13 2025,
      Lrecl=32767, Recfm=V

  library(haven)
   library(dplyr)
   want <- read_sas("&tblinp")
   modl <- lm(WEIGHT ~ HEIGHT, data=want)
   want$PREDICT<-modl$fitted.values
   writeClipboard("Greetings from R")
   &tblout <- want
save.image(file = 'd:/wpswrk/workspace.RData')
NOTE: 8 records were read from file 'c:\temp\r_pgm.sas'
      The minimum record length was 46
      The maximum record length was 80
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000



NOTE: The infile clp is:
      Clipboard

xxxxxx  Greetings from R
NOTE: 1 record was read from file clp
      The minimum record length was 16
      The maximum record length was 16
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


WARNING: The filename "ft15f001" has not been assigned
WARNING: The filename "r_pgm" has not been assigned

NOTE: The file tmp is:
      Filename='d:\wpswrk\_TD22716\#LN00003',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=12:26:34 Nov 13 2025,
      Last Accessed=12:26:34 Nov 13 2025,
      Last Modified=12:26:34 Nov 13 2025,
      Lrecl=32767, Recfm=V

NOTE: 9 records were written to file tmp
      The minimum record length was 4
      The maximum record length was 33
NOTE: The data step took :
      real time : 0.000

9                                          Altair SLC     12:26 Thursday, November 13, 2025

      cpu time  : 0.000


Start of %INCLUDE(level 1) tmp is file d:\wpswrk\_TD22716\#LN00003
58      +  options set=RHOME 'D:\d451';
59      +  proc R;
60      +  submit;
61      +  load('d:/wpswrk/workspace.RData')
62      +  want
63      +  ls()
64      +  endsubmit;
NOTE: Using R version 4.5.1 (2025-06-13 ucrt) from d:\r451

NOTE: Submitting statements to R:

> load('d:/wpswrk/workspace.RData')
> want
> ls()

NOTE: Processing of R statements complete

65      +  import r=class data=class;
NOTE: Creating data set 'WORK.class' from R data frame 'class'
NOTE: Data set "WORK.class" has 19 observation(s) and 5 variable(s)

66      +  run;quit;
NOTE: Procedure R step took :
      real time : 0.317
      cpu time  : 0.015


End of %INCLUDE(level 1) tmp

NOTE: The infile clp is:
      Clipboard

macro variable greetings = Greetings from R
NOTE: 1 record was read from file clp
      The minimum record length was 16
      The maximum record length was 16
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


67
68        %utlfkil(d:/wpswrk/workspace.RData);
69
ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 3.127
      cpu time  : 0.187

/*
 _ __ ___   __ _  ___ _ __ ___  ___
| `_ ` _ \ / _` |/ __| `__/ _ \/ __|
| | | | | | (_| | (__| | | (_) \__ \
|_| |_| |_|\__,_|\___|_|  \___/|___/

*/


data _null_;
 file "c:/wpsoto/utl_slc_rbegin.sas";
 input;
 put _infile_;
cards4;
%macro utl_slc_rbegin;

data _null_;
 infile cards4 eof=done truncover;
 file "c:/temp/r_pgm.sas";
 input;
 put _infile_;
 putlog _infile_;
 return;
 done:
   put "save.image(file = 'd:/wpswrk/workspace.RData')";

%mend utl_slc_rbegin;
;;;;
run;quit;




data _null_;
 file "c:/wpsoto/utl_slc_rend.sas";
 input;
 put _infile_;
cards4;
%macro utl_slc_rend(
   tblinp=d:/sd1/class.sas7bdat
  ,tblout=class
  ,return=N
  ,resolve=Y);

run;quit;

data _null_;
  infile "c:/temp/r_pgm.sas";
  input;
  file "c:/temp/r_pgmx.sas";
  %if &resolve=Y %then %do;
    _infile_=resolve(_infile_);
    put _infile_;
  %end;
run;quit;

options noxwait noxsync;
filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < c:/temp/r_pgmx.sas";

data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;quit;

data _null_;
  infile " c:/temp/r_pgm.sas";
  input;
  putlog _infile_;
run;quit;

%if %upcase(%substr(&return.,1,1)) ne N %then %do;

  filename clp clipbrd ;

  data _null_;
   infile clp obs=1;
   input;
   putlog "xxxxxx  " _infile_;
   call symputx("&return.",_infile_,"G");
  run;quit;

%end;

filename ft15f001 clear;
filename rut clear;
filename r_pgm clear;

filename tmp temp;

data _null_;
  file tmp;
  put "options set=RHOME 'D:\d451';";
  put "proc R;";
  put "submit;";
  put "load('d:/wpswrk/workspace.RData')";
  put "want";
  put "ls()";
  put "endsubmit;";
  put "import r=&tblout data=&tblout;";
  put "run;quit;";
run;quit;

%inc tmp;

%if &return ne N %then %do;

  filename clp clipbrd ;

  data _null_;
   infile clp;
   input;
   putlog "macro variable &return = " _infile_;
   call symputx("&return.",_infile_,"G");
  run;quit;

%end;

%mend utl_slc_rend;
;;;;
run;quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/























































































































































































































































































































%macro utl_slc_rbegin;

data _null_;
 infile cards4 eof=done truncover;
 file "c:/temp/r_pgm.sas";
 input;
 put _infile_;
 putlog _infile_;
 return;
 done:
   put "save.image(file = 'd:/wpswrk/workspace.RData')";

%mend utl_slc_rbegin;



%macro utl_slc_rend(
   tblinp=d:/sd1/class.sas7bdat
  ,tblout=class
  ,return=N
  ,resolve=Y);

run;quit;

data _null_;
  infile "c:/temp/r_pgm.sas";
  input;
  file "c:/temp/r_pgmx.sas";
  %if &resolve=Y %then %do;
    _infile_=resolve(_infile_);
    put _infile_;
  %end;
run;quit;

options noxwait noxsync;
filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < c:/temp/r_pgmx.sas";

data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;quit;

data _null_;
  infile " c:/temp/r_pgm.sas";
  input;
  putlog _infile_;
run;quit;

%if %upcase(%substr(&return.,1,1)) ne N %then %do;

  filename clp clipbrd ;

  data _null_;
   infile clp obs=1;
   input;
   putlog "xxxxxx  " _infile_;
   call symputx("&return.",_infile_,"G");
  run;quit;

%end;

filename ft15f001 clear;
filename rut clear;
filename r_pgm clear;

filename tmp temp;

data _null_;
  file tmp;
  put "options set=RHOME 'D:\d451';";
  put "proc R;";
  put "submit;";
  put "load('d:/wpswrk/workspace.RData')";
  put "want";
  put "ls()";
  put "endsubmit;";
  put "import r=&tblout data=&tblout;";
  put "run;quit;";
run;quit;

%inc tmp;

%if %upcase(%substr(&return.,1,1)) ne N %then %do;

  filename clp clipbrd ;

  data _null_;
   infile clp;
   input;
   putlog "macro variable &return = " _infile_;
   call symputx("&return.",_infile_,"G");
  run;quit;

%end;

%mend utl_slc_rend;


%utl_slc_rbegin;
cards4;
  library(haven)
   library(dplyr)
   want <- read_sas("&tblinp")
   modl <- lm(WEIGHT ~ HEIGHT, data=want)
   want$PREDICT<-modl$fitted.values
   writeClipboard("Greetings from R")
   &tblout <- want
;;;;
%utl_slc_rend(
   tblinp=d:/sd1/class.sas7bdat
  ,tblout=class
  ,return=greetings
  ,resolve=Y);






;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;




























































%utl_slc_rbegin;
cards4;


;;;;
run;quit;



%macro utl_rendx(return=,resolve=Y)/des="utl_rbeginx uses parmcards and must end with utl_rendx macro";
run;quit;
* EXECUTE R PROGRAM;
data _null_;
  infile "c:/temp/r_pgm.sas";
  input;
  file "c:/temp/r_pgmx.sas";
  %if "&resolve"="Y" %then %do;_infile_=resolve(_infile_);%end;
  put _infile_;
run;quit;
options noxwait noxsync;
filename rut pipe "D:\r451\bin\r.exe --vanilla --quiet --no-save < c:/temp/r_pgmx.sas";
run;quit;
data _null_;
  file print;
  infile rut;
  input;
  put _infile_;
  putlog _infile_;
run;quit;
data _null_;
  infile " c:/temp/r_pgm.sas";
  input;
  putlog _infile_;
run;quit;
%if "&return" ne ""  %then %do;
  filename clp clipbrd ;
  data _null_;
   infile clp obs=1;
   input;
   putlog "xxxxxx  " _infile_;
   call symputx("&return.",_infile_,"G");
  run;quit;
  %end;
filename ft15f001 clear;
%mend utl_rendx;





















































       ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
       ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
       ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
       ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
       ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;
       ;;;;%end;%mend;/*'*/ *);*};*];*/;/*"*/;run;quit;%end;end;run;endcomp;%utlfix;




















%macro utl_rbeginx/des="utl_rbeginx uses parmcards and must end with utl_rendx macro";
%utlfkil(c:/temp/r_pgmx.sas);
%utlfkil(c:/temp/r_pgm.sas);
filename ft15f001 "c:/temp/r_pgm.sas";
%mend utl_rbeginx;


















%let x=22;


options set=RHOME "D:\d451";
&_init_;
proc r;
submit;
x=&x;
x
endsubmit;
run;
quit;










1                                          Altair SLC     09:15 Thursday, November 13, 2025

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿;;;;
           ^
ERROR: Expected a statement keyword : found "ï"

NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.000


NOTE: AUTOEXEC processing completed

1
2         %let x=22;
3
4         options set=RHOME "D:\d451";
5         &_init_;
6         proc r;
7         submit;
8         x=&x;
9         x
10        endsubmit;
NOTE: Using R version 4.5.1 (2025-06-13 ucrt) from d:\r451

NOTE: Submitting statements to R:

> x=&x;
Error: unexpected '&' in "x=&"
> x
Error: object 'x' not found

NOTE: Processing of R statements complete

11        run;
NOTE: Procedure r step took :
      real time : 0.364
      cpu time  : 0.000


12        quit;
ERROR: Error printed on page 1
