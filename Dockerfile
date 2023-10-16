FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    libxcomposite-dev \
    libcups2-dev \
    libasound2-dev \
    libpango-1.0-0 \
    libatk1.0-0 \
    libgbm-dev \
    libcairo-5c0 \
    libxdamage-dev \
    libatspi2.0-dev \
    libatk-bridge2.0-dev \
    libxkbcommon-dev \
    libxrandr-dev \
    libnss3 \
    p7zip-full \
    expect

ADD https://ponies.cloud/scanner_web/acunetix/Acunetix-v23.9.23-Linux-Pwn3rzs-CyberArsenal.7z .

RUN 7z x Acunetix-v23.9.23-Linux-Pwn3rzs-CyberArsenal.7z -pPwn3rzs

RUN echo "127.0.0.1  erp.acunetix.com\n\
    127.0.0.1  erp.acunetix.com.\n\
    ::1  erp.acunetix.com\n\
    ::1  erp.acunetix.com.\n\
    \n\
    127.0.0.1  telemetry.invicti.com\n\
    127.0.0.1  telemetry.invicti.com.\n\
    ::1  telemetry.invicti.com\n\
    ::1  telemetry.invicti.com." >> /etc/hosts

COPY script.exp .

RUN expect script.exp

CMD systemctl stop acunetix

CMD cp wvsc /home/acunetix/.acunetix/v_231005181/scanner/

CMD chown acunetix:acunetix /home/acunetix/.acunetix/v_231005181/scanner/wvsc
CMD chmod +x /home/acunetix/.acunetix/v_231005181/scanner/wvsc

CMD ls /home/acunetix

CMD rm /home/acunetix/.acunetix/data/license/*

CMD cp license_info.json /home/acunetix/.acunetix/data/license/
CMD cp wa_data.dat /home/acunetix/.acunetix/data/license/

CMD chown acunetix:acunetix /home/acunetix/.acunetix/data/license/license_info.json
CMD chown acunetix:acunetix /home/acunetix/.acunetix/data/license/wa_data.dat
CMD chmod 444 /home/acunetix/.acunetix/data/license/license_info.json
CMD chmod 444 /home/acunetix/.acunetix/data/license/wa_data.dat
CMD chattr +i /home/acunetix/.acunetix/data/license/license_info.json

CMD systemctl start acunetix
