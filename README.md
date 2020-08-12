# 항체의약품 TMDD 모델링을 위한 Edison 앱의 활용

본 연구결과가 제 10회 첨단 사이언스 교육허브 개발 전산의학 경진대회에서 최우수상을 받았습니다. [논문](docs-edison-2020/CMC-TMDD-2020-08-12-paper.pdf), [발표자료](docs-edison-2020/CMC-TMDD-2020-08-12-slides.pdf)를 보실 수 있습니다.

## 실행

- singlularity(도커와 비슷한 툴)를 활용하여 nlmixr이 설치된 컨테이너를 실행하면 됩니다.

## 실행 방법

1. bulb 서버에 로그인
2. 특정 경로에 폴더를 만들고 실행에 필요한 R 파일과 관련 데이터들을 복사
3. run.sh bash 파일 생성
    - run.sh 는 사용자 입력 파일을 복사하고 singularity를 활용해 r 파일을 실행합니다. 
    - r 파일 안에서 매개변수 입력 방식이 아닌 input.dat, input2.dat 의 상대 경로로 바로 읽도록 코드를 작성해 주세요.

**run.sh 파일 설명**

```bash
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
```

4. runscript.R  파일 생성 

**runscript.R 파일 설명**

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

5. 아래 명령어로 실행 테스트를 진행합니다.

```bash
./run.sh -i test.inp
```

**test.inp 파일 내용**

```r
aa 10
bb 20
```

6. 실행이 끝나면 result/output.txt 이 생성됩니다.

보내주신 설치 url을 통해 컨테이너를 만들었으며, SnakeCharmR 는 python.h 문제로 설치가 되지 않아 reticulate을 대신 설치하였습니다.

RxODE와 reticulate는 install.packages 명령어를 통해 설치하였으며, install_github("nlmixrdevelopment/RxODE") 로 설치가 필요한경우 연락주시면 새로운 컨테이너 이미지를 생성하도록 하겠습니다.

ex) 

```bash
Rscript -e 'install.packages("RxODE")'
Rscript -e 'install.packages("reticulate")'
```
