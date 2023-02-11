# Hammerspoon 설정

앱 전환이나 창 분할 등의 기능을 구현한 Hammerspoon 설정 파일

> Hammerspoon: macOS 자동화 도구

## 설치

```sh
# hammerspoon 설치
brew install --cask hammerspoon

# submodule이 필요하므로 반드시 --reccursive 옵션을 붙여서 클론
git clone --recursive git@github.com:datalater/hammerspoon-config.git

# hammerspoon-config 폴더로 이동
cd hammerspoon-config

# 필요한 모듈 설치 (Brewfile 참고)
brew bundle

# 모듈 설치 스크립트 실행
chmod +x install-modules.sh
source install-modules.sh

# hammerspoon 설정 파일 연결
rm -rf ~/.hammerspoon && ln -s $(pwd) ~/.hammerspoon
```

## 설치 확인

1. 설치를 완료하고 Hammerspoon을 실행합니다.
2. 메뉴바에에서 Hammerspoon 우클릭 후 Reload config를 눌러서 `loaded` 메시지가 나오면 성공입니다.

![hammerspoon-reload-config](https://user-images.githubusercontent.com/8105528/218239932-bd9b9f81-2b7e-4cf6-86e3-a8dddfb11ab1.gif)

## Misc

Q. M1 Mac에서 설치 오류가 난다면 어떻게 해야 하나요?

> (1) M1이 아닌 인텔 버전으로 brew로 설치하고 (2) 인텔 버전으로 설치한 brew로 lua, luarocks, hammerspoon 설치합니다. [참고 - 인텔 버전으로 iterm 세팅하기](https://subicura.com/mac/dev/apple-silicon.html#apple-silicon-m1)
