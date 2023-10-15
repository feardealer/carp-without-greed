FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

CMD ["unshare", "--pid", "--fork", "--mount-proc", "/lib/systemd/systemd"]

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
    wget \
    p7zip-full \
    expect

RUN wget https://ponies.cloud/scanner_web/acunetix/Acunetix-v23.9.23-Linux-Pwn3rzs-CyberArsenal.7z

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

COPY wvsc /home/acunetix/.acunetix/v_230906116/scanner/wvsc

RUN chown acunetix:acunetix /home/acunetix/.acunetix/v_230906116/scanner/wvsc
RUN chmod +x /home/acunetix/.acunetix/v_230906116/scanner/wvsc

CMD rm /home/acunetix/.acunetix/data/license/*

COPY license_info.json /home/acunetix/.acunetix/data/license/
COPY wa_data.dat /home/acunetix/.acunetix/data/license/

RUN chown acunetix:acunetix /home/acunetix/.acunetix/data/license/license_info.json
RUN chown acunetix:acunetix /home/acunetix/.acunetix/data/license/wa_data.dat
RUN chmod 444 /home/acunetix/.acunetix/data/license/license_info.json
RUN chmod 444 /home/acunetix/.acunetix/data/license/wa_data.dat
CMD chattr +i /home/acunetix/.acunetix/data/license/license_info.json

CMD systemctl start acunetix
