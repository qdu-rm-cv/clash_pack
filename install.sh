#! /bin/bash

# ----------------------------------------------------------------
### Constant Variables
# ----------------------------------------------------------------
ROOT_DIR=$(
  cd "$(dirname "$0")"
  pwd
)
USER=$(whoami)
CLASH=/home/$USER/clash
CLASH_DIR=$(
  if [ ! -d "{$CLASH}" ]; then
    mkdir -p ${CLASH}
  fi
  cd ${CLASH}
  pwd
)

# ----------------------------------------------------------------
### Scripts
# ----------------------------------------------------------------

function copy_file() {
  SRC=$1
  DST=$2
  echo "[RUN]  sudo cp -r ${SRC} ${DST}"
  if [ -d "${DST}" ]; then
    sudo rm -rf ${DST}
  fi
  sudo cp -r ${SRC} ${DST}
}

echo -e "[MAIN]  Start\n"

# 1) Modify the .desktop file and copy it.
sed -i 's/'USER'/'${USER}'/g' ${ROOT_DIR}/clash.desktop

copy_file ${ROOT_DIR}/clash.desktop /usr/share/applications/clash.desktop

# 2) Add Files to the /usr/local/bin directory.
sudo chmod 777 ${ROOT_DIR}/files/cfw
sudo chmod 777 ${ROOT_DIR}/files/clash

copy_file ${ROOT_DIR}/files/clash /usr/local/bin/clash
copy_file ${ROOT_DIR}/files/cfw /usr/local/bin/cfw

# 3) Unzip the .tar.gz file
tar -zxvf ${ROOT_DIR}/clash.tar.gz -C /home/$USER

echo -e "\n[MAIN]  Finish"
