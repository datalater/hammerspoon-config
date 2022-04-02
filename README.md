## Installation

hammerspoon 설치:

- mac의 경우 인텔 버전으로 설치된 brew로 lua, luarocks, hammerspoon 설치할 것 - [참고 - 인텔 버전으로 iterm 세팅하기](https://subicura.com/mac/dev/apple-silicon.html#apple-silicon-m1)

## Git SSH 연결 테스트

```bash
# SSH key generate 이후
pbcopy < ~/.ssh/id_ed25519.pub

# github ssh 연결 테스트
ssh -T git@github.com

...
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
...
# 성공시
Hi datalater! Youve successfully authenticated, but GitHub does not provide shell access.
```

## hammerspoon 설정

```bash
git clone --recursive git@github.com:datalater/hammerspoon-config.git
cd hammerspoon-config

chmod +x install-modules.sh

brew bundle

source install-modules.sh

rm -rf ~/.hammerspoon && ln -s $(pwd) ~/.hammerspoon
```
