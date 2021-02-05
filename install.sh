sudo locale-gen en_US.UTF-8 ;\
export LC_ALL="C";
sudo apt update ;\
sudo apt -y dist-upgrade ;\
sudo apt -y autoremove ;\
sudo apt install -y software-properties-common ;\
sudo apt install -y cmake pkg-config libglib2.0-dev libgpgme-dev libgnutls28-dev uuid-dev libssh-gcrypt-dev \
libldap2-dev doxygen graphviz libradcli-dev libhiredis-dev libpcap-dev bison libksba-dev libsnmp-dev \
gcc-mingw-w64 heimdal-dev libpopt-dev xmltoman redis-server xsltproc libical-dev postgresql \
postgresql-contrib postgresql-server-dev-all gnutls-bin nmap rpm nsis curl wget fakeroot gnupg \
sshpass socat snmp smbclient libmicrohttpd-dev libxml2-dev python-polib gettext rsync xml-twig-tools \
python3-paramiko python3-lxml python3-defusedxml python3-pip python3-psutil virtualenv vim git ;\
sudo apt install -y texlive-latex-extra --no-install-recommends ;\
sudo apt install -y texlive-fonts-recommended ;\
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - ;\
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list ;\
sudo apt update ;\
sudo apt -y install yarn;
echo 'export PATH="$PATH:/opt/gvm/bin:/opt/gvm/sbin:/opt/gvm/.local/bin"' | sudo tee -a /etc/profile.d/gvm.sh ;\
sudo chmod 0755 /etc/profile.d/gvm.sh ;\
source /etc/profile.d/gvm.sh ;\
sudo bash -c 'cat << EOF > /etc/ld.so.conf.d/gvm.conf;
# gmv libs location
/opt/gvm/lib;
EOF';
sudo mkdir /opt/gvm ;\
sudo adduser gvm --disabled-password --home /opt/gvm/ --no-create-home --gecos '' ;\
sudo usermod -aG redis gvm ;\
sudo chown gvm:gvm /opt/gvm/ ;\
sudo su - gvm;
mkdir src ;\
cd src ;\
export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH;
git clone -b gvm-libs-11.0 --single-branch  https://github.com/greenbone/gvm-libs.git ;\
git clone -b openvas-7.0 --single-branch https://github.com/greenbone/openvas.git ;\
git clone -b gvmd-9.0 --single-branch https://github.com/greenbone/gvmd.git ;\
git clone -b master --single-branch https://github.com/greenbone/openvas-smb.git ;\
git clone -b gsa-9.0 --single-branch https://github.com/greenbone/gsa.git ;\
git clone -b ospd-openvas-1.0 --single-branch  https://github.com/greenbone/ospd-openvas.git ;\
git clone -b ospd-2.0 --single-branch https://github.com/greenbone/ospd.git;
#install gvm-libs
cd gvm-libs ;\
 export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH ;\
 mkdir build ;\
 cd build ;\
 cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm .. ;\
 make ;\
 make doc ;\
 make install ;\
 cd /opt/gvm/src;
#config and build openvas-smb
cd openvas-smb ;\
 export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH ;\
 mkdir build ;\
 cd build/ ;\
 cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm .. ;\
 make ;\
 make install ;\
 cd /opt/gvm/src
#config and build scanner
cd openvas ;\
 export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH ;\
 mkdir build ;\
 cd build/ ;\
 cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm .. ;\
 make ;\
 make doc ;\
 make install ;\
 cd /opt/gvm/src;
 sudo su;
 export LC_ALL="C" ;\
ldconfig ;\
cp /etc/redis/redis.conf /etc/redis/redis.orig ;\
cp /opt/gvm/src/openvas/config/redis-openvas.conf /etc/redis/ ;\
chown redis:redis /etc/redis/redis-openvas.conf ;\
echo "db_address = /run/redis-openvas/redis.sock" > /opt/gvm/etc/openvas/openvas.conf ;\
systemctl enable redis-server@openvas.service ;\
systemctl start redis-server@openvas.service
sysctl -w net.core.somaxconn=1024
sysctl vm.overcommit_memory=1;
echo "net.core.somaxconn=1024"  >> /etc/sysctl.conf;
echo "vm.overcommit_memory=1" >> /etc/sysctl.conf;
systemctl daemon-reload ;\
systemctl start disable-thp ;\
systemctl enable disable-thp ;\
systemctl restart redis-server;
