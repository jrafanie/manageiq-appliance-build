#
# Kick off a nightly upstream build
#
# repo:      ManageIQ/manageiq.git
# branch:    master
# fileshare: true
#

CUR_BUILD="`virsh list | sed '1,2d'`"
if [ -n "${CUR_BUILD}" ]
then
  echo "Current ImageFactory Build ongoing, cannot kick-off nightly build"
  exit 1
fi

LOG_DIR=/build/logs
mkdir -p ${LOG_DIR}

DATE_STAMP=`date +"%Y%m%d_%T"`
LOG_FILE="${LOG_DIR}/upstream_${DATE_STAMP}.log"
BUILD_OPTIONS="--type nightly"

if [ "${1}" = "--fileshare" -o "${1}" = "--no-fileshare" -o "${1}" = "--local" ]
then
  BUILD_OPTIONS="$BUILD_OPTIONS ${1}"
  shift
fi

if [ "${1}" = "--fg" ]
then
  echo "Nightly Build kicked off, Log being saved in ${LOG_FILE} ..."

  time ruby /build/scripts/vmbuild.rb $BUILD_OPTIONS 2>&1 | tee ${LOG_FILE}
else
  nohup time ruby /build/scripts/vmbuild.rb $BUILD_OPTIONS >${LOG_FILE} 2>&1 &

  echo "Nightly Build kicked off, Log @ ${LOG_FILE} ..."
fi
