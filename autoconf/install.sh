# Install the vim and cppenviron.
# * It's contains software:
#       dos2unix
#       git
#       vim
#       g++
#       ctags
#       cmake
#       python-dev
#       vim-YouCompleteMe
#       vim-vundle
#       vim-airline
#       vim-nerdtree
#       vim-taglist
#       vim-cppenv.
#
# * And contains config files:
#       _vimrc
#       .ycm_extra_conf.py
#

# install dos2unix, git, vim, g++, ctags, cmake, python-dev
./change_source_list.sh

INSTALL_TOOL=apt-get

apt-get > /dev/null
if [ "$?" != "0" ];
then
    INSTALL_TOOL=yum
fi

echo "INSTALL_TOOL: " $INSTALL_TOOL

sudo $INSTALL_TOOL update -y

dos2unix --version > /dev/null || sudo $INSTALL_TOOL install dos2unix -y
dos2unix --version || exit 1

git --version > /dev/null || sudo $INSTALL_TOOL install git -y
git --version > /dev/null || exit 1
git config --global user.email user_email@gmail.com
git config --global user.name user_name

vim --version > /dev/null || sudo $INSTALL_TOOL install vim -y
vim --version > /dev/null || exit 1

g++ --version > /dev/null || sudo $INSTALL_TOOL install g++ -y
g++ --version > /dev/null || exit 1

ctags --version > /dev/null || sudo $INSTALL_TOOL install ctags -y
ctags --version > /dev/null || exit 1

cmake --version > /dev/null || sudo $INSTALL_TOOL install cmake -y
cmake --version > /dev/null || exit 1

sudo $INSTALL_TOOL install python-dev -y

# copy _vimrc file to $HOME
dos2unix _vimrc
rm ~/_vimrc -f
ln _vimrc ~/_vimrc
chmod 0666 ~/_vimrc
dos2unix .ycm_extra_conf.py
rm ~/.ycm_extra_conf.py -f
cp .ycm_extra_conf.py ~/
chmod 0666 ~/.ycm_extra_conf.py

# git clone vim-vundle.git
vim_path=`vim --version | grep '$VIM:' | cut -d'"' -f2`
vundle_path=${vim_path}/vimfiles/bundle/Vundle.vim
#echo $vim_path
#echo ${vundle_path}
if test -d ${vundle_path}; then
    cd ${vundle_path}
    sudo git pull || exit 2
else
    sudo git clone https://github.com/gmarik/Vundle.vim.git ${vundle_path} || exit 2
fi

# gitclone and compile YouCompleteMe
ycm_path=${vim_path}/vimfiles/bundle/YouCompleteMe
if test -d ${ycm_path}; then
    cd ${ycm_path}
    sudo git pull || exit 2
else
    sudo git clone https://github.com/Valloric/YouCompleteMe.git ${ycm_path} || exit 2
    cd ${ycm_path}
fi
sudo git submodule update --init --recursive || exit 3
sudo ./install.sh --clang-completer || exit 3

# install vim-plugins
sudo vim +BundleInstall -c quitall

echo 'vim-env is ok, good luck!'

