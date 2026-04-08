# overleaf

下载源码

```jsx
git clone https://github.com/overleaf/overleaf.git ./overleaf-src
git clone https://github.com/overleaf/toolkit.git ./overleaf-toolkit
cd overleaf-toolkit/
bin/init
bin/up -d
```

编译docker image

```jsx
docker build -t yundait-latex-base:latest -f ./server-ce/Dockerfile-base .

docker build -t yundait-latex:latest -f ./server-ce/Dockerfile .
```

修改Dockerfile-base

```jsx
RUN mkdir /install-tl-unx \
&&  wget --quiet https://tug.org/texlive/files/texlive.asc \
&&  gpg --import texlive.asc \
&&  rm texlive.asc \
&&  wget --quiet ${TEXLIVE_MIRROR}/install-tl-unx.tar.gz \
&&  wget --quiet ${TEXLIVE_MIRROR}/install-tl-unx.tar.gz.sha512 \
&&  wget --quiet ${TEXLIVE_MIRROR}/install-tl-unx.tar.gz.sha512.asc \
&&  gpg --verify install-tl-unx.tar.gz.sha512.asc \
&&  sha512sum -c install-tl-unx.tar.gz.sha512 \
&&  tar -xz -C /install-tl-unx --strip-components=1 -f install-tl-unx.tar.gz \
&&  rm install-tl-unx.tar.gz* \
&&  echo "tlpdbopt_autobackup 0" >> /install-tl-unx/texlive.profile \
&&  echo "tlpdbopt_install_docfiles 0" >> /install-tl-unx/texlive.profile \
&&  echo "tlpdbopt_install_srcfiles 0" >> /install-tl-unx/texlive.profile \
&&  echo "selected_scheme scheme-basic" >> /install-tl-unx/texlive.profile \
    \
&&  /install-tl-unx/install-tl \
      -profile /install-tl-unx/texlive.profile \
      -repository ${TEXLIVE_MIRROR} \
    \
&&  $(find /usr/local/texlive -name tlmgr) path add \
&&  tlmgr install --repository ${TEXLIVE_MIRROR} \
      latexmk \
      texcount \
      synctex \
      etoolbox \
      xetex \
&&  tlmgr path add \
&&  rm -rf /install-tl-unx \
&&  cd /usr/local/texlive \
&&  wget --quiet http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh --no-check-certificate \
&&  sh update-tlmgr-latest.sh \
&&  tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet/ \
&&  tlmgr update --self --all \
&&  tlmgr install scheme-full \
&&  cd /usr/local/texlive/2024/bin/x86_64-linux \
&&  tlmgr path add

```

修改toolkit环境变量

variables.env

```jsx
OVERLEAF_SITE_LANGUAGE=zh-CN
```

设置代理

```jsx
export https_proxy=http://172.17.0.1:20171 http_proxy=http://172.17.0.1:20171 all_proxy=socks5://172.17.0.1:20170
```

文献引用问题

```jsx
cd /usr/local/texlive/2024/bin/x86_64-linux
tlmgr path add
```

初始化管理员

```jsx
http://IP/launchpad
```