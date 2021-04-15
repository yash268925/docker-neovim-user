FROM alpine:latest as base

RUN apk add curl \
 && mkdir /etc/skel \
 && curl -fLo /etc/skel/.config/nvim/init.vim --create-dirs \
      https://raw.githubusercontent.com/yash268925/neovim-init/main/init.vim \
 && curl -fLo /etc/skel/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

FROM yash268925/neovim

ENV PATH=${NEOVIM_PREFIX}/bin:$PATH

COPY --from=base /etc/skel /etc/skel
RUN apk add \
    sudo \
    git

ONBUILD ARG UID
ONBUILD ARG GID
ONBUILD ARG UNAME

ONBUILD RUN addgroup -S ${UNAME} -g ${GID} \
         && adduser -S ${UNAME} -u ${UID} -G ${UNAME} \
         && echo "${UNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
         && echo "${UNAME}:${UNAME}" | chpasswd \
         && chmod -R go+rw ${NEOVIM_PREFIX}/share

ONBUILD USER ${UID}:${GID}
ONBUILD WORKDIR /home/${UNAME}

ONBUILD RUN ${NEOVIM_PREFIX}/bin/nvim --headless +PlugInstall +q +q
