#!/bin/bash

# 변수 설정
SERVER_USER="root"
SERVER_IP="192.168.10.138"
BACKUP_SOURCE="/bin/ /home/qqq/Desktop/application"
if [ "$1" == "malicious" ]; then
  BACKUP_DESTINATION="/home/tserver/backup/malicious_backup_$(date +%Y%m%d_%H%M%S)"
else
  BACKUP_DESTINATION="/home/tserver/backup/regular_backup_$(date +%Y%m%d_%H%M%S)"
fi

# 백업 대상 서버에 /backup 디렉토리가 존재하는지 확인하고, 없으면 생성
ssh -i /home/qqq/.ssh/id_rsa "$SERVER_USER@$SERVER_IP" "mkdir -p $BACKUP_DESTINATION"

# /bin 디렉토리를 서버의 /backup 디렉토리로 백업하고, 성공 여부 확인
if rsync -avz -e "ssh -i /home/qqq/.ssh/id_rsa" $BACKUP_SOURCE "$SERVER_USER@$SERVER_IP:$BACKUP_DESTINATION"; then
    # 백업 완료 신호 파일 생성
    touch /tmp/backup_complete
fi
