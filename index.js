const fs = require('fs');
const APP = './cve';

const KEY = '/CA/localhost/localhost.decrypted.key';
const CERT = '/CA/localhost/localhost.crt';
const KEYPATH = APP.concat(KEY);
const CERTPATH = APP.concat(KEY);

const key = fs.readFileSync(KEYPATH);
const cert = fs.readFileSync(CERTPATH);

const express = require('express');
const app = express();

app.get('/', (req, res, next) => {
  res.status(200).send('Hello world!');
});

const https = require('https');
const server = https.createServer({ key, cert }, app);

const port = 3000;
server.listen(port, () => {
  console.log(`Server is listening on https://localhost:${port}`);
});
