<p align="center">
  <img src="https://github.com/user-attachments/assets/a66366a0-f0d9-4987-83be-e2f37d0101fb" width="400"/>
</p>

<div align=center>

# terraform-google-multi-env

[![LICENSE](https://img.shields.io/dub/l/vibe-d.svg?style=flat-square)](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/LICENSE)
[![MADE BY](https://img.shields.io/badge/made%20by-steamedEggMaster-informational?style=flat-square)](https://github.com/steamedEggMaster)



</div>

## :memo: Table of Contents

- [What is this?](#what-is-this)
- [개선점](#개선점)
- [의문점](#의문점)
- [디렉터리 구조](#디렉터리-구조)
- [실행 방법](#실행-방법)
- [TF Docs](#tf-docs)
  - [1. Requirements](#1-requirements)
  - [2. Providers](#2-providers)
  - [3. Modules](#3-modules)
  - [4. Resources](#4-resources)
  - [5. Inputs](#5-inputs)
  - [6. Outputs](#6-outputs)
- [참고 자료](#참고-자료)

<br>
<br>
<br>

# What is This?

이 프로젝트는 `steamedEggMaster`가 `dev`, `prd` 등 GCP 기반의 여러 환경들을 <br>
효율적으로 관리하기 위해 설계한 `Terraform Module` 입니다. <br>
<br>
`Child Module`들은 GCP에서 제공하는 `공식 Terraform 모듈 깃허브`를 Fork하여 사용하였으며, 🍴 <br>
그 외 kubernetes, helm Resource 등 단일 리소스들은 `Terraform Registry`를 참고하여 작성하였습니다. 📝 <br>
<br>
Terraform과 모듈에 대해 학습 후 직접 설계하고 인터넷을 참고하여 만든 것이기에 실수가 많고 부족한 부분이 많습니다. <br>
`Pull Request` or `Issue` 를 활용한 피드백은 정말정말 감사합니다. 😁

### :sparkles: HELP

##### :pray: [HOW TO CONTRIBUTE](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/CONTRIBUTING.md)

##### :star: 이 저장소와 steamedEggMaster는 PR 과 star 를 먹고 자랍니다.

<br>
<br>
<br>

# 개선점

<details>
<summary>1️⃣ <code>terraform.tfvars</code> 파일을 사용하지 않고 <code>variables.tf</code>에는 최소한의 내용만 담는다</summary>

   - 기존에 사용하던 <br>
     `terraform.tfvars` 파일은 가독성이 너무 떨어졌고 ⬇️, <br>
     `variables.tf` 파일은 내용이 많으면 파악이 쉽지 않았음.

     => 1️⃣ 개발자 친화적인 YAML에 리소스 관련 변수를 담고, <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2️⃣ *String Interpolation**을 이용하여 중복 변수들을 `하나의 YAML 파일에서 관리`하자‼️ <br>

     - ✨ 가독성 크게 향상됨. ✨.

   - [참고 유튜브 - 확장 가능한 테라폼 코드관리](https://www.youtube.com/watch?v=m9HeYtzeiLI)
   - [6-gke.yaml로 이동하기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/env/example_dev/config/6-gke.yaml)(1️⃣ YAML 리소스 관리 파일)
   - [context.yaml로 이동하기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/env/example_dev/config/context.yaml)(2️⃣ 중복 변수 관리 파일)

</details>

<br>

<details>
<summary>2️⃣ 모든 환경은 <code>하나의 Terraform 코드를 공유</code>한다.</summary>

   - `Best Practice`에 나온 예시 확인 결과, <br>
     환경별 `Terraform 코드 중복`이 많은 것을 확인. <br>
     이대로 진행한다면 코드 유지보수성 감소 ⬇️ 될 것이라 판단. <br>

     => 2️⃣가지 해결 방법이 존재.

     1. `Terraform Workspace` <br>
        : `동일한 코드베이스`로 여러 환경을 분리해 관리할 수 있게 해주는 Terraform의 `내장 기능`.

        - 기존에는 해당 방법으로 구축하려 했으나, <br>

          1. 상태 파일 하나에서 모든 환경의 상태를 관리해야 하는 문제 <br>
          2. 실수로 잘못된 환경에 명령어를 실행할 수 있는 문제(CLI 명령어 기반 수동적으로 환경을 확인해야 함) <br>

          등의 한계로 인하여 `2번 방법` 채택‼️

     2. `Terragrunt` <br>
        : Terraform 설정을 모듈화하고 환경별 구성과 반복을 쉽게 관리하도록 도와주는 `Wrapper 도구`.
     
        - ✨ 직접 경험한 장점들 ✨
          1. 사용할 Terraform 루트 모듈을 `경로`로 설정 <br>
             => 이 기능을 통해, 하나의 루트 모듈을 여러 환경이 `공유` 가능.
            
          3. 상태 파일을 환경별 `개별화` 가능.
             
          4. 상태 파일 이름에 `변수 설정` 가능. <br>
             => 동적인 이름 설정 기능을 사용하여 이후, `셸스크립트 기반 GCP 계정 이동 재구축 자동화` 수행.
             
          5. terragrunt 실행을 위해 `.hcl 파일이 위치한 폴더`가 `Working Directory` 가 되어야 함. <br>
             => 세션이 위치한 폴더 == 해당 환경이기에 환경 혼동 ⬇️

   - [참고 사이트 - Terraform 코드 중복•관리 복잡도 해결하기](https://insight.infograb.net/blog/2024/11/13/terragrunt/?utm_source=chatgpt.com)
   - [terragrunt.hcl로 이동하기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/env/example_dev/terragrunt.hcl)

</details>

<br>

<details>
<summary>3️⃣ GitOps 기반 리소스들을 제외하고, <br>
   Kubernetes 생성과 동시에 필요한 리소스 <br>
   (<code>namespace</code>, <code>ingress-nginx</code>, <code>cert-manager</code> 등)를 <code>Terraform으로 생성</code>한다. </summary>

   - 기존에는 직접 다운로드 및 명령어 실행 등 수동적 작업이 존재. ♨️ <br>

       - `Helm, kubernetes Provider`를 사용하여 자동화. <br>
             Terraform은 단순히 클라우드 리소스만이 아닌, <br> 
             data 리소스 기반 GKE 연결을 통해 k8s 리소스도 생성 가능. <br>
         
       - Argocd의 `CRD(Custom Resource Definition)`를 사용한다면, <br> 
         Application 배포까지 자동화 가능한 엄청난 기능‼️ <br>

   - [providers.tf로 이동하기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/terraform-google/providers.tf)
   - [main_kubect.tf로 이동하기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/terraform-google/main_kubectl.tf)(k8s 리소스 실행 파일)
   - [13-kubectl.yaml로 이동하기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/env/example_dev/config/13-kubectl.yaml)(k8s 리소스 정의 파일)

</details>

<br>

<details>

<summary>4️⃣ 각 환경 별로 필요한 리소스(YAML 파일)가 다르기에, <br> 
         <code>YAML 파일 존재 여부</code>에 따라 리소스 생성이 문제 없도록 <code>fallback 처리</code>한다. </summary>
    
  - Terraform에는 리소스를 여러 번 생성 가능한 for문과 같은 `count`, `for_each`가 존재.
    
      1️⃣ `count`는 설정한 횟수만큼 동일한 구성의 리소스를 생성. <br>
      2️⃣ `for_each`는 해당 리소스에 대한 여러 구성에 맞게 각각 리소스 생성. <br>
      
    - *map 타입*과 _key-value 형태의 object 타입_ 사용 가능.
    - YAML은 key-value 형태의 object 타입 그 자체이기에, 사용하기 적합. <br>
      => ✅ locals.tf에서 `중첩 3항 연산자`를 통해 **fallback** 처리.

   - [locals.tf로 이동하기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/terraform-google/locals.tf)

</details>

<br>

<details>

<summary>5️⃣ GKE와 그 외 리소스 <code>생성 주기</code>를 나눈다.</summary>

   - kubernetes, helm 관련 data들은 GKE와 연결된 상태에서 리소스를 확인하기에, <br>
     단순히 `Terragrunt plan -out=tfplan` 사용 시 GKE에 연결할 수 없어 문제 발생.

     => ✅ Network ~ GKE까지 생성하는 모듈을 분리 후 <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `terragrunt plan -target=module.private_cluster -out=tfplan` 실행하고 <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `Terragrunt plan -out=tfplan` 를 실행한다.

   - [main.tf로 이동하기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/terraform-google/main.tf)

</details>
    
<br>

<details>

<summary>6️⃣ <code>서비스 외부 IP들</code>을 <code>Output으로 출력</code>한다. </summary>

   - Ingress Controller 외부 IP 같은 도메인 연결에 필요한 데이터를 가져오기 위해, <br>
     `gcloud CLI`로 접속 및 `kubectl get svc -n ingress-nginx`로 가져오는 것은 번거로운 작업.
     - Ingress 이외에도 여러 서비스의 외부 IP를 가져올 수 있음.(ex Grafana, Redis)

     => ✅ `kubernetes_service Data 리소스`를 활용하여, <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IP 값을 가져온 후, Output을 통해 출력하자!

   - [data.tf로 이동하기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/terraform-google/data.tf)

</details>
   
<br>
<br>
<br>

# 의문점

1. `Terraform`과 `CI-CD`의 `융합`은 과연 좋은것인가 ❓❓
   - Terraform의 장점은 `plan을 통해 변경 사항 확인`이 가능한것. <br>
     하지만, `Github Actions`에서는 실행 도중에 입력을 받을 수 없기에 ⚠️ 바로 apply를 해야함. <br>
     
     => `로컬에서 plan`을 하고, `CI-CD`를 수행하면 되지 않는가? <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 그럴 것이라면, 로컬에서 apply 하는 것이 나음.

     => ✅ `Jenkins`를 사용하면 CI-CD 실행 도중, `입력 가능`하다고함❗️ <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 하지만, 그것만을 위해 사용하는 것은 `리소스 낭비`. <br>
     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 나중에 DevOps 엔지니어가 여러 명일때, `협업을 생각해보고 도입`하자. <br>

<br>
<br>
<br>

# 디렉터리 구조

```
terraform-google-multi-env/
├── env/
│   ├── dev/
│   │   ├── config/                 # yaml 파일들 위치
│   │   │   ├── helm/
│   │   │   │   ├── argocd-values.yaml
│   │   │   │   └── ...
│   │   │   │
│   │   │   ├── yaml/
│   │   │   │   ├── argocd/         # argocd CRD yaml 파일들 위치
│   │   │   │   └── application/    # argocd application 파일들 위치
│   │   │   │
│   │   │   ├── 1-provider.yaml
│   │   │   ├── 2-api.yaml
│   │   │   ├── ...
│   │   │   ├── 12-helm.yaml        # helm 설정 파일
│   │   │   ├── 13-kubectl.yaml     # helm/, yaml/ 폴더 내부 yaml 파일들의 경로 지정
│   │   │   └── context.yaml        # 공통 변수 관리 파일
│   │   └── terragrunt.hcl          # 환경마다의 terragrunt 파일
│   │
│   ├── db/
│   └── prd/
│
├── modules/            # 자식 모듈
│   ├── kuberentes/         # kubernetes 오브젝트 생성용 자식 모듈
│   └── private_cluster/    # Network ~ GKE 생성까지의 자식 모듈
│
├── terraform/          # 루트 모듈
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
│   └── versions.tf         # Terraform 및 Provider 버전 고정
│
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

   1. GCP는 계정마다 무료 300달러를 제공한다. ▶️ 300달러 받기위한 회원가입을 수행한다.

   2. 새로운 프로젝트를 생성한다.

      - 이때❗️, 프로젝트 ID를 반드시 `1-provider.yaml`의 `project_id`와 동일하게 생성한다.

   3. 생성된 프로젝트에 접속 후, Service Accounts 섹션으로 이동한다.

      - Service Account를 Owner 권한으로 생성 후, json credential key를 다운로드 받는다.

   4. GCS 섹션으로 이동하여 GCS를 생성한다.

      - 이때❗️, GCS 명은 반드시 `terragrunt.hcl`의 `bucket이름`과 동일해야 한다.

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

10. terragrunt 실행 - 반드시 변경 사항 확인 후 apply‼️

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

11. terragrunt 리소스 삭제
    ```
    terragrunt destroy 또는
    terragrunt destroy --auto-approve
    ```

<br>
<hr>
<br>

# TF Docs

### 1. Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.10.3 |

### 2. Providers

| Provider     | Source                 | Version   |
| ------------ | ---------------------- | --------- |
| `google`     | `hashicorp/google`     | `~> 6.0`  |
| `kubernetes` | `hashicorp/kubernetes` | `~> 2.0`  |
| `helm`       | `hashicorp/helm`       | `~> 2.0`  |
| `kubectl`    | `gavinbunney/kubectl`  | `~> 1.14` |

### 3. Modules

| 모듈 이름               | 설명                                                         |
| ----------------------- | ------------------------------------------------------------ |
| `private_cluster`       | GCP VPC, Subnet, GKE 클러스터, Cloud NAT 등 인프라 구성 모듈 |
| `service_account`       | GCP 서비스 계정 생성 모듈                                    |
| `service_account_iam`   | 서비스 계정에 IAM 권한을 부여하는 모듈                       |
| `artifact_registry_iam` | Artifact Registry에 대한 IAM 권한을 설정하는 모듈            |
| `storage_bucket_iam`    | Cloud Storage 버킷에 대한 IAM 권한을 설정하는 모듈           |
| `database`              | Cloud SQL(PostgreSQL) 데이터베이스 인스턴스를 생성하는 모듈  |
| `registry`              | Artifact Registry(컨테이너 이미지 저장소)를 생성하는 모듈    |
| `bucket`                | Cloud Storage 버킷을 생성하는 모듈                           |
| `k8s_namespace`         | Kubernetes 네임스페이스를 생성하는 모듈                      |
| `k8s_sa`                | Kubernetes ServiceAccount를 생성하는 모듈                    |
| `kubectl_manifest`      | Kubectl Provider를 사용해 k8s 리소스(YAML)를 배포하는 모듈   |

### 4. resources

| 리소스 종류               | 설명                                                       |
| ------------------------- | ---------------------------------------------------------- |
| `google_sql_ssl_cert`     | 생성한 GCP Cloud SQL 인트턴스의 SSL 인증서 가져오는 리스소 |
| `google_compute_instance` | GCP VM 인스턴스 생성 리소스                                |
| `helm_release`            | Helm 차트를 Kubernetes에 배포하는 리소스                   |

### 5. Inputs

| 변수 이름   | 설명             | 타입     | 필수 여부 |
| ----------- | ---------------- | -------- | --------- |
| `file_path` | config 파일 경로 | `string` | ✅        |
| `env`       | 배포 환경        | `string` | ✅        |

##### 🚫 주의할 점

1. `terragrunt`는 `init` 수행 시 `env/환경/` 디렉터리 하위에 **캐싱 폴더(.terragrunt-cache)** 를 생성합니다. <br>
   이후 실행되는 모든 Terraform 코드는 **이 캐시된 디렉터리 기준으로 동작**하므로, <br>
   `config` 파일 경로는 반드시 **캐시 디렉터리 기준으로 작성해야 합니다.** <br>

2. 이 프로젝트는 `yamldecode()`를 기반으로 리소스를 구성하기 때문에, <br>
   대부분의 변수는 `Inputs` 항목에 정의되어 있지 않습니다‼️ <br>
   필요한 값은 각 모듈의 `variables` 정의를 직접 확인하여, <br>
   해당 스타일에 맞게 YAML 파일을 작성해야 합니다‼️

### 6. Outputs

| 출력 변수          | 설명                                        | 민감 정보 |
| ------------------ | ------------------------------------------- | --------- |
| `all_vm_ips`       | 생성된 VM 인스턴스들의 Internal/External IP | ❌        |
| `nginx_ingress_ip` | Nginx Ingress Controller의 External IP      | ❌        |
| `database_ips`     | 생성된 데이터베이스의 Internal/External IP  | ❌        |
| `db_cert`          | 데이터베이스 SSL 연결용 인증서 정보         | ✅        |
| `redis_master_ip`  | Redis Master 서비스의 External IP           | ❌        |

<br>
<br>
<br>

# 참고 자료

1. [Interview_Question_for_Beginner](https://github.com/jbee37142/Interview_Question_for_Beginner) - README.md 작성 형식 학습
2. [확장 가능한 테라폼 코드관리](https://www.youtube.com/watch?v=m9HeYtzeiLI)
3. [Terraform 코드 중복•관리 복잡도 해결하기](https://insight.infograb.net/blog/2024/11/13/terragrunt/?utm_source=chatgpt.com)
4. [Terraform Best Practice Examples](https://www.terraform-best-practices.com/ko/examples)
5. [Terraform Registry](https://registry.terraform.io)

<br>

[🔝 맨 위로](#terraform-google-multi-env)
