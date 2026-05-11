# 로그인 가이드 — GitHub Personal Access Token (PAT)

이 페이지에 로그인하려면 본인의 **GitHub 계정**에서 발급한 **Fine-grained Personal Access Token**이 필요합니다.

서버/DB 없이 GitHub 레포 자체를 데이터 저장소로 쓰기 때문에, 자료 업로드·제출 같은 쓰기 동작은 본인 토큰을 통해 본인 이름으로 커밋됩니다.

---

## 1. 사이트 접속

> **https://cloud-club.github.io/09th-cloud-diet/**

브라우저로 위 주소에 들어가면 Dashboard 화면이 뜨고, 사이드바 하단에 **Login** 버튼이 보입니다.

---

## 2. 토큰 발급 (Fine-grained PAT)

### 2-1. 발급 페이지 열기

GitHub 우상단 아바타 → **Settings** → 좌측 메뉴 맨 아래 **Developer settings**
→ **Personal access tokens** → **Fine-grained tokens** → **Generate new token**

또는 바로 이 링크: https://github.com/settings/personal-access-tokens/new

### 2-2. 기본 정보

| 항목 | 입력 |
|------|------|
| **Token name** | `09th-cloud-diet` (자유롭게) |
| **Expiration** | 권장 **90 days** (스터디 8주 + 여유) — 만료되면 같은 절차로 재발급 |
| **Description** | `Cloud Club 9기 시즌 2 스터디 사이트 로그인용` |
| **Resource owner** | 본인 GitHub 계정 |

### 2-3. Repository access

**Only select repositories**를 선택하고 `cloud-club/09th-cloud-diet`만 골라주세요.

> Tip: 검색창에 `09th-cloud-diet`를 치면 바로 찾을 수 있습니다.

전체 레포에 대한 권한을 주면 보안상 위험이 커지므로 반드시 **이 레포만** 선택해주세요.

### 2-4. Permissions

`Repository permissions` 섹션을 펼치고 아래 3개만 조정합니다. **나머지는 손대지 마세요.**

| Permission | 값 | 용도 |
|------------|------|------|
| **Contents** | **Read and write** | 자료 업로드, 산출물 제출, README/파일 읽기 |
| **Issues** | Read and write | 답안 제출(시즌 1 호환), 토론 |
| **Metadata** | Read-only (자동 선택) | 레포 기본 정보 |

> 읽기 전용으로 둘러보기만 할 거면 위 항목을 전부 **Read-only**로 바꿔도 됩니다.
> 단, 그러면 자료 업로드 / 제출 / 출석 체크는 **불가능**합니다.

### 2-5. 발급

맨 아래 **Generate token** 클릭 → 토큰 문자열(예: `github_pat_…`)을 **즉시 복사**하세요.

> ⚠️ 이 화면을 닫으면 **다시는 볼 수 없습니다.** 분실하면 새 토큰을 발급해야 합니다.

---

## 3. 사이트에서 로그인

1. https://cloud-club.github.io/09th-cloud-diet/ 접속
2. 좌측 사이드바 하단 **Login** 버튼 클릭
3. 방금 복사한 토큰을 붙여넣고 **Login**
4. 로그인 성공하면 사이드바에 `@username`이 표시됩니다

토큰은 **브라우저 localStorage에만** 저장됩니다. 서버로 전송되지 않고, 다른 사람 PC로 옮겨가지도 않습니다.

---

## 4. 권한별로 할 수 있는 것

### 읽기 전용 (Contents: Read-only)
- Dashboard / Problems / Materials / Scores / Profile 페이지 모두 조회
- 본인/타인 산출물 열람
- 시즌 1 아카이브 조회

### 쓰기 가능 (Contents: Read and write + Issues: Read and write)
- Materials 페이지에서 **자료 업로드 / 수정 / 삭제**
- Submit 페이지에서 **산출물 / 답안 제출**
- 본인 Profile 정보 갱신
- (시즌 1 호환) Issues 통한 답안 제출

> 모든 쓰기 동작은 본인 GitHub 계정 이름으로 **public commit**이 됩니다. 즉, 누가 무엇을 올렸는지 git log에 영구 기록됩니다.

---

## 5. 토큰 만료 / 분실 시

### 만료 알림
GitHub은 토큰 만료 7일 전, 그리고 만료 후에 이메일로 알려줍니다.

### 재발급 절차
1. https://github.com/settings/personal-access-tokens 접속
2. 기존 토큰 옆 **⋯** → **Regenerate** (이름·권한 그대로 새 토큰 생성)
   - 또는 **Delete** 후 위 2번 과정 다시
3. 사이트에서 사이드바 user 영역의 로그아웃 버튼 → 새 토큰으로 다시 로그인

### 보안 사고가 의심되면
토큰이 노출됐다고 의심되면 **즉시 Revoke**하세요:
https://github.com/settings/personal-access-tokens → 해당 토큰 → **Revoke**

---

## 6. 자주 묻는 질문

**Q. Classic Personal Access Token도 되나요?**
A. 됩니다만, 권장하지 않습니다. Fine-grained가 레포 단위 / 권한 단위로 훨씬 안전합니다.

**Q. 토큰을 코드에 커밋해도 되나요?**
A. **절대 안 됩니다.** 토큰은 비밀번호와 동일합니다. 실수로 push 했다면 즉시 Revoke 후 재발급하세요.

**Q. 모바일에서도 로그인 되나요?**
A. 네. 모바일 브라우저에서도 동일하게 동작합니다. 다만 토큰 발급은 데스크탑에서 하는 게 편합니다.

**Q. 만료기간 90일이 너무 짧으면?**
A. 최대 1년까지 늘릴 수 있습니다. 다만 보안상 짧을수록 좋습니다. 스터디 종료 시점(2026-06 말)에 맞춰 잡아도 됩니다.

**Q. 토큰이 안 먹어요 / 403 떠요**
A. 다음을 확인해주세요:
- 토큰의 Repository access에 `09th-cloud-diet`가 포함됐는지
- Contents 권한이 Read-only가 아닌지 (쓰기 동작 시)
- 토큰이 아직 만료되지 않았는지
- 본인이 cloud-club 조직 멤버이거나 레포에 collaborator로 등록됐는지

---

## 7. 참고

- Fine-grained PAT 공식 문서: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens
- 본 사이트 레포: https://github.com/cloud-club/09th-cloud-diet
- 문의: 스터디 Slack 채널 또는 [@dev-jiseok](https://github.com/dev-jiseok)
