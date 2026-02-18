# Hammerspoon 설정

- [설치](#설치)
- [설치 확인](#설치-확인)
- [appman.toggle 사용법](#appmantoggle-사용법)
- [pull](#pull)
  - [bundleID 찾는 법](#bundleid-찾는-법)
- [Misc](#misc)
- [📚 함께 읽기](#-함께-읽기)

앱 전환이나 창 분할 등의 기능을 구현한 Hammerspoon 설정 파일

> Hammerspoon: macOS 자동화 도구

## 설치

```sh
# hammerspoon 설치
brew install --cask hammerspoon

# 👉 submodule이 필요하므로 반드시 --recursive 옵션(= `--recurse-submodules`)을 붙여서 클론
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

## appman.toggle 사용법

```sh
# 아래 명령어로 설치된 앱 목록을 확인할 수 있습니다.
# 그 앱 이름을 사용하세요. `ChatGPT Atlas.app` => `ChatGPT Atlas`
ls /Applications
```

```lua
mode:bind({}, "a", app_man:toggle("ChatGPT Atlas"))
```

LaunchServices에서 앱 이름을 제대로 찾지 못하는 경우에는 `bundleID`나 앱 경로를 함께 넘겨서 실행할 수도 있습니다.

```lua
mode:bind({}, "a", app_man:toggle({ name = "ChatGPT Atlas", bundleID = "com.openai.atlas" }))
```

## pull

```sh
git pull --rebase origin main
git submodule update --remote
```

### bundleID 찾는 법

1. 가장 간단한 방법은 `osascript -e 'id of application "앱 이름"'`을 실행하는 것입니다. 대부분의 앱은 이 명령으로 바로 번들 아이디가 출력됩니다.
2. `osascript`가 실패한다면 앱 패키지에서 직접 읽어올 수 있습니다. 예를 들어 ChatGPT Atlas라면 아래처럼 실행합니다.

```sh
/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' "/Applications/ChatGPT Atlas.app/Contents/Info.plist"
# 또는 defaults 명령 사용
defaults read "/Applications/ChatGPT Atlas.app/Contents/Info" CFBundleIdentifier
```

3. App Store나 iOS 앱처럼 특이한 설치 경로라면 `mdls -name kMDItemCFBundleIdentifier /경로/앱이름.app` 으로 Spotlight 메타데이터에서 확인할 수도 있습니다.

## Misc

Q. M1 Mac에서 설치 오류가 난다면 어떻게 해야 하나요?

> (1) M1이 아닌 인텔 버전으로 brew로 설치하고 (2) 인텔 버전으로 설치한 brew로 lua, luarocks, hammerspoon 설치합니다. [참고 - 인텔 버전으로 iterm 세팅하기](https://subicura.com/mac/dev/apple-silicon.html#apple-silicon-m1)

Q. 한영전환을 할 때마다 녹색 바가 뜨는데 없애고 싶어요. 어떻게 해야 하나요?

> `init.lua` 파일에서 `inputsource_aurora` 모듈을 불러오는 코드를 삭제하면 됩니다.
>
> 참고로 이 기능은 맥에서 한영전환이 느린 경우 현재 입력 소스가 한글인지 신호를 주기 위해 구현된 기능입니다. 맥북에서는 녹색 바가 메뉴바 사이즈에 알맞게 정상적으로 나오지만 간혹 맥북에 연결한 외부 모니터에서는 사이즈가 이상하게 나오는 경우가 있습니다. 이런 경우에는 `inputsource_aurora` 모듈을 불러오는 코드를 삭제하면 비활성화 됩니다.

```lua
-- hammerspoon config
require('luarocks.loader')
require('modules.inputsource_aurora') -- 여기!
```

## 📚 함께 읽기

- [Learn Lua in 15 Minutes](https://tylerneylon.com/a/learn-lua/)
