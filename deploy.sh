# clone vimrc
cp .vimrc .vimrc.basic .vimrc.vundle ~

# init vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install plugins
vim +PluginInstall +qa
