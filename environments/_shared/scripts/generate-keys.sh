#!/bin/bash

source "/home/asw/_shared/scripts/common.sh"

# Cancello (se esiste) e (ri)creo la cartella in cui salvare i certificati
rm -rf ${CERTS_PATH} && mkdir -p ${CERTS_PATH}

# Prefisso nome chiavi
for i in `seq 1 3`; do
SWARM_NAME=swarm-$i
KEY_PREFIX_PATH=${CERTS_PATH}/${SWARM_NAME}-

# Creo un file di configurazione openssl per il certificato
cat > ${KEY_PREFIX_PATH}extfile.cnf <<EOM
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
countryName = IT
countryName_default = IT
stateOrProvinceName = Lazio
stateOrProvinceName_default = Lazio
localityName = Rome
localityName_default = RM
organizationalUnitName = RM3
organizationalUnitName_default = RM3
commonName = my-swarm
commonName_max = 64
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = DNS:my-swarm,DNS:swarm-1,DNS:swarm-2,DNS:swarm-3,DNS:dev,DNS:localhost,IP:10.11.1.71,IP:10.11.1.72,IP:10.11.1.73,IP:10.11.1.70,IP:127.0.0.1
EOM

# Creo prima il certificato e le chiavi per il server:
# Genero chiave privata base ca-key.pem
openssl genrsa -out ${KEY_PREFIX_PATH}ca-key.pem 4096
# Genero il certificato ca.pem
openssl req -new -x509 -days 3650 -key ${KEY_PREFIX_PATH}ca-key.pem -out ${KEY_PREFIX_PATH}ca.pem -subj "/CN=${SWARM_NAME}" -config ${KEY_PREFIX_PATH}extfile.cnf
# Genero chiave server
openssl genrsa -out ${KEY_PREFIX_PATH}server-key.pem 4096
# Genero ora il file CSR (Certificate Signing Request)
openssl req -sha256 -new -key ${KEY_PREFIX_PATH}server-key.pem -out ${KEY_PREFIX_PATH}server.csr -subj "/CN=${SWARM_NAME}" -config ${KEY_PREFIX_PATH}extfile.cnf

# Creo un file di configurazione openssl per il server
cat > ${KEY_PREFIX_PATH}extfile.cnf <<EOM
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = DNS:my-swarm,DNS:swarm-1,DNS:swarm-2,DNS:swarm-3,DNS:dev,DNS:localhost,IP:10.11.1.71,IP:10.11.1.72,IP:10.11.1.73,IP:10.11.1.70,IP:127.0.0.1
EOM

# Genero la chiave
openssl x509 -req -days 3650 -in ${KEY_PREFIX_PATH}server.csr -CA ${KEY_PREFIX_PATH}ca.pem -CAkey ${KEY_PREFIX_PATH}ca-key.pem -CAcreateserial -out ${KEY_PREFIX_PATH}server-cert.pem -extfile ${KEY_PREFIX_PATH}extfile.cnf

# Chiavi server create.
# Per l'autenticazione lato client,creo una coppia di chiavi cliente
openssl genrsa -out ${KEY_PREFIX_PATH}key.pem 4096
openssl req -subj '/CN=client' -new -key ${KEY_PREFIX_PATH}key.pem -out ${KEY_PREFIX_PATH}client.csr
openssl x509 -req -days 3650 -in ${KEY_PREFIX_PATH}client.csr -CA ${KEY_PREFIX_PATH}ca.pem -CAkey ${KEY_PREFIX_PATH}ca-key.pem -CAcreateserial -out ${KEY_PREFIX_PATH}cert.pem -extfile ${KEY_PREFIX_PATH}extfile.cnf

rm -v ${KEY_PREFIX_PATH}client.csr ${KEY_PREFIX_PATH}server.csr ${KEY_PREFIX_PATH}ca.srl ${KEY_PREFIX_PATH}extfile.cnf
done


# Creazione dei certificati e chiavi per il registry

SWARM_NAME=my-registry
KEY_PREFIX_PATH=${CERTS_PATH}/${SWARM_NAME}-

cat > ${KEY_PREFIX_PATH}extfile.cnf <<EOM
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
countryName = IT
countryName_default = IT
stateOrProvinceName = Lazio
stateOrProvinceName_default = Lazio
localityName = Rome
localityName_default = RM
organizationalUnitName = RM3
organizationalUnitName_default = RM3
commonName = my-registry
commonName_max = 64
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = DNS:my-swarm,DNS:swarm-1,DNS:swarm-2,DNS:swarm-3,DNS:my-registry,DNS:localhost,IP:10.11.1.71,IP:10.11.1.72,IP:10.11.1.73,IP:10.11.1.70,IP:127.0.0.1
EOM

openssl genrsa -out ${KEY_PREFIX_PATH}ca-key.pem 4096
openssl req -new -x509 -days 3650 -key ${KEY_PREFIX_PATH}ca-key.pem -out ${KEY_PREFIX_PATH}ca.pem -subj "/CN=${SWARM_NAME}" -config ${KEY_PREFIX_PATH}extfile.cnf
openssl genrsa -out ${KEY_PREFIX_PATH}server-key.pem 4096
openssl req -sha256 -new -key ${KEY_PREFIX_PATH}server-key.pem -out ${KEY_PREFIX_PATH}server.csr -subj "/CN=${SWARM_NAME}" -config ${KEY_PREFIX_PATH}extfile.cnf

cat > ${KEY_PREFIX_PATH}extfile.cnf <<EOM
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = DNS:my-swarm,DNS:swarm-1,DNS:swarm-2,DNS:swarm-3,DNS:dev,DNS:localhost,IP:10.11.1.71,IP:10.11.1.72,IP:10.11.1.73,IP:10.11.1.70,IP:127.0.0.1
EOM

openssl x509 -req -days 3650 -in ${KEY_PREFIX_PATH}server.csr -CA ${KEY_PREFIX_PATH}ca.pem -CAkey ${KEY_PREFIX_PATH}ca-key.pem -CAcreateserial -out ${KEY_PREFIX_PATH}server-cert.pem -extfile ${KEY_PREFIX_PATH}extfile.cnf

openssl genrsa -out ${KEY_PREFIX_PATH}key.pem 4096
openssl req -subj '/CN=client' -new -key ${KEY_PREFIX_PATH}key.pem -out ${KEY_PREFIX_PATH}client.csr
openssl x509 -req -days 3650 -in ${KEY_PREFIX_PATH}client.csr -CA ${KEY_PREFIX_PATH}ca.pem -CAkey ${KEY_PREFIX_PATH}ca-key.pem -CAcreateserial -out ${KEY_PREFIX_PATH}cert.pem -extfile ${KEY_PREFIX_PATH}extfile.cnf
rm -v ${KEY_PREFIX_PATH}client.csr ${KEY_PREFIX_PATH}server.csr ${KEY_PREFIX_PATH}ca.srl ${KEY_PREFIX_PATH}extfile.cnf