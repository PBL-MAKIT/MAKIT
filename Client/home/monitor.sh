#!/bin/bash

# 스노트 경고 로그 위치
alert_file="/var/log/snort/snort.alert.fast"

# 백업 스크립트 위치
backup_script="/home/qqq/backup_script.sh"

# 로그 파일을 추적하고 새로운 줄에 대해서만 패턴을 검색
tail -f --lines=0 $alert_file | while read line; do
  if echo "$line" | grep -q "Brute"; then
    echo "경고 발견: $line"
    
    # 악성 백업을 나타내는 플래그와 함께 백업 스크립트 호출
    bash "$backup_script" malicious &

    # 악성 활동 플래그
    touch /tmp/malicious_activity

    # 백업 완료 신호 파일이 나타날 때까지 반복
    while true; do
      if [ -f /tmp/backup_complete ]; then
        echo "악성 백업 완료. 시스템 재부팅 중..."
        sudo reboot
      fi
      sleep 1 # 높은 CPU 사용을 피하기 위해 다시 확인하기 전에 잠시 대기
    done

    # 다음 번을 위해 신호 파일 삭제
    rm -f /tmp/backup_complete
    rm -f /tmp/malicious_activity
  fi
done
