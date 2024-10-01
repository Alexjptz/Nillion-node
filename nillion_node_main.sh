#!/bin/bash
tput reset
tput civis

show_orange() {
    echo -e "\e[33m$1\e[0m"
}

show_blue() {
    echo -e "\e[34m$1\e[0m"
}

show_green() {
    echo -e "\e[32m$1\e[0m"
}

show_red() {
    echo -e "\e[31m$1\e[0m"
}

stop_node() {
    show_orange "Останавливаем контейнер (Stopping container)..."
    if docker stop nillion; then
        sleep 1
        show_green "Успешно (Success)"
        echo ""
    else
        sleep 1
        show_blue "Нода не запущена (Node is not running)"
        echo ""
    fi

    show_orange "Удаляем контейнер (Deleting container)..."
    if docker rm nillion; then
        sleep 1
        show_green "Успешно (Success)"
        echo ""
    else
        sleep 1
        show_blue "Контейнер Nillion не найден (Didn't find Nillion)"
        echo ""
    fi
}

show_orange " .__   __.  __   __       __       __    ______   .__   __. " && sleep 0.2
show_orange " |  \ |  | |  | |  |     |  |     |  |  /  __  \  |  \ |  | " && sleep 0.2
show_orange " |   \|  | |  | |  |     |  |     |  | |  |  |  | |   \|  | " && sleep 0.2
show_orange " |  .    | |  | |  |     |  |     |  | |  |  |  | |  .    | " && sleep 0.2
show_orange " |  |\   | |  | |   ----.|   ----.|  | |   --'  | |  |\   | " && sleep 0.2
show_orange " |__| \__| |__| |_______||_______||__|  \______/  |__| \__| " && sleep 0.2
echo ""
sleep 1

while true; do
    echo "1. Подготовка к установке Nillion (Preparation)"
    echo "2. Установка Nillion (Install)"
    echo "3. Получить данные Verifier (Get Verifier data)"
    echo "4. Запустить или перезапустить ноду (Start or restart node)"
    echo "5. Удаление ноды (Delete node)"
    echo "6. Проверить логи (Check logs)"
    echo "7. Восстановить ноду (Node restore)"
    echo "8. Остановить ноду (Stop Node)"
    echo "9. Выход (Exit)"
    echo ""
    read -p "Выберите опцию (Select option): " option

    case $option in
        1)
            show_orange "Начинаем подготовку (Starting preparation)..."
            sleep 1
            # Update packages
            show_orange "Обновляем пакеты (Updating packages)..."
            if sudo apt update && sudo apt upgrade -y && apt install jq; then
                sleep 1
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                show_red "Ошибка (Fail)"
                echo ""
            fi

            # Check Docker version
            show_orange "Проверяем версию Docker (Checking Docker version)..."
            if command -v docker &> /dev/null; then
                DOCKER_VERSION=$(docker --version | grep -oP '\d+\.\d+\.\d+')
                REQUIRED_VERSION="27.2.0"

                if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$DOCKER_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
                    show_green "Docker version $DOCKER_VERSION is OK"
                    echo ""
                else
                    show_orange "Требуется обновить (Update Require)"
                    echo ""
                    sleep 1

                    # Install or update Docker
                    show_orange "Обновляем Docker (Updating Docker)..."
                    sleep 1
                    if sudo apt install apt-transport-https ca-certificates curl software-properties-common -y &&
                    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
                    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" &&
                    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y; then
                        sleep 1
                        show_green "Успешно (Success)"
                        echo ""
                    else
                        sleep 1
                        show_red "Ошибка (Fail)"
                        echo ""
                    fi
                fi
            else
                # Docker installation
                show_red "Docker не установлен (Docker not installed)"
                show_orange "Устанавливаем Docker (Installing Docker)..."
                sleep 1
                if sudo apt install apt-transport-https ca-certificates curl software-properties-common -y &&
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" &&
                sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y; then
                    sleep 1
                    show_green "Успешно (Success)"
                    echo ""
                else
                    sleep 1
                    show_red "Ошибка (Fail)"
                    echo ""
                fi
            fi
            echo -e "\e[33m--- ПОДГОТОВКА ЗАВЕРШЕНА. PREPARATION COMPLETED ---\e[0m"
            echo ""
            ;;
        2)
            show_orange "Устанавливаем Nillion (Install Nillion)..."

            # Install Verifier Image
            show_orange "Скачиваем Verifier Image (Pulling Verifier Image)..."
            if docker pull nillion/verifier:v1.0.1; then
                sleep 1
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                show_red "Ошибка (Fail)"
                echo ""
            fi

            # Create Verifier directory
            show_orange "Создаем директорию для Verifier (Creating directory for Verifier)..."
            if mkdir -p $HOME/nillion/verifier; then
                sleep 1
                show_green "Успешно (Success)"
                echo ""
            else
                show_green "Найдена (Found)"
                echo ""
            fi

            # Starting the container for Verifier initialization and registration.
            show_orange "Запускаем контейнер для Verifier (Starting Verifier container)..."
            if docker run --name verifier -v $HOME/nillion/verifier:/var/tmp nillion/verifier:v1.0.1 initialise; then
                sleep 1
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                show_red "Ошибка (Fail)"
                echo ""
            fi
            ;;
        3)
            #check Verifier Verifier data
            show_orange "Получаем данные Verifier (Getting Verifier data)..."
            sleep 1
            if sudo cat $HOME/nillion/verifier/credentials.json; then
                sleep 1
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                show_red "Ошибка (Fail)"
                echo ""
            fi
            echo -e "\e[33mПри первой регистрации перейдите на сайт \nhttps://verifier.nillion.com/verifier \nи введите данные в 5 пункте\e[0m"
            echo ""
            echo -e "\e[33mFor the first registration, go to the website \nhttps://verifier.nillion.com/verifier \nand enter the data in point 5.\e[0m"
            echo ""
            ;;
        4)
            # start or restart node
            stop_node

            #RPC choice
            echo -e "\e[33mCПИСОК RPC (RPC LIST)\e[0m"
            echo ""
            echo "1. Lavander Five (standart)"
            echo "2. PolkaChu"
            echo "3. Kjnodes"
            echo "4. Nodex"
            echo "5. Custom RPC"
            echo ""
            read -p "Выберете RPC (Choose RPC): " RPC

            case $RPC in
                1)
                    # Standart RPC (Lavander Five)
                    RPC_URL="https://testnet-nillion-rpc.lavenderfive.com"
                    ;;
                2)
                    #Polkachu RPC
                    RPC_URL="https://nillion-testnet-rpc.polkachu.com"
                    ;;
                3)
                    # Kjnodes RPC
                    RPC_URL="https://nillion-testnet.rpc.kjnodes.com"
                    ;;
                4)
                    # Nodex RPC
                    RPC_URL="https://nillion-testnet.rpc.nodex.one"
                    ;;
                5)
                    # Custom RPC
                    read -p "Введите Custom RPC URL (Enter Custom RPC URL): " RPC_URL
                    ;;
                *)
                    # Wrong option
                    echo ""
                    echo -e "\e[31mНеверная опция\e[0m. Пожалуйста, выберите из тех, что есть."
                    echo ""
                    echo -e "\e[31mInvalid option.\e[0m Please choose from the available options."
                    echo ""
                    ;;
            esac
            echo -e "\e[34mRPC =\e[0m $RPC_URL"
            echo ""

            #Starting Node
            show_orange "Запускаем ноду (Starting node)..."
            sleep 2
            sudo docker run --name nillion -d -v ./nillion/verifier:/var/tmp nillion/verifier:v1.0.1 verify --rpc-endpoint $RPC_URL
            echo ""
            show_green "----- НОДА ЗАПУЩЕНА. NODE STARTED -----"
            echo ""
            ;;
        5)
            #Deleting Node
            stop_node

            if docker rm verifier; then
                sleep 1
                show_green "Контейнер Verifier удален (Verifier container deleted)"
                echo ""
            else
                sleep 1
                show_blue "Контейнер Verifier не найден (Didn't find Verifier)"
                echo ""
            fi

            if rm -rvf $HOME/nillion; then
                sleep 1
                show_green "Директория nillion удалена (Node directory Deleted)"
                echo ""
            else
                sleep 1
                show_blue "Директория nillion не найдена (Didn't find Nillion directory)"
                echo ""
            fi
            show_green "----- НОДА УДАЛЕНА. NODE DELETED -----"
            echo ""
            ;;
        6)
            #check logs
            show_orange "Проверяем логи (Cheking logs)..."
            echo ""
            sleep 1
            sudo docker logs --tail=100 nillion
            echo ""
            ;;
        7)
            #Restore the node
            # Create Verifier directory
            show_orange "Создаем директорию для Verifier (Creating directory for Verifier)..."
            if mkdir -p nillion/verifier; then
                sleep 1
                show_green "Успешно (Success)"
                echo ""
            else
                show_blue "Найдена (Found)"
                echo ""
            fi

            FILE_PATH="nillion/verifier/credentials.json"

            # Check if file exist
            if [ -f "$FILE_PATH" ]; then
                show_green "Сredentials.json найден (Found)."
            else
                sleep 1
                touch ./nillion/verifier/credentials.json
                cd $HOME
                show_green "Сredentials.json создан (Created)."
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

            show_green "сredentials.json обновлен (updated)"
            echo ""
            ;;
        8)
            # stop node
            stop_node
            ;;
        9)
            # Stop script and exit
            show_red "Скрипт остановлен (Script stopped)"
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
