#!/bin/bash

# 변수 설정
BACKUP_DIR="/home/tserver/backup"
MALICIOUS_SUBSTRING="malicious_backup"
CLIENT_IP="192.168.10.200"
CLIENT_USER="qqq"

# 무한 루프를 통해 백업 디렉토리 모니터링
while true; do
    # 최근에 생성된 malicious_backup 디렉토리 찾기
    latest_backup=$(find $BACKUP_DIR -type d -name "*$MALICIOUS_SUBSTRING*" -printf '%T+ %p\n' | sort -r | head -n 1 | cut -d' ' -f2)
    
    if [ ! -z "$latest_backup" ] && [ ! -f "$latest_backup/.handled" ]; then
        # TFTP와 DHCP 서버 재시작 
        sudo systemctl restart tftpd-hpa
        sudo systemctl restart isc-dhcp-server

        # 클라이언트에 백업 파일 전송 (원하는 경우 주석 해제)
        # scp -r $latest_backup $CLIENT_USER@$CLIENT_IP:/desired/destination/path

        # 처리 표시 파일 생성 (원하는 경우 주석 해제)
        # touch "$latest_backup/.handled"
    fi

    sleep 10 # 10초마다 체크
done
