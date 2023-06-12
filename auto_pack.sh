#! /usr/bash

# ----------------------------------------------------------------
### Constant Variables
# ----------------------------------------------------------------
ROOT_DIR=$(
  cd "$(dirname "$0")"
  pwd
)
VERSION=$(cat ${ROOT_DIR}/VERSION)
WRITE_VERSION=${VERSION}

# ----------------------------------------------------------------
### Scripts
# ----------------------------------------------------------------
check_link() {
  link1="https://github.com/Fndroid/clash_for_windows_pkg/releases/download/$1/Clash.for.Windows-$1-x64-linux.tar.gz"
  link2="https://github.com/BoyceLig/Clash_Chinese_Patch/releases/download/$1/app.zip"

  # echo "Checking [${link1}] ... \n"
  if [ $(curl -I -m 5 -s -w "%{http_code}\n" -o /dev/null ${link1}) -eq "302" ]; then
    if [ $(curl -I -m 5 -s -w "%{http_code}\n" -o /dev/null ${link2}) -eq "302" ]; then
      # echo "Checking [${link2}] ... \n"
      echo 1
    fi
  else
    echo 0
  fi
}

sudo apt install unzip

# 1) VERSION update

major=$(echo ${VERSION} | cut -d "." -f 1)
minor=$(echo ${VERSION} | cut -d "." -f 2)
patch=$(echo ${VERSION} | cut -d "." -f 3)

if [ $(check_link ${major}.${minor}.$(expr ${patch} + 1)) == 1 ]; then
  WRITE_VERSION=${major}.${minor}.$(expr ${patch} + 1)
elif [ $(check_link ${major}.$(expr ${minor} + 1).${patch}) == 1 ]; then
  WRITE_VERSION=${major}.$(expr ${minor} + 1).${patch}
elif [ $(check_link $(expr ${major} + 1).${minor}.${patch}) == 1 ]; then
  WRITE_VERSION=$(expr ${major} + 1).${minor}.${patch}
else
  WRITE_VERSION=${VERSION}
  exit 0
fi
git lfs untrack clash-${VERSION}.tar.gz
VERSION=${WRITE_VERSION}
DEST_DIR=${ROOT_DIR}/temp/clash_origin-${VERSION}/

sed -i 1c"${WRITE_VERSION}" ${ROOT_DIR}/VERSION

# 2) Create temporary directory
if [ ! -d "${ROOT_DIR}/temp" ]; then
  mkdir -p "${ROOT_DIR}/temp"
fi

# 3) Download the package and extract
if [ -d "${ROOT_DIR}/temp/app-${VERSION}.zip" ]; then
  rm ${ROOT_DIR}/temp/app-${VERSION}.zip
fi
wget -O ${ROOT_DIR}/temp/app-${VERSION}.zip https://github.com/BoyceLig/Clash_Chinese_Patch/releases/download/${VERSION}/app.zip
unzip -d ${ROOT_DIR}/temp/app-${VERSION} ${ROOT_DIR}/temp/app-${VERSION}.zip

if [ -d "${ROOT_DIR}/temp/clash_origin-${VERSION}.tar.gz" ]; then
  rm ${ROOT_DIR}/temp/clash_origin-${VERSION}.tar.gz
fi
wget -O ${ROOT_DIR}/temp/clash_origin-${VERSION}.tar.gz https://github.com/Fndroid/clash_for_windows_pkg/releases/download/${VERSION}/Clash.for.Windows-${VERSION}-x64-linux.tar.gz
tar -zxvf ${ROOT_DIR}/temp/clash_origin-${VERSION}.tar.gz -C ${ROOT_DIR}/temp/
mv "${ROOT_DIR}/temp/Clash for Windows-${VERSION}-x64-linux" ${DEST_DIR}

# 4) Move some files

cp -r ${ROOT_DIR}/files/logo* ${DEST_DIR}
mv ${DEST_DIR}resources/app.asar ${DEST_DIR}resources/app.asar.bak
cp -r ${ROOT_DIR}/temp/app-${VERSION}/app.asar ${DEST_DIR}
cp -r ${ROOT_DIR}/VERSION ${DEST_DIR}

# 5) Compress and git lfs track
cd ${DEST_DIR}
tar -zcf clash-${VERSION}.tar.gz
git lfs track clash-${VERSION}.tar.gz
