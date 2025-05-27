#!/bin/bash

# Получаем список устройств
devices=$(bluetoothctl devices | awk '{print $2, substr($0, index($0,$3))}')

# Проверяем, есть ли устройства
if [[ -z "$devices" ]]; then
    notify-send "Bluetooth" "Нет доступных устройств"
    exit 1
fi

# Показываем список в rofi/wofi
selected=$(echo "$devices" | wofi -dmenu -p "Выбери устройство")

# Если выбрано устройство
if [[ -n "$selected" ]]; then
    mac=$(echo "$selected" | awk '{print $1}')
    
    # Проверяем, подключено ли устройство
    if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        bluetoothctl disconnect "$mac"
        notify-send "Bluetooth" "Отключено: $selected"
    else
        bluetoothctl connect "$mac"
        notify-send "Bluetooth" "Подключено: $selected"
    fi
fi
