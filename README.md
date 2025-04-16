<p align="center">
  <img src="https://github.com/user-attachments/assets/a66366a0-f0d9-4987-83be-e2f37d0101fb" width="400"/>
</p>

<div align=center>

# terraform-google-multi-env

[![LICENSE](https://img.shields.io/dub/l/vibe-d.svg?style=flat-square)](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/LICENSE)

</div>

## :memo: Table of Contents

- [What is this?](#what-is-this)

<br>
<br>

# What is This?

이 프로젝트는 steamedEggMaster가 dev, prd 등 GCP 기반의 여러 환경들을 효율적으로 관리하기 위해 설계된 Terraform 모듈입니다. <br>
Child Module들은 GCP에서 제공하는 공식 깃허브 모듈을 Fork하여 사용하였으며, <br> 
그 외 kubernetes, helm Resource 등 단일 리소스들은 Terraform Registry를 활용하여 작성하였습니다. <br>
Terraform과 모듈에 대해 학습 후 직접 설계하고 인터넷을 참고하여 만든 것이기에 실수가 많고 부족한 부분이 많습니다. <br>
많은 피드백은 정말 감사합니다. 😁

# 고려 사항 및 개선 방법
1. terraform.tfvars 파일과 variables.tf을 사용하지 않는다. <br>
   - 기존에 사용하던 terraform.tfvars 파일은 가독성이 너무 떨어졌고, <br>
      variables.tf 파일의 내용이 많으면 내용 파악이 쉽지 않았음.
   <br>
   => YAML로 변수들을 관리하고, Terraform의 yamldecode(templatefile())로 String Interpolation을 활용하여 중복 변수들을 한곳에서 관리하자!
     
2. 모든 환경은 하나의 Terraform 코드를 공유한다. <br>
   - Best Practice를 확인한 결과, Terraform 코드 중복이 많다고 느껴졌음. <br>
     환경 별 코드가 달라질 수 있고, 유지보수가 힘듬. <br>

     => 2가지 해결 방법이 존재

     1. Terraform Workspace <br>
        - 기존에는 해당 방법으로 구축하려 했으나, <br> 
          상태 파일 하나에서 모든 환경의 상태를 관리해야 하는 문제 + 실수로 환경 변경 없이 CLI 실행할 수 있는 문제(코드로 환경을 확인해야 함) <br>
          등의 문제로 인해 2번 방법 채택‼️
     2. Terragrunㅅ
       - 
5. 
