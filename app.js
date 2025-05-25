const express = require('express');
const app = express();
const path = require('path');
const http = require('http');

const port = 3000;

app.get('/', (req, res) => {
  res.send("penis");
});

app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});