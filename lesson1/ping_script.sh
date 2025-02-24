#!/bin/bash

read -p "Введите адрес для пингования: " address

count=0

while true
do
  ping_result=$(ping -c 1 $address | grep 'time=')

  if [[ -z $ping_result ]]; then
    ((count++))
    echo "Не удалось выполнить пинг $count раз подряд"
  else
    ping_time=$(echo $ping_result | awk -F'time=' '{print $2}' | awk '{print $1}')
    count=0

    if (( $(echo "$ping_time > 100" | bc -l) )); then
      echo "Время пинга превышает 100 мс: $ping_time мс"
    fi
  fi
  if [ $count -ge 3 ]; then
    echo "Пинг не удалось выполнить 3 раза подряд. Завершаем скрипт."
    exit 1
  fi
  sleep 1
done
