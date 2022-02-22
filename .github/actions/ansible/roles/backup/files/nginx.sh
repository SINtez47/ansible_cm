#!/bin/bash

#Проверка не запещен ли скрипт
if [[ ($(ps -e| grep srv_bak.sh | wc -l)>"2") ]]; then
echo "Процесс уже запущен"
exit;
fi

basepath=/home/dimar/ansible_cm/backup/nginx

today=`date +%Y%m%d`
yesterday=`date --date="yesterday" +%Y%m%d`
monthago=`date --date="30 day ago" +%Y%m%d`

todaydir=$basepath/$today
yesterdaydir=$basepath/$yesterday
monthagodir=$basepath

#echo $monthagodir

#mkdir -p $todaydir

#chmod 0777 $todaydir
mkdir -p $basepath/$today

#Копирование из yesterday dir в today dir Common
if [ -d $basepath/$yesterday ]; then
        cp -al $basepath/$yesterday/* $basepath/$today
fi

I=0
MAX_RESTARTS=10 # количество возобновлений
LAST_EXIT_CODE=1
while [ $I -le $MAX_RESTARTS ]
do
  I=$(( $I + 1 ))
  echo $I. Запуск синхронизации

#Backup BACKUP
rsync -avz --no-o --no-g --link-dest=$basepath/$yesterday --delete /etc/nginx/ $basepath/$today

  LAST_EXIT_CODE=$?
  if [ $LAST_EXIT_CODE -eq 0 ]; then
    break
  fi
done
 
if [ $LAST_EXIT_CODE -ne 0 ]; then
  echo Синхронизация не удалась for $I раз.
else
  echo Синхронизация равершена после $I попытки.
fi

#Удаление старых архивов

folders='nginx'

for folder in $folders; do
if [ -d $basepath/$monthago ]; then
        rm -r $basepath/$monthago
                echo Архив $basepath/$monthago удален.
                fi
done
