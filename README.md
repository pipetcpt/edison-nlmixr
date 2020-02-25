# edison-nlmixr

안녕하세요.

 

잘지내셨는지요? 요청하신 패키지가 완료되어 연락드립니다.

 

실행 방법은  singlularity(도커와 비슷한 툴)를 활용하여 nrmixr이 설치된 컨테이너를 실행하면 됩니다.

 

실행 방법은 다음과 같습니다.

 

1. bulb 서버에 로그인

2. 특정 경로에 폴더를 만들고 실행에 필요한 R 파일과 관련 데이터들을 복사

3. run.sh bash 파일 생성

   - run.sh 는 사용자 입력 파일을 복사하고 singularity를 활용해 r 파일을 실행합니다. 

run.sh 파일 설명 =========================================================================================================

#!/bin/bash

# 입력파일이 한개인 경우, 아래와 같이 사용자가 생성한 입력 파일을 현재 디렉토리에 input.dat 로 저장

cp $2 input.dat    

# 입력 파일이 두개인 경우 아래 명령어 추가 

# cp $4 input2.dat

 

# singularity 실행 

singularity exec --bind $PWD:/mnt /SYSTEM_BULB/Singularity/images/nlmixr.sif Rscript -e 'source("./runscript.r", keep.source=TRUE, echo=TRUE)'

# singularity exec : 컨테이너와 함께 특정 명령어를 실행 

#  --bind $PWD:/mnt : 현재 경로($PWD)를 컨테이너 안 /mnt 폴더로 마운트 ( 현재 경로에 있는 파일들을 컨테이너 안에서 사용할 수 있도록 함)

#  /SYSTEM_BULB/Singularity/images/nlmixr.sif : 컨테이너 경로

# Rscript -e 'source("./runscript.r", keep.source=TRUE, echo=TRUE)' : 컨테이너에서 실행해야하는 명령어

 

#복사한 입력 파일 삭제

rm -rf input.dat

======================================================================================================================

  - r 파일 안에서 매개변수 입력 방식이 아닌 input.dat, input2.dat 의 상대 경로로 바로 읽도록 코드를 작성해 주세요.

 

 

4. runscript.r  파일 생성 

runscript.r 파일 설명 =====================================================================================================

```r
#!/usr/bin/env Rscript

## Load Phenobarb data

library(nlmixr)

 

## input file load 

inputdata <- read.table(file="input.dat", header = FALSE, sep = " ")

print(inputdata)

 

pheno <- function() {

  ini({

    tcl <- log(0.008) # typical value of clearance

    tv <-  log(0.6)   # typical value of volume

    ## var(eta.cl)

    eta.cl + eta.v ~ c(1,

                       0.01, 1) ## cov(eta.cl, eta.v), var(eta.v)

    # interindividual variability on clearance and volume

    add.err <- 0.1    # residual variability

  })

  model({

    cl <- exp(tcl + eta.cl) # individual value of clearance

    v <- exp(tv + eta.v)    # individual value of volume

    ke <- cl / v            # elimination rate constant

    d/dt(A1) = - ke * A1    # model differential equation

    cp = A1 / v             # concentration in plasma

    cp ~ add(add.err)       # define error model

  })

}

fit <- nlmixr(pheno, pheno_sd, "saem", table=list(cwres=TRUE, npde=TRUE))

print(fit)

 

## output file export 

unlink("result", recursive=TRUE)

dir.create("result");

fileOut<-file("result/output.txt")

writeLines(c("Hello EDISON."), fileOut)

close(fileOut)
```

======================================================================================================================

 

5. 아래 명령어로 실행 테스트를 진행합니다.

 ./run.sh -i test.inp

 

test.inp 파일 내용 ============

aa 10

bb 20

==========================

 

6. 실행이 끝나면 result/output.txt 이 생성됩니다.

 

 

보내주신 설치 url을 통해 컨테이너를 만들었으며, SnakeCharmR 는 python.h 문제로 설치가 되지 않아 reticulate을 대신 설치하였습니다.

 

RxODE와 reticulate는 install.packages 명령어를 통해 설치하였으며, install_github("nlmixrdevelopment/RxODE") 로 설치가 필요한경우 연락주시면 새로운 컨테이너 이미지를 생성하도록 하겠습니다.

ex) 

```bash
Rscript -e 'install.packages("RxODE")'
Rscript -e 'install.packages("reticulate")'
```
 

변수들이 많아 설치가 많이 늦었습니다.

확인부탁드리고 앱 등록시 제가 추가로 안내드려야 하는 내용이 있어. 앱 등록 전에 메일 주시면 감사하겠습니다.

 

감사합니다.

 

전인호 드림

 
