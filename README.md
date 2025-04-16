<p align="center">
  <img src="https://github.com/user-attachments/assets/a66366a0-f0d9-4987-83be-e2f37d0101fb" width="400"/>
</p>

<div align=center>

# terraform-google-multi-env

[![LICENSE](https://img.shields.io/dub/l/vibe-d.svg?style=flat-square)](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/LICENSE)

</div>

## :memo: Table of Contents

- [What is this?](#what-is-this)
- [구성 목표 및 방법](#구성-목표-및-방법)

<br>
<br>
<br>

# What is This?

이 프로젝트는 steamedEggMaster가 dev, prd 등 GCP 기반의 여러 환경들을 효율적으로 관리하기 위해 설계된 Terraform 모듈입니다. <br>
`Child Module`들은 GCP에서 제공하는 공식 깃허브 모듈을 Fork하여 사용하였으며, 🍴 <br> 
그 외 kubernetes, helm Resource 등 단일 리소스들은 `Terraform Registry`를 활용하여 작성하였습니다. 📝 <br>
Terraform과 모듈에 대해 학습 후 직접 설계하고 인터넷을 참고하여 만든 것이기에 실수가 많고 부족한 부분이 많습니다. <br>
많은 피드백은 정말 감사합니다. 😁

### :sparkles: HELP

##### :pray: [HOW TO CONTRIBUTE](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/CONTRIBUTING.md)

##### :star: 이 저장소와 steamedEggMaster는 PR 과 star 를 먹고 자랍니다.

<br>
<br>
<br>

# 구성 목표 및 방법

1. terraform.tfvars 파일과 variables.tf을 사용하지 않는다. <br>
   - 기존에 사용하던 terraform.tfvars 파일은 가독성이 너무 떨어졌고, <br>
     variables.tf 파일의 내용이 많으면 내용 파악이 쉽지 않았음.
   
     => ✅ YAML로 변수들을 리소스에 따라 파일로 나누어 관리하고, <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Terraform의 `yamldecode(templatefile())`로 String Interpolation을 이용하여 중복 변수들을 `한곳에서 관리`하자! <br>

   - [참고 유튜브 - 확장 가능한 테라폼 코드관리](https://www.youtube.com/watch?v=영상ID)

<br>

2. 모든 환경은 하나의 Terraform 코드를 공유한다. <br>
   - Best Practice를 확인한 결과, Terraform 코드 중복이 많다고 느껴졌음. <br>
     이는 환경 별 코드 일관성 유지 및 코드 변경 힘들게함. 😢 <br>

     => 2️⃣가지 해결 방법이 존재

     1. **Terraform Workspace** <br>
        - 기존에는 해당 방법으로 구축하려 했으나, <br> 
          1. 상태 파일 하나에서 모든 환경의 상태를 관리해야 하는 문제와 <br>
          2. 실수로 환경 변경 없이 CLI 실행할 수 있는 문제(코드로 환경을 확인해야 함) <br>
        
          등의 한계로 인하여 2번 방법 채택‼️
     
     2. **Terragrunt** <br>
        - 직접 경험한 장점들
          1. 사용할 Terraform 모듈을 경로 상으로 설정 <- 이 기능을 통해, 하나의 루트 모듈을 공유 가능
          2. 상태 파일 관리 환경별 개별화 가능
          3. 상태 파일 이름에 변수 설정 가능 <- 동적인 이름 설정 기능을 사용하여 이후, `셸스크립트 기반 GCP 계정 이동 재구축 자동화` 수행.
   - [참고 사이트 - Terraform 코드 중복•관리 복잡도 해결하기](https://insight.infograb.net/blog/2024/11/13/terragrunt/?utm_source=chatgpt.com)

<br>

3. GitOps 기반 리소스들을 제외하고,
   Kubernetes 생성과 동시에 필요한 리소스(예 : namespace, ingress-nginx, cert-manager 등)를 Terraform으로 생성한다.
   - 기존에는 직접 안에서 다운로드를 받고 설정해야 했음. ♨️ <br>

     - Helm, kubernetes Provider를 사용하여 자동화한다. <br>
       Terraform은 단순히 CSP 리소스만이 아닌, data 기반 GKE 연결을 통해 k8s 리소스도 생성이 가능하다. <br>
       => ✅ Argocd의 `CRD(Costum Resource Definition)`를 사용한다면, Application 배포까지 자동화 가능한 엄청난 기능‼️

<br>

4. 각 환경 별로 필요없는 모듈(YAML 파일)이 있기에, YAML 파일 존재 여부를 파악하고,
   파일은 있더라도, 주석 처리를 통해 리소스 생성을 방지해도 문제 없도록 한다.

   - Terraform에는 리소스를 여러 번 생성 가능한 for문과 같은 count, for_each가 존재.
     1. `count`는 설정한 횟수만큼 동일한 구성의 리소스를 생성.
     2. `for_each`는 해당 리소스에 대한 여러 구성에 맞게 각각 리소스 생성.
        - map 타입과 key-value 형태의 object 타입 사용 가능.
        - YAML은 key-value 형태의 object 타입 그 자체이기에, 사용하기 적합. <br>
          => ✅ locals.tf에서 `중첩 3항 연산자`를 통해, 4번 내용을 안전하게 **fallback** 가능.

<br>
<hr>
