# docker-neovim-user

yash268925/docker-neovim(https://github.com/yash268925/docker-neovim)をcompose構成などで使用する際にユーザーを指定できるようにしたもの。
init.vimを引っ張ってきて初期化する処理をONBUILDで指定しているため、compose構成側でbuildするときに同時に初期化処理が発動する。
