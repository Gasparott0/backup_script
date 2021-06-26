#!/bin/bash

function error ()
{
        rm -rf temp_backup
        echo "Fim da execução... [ERRO]"
        exit 1
}

mkdir temp_backup
mkdir -p logs

date=$(date +%d-%m-%Y)
log_backup_file=logs/backup-${date}.log

if [ -s diretorios_backup ]
then
        echo "Detecção dos diretórios -> OK" > ${log_backup_file}

        while read line
        do
                file_name=$(echo ${line} | cut -d / -f 3)-${date}.tar.bz2
                tar -jcf temp_backup/${file_name} ${line} 2> /dev/null
                if [ $? -eq 0 ]
                then
                        echo "Compactação individual ${file_name} -> OK" >> ${log_backup_file}
                else
                        echo "Compactação individual ${file_name} -> ERRO" >> ${log_backup_file}
                fi
        done < diretorios_backup

        tar -jcf temp_backup/Backup-${date}.tar.bz2 temp_backup 2> /dev/null
        if [ $? -eq 0 ]
        then
                echo "Compactação geral backup -> OK" >> ${log_backup_file}
                mv temp_backup/Backup-${date}.tar.bz2 /backups
        else
                echo "Compactação geral backup -> ERRO" >> ${log_backup_file}
                error
        fi

        rm -rf temp_backup
else
        echo "Detecção dos diretórios -> ERRO" > ${log_backup_file}
        error
fi

echo "Fim da execução... [SUCESSO]"
exit 0