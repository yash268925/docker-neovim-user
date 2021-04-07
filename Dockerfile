FROM alpine:latest as base

RUN apk add curl \
 && mkdir /etc/skel \
 && curl -fLo /etc/skel/.config/nvim/init.vim --create-dirs \
      https://raw.githubusercontent.com/yash268925/neovim-init/main/init.vim \
 && curl -fLo /etc/skel/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

FROM yash268925/docker-neovim

ENV PATH=${NEOVIM_PREFIX}/bin:$PATH

COPY --from=base /etc/skel /etc/skel

ARG UID=1000
ARG GID=1000
ARG UNAME=foxtail

ONBUILD ARG UID
ONBUILD ARG GID
ONBUILD ARG UNAME

ONBUILD RUN addgroup -S ${UNAME} -g ${GID} \
         && adduser -S ${UNAME} -u ${UID} -G ${UNAME} \
         && chmod -R go+rw ${NEOVIM_PREFIX}/share

ONBUILD USER ${UID}:${GID}
ONBUILD WORKDIR /home/${UNAME}

ONBUILD RUN ${NEOVIM_PREFIX}/bin/nvim +PlugInstall +q +q
