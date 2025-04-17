# HOW TO CONTRIBUTE

여러 가지 방법으로 terraform-google-multi-env에 참여하실 수 있습니다 :)
PR 을 올려주실 때, labels 를 참고하셔서 알맞은 제목을 함께 올려주세요!
Commit Message 는 `Update`라고만 해주셔도 되고, 원하시는 메세지를 적어주시면 됩니다.

## Process

해당 Repository 에 contribute 하는 방법을 소개드립니다.

### Pull Request 를 통한 Contribute

#### 1. Fork this respository

이 repository 를 fork 해주세요!

#### 2. Clone forked repository

fork 해간 repository 를 local directory 에 clone 해주세요!

```bash
# in your workspace
$ git clone https://github.com/steamedEggMaster/terraform-google-multi-env.git
$ cd terraform-google-multi-env
```

#### 3. Commit your

```bash
$ git add .
$ git commit -m "[your description]"
$ git push origin main
```

### 4. Register pull request for your commit

`Pull Request`를 등록해주세요.

### 5. Apply prettier

```
$ prettier --write **/*.md
# or
$ npx prettier --write **/*.md
```

### Optional. Resolve Conflict

Pull Request 를 등록했는데, conflict 가 있어서 auto merge 가 안된다고 하는 경우 해당 conflict 를 해결해주세요.

```bash
# in terraform-google-multi-env
$ git remote add --track main upstream https://github.com/steamedEggMaster/terraform-google-multi-env.git
$ git fetch upstream
$ git rebase upstream/main
# (resolve conflict in your editor)
$ git add .
$ git rebase --continue
$ git push -f origin main
```

- 참고자료 : [많은 Git 커맨드 중 정말 필요한 것만 정리한 내용](https://github.com/JaeYeopHan/Minimal_Git_command)

### Issue 를 통한 Contribute

Pull Request 방식이 익숙하시지 않은 분들은 issue 로 내용을 등록하실 수도 있습니다. 추가하고 싶은 내용을 issue 로 등록해주시면 저 또는 다른 분들이 적절한 위치에 올려주신 내용을 추가할 수 있습니다 :)

---

## Labels for PR

- Edit typos or links
  - 오타 또는 잘못된 링크를 수정.
- Inaccurate information
  - 잘못된 정보에 대한 Fix.
- New Resources
  - 새로운 내용 추가

### 그 외 Labels

- Suggestions
  - 해당 `Repository`에 건의하고 싶은 사항에 대해서 `Issue`로 등록해주세요.
- Questions
  - 질문이 있으시면 해당 Label 과 함께 `Issue`를 등록해주세요.

---

## 📝 템플릿 (예시)

### 📌 Pull Request Template
```md
### 📌 Pull Request 내용

- [ ] 오타 또는 링크 수정
- [ ] 잘못된 정보 수정
- [ ] 문서/예제 추가

#### ✨ 변경 사항 요약
<!-- 변경한 내용 간단히 정리해주세요 -->

#### 📎 관련 이슈
<!-- 관련된 이슈가 있다면 작성해주세요 -->
```

### 📌 Issue Template
이슈 등록 시 아래 템플릿 중 하나를 선택하여 작성해주세요.  
GitHub에서 "New Issue"를 클릭하면 직접 선택할 수 있습니다.


| 유형 | 설명 | 템플릿 링크 |
|------|------|-------------|
| **Edit typos or links** | 오타 또는 잘못된 링크 수정 제안 | [보기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/.github/ISSUE_TEMPLATE/typo-or-link.md) |
| **Inaccurate information** | 잘못된 정보에 대한 수정 요청 | [보기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/.github/ISSUE_TEMPLATE/inaccurate-info.md) |
| **New Resources** | 새로운 문서, 링크, 예제 추가 제안 | [보기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/.github/ISSUE_TEMPLATE/new-resource.md) |
| **Suggestions** | 기능 제안 또는 구조 개선 건의 | [보기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/.github/ISSUE_TEMPLATE/suggestion.md) |
| **Questions** | 프로젝트 관련 질문 | [보기](https://github.com/steamedEggMaster/terraform-google-multi-env/blob/main/.github/ISSUE_TEMPLATE/question.md) |

각 항목은 `.github/ISSUE_TEMPLATE/` 폴더에 템플릿으로 저장되어 있으며,  
이슈 생성 시 자동으로 해당 템플릿 양식이 적용됩니다.
```

---

감사합니다! 프로젝트 발전에 함께해 주세요 😊