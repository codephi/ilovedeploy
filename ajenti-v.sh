#!/usr/bin/env bash

ask() {
    while true; do
        if [ "${2:-}" = "S" ]; then
            prompt="S/n"
            default=S
        elif [ "${2:-}" = "N" ]; then
            prompt="s/N"
            default=N
        else
            prompt="s/n"
            default=
        fi

        read -p "$1 [$prompt] " REPLY </dev/tty

        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        case "$REPLY" in
            S*|s*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}
echo -e "\e[104m         _                  _    _    _    _____              _
   /\   (_)            _   (_)  | |  | |  (____ \            | |
  /  \   _  ____ ____ | |_  _ __| |  | |   _   \ \ ____ ____ | | ___  _   _
 / /\ \ | |/ _  )  _ \|  _)| (___) \/ /   | |   | / _  )  _ \| |/ _ \| | | |
| |__| || ( (/ /| | | | |__| |    \  /    | |__/ ( (/ /| | | | | |_| | |_| |
|______|| |\____)_| |_|\___)_|     \/     |_____/ \____) ||_/|_|\___/ \__  |
      (__/                                             |_|           (____/"


echo -e "\e[39m\e[49mPrograma de auxílio à instalação para servidores."
echo "Esse progra instalará diversar bibliotecas para criação completa de um servidor PHP e NodeJs"
echo "As principais aplicações disponiveis aqui são NodeJs, Php, MongoDb, Mysql, assim como serviços de FPT e Email"
echo -e "\e[31m"


echo "AO EXECUTAR ESSE PROGRAMA VOCÊ ESTÁ DECLARANDO QUE É O ÚNICO E EXCLUSIVO RESPONSÁVEL POR QUALQUER RESULTADO GERADO (ERROS, FALHAS, BUGS, DESTRUIÇÃO, ATAQUE COMUNISTA, APOCALIPSE...)"
echo -e '\e[34m'
read -p "Vamos começar? [Prescione enter para começar]" ENTER

echo ''
echo -e "\e[39mInstalando bibliotecas básicas: curl wget git zip unzip unp:"
echo ''
apt-get update && apt-get upgrade -y && install -y curl wget git zip unzip unp
. /etc/lsb-release


AJENTI_ADDONS="apt-get install ajenti-v ajenti-v-nginx"
AJENTI_COMMAND_INSTALL="wget -O- https://raw.github.com/ajenti/ajenti/1.x/scripts/install-ubuntu.sh | sh"

###########################################################################################
###################### ----------> NODEJS
###########################################################################################
echo ''
if ask "Deseja instalar o Nodejs? (https://nodejs.org/en)" S; then

   AJENTI_ADDONS="$AJENTI_ADDONS ajenti-v-nodejs"
   read -p "Qual versão no Nodejs deseja instalar? [6]" NODE_VERSION_INSTALL

   if [[ $NODE_VERSION_INSTALL == '' ]]; then
      NODE_VERSION_INSTALL=6
   fi

   NODE_COMAND_INSTALL="curl -sL https://deb.nodesource.com/setup_$NODE_VERSION_INSTALL.x | sudo -E bash - && apt-get install -y nodejs"
   echo -e "\e[33m"
   if ask "Isso está correto? \"$NODE_COMAND_INSTALL\" ?" S; then
     echo 'Ok...'
   else
     read -p "Insira o comando de instação do Nodejs:" NODE_COMAND_INSTALL
   fi

fi

###########################################################################################
###################### ----------> MongoDb
###########################################################################################
echo -e "\e[39m"
if ask "Deseja instalar o Mongodb: (http://mongodb.com)" S; then

  read -p "Qual versão no Nodejs deseja instalar? [3.2]" MONGODB_VERSION_INSTALL

  if [[ $MONGODB_VERSION_INSTALL == '' ]]; then
     MONGODB_VERSION_INSTALL='3.2'
  fi

  MONGODB_COMMAND_INSTALL="apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 && echo \"deb http://repo.mongodb.org/apt/ubuntu $DISTRIB_CODENAME/mongodb-org/$MONGODB_VERSION_INSTALL multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-$MONGODB_VERSION_INSTALL.list
   && apt-get update && apt-get install -y mongodb-org"
   echo -e "\e[33m"
   if ask "Isso está correto? \"$MONGODB_COMMAND_INSTALL\" ?" S; then
     echo 'Ok...'
   else
     read -p "Insira o comando de instação do MongoDb:" MONGODB_COMMAND_INSTALL
   fi
fi

echo -e "\e[39m"
if ask "Deseja instalar o mysql? (ajenti-v-mysql)" S; then
  echo 'Ok...'
  AJENTI_ADDONS="$AJENTI_ADDONS ajenti-v-mysql"
fi
echo ''
if ask "Deseja instalar o php? (ajenti-v-php-fpm)" S; then
  echo 'Ok...'
  AJENTI_ADDONS="$AJENTI_ADDONS ajenti-v-php-fpm php5-mysql"
fi
echo ''
if ask "Deseja instalar o pureftpd? (ajenti-v-ftp-pureftpd )" S; then
  echo 'Ok...'
  AJENTI_ADDONS="$AJENTI_ADDONS ajenti-v-ftp-pureftpd"
fi
echo ''
if ask "Deseja instalar o exim e o courier mail? (ajenti-v-mail)" S; then
  echo 'Ok...'
  AJENTI_ADDONS="$AJENTI_ADDONS ajenti-v-mail"
fi


if [[ $NODE_COMAND_INSTALL != '' ]]; then
  echo ''
  echo -e "\e[32m######################################################################\nINSTALANDO NODEJS\n######################################################################"
   eval $NODE_COMAND_INSTALL
fi

if [[ $MONGODB_COMMAND_INSTALL != '' ]]; then
  echo ''
  echo -e "\e[42m\e[39m######################################################################\nINSTALANDO MONGODB\n######################################################################"
   eval $MONGODB_COMMAND_INSTALL
fi

if [[ $AJENTI_COMMAND_INSTALL != '' ]]; then
  echo ''
  echo -e "\e[93m\e[49m######################################################################\nINSTALANDO AJENTI\n######################################################################"
   eval $AJENTI_COMMAND_INSTALL
   eval $AJENTI_ADDONS
fi
