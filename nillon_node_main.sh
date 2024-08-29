#!/bin/bash
tput reset
tput civis

# Put your logo here if nessesary

echo -e "\e[33m"
echo -e '----------_____--------------------_____----------------_____----------'
echo -e '---------/\----\------------------/\----\--------------/\----\---------'
echo -e '--------/::\____\----------------/::\----\------------/::\----\--------'
echo -e '-------/:::/----/---------------/::::\----\-----------\:::\----\-------'
echo -e '------/:::/----/---------------/::::::\----\-----------\:::\----\------'
echo -e '-----/:::/----/---------------/:::/\:::\----\-----------\:::\----\-----'
echo -e '----/:::/____/---------------/:::/__\:::\----\-----------\:::\----\----'
echo -e '----|::|----|---------------/::::\---\:::\----\----------/::::\----\---'
echo -e '----|::|----|-----_____----/::::::\---\:::\----\--------/::::::\----\--'
echo -e '----|::|----|----/\----\--/:::/\:::\---\:::\----\------/:::/\:::\----\-'
echo -e '----|::|----|---/::\____\/:::/--\:::\---\:::\____\----/:::/--\:::\____\'
echo -e '----|::|----|--/:::/----/\::/----\:::\--/:::/----/---/:::/----\::/----/'
echo -e '----|::|----|-/:::/----/--\/____/-\:::\/:::/----/---/:::/----/-\/____/-'
echo -e '----|::|____|/:::/----/------------\::::::/----/---/:::/----/----------'
echo -e '----|:::::::::::/----/--------------\::::/----/---/:::/----/-----------'
echo -e '----\::::::::::/____/---------------/:::/----/----\::/----/------------'
echo -e '-----~~~~~~~~~~--------------------/:::/----/------\/____/-------------'
echo -e '----------------------------------/:::/----/---------------------------'
echo -e '---------------------------------/:::/----/----------------------------'
echo -e '---------------------------------\::/----/-----------------------------'
echo -e '----------------------------------\/____/------------------------------'
echo -e '-----------------------------------------------------------------------'
echo -e '\e[0m'

echo -e "\n \e[33mПодпишись на мой канал\e[0m Beloglazov invest, \n чтобы быть в курсе самых актуальных нод и активностей \n \e[33mhttps://t.me/beloglazovinvest \e[0m \n"

sleep 2

while true; do
    echo "1. Подготовка к установке Nillon (Preparation)"
    echo "2. Установка Nillon (Install)"
    echo "3. Получить данные Accuser (Get Accuser data)"
    echo "4. Выход (Exit)"
    echo ""
    read -p "Выберите опцию (Select option): " option

    case $option in
        1)
            echo -e "\e[33mНачинаем подготовку (Starting preparation)...\e[0m"
            sleep 1
            # Update packages
            echo -e "\e[33mОбновляем пакеты (Updating packages)...\e[0m"
            if sudo apt update && sudo apt upgrade -y; then
                sleep 1
                echo -e "Обновление пакетов (Updating packages): \e[32mУспешно (Success)\e[0m"
                echo ""
            else
                echo -e "Обновление пакетов (Updating packages): \e[31mОшибка (Error)\e[0m"
                echo ""
                exit 1
            fi

            # Check Docker version
            echo -e "\e[33mПроверяем версию Docker (Checking Docker version)...\e[0m"
            if command -v docker &> /dev/null; then
                DOCKER_VERSION=$(docker --version | grep -oP '\d+\.\d+\.\d+')
                REQUIRED_VERSION="27.2.0"

                if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$DOCKER_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
                    echo -e "Проверка версии Docker (Docker version check): \e[32mУспешно (Success)\e[0m"
                    echo -e "(\e[32mDocker version $DOCKER_VERSION is OK\e[0m)"
                    echo ""
                else
                    echo -e "Проверка версии Docker (Docker version check): \e[33mТребуется обновить (Update Require)\e[0m"
                    echo ""
                    sleep 1

                    # Install or update Docker
                    echo -e "\e[33mОбновляем Docker (Updating Docker)...\e[0m"
                    sleep 1
                    if sudo apt install apt-transport-https ca-certificates curl software-properties-common -y &&
                    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
                    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" &&
                    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y; then
                        sleep 1
                        echo -e "Установка/Обновление Docker (Docker installation/update): \e[32mУспешно (Success)\e[0m"
                        echo ""
                    else
                        echo -e "Установка/Обновление Docker (Docker installation/update): \e[31mОшибка (Error)\e[0m"
                        echo ""
                        exit 1
                    fi
                fi
            else
                # Docker installation
                echo -e "\e[31mDocker не установлен (Docker not installed)\e[0m"
                echo -e "\e[33mУстанавливаем Docker (Installing Docker)...\e[0m"
                sleep 1
                if sudo apt install apt-transport-https ca-certificates curl software-properties-common -y &&
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" &&
                sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y; then
                    sleep 1
                    echo -e "Установка Docker (Docker installation): \e[32mУспешно (Success)\e[0m"
                    echo ""
                else
                    echo -e "Установка Docker (Docker installation): \e[31mОшибка (Error)\e[0m"
                    echo ""
                    exit 1
                fi
            fi
            echo -e "\e[33m--- ПОДГОТОВКА ЗАВЕРШЕНА. PREPARATION COMPLETED ---\e[0m"
            echo ""
            ;;
        2)
            echo -e "\e[33mУстанавливаем Nillon (Install Nillon)...\e[0m"

            # Install Accuser Image
            echo -e "\e[33mСкачиваем Accuser Image (Pulling Accuser Image)...\e[0m"
            if docker pull nillion/retailtoken-accuser:v1.0.0; then
                sleep 1
                echo -e "Скачивание Accuser Image (Pulling Accuser Image): \e[32mУспешно (Success)\e[0m"
                echo ""
            else
                echo -e "Скачивание Accuser Image (Pulling Accuser Image): \e[31mОшибка (Error)\e[0m"
                echo ""
                exit 1
            fi

            # Create Accuser directory
            echo -e "\e[33mСоздаем директорию для Accuser (Creating directory for Accuser)...\e[0m"
            if mkdir -p nillion/accuser; then
                sleep 1
                echo -e "Создание директории (Directory creation): \e[32mУспешно (Success)\e[0m"
                echo ""
            else
                echo -e "Создание директории (Directory creation): \e[31mОшибка (Error)\e[0m"
                echo ""
                exit 1
            fi

            # Starting the container for Accuser initialization and registration.
            echo -e "\e[33mЗапускаем контейнер для Accuser (Starting Accuser container)...\e[0m"
            if docker run --name accuser -v "$(pwd)/nillion/accuser:/var/tmp" nillion/retailtoken-accuser:v1.0.0 initialise; then
                sleep 1
                echo -e "Запуск контейнера Accuser (Starting Accuser container): \e[32mУспешно (Success)\e[0m"
                echo ""
            else
                echo -e "Запуск контейнера Accuser (Starting Accuser container): \e[31mОшибка (Error)\e[0m"
                echo ""
                exit 1
            fi
            ;;
        3)
            #check Accuser Verifier data
            echo -e "\e[33mПолучаем данные Accuser (Getting Accuser data)...\e[0m"
            sleep 1
            if sudo cat /root/nillion/accuser/credentials.json; then
                sleep 1
                echo -e "Данные Accuser (Accuser data): \e[32mУспешно (Success)\e[0m"
                echo ""
            else
                echo -e "Данные Accuser (Accuser data): \e[31mОшибка (Error)\e[0m"
                echo ""
                exit 1
            fi
            echo -e "\e[33mПри первой регистрации перейдите на сайт \nhttps://verifier.nillion.com/verifier \nи введите данные в 5 пункте\e[0m"
            echo ""
            echo -e "\e[33mFor the first registration, go to the website \nhttps://verifier.nillion.com/verifier \nand enter the data in point 5.\e[0m"
            echo ""
            ;;
        4)
            # Stop script and exit
            echo -e "\e[31mСкрипт остановлен (Script stopped)\e[0m"
            echo ""
            exit 0
            ;;
        *)
            # incorrect options handling
            echo ""
            echo -e "\e[31mНеверная опция\e[0m. Пожалуйста, выберите из тех, что есть."
            echo ""
            echo -e "\e[31mInvalid option.\e[0m Please choose from the available options."
            echo ""
            ;;
    esac
done
