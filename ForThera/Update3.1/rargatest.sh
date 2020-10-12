mv -v /opt/retroarch/bin/retroarch /opt/retroarch/bin/retroarch.testupdate.bak
mv -v /opt/retroarch/bin/retroarch32 /opt/retroarch/bin/retroarch32.testupdate.bak
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/retroarch/retroarch -O /opt/retroarch/bin/retroarch
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/retroarch32/retroarch32 -O /opt/retroarch/bin/retroarch32
sudo chown -v odroid:odroid /opt/retroarch/bin/retroarch
sudo chmod -v 777 /opt/retroarch/bin/retroarch
sudo chown -v odroid:odroid /opt/retroarch/bin/retroarch32
sudo chmod -v 777 /opt/retroarch/bin/retroarch32
sudo ln -sfv /usr/lib/aarch64-linux-gnu/librga.so /usr/lib/aarch64-linux-gnu/librga.so.2