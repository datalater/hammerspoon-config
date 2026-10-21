# Hammerspoon 설정

- [설치](#설치)
- [설치 확인](#설치-확인)
- [appman.toggle 사용법](#appmantoggle-사용법)
  - [특정 창만 바인딩하기 (windowTitle)](#특정-창만-바인딩하기-windowtitle)
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

git clone git@github.com:datalater/hammerspoon-config.git

# hammerspoon-config 폴더로 이동
cd hammerspoon-config

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

### 특정 창만 바인딩하기 (windowTitle)

같은 앱 안의 **특정 창 하나**만 단축키로 부르고 싶을 때 사용합니다. 예를 들어 크롬 확장 프로그램 창(`chrome.windows.create({ type: "popup" })`)은 별도 앱이 아니라 Chrome 프로세스 안의 창이라서, 앱 이름만으로는 일반 Chrome과 구분할 수 없습니다.

```lua
-- init.lua (F13 모드 안)
mode:bind({"shift"}, "q", app_man:toggle({
    name = "Google Chrome",
    windowTitle = "QA Scenario Checker"  -- 창 제목의 일부만 맞아도 됩니다 (부분 일치, 대소문자 구분)
}))
```

동작은 다음과 같습니다.

| 상황 | 동작 |
| --- | --- |
| 그 창이 열려 있고 다른 창이 전면 | 그 창을 앞으로 가져옵니다. 최소화되어 있으면 복원합니다. |
| 그 창이 이미 전면 | 앱을 숨기고(`hide()`) macOS가 직전 앱으로 돌려놓습니다. `appman.toggle("앱 이름")`과 같은 방식입니다. |
| 그 창이 없음 | `<windowTitle> 창이 열려 있지 않습니다` 알림만 띄웁니다. 창을 새로 열지는 않습니다. |

#### 새 창을 바인딩하는 순서

1. **창 제목 확인**: 대상 창을 열어 둔 상태에서 Hammerspoon 콘솔(메뉴바 아이콘 → Console)에 아래를 입력합니다.

   ```lua
   for _, w in ipairs(hs.application.get("Google Chrome"):allWindows()) do print(w:title(), w:subrole()) end
   ```

   출력된 제목에서 다른 창과 겹치지 않는 부분을 `windowTitle`로 씁니다. 크롬은 보통 페이지 `<title>`이 창 제목이 됩니다.

2. **빈 키 찾기**: 같은 모드(F13) 안에서 이미 쓰는 키와 겹치지 않아야 합니다. 창 이동(`win_move`)은 F14 모드라서 F13 키와는 겹치지 않습니다. `init.lua`에서 `local mode = f13_mode`로 시작하는 블록(앱 토글, 클립보드)의 바인딩만 확인하면 됩니다.

   ```sh
   # 어느 모달에 속한 바인딩인지(f13_mode / f14_mode)는 각 블록의 `local mode = ...` 줄로 구분합니다.
   grep -nE 'local mode|mode:bind' ~/.hammerspoon/init.lua
   ```

3. **바인딩 추가**: 위 예시처럼 `init.lua`의 app manager 블록(`do -- app manager`)에 한 줄을 추가합니다.

4. **적용**: `Cmd + Option + R`로 reload하고 콘솔에 오류가 없는지 확인합니다.

#### 주의할 점

- 창이 전면일 때 한 번 더 누르면 **앱 전체**(예: Chrome의 일반 창 포함)가 숨겨집니다. 창 하나만 숨기는 동작이 아닙니다.
- `windowTitle`이 다른 창 제목과 겹치면 먼저 발견된 창이 선택됩니다.
- 구현은 `modules/appman.lua`의 `windowTitle` 분기입니다. `name`은 `hs.application.get(name)`으로 앱을 찾는 값이므로 정확한 앱 이름이어야 합니다.

## pull

```sh
git pull --rebase origin main
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

Q. 한영전환을 할 때마다 녹색 바가 뜨는데 없애고 싶어요. 어떻게 해야 하나요?

> `init.lua` 파일에서 `inputsource_aurora` 모듈을 불러오는 코드를 삭제하면 됩니다.
>
> 참고로 이 기능은 맥에서 한영전환이 느린 경우 현재 입력 소스가 한글인지 신호를 주기 위해 구현된 기능입니다. 맥북에서는 녹색 바가 메뉴바 사이즈에 알맞게 정상적으로 나오지만 간혹 맥북에 연결한 외부 모니터에서는 사이즈가 이상하게 나오는 경우가 있습니다. 이런 경우에는 `inputsource_aurora` 모듈을 불러오는 코드를 삭제하면 비활성화 됩니다.

```lua
-- hammerspoon config
require('modules.inputsource_aurora') -- 여기!
```

## 📚 함께 읽기

- [Learn Lua in 15 Minutes](https://tylerneylon.com/a/learn-lua/)
