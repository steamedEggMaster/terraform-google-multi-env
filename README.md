<p align="center">
  <img src="https://github.com/user-attachments/assets/a66366a0-f0d9-4987-83be-e2f37d0101fb" width="400"/>
</p>

<div align=center>

# terraform-google-multi-env

[![LICENSE](https://img.shields.io/dub/l/vibe-d.svg?style=flat-square)](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/LICENSE)

</div>

## :memo: Table of Contents

- [What is this?](#what-is-this)
- [개선점](#개선점)
- [디렉터리 구조](#디렉터리-구조)
- [실행 방법](#실행-방법)

<br>
<br>
<br>

# What is This?

이 프로젝트는 steamedEggMaster가 dev, prd 등 GCP 기반의 여러 환경들을 효율적으로 관리하기 위해 설계된 Terraform 모듈입니다. <br>
`Child Module`들은 GCP에서 제공하는 공식 깃허브 모듈을 Fork하여 사용하였으며, 🍴 <br> 
그 외 kubernetes, helm Resource 등 단일 리소스들은 `Terraform Registry`를 활용하여 작성하였습니다. 📝 <br>
Terraform과 모듈에 대해 학습 후 직접 설계하고 인터넷을 참고하여 만든 것이기에 실수가 많고 부족한 부분이 많습니다. <br>
`Pull Request` or `Issue` 를 활용한 피드백은 정말정말 감사합니다. 😁

### :sparkles: HELP

##### :pray: [HOW TO CONTRIBUTE](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/CONTRIBUTING.md)

##### :star: 이 저장소와 steamedEggMaster는 PR 과 star 를 먹고 자랍니다.

<br>
<br>
<br>

# 개선점

1. terraform.tfvars 파일과 variables.tf을 사용하지 않는다. <br>
   - 기존에 사용하던 terraform.tfvars 파일은 가독성이 너무 떨어졌고, <br>
     variables.tf 파일의 내용이 많으면 내용 파악이 쉽지 않았음.
   
     => ✅ YAML로 변수들을 리소스에 따라 파일로 나누어 관리하고, <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Terraform의 `yamldecode(templatefile())`로 String Interpolation을 이용하여 중복 변수들을 `한곳에서 관리`하자‼️ <br>

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
          1. 사용할 Terraform 모듈을 경로 상으로 설정 <- 이 기능을 통해, 하나의 루트 모듈을 공유 가능.
          2. 상태 파일 관리 환경별 개별화 가능.
          3. 상태 파일 이름에 변수 설정 가능 <- 동적인 이름 설정 기능을 사용하여 이후, `셸스크립트 기반 GCP 계정 이동 재구축 자동화` 수행.
   - [참고 사이트 - Terraform 코드 중복•관리 복잡도 해결하기](https://insight.infograb.net/blog/2024/11/13/terragrunt/?utm_source=chatgpt.com)

<br>

3. GitOps 기반 리소스들을 제외하고, <br>
   Kubernetes 생성과 동시에 필요한 리소스(예 : namespace, ingress-nginx, cert-manager 등)를 Terraform으로 생성한다.
   - 기존에는 k8s 접속 후 직접 다운로드를 받고 설정해야 했음. ♨️ <br>

     - Helm, kubernetes Provider를 사용하여 자동화. <br>
       Terraform은 단순히 CSP 리소스만이 아닌, data 기반 GKE 연결을 통해 k8s 리소스도 생성이 가능. <br>
       => ✅ Argocd의 `CRD(Costum Resource Definition)`를 사용한다면, Application 배포까지 자동화 가능한 엄청난 기능‼️

<br>

4. 각 환경 별로 필요없는 모듈(YAML 파일)이 있기에, YAML 파일 존재 여부를 파악하고,
   파일은 있더라도, 주석 처리를 통해 리소스 생성을 방지해도 문제 없도록 한다.

   - Terraform에는 리소스를 여러 번 생성 가능한 for문과 같은 count, for_each가 존재.
     1. `count`는 설정한 횟수만큼 동일한 구성의 리소스를 생성.
     2. `for_each`는 해당 리소스에 대한 여러 구성에 맞게 각각 리소스 생성.
        - *map 타입*과 *key-value 형태의 object 타입* 사용 가능.
        - YAML은 key-value 형태의 object 타입 그 자체이기에, 사용하기 적합. <br>
          => ✅ locals.tf에서 `중첩 3항 연산자`를 통해, 4번 목표를 안전하게 **fallback** 가능.
          - [locals.tf로 이동하기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/terraform/locals.tf)

<br>

5. GKE와 그 외 리소스 생성 주기를 나눈다.
   - kubernetes, helm 관련 data들은 GKE와 연결된 상태에서 리소스를 확인하기에, <br>
     단순히 `Terragrunt plan -out=tfplan` 사용 시 GKE에 연결할 수 없어 문제 발생.

     => ✅ Network ~ GKE까지 생성하는 모듈을 분리 후 <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `terragrunt plan -target=module.private_cluster -out=tfplan` 실행하고 <br>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `Terragrunt plan -out=tfplan` 를 실행한다.

<br>
<br>
<br>

# 디렉터리 구조

```
terraform-google-multi-env/
├── env/
│   ├── dev/
│   │   ├── config/                  # yaml 파일들 위치
│   │   │   ├── helm/
│   │   │   │   ├── argocd-values.yaml
│   │   │   │   └── ...
│   │   │   ├── yaml/
│   │   │   │   ├── argocd/         # argocd CRD yaml 파일들 위치
│   │   │   │   └── application/    # argocd application 파일들 위치
│   │   │   ├── 1-provider.yaml
│   │   │   ├── 2-api.yaml
│   │   │   ├── ...
│   │   │   ├── 12-helm.yaml        # helm 설정 파일
│   │   │   ├── 13-kubectl.yaml     # helm/, yaml/ 폴더 내부 yaml 파일들의 경로 지정
│   │   │   └── context.yaml        # 공통 변수 관리 파일
│   │   └── terragrunt.hcl          # 환경마다의 terragrunt 파일
│   ├── db/
│   └── prd/
├── modules/
│   ├── kuberentes/         # kubernetes 오브젝트 생성용 자식 모듈
│   └── private_cluster/    # Network ~ GKE 생성까지의 자식 모듈
├── terraform/
│   ├── backend,tf          # 백엔드 설정 파일 (설정 자체는 비어있음)
│   ├── data,tf             # data 리소스 모음
│   ├── locals.tf           # 로컬 변수 정의
│   ├── main_helm.tf        # Helm Provider 기반 Helm 리소스
│   ├── main_k8s.tf         # Kubernetes Provider 기반 k8s 모듈
│   ├── main_kubectl.tf     # Kubectl Provider 기반 Manifest 모듈
│   ├── main_vm.tf          # VM 인스턴스 리소스
│   ├── main.tf             # 핵심이 되는 Network, GKE, ServiceAccount 등 모듈
│   ├── outputs.tf          # DB IP 등 출력 변수 정의
│   ├── providers.tf        # Terraform Provider 설정
│   ├── variables.tf        # 입력 변수 정의
│   ├── versions.tf         # Terraform 및 Provider 버전 고정
│   ├── README.md
├── .gitignore
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```
1. `env/` 폴더 내부에 각각의 환경 폴더가 존재합니다.
2. `config/` 폴더 내부에 핵심적인 리소스 메타데이터 파일들이 존재합니다.
3. `helm/` 폴더 내부에 helm의 values.yaml 파일들이 존재합니다.
4. `yaml/` 폴더 내부에 Object Manifest 파일들이 존재합니다.
5. `modules/` 폴더 내부에 루트 모듈이 사용하는 자식 모듈들이 존재합니다.
6. 기능들에 따라 리소스를 `main_*.tf` 파일로 분리하여 유지보수성 및 가독성을 높였습니다.

<br>
<br>
<br>

# 실행 방법
1. terraform을 설치한다.
   - [install terraform](https://developer.hashicorp.com/terraform/install)
2. terragrunt를 설치한다.
   - [install terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
3. GCP CLI를 설치한다.
   - [install GCP CLI](https://cloud.google.com/sdk/docs/install?hl=ko)
4. Github Repository를 Clone 한다.
   ```
   git clone https://github.com/steamedEggMaster/terraform-google-multi-env.git
   ```

5. GCP에서 Terraform을 사용할 계정을 생성한다.
   
   1. GCP는 계정마다 무료 300달러를 제공한다. ▶️ 300달러 받기위한 설정을 수행한다.

   2. 새로운 프로젝트를 생성한다.
      - 이때, 프로젝트 ID를 반드시 `1-provider.yaml`의 `project_id`와 동일하게 생성한다.

   3. 생성된 프로젝트에 접속 후, Service Accounts 섹션으로 이동한다.
      - Service Account를 Owner 권한으로 생성 후, json credential key를 다운로드 받는다.

   4. GCS 섹션으로 이동하여 GCS를 생성한다.
      - 이때, GCS 명은 반드시 `terragrunt.hcl`의 `bucket이름`과 동일해야 한다.

   5. ServiceUsage API 섹션으로 이동하여 API를 활성화 한다.
      - API Enabled 상태라면 넘어간다.

6. gcloud CLI 를 통해 서비스 계정을 현재 세션이 사용하도록 설정
   ```
   gcloud auth activate-service-account --key-file=<다운로드한 json key 위치>
   ```

7. `/env/환경/` 폴더로 이동
   ```
   cd ./terraform-google-multi-env/env/환경 
   ```

8. 필요한 yaml 파일과 terragrunt.hcl 파일을 **디렉터리 구조**에 맞게 작성.

9. terragrunt 초기화
   ```
   terragrunt init
   ```

10. terragrunt 실행 - 변경 사항 확인 후 apply‼️
   1. GKE를 생성하는 경우
      ```
      terragrunt plan -target=module.private_cluster -out=tfplan
      terragrunt apply tfplan
      
      terragrunt plan -out=tfplan
      terragrunt apply tfplan  
      ```
   2. GKE를 생성하지 않는 경우
      ```
      terragrunt plan -out=tfplan
      terragrunt apply tfplan  
      ```

<br>
<hr>
<br>

