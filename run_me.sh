$!echo "CERT creation shell script"
APP=cve
if [ $1 = "clean" ]; then
echo $pwd
rm -rf cert; 
echo "clean";
exit
fi

if [ $1 = "install" ]; then
if [ "$EUID" -ne 0 ]; then
echo "run as root"
exit
fi
mkdir /usr/local/share/ca-certificates/$APP
cp localhost.crt /usr/local/share/ca-certificates/$APP
chmod 755 /usr/local/share/ca-certificates/$APP
chmod 644 /usr/local/share/ca-certificates/$APP/localhost.crt
update-ca-certificates 
exit
fi
mkdir cert
 cd cert
 mkdir CA
 cd CA
 openssl genrsa -out CA.key -des3 2048
openssl req -x509 -sha256 -new -nodes -days 3650 -key CA.key -out CA.pem
 mkdir localhost
 cd localhost
 touch localhost.ext

 echo "authorityKeyIdentifier = keyid,issuer 
basicConstraints = CA:FALSE 
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment 
subjectAltName = @alt_names 
 
[alt_names] 
DNS.1 = localhost 
IP.1 = 127.0.0.1
" > localhost.ext
openssl genrsa -out localhost.key -des3 2048
openssl req -new -key localhost.key -out localhost.csr
openssl x509 -req -in localhost.csr -CA ../CA.pem -CAkey ../CA.key -CAcreateserial -days 3650 -sha256 -extfile localhost.ext -out localhost.crt
openssl rsa -in localhost.key -out localhost.decrypted.key
