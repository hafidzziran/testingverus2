#!/bin/bash

POOL="stratum+tcp://luckpool.net:3956"
WALLET="RMHG9FJS11g1y3FxfbHU82Bu7vChyoN3PL"
WORKER="4jamTes"
CPU_THREADS=3
DURATION=3480
PAUSE=300

if ! command -v screen &> /dev/null; then
    echo "screen tidak ditemukan! Instal dengan: sudo apt install screen"
    exit 1
fi

if [ ! -f "./SRBMiner-MULTI" ]; then
    echo "File 'SRBMiner-MULTI' tidak ditemukan!"
    exit 1
fi

for i in {1..4}; do
    echo "Memulai sesi ke-$i"

    screen -dmS srbminer_$i ./SRBMiner-MULTI \
        --algorithm verushash \
        --pool $POOL \
        --wallet $WALLET.$WORKER \
        --password x \
        --cpu-threads $CPU_THREADS >> srbminer.log 2>&1

    echo "Menambang selama $DURATION detik..."
    sleep $DURATION

    echo "Menghentikan sesi ke-$i"
    pkill SRBMiner-MULTI

    if [ $i -lt 4 ]; then
        echo "Jeda selama $PAUSE detik..."
        sleep $PAUSE
    fi
done

echo "Semua sesi mining selesai."
