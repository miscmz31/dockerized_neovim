FROM alpine:latest

RUN apk --no-cache add ca-certificates

ENV HOME /home/user
RUN adduser -u 1001 -D user \
        && mkdir -p $HOME/.vim/vimrc \
        && mkdir -p $HOME/.config/nvim \
        && chown -R user:user $HOME

COPY init.vim $HOME/.config/nvim/
COPY coc-settings.json $HOME/.config/nvim/
COPY statusline.vim $HOME/.vim/vimrc/
COPY tabline.vim $HOME/.vim/vimrc/

RUN set -x \
        && apk add --no-cache --virtual .build-deps \
                build-base \
                python3 \
                python3-dev \
                py3-pip \
                neovim \
                nodejs \
                npm \
                git \
                ripgrep \
                the_silver_searcher \
                curl \
                gcc \
        && sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' \
        && pip install --no-cache-dir pynvim

RUN nvim --headless +PlugInstall +qa &>/dev/null

WORKDIR /workspace
ENTRYPOINT [ "nvim" ]
