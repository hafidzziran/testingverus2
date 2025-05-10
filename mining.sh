#!/bin/bash

# Konfigurasi mining
POOL="stratum+tcp://luckpool.net:3956"
WALLET="RMHG9FJS11g1y3FxfbHU82Bu7vChyoN3PL"
WORKER="4jamTes"
CPU_THREADS=3
DURATION=3480  # Waktu mining per sesi dalam detik (58 menit)
PAUSE=300      # Jeda antar sesi dalam detik (5 menit)

# Pastikan screen terinstal
if ! command -v screen &> /dev/null
then
    echo "screen tidak ditemukan! Instal dengan: sudo apt install screen"
    exit 1
fi

# Cek apakah file SRBMiner-MULTI ada
if [ ! -f "./SRBMiner-MULTI" ]; then
    echo "File 'SRBMiner-MULTI' tidak ditemukan! Pastikan sudah diekstrak di folder saat ini"
    exit 1
fi

# Loop untuk 4 sesi mining
for i in {1..4}
do
    echo "Memulai sesi ke-$i"

    # Jalankan mining di dalam screen, output disimpan ke srbminer.log
    screen -dmS srbminer ./SRBMiner-MULTI \
    --algorithm verushash \
    --pool $POOL \
    --wallet $WALLET.$WORKER \
    --password x \
    --cpu-threads $CPU_THREADS >> srbminer.log 2>&1

    echo "Menambang selama $DURATION detik..."
    sleep $DURATION

    echo "Menghentikan sesi ke-$i"
    pkill SRBMiner-MULTI

    # Jeda sebelum sesi berikutnya
    if [ $i -lt 4 ]; then
        echo "Jeda selama $PAUSE detik sebelum sesi berikutnya..."
        sleep $PAUSE
    fi
done

echo "Semua sesi mining selesai."
