#!/bin/bash

# da https://github.com/paulczar/omgwtfssl 
# https://github.com/paulczar/omgwtfssl/blob/master/generate-certs

# modificato per salvare tutti i certificati nella cartella ${CERTS_PATH} 
# in più aggiunge ai certificati tanti domini ed ip quanti sono gli swarm,
# oltre al dominio my-swarm e my-registry impostati di default.
# prende in ingresso un parametro indicante il numero di nodi dello swarm. 

if [[ -z $SILENT ]]; then
echo "Generazione dei certificati"
fi

export CERTS_PATH=${CERTS_PATH}

export CA_KEY=${CERTS_PATH}/${CA_KEY-"ca-key.pem"}
export CA_CERT=${CERTS_PATH}/${CA_CERT-"ca.pem"}
export CA_SUBJECT=${CA_SUBJECT:-"swarm-ca"}
export CA_EXPIRE=${CA_EXPIRE:-"3650"}

export SSL_CONFIG=${CERTS_PATH}/${SSL_CONFIG:-"openssl.cnf"}
export SSL_KEY=${CERTS_PATH}/${SSL_KEY:-"key.pem"}
export SSL_CSR=${CERTS_PATH}/${SSL_CSR:-"key.csr"}
export SSL_CERT=${CERTS_PATH}/${SSL_CERT:-"cert.pem"}
export SSL_SIZE=${SSL_SIZE:-"4096"}
export SSL_EXPIRE=${SSL_EXPIRE:-"3650"}

# se non esiste, crea la cartella per i certificati 

if [[ -d ${CERTS_PATH} ]]; then
    [[ -z $SILENT ]] && echo "====> Using existing certificate folder ${CERTS_PATH}"
else
    [[ -z $SILENT ]] && echo "====> Creating new certificate folder ${CERTS_PATH}"
    mkdir ${CERTS_PATH}
fi

# ora crea i certificati 

[[ -z $SILENT ]] && echo "--> Certificate Authority"

if [[ -e ${CA_KEY} ]]; then
    [[ -z $SILENT ]] && echo "====> Using existing CA Key ${CA_KEY}"
else
    [[ -z $SILENT ]] && echo "====> Generating new CA key ${CA_KEY}"
    openssl genrsa -out ${CA_KEY} ${SSL_SIZE} > /dev/null
fi

if [[ -e ${CA_CERT} ]]; then
    [[ -z $SILENT ]] && echo "====> Using existing CA Certificate ${CA_CERT}"
else
    [[ -z $SILENT ]] && echo "====> Generating new CA Certificate ${CA_CERT}"
    openssl req -x509 -new -nodes -key ${CA_KEY} -days ${CA_EXPIRE} -out ${CA_CERT} -subj "/CN=${CA_SUBJECT}" > /dev/null  || exit 1
fi

echo "====> Generating new config file ${SSL_CONFIG}"
cat > ${SSL_CONFIG} <<EOM
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
EOM

if [[ -n ${SSL_DNS} || -n ${SSL_IP} ]]; then
    cat >> ${SSL_CONFIG} <<EOM
subjectAltName = @alt_names
[alt_names]
EOM

    IFS=","
    dns=(${SSL_DNS})
    dns+=(${SSL_SUBJECT})
    for i in "${!dns[@]}"; do
      echo DNS.$((i+1)) = ${dns[$i]} >> ${SSL_CONFIG}
    done

    if [[ -n ${SSL_IP} ]]; then
        ip=(${SSL_IP})
        for i in "${!ip[@]}"; do
          echo IP.$((i+1)) = ${ip[$i]} >> ${SSL_CONFIG}
        done
    fi
fi

[[ -z $SILENT ]] && echo "====> Generating new SSL KEY ${SSL_KEY}"
openssl genrsa -out ${SSL_KEY} ${SSL_SIZE} > /dev/null || exit 1

[[ -z $SILENT ]] && echo "====> Generating new SSL CSR ${SSL_CSR}"
openssl req -new -key ${SSL_KEY} -out ${SSL_CSR} -subj "/CN=${SSL_SUBJECT}" -config ${SSL_CONFIG} > /dev/null || exit 1

[[ -z $SILENT ]] && echo "====> Generating new SSL CERT ${SSL_CERT}"
openssl x509 -req -in ${SSL_CSR} -CA ${CA_CERT} -CAkey ${CA_KEY} -CAcreateserial -out ${SSL_CERT} \
    -days ${SSL_EXPIRE} -extensions v3_req -extfile ${SSL_CONFIG} > /dev/null || exit 1