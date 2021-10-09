## Installation

hammerspoon 설치:

- mac의 경우 인텔 버전으로 설치된 brew로 lua, luarocks, hammerspoon 설치할 것 - [참고 - 인텔 버전으로 iterm 세팅하기](https://subicura.com/mac/dev/apple-silicon.html#apple-silicon-m1)

hammerspoon 설정 설치:

```bash
git clone --recursive git@github.com:datalater/hammerspoon-config.git
cd hammerspoon-config
chmod +x install-modules.sh
./install-modules.sh
ln -s $(pwd) ~/.hammerspoon
```
