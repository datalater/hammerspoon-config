# 튜토리얼

## 서브 모듈 버전 관리

해당 저장소는 Git 서브모듈을 사용해서 버전 관리를 합니다. 따라서 메인 프로젝트 내부에 있는 `/modules/hammerspoon_winmove` 디렉토리를 업데이트하려면 Git submodule 명령어를 사용해야 합니다:

```sh
# 최신 서브모듈 받아오기
git submodule update --remote
```

```sh
# 서브모듈 로컬 변경사항 커밋하기

# 서브모듈 디렉토리에서 add-commit-push
cd path/to/submodule
git add .
git commit -m "Commit message"
git push

# 업데이트된 서브모듈을 추적하도록 메인 저장소 업데이트
cd /main
git add .
git commit -m "Update submodule"
git push
```

## 📚 함께 읽기

- [stackoverflow - How do I "commit" changes in a git submodule?](https://stackoverflow.com/a/5542964)
- [Tecoble - git submodule로 중요한 정보 관리하기](https://tecoble.techcourse.co.kr/post/2021-07-31-git-submodule/)
