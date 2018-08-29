#!/usr/bin/env bash

### ARGS PASSED TO SCRIPT
[ -z "$2" ] && { echo "USAGE: `basename $0` repository_name registry_url"; exit 1; }
REPO_NAME="$1"
REG_URL="$2"

LOGDIR=`pwd`
E_LOG=${LOGDIR}/cmd.err.log
O_LOG=${LOGDIR}/cmd.out.log
### FUNCTION THAT PRINTS A DASHED LINE
plines () {
  perl -e 'print "- " x60, "\n"'
}
### FUNCTION TO MANAGE STDOUT & STDERR TO CONSOLE & LOGS
count=1
runcmd () {
    DATE=`date +'%d/%m/%Y %H:%M:%S'`
	CMD="$1"
	exec 3>&2
	exec 2>>${E_LOG}
	printf "$DATE CMD %d> %s:" ${count} "${CMD}" 1>&2
    printf "$DATE CMD %d> %s, Result: " ${count} "${CMD}" | tee -a ${O_LOG}
	CMDOUT=`eval "${1}" `; EC="$?"
	if [ "$EC" -eq 0 ]; then
	     	printf "OK [%d]\n" $EC | tee -a ${O_LOG}
	else
		printf "FAILED [%d] Check log\n" $EC | tee -a ${O_LOG}
	fi
	[ ! -z "$CMDOUT" ] && printf "%b" "\n${CMDOUT}\n" && plines
	count=`expr $count + 1`
	#sed -i '' '$a\' ${E_LOG} #OSX
    sed -i '$a\' ${E_LOG}  #GNU
	exec 2>&3
}
# FUNCTION TO BUILD & RETURN DOCKER COMMANDS
# ARGS ARE: (1) TAG_NAME, (2) REPO NAME, (3) REGISTRY URL, (4) COMMAND [tag, push, build images]
# Example:  "dcr_cmd frontend_dev_v01 odecee/techradar 758085500738.dkr.ecr.us-east-1.amazonaws.com push
dcr_cmd () {
  TAG="$1"; REPO="$2"; REGISTRY="$3"; DCMD="$4"
  case "$DCMD" in
    tag)
        FULL_CMD="docker ${DCMD} ${REPO}:${TAG} ${REGISTRY}/${REPO}:${TAG}"
        ;;
    push)
        FULL_CMD="docker ${DCMD} ${REGISTRY}/${REPO}:${TAG}"
        ;;
    build)
        FULL_CMD="docker ${DCMD} -t ${REPO}:${TAG} ."
        ;;
    images)
        FULL_CMD="docker ${DCMD} ${REGISTRY}/${REPO}"
        ;;
    default)
        echo "Bad option to docker command function"
        exit 127
        ;;
  esac
  DOCKER_BUILD_CMD="$FULL_CMD"
}

CDIR=`pwd`

if [ -d "${CDIR}/TechRadarAppFrontEnd/techradar-ionic" ]; then
   rm -rf ${CDIR}/TechRadarAppFrontEnd/techradar-ionic
fi
mv application/techradar-ionic TechRadarAppFrontEnd/

if [ -d "${CDIR}/TechRadarAppServer/techradar-server" ]; then
  rm -rf ${CDIR}/TechRadarAppServer/techradar-server
fi
mv application/techradar-server TechRadarAppServer/



plines
cd virtual_tmp && . bin/activate; cd `pwd`/../ && pwd && ls -la
which python
docker --version
plines
region="us-east-1"; registry_ids="758085500738"; echo "REGION: ${region}" "REGISTRY: ${registry_ids}"
docker_login_command=$(aws ecr get-login --region "${region}" --registry-ids ${registry_ids})
echo "DOCKER LOGIN COMMAND:"; echo; echo "${docker_login_command}"; eval ${docker_login_command}
plines

runcmd "aws ecr describe-repositories"
echo  "##########  START DOCKER BUILDS ##########"
echo  "##############  BUILD init ##############"

while read line
do
    echo "$line" | egrep -vi '^[a-z]' 2>/dev/null  && continue
    _IFS=$IFS; IFS=','
    set -- $line

    WORKDIR="$1"; IMG_TAG="$2"; PUSH="$3"
    [ -d "${CDIR}/${WORKDIR}" ] && cd ${CDIR}/${WORKDIR} || { echo "$WORKDIR doesn't exist"; exit 1; }

    dcr_cmd "${IMG_TAG}" "${REPO_NAME}" "${REG_URL}" build;     runcmd "$DOCKER_BUILD_CMD"
    dcr_cmd "${IMG_TAG}" "${REPO_NAME}" "${REG_URL}" tag;       runcmd "$DOCKER_BUILD_CMD"
    if [ "$PUSH" = 'TRUE' ]
    then
      dcr_cmd "${IMG_TAG}" "${REPO_NAME}" "${REG_URL}" push;    runcmd "$DOCKER_BUILD_CMD"
    fi
    dcr_cmd "${IMG_TAG}" "${REPO_NAME}" "${REG_URL}" images;    runcmd "$DOCKER_BUILD_CMD"
    docker images

done < ${CDIR}/directories.conf
IFS=$_IFS



#cd ../TechRadarCompose   && ls
#docker-compose up -d
#
#echo  "##############  TEST THE SETUP ##############"
#curl -o techradar_home.html http://localhost:8100
#curl -o techradar_backend.html localhost:3000/documentation
#
#docker-compose stop

