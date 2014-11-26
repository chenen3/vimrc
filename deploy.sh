# install ctags, cscope
sudo apt-install update
sudo apt-install ctags
sudo apt-install cscope

# vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# clone my vimrc
git clone https://github.com/Aha-/vimrc
cd vimrc && cp .vimrc .vimrc.basic .vimrc.vundle ~

# install plugins
vim +PluginInstall +qa
