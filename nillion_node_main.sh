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
    echo "1. Подготовка к установке Nillion (Preparation)"
    echo "2. Установка Nillion (Install)"
    echo "3. Получить данные Accuser (Get Accuser data)"
    echo "4. Запустить или перезапустить ноду (Start or restart node)"
    echo "5. Удаление ноды (Delete node)"
    echo "6. Проверить логи (Check logs)"
    echo "7. Восстановить ноду (Node restore)"
    echo "8. Выход (Exit)"
    echo ""
    read -p "Выберите опцию (Select option): " option

    case $option in
        1)
            echo -e "\e[33mНачинаем подготовку (Starting preparation)...\e[0m"
            sleep 1
            # Update packages
            echo -e "\e[33mОбновляем пакеты (Updating packages)...\e[0m"
            if sudo apt update && sudo apt upgrade -y && apt install jq; then
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
            echo -e "\e[33mУстанавливаем Nillion (Install Nillion)...\e[0m"

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
                echo -e "Директория (Directory): \e[32mНайдена (Found)\e[0m"
                echo ""
            fi

            # Starting the container for Accuser initialization and registration.
            echo -e "\e[33mЗапускаем контейнер для Accuser (Starting Accuser container)...\e[0m"
            if docker run --name accuser -v "$(pwd)/nillion/accuser:/var/tmp" nillion/retailtoken-accuser:v1.0.1 initialise; then
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
            # Stop container
            echo -e "\e[33mОстанавливаем контейнер (Stopping container)...\e[0m"
            if docker stop nillion; then
                sleep 1
                echo -e "Контейнер остановлен (Container stopped): \e[32mУспешно (Success)\e[0m"
                echo ""
            else
                echo -e "\e[34mКонтейнер не запущен (Container isn't running)\e[0m"
                echo ""
            fi

            # Delete container
            echo -e "\e[33mУдаляем контейнер (Deleting container)...\e[0m"
            if docker rm nillion; then
                sleep 1
                echo -e "Контейнер nillion удален (Container deleted): \e[32mУспешно (Success)\e[0m"
                echo ""
            else
                echo -e "\e[34mКонтейнер nillion не найден (Container doesn't exist)\e[0m"
                echo ""
            fi

            #Starting Node
            echo -e "\e[33mЗапускаем ноду (Starting node)...\e[0m"
            sleep 1
            sudo docker run --name nillion -v ./nillion/accuser:/var/tmp nillion/retailtoken-accuser:v1.0.1 accuse --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com/" --block-start "$(curl -s https://testnet-nillion-rpc.lavenderfive.com/abci_info | jq -r '.result.response.last_block_height')"
            ;;
        5)
            #Deleting Node
            echo -e "\e[33mУдаляем ноду (Deleting node)...\e[0m"
            if docker stop nillion; then
                sleep 1
                echo -e "Нода остановлена (Node stopped): \e[32mУспешно (Success)\e[0m"
                echo ""
            else
                echo ""
                echo -e "\e[34mНода не запущена (Node is not running)\e[0m"
                echo ""
            fi

            if docker rm nillion; then
                sleep 1
                echo -e "Контейнер Nillion удален (Nillion container deleted): \e[32mУспешно (Success)\e[0m"
                echo ""
            else
                echo -e "\e[34mКонтейнер Nillion не найден (Didn't find Nillion)\e[0m"
                echo ""
            fi

            if docker rm accuser; then
                sleep 1
                echo -e "Контейнер Accuser удален (Accuser container deleted): \e[32mУспешно (Success)\e[0m"
                echo ""
            else
                echo -e "\e[34mКонтейнер Accuser не найден (Didn't find Accuser)\e[0m"
                echo ""
            fi

            if rm -rvf ./nillion; then
                sleep 1
                echo -e "Директория nillion удалена (Node directory Deleted): \e[32mУспешно (Success)\e[0m"
                echo ""
            else
                echo -e "Директория nillion удалена (Node directory Deleted): \e[31mОшибка (Error)\e[0m"
                echo ""
            fi
            echo -e "\e[33m----- НОДА УДАЛЕНА. NODE DELETED -----\e[0m"
            echo ""
            ;;
        6)
            #check logs
            echo -e "\e[33mПроверяем логи (Cheking logs)...\e[0m"
            echo ""
            sleep 1
            sudo docker logs --tail=1000 nillion | grep -A 2 Registered | tail -3
            echo ""
            ;;
        7)
            #Restore the node
            # Create Accuser directory
            echo -e "\e[33mСоздаем директорию для Accuser (Creating directory for Accuser)...\e[0m"
            if mkdir -p nillion/accuser; then
                sleep 1
                echo -e "Создание директории (Directory creation): \e[32mУспешно (Success)\e[0m"
                echo ""
            else
                echo -e "Директория (Directory): \e[34mНайдена (Found)\e[0m"
                echo ""
            fi

            FILE_PATH="nillion/accuser/credentials.json"

            # Check if file exist
            if [ -f "$FILE_PATH" ]; then
                echo -e "\e[33mСredentials.json найден (Found).\e[0m"
            else
                sleep 1
                touch ./nillion/accuser/credentials.json
                cd $HOME
                echo -e "\e[33mСredentials.json создан (Created).\e[0m"
            fi

            # Get data from user
            echo -n "Введите приватный ключ (priv_key): "
            read priv_key

            echo -n "Введите публичный ключ (pub_key): "
            read pub_key

            echo -n "Введите адрес (address): "
            read address

            # Rewrite credentials
            echo "{
            \"priv_key\": \"$priv_key\",
            \"pub_key\": \"$pub_key\",
            \"address\": \"$address\"
            }" > $FILE_PATH

            echo -e "сredentials.json обновлен (updated): \e[32mУспешно (Success)\e[0m  ."
            echo ""
            ;;
        8)
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
