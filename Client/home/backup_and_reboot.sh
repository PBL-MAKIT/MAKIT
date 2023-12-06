#!/bin/bash

# 변수 설정
SERVER_USER="root"
SERVER_IP="192.168.253.135"
BACKUP_SOURCE="/bin/"
BACKUP_DESTINATION="/backup/bin_backup_$(date +%Y%m%d_%H%M%S)"

# 백업 대상 서버에 /backup 디렉토리가 존재하는지 확인하고, 없으면 생성
ssh "$SERVER_USER@$SERVER_IP" "mkdir -p $BACKUP_DESTINATION"

# /bin 디렉토리를 서버의 /backup 디렉토리로 백업
rsync -avz $BACKUP_SOURCE "$SERVER_USER@$SERVER_IP:$BACKUP_DESTINATION"

# 백업 후 시스템 재부팅
echo "Backup completed. Rebooting system..."
sudo reboot
