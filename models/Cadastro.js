const mongoose = require('mongoose');

const EnderecoSchema = new mongoose.Schema({
  rua: String,
  numero: String,
  bairro: String,
  cidade: String,
  estado: String,
  cep: String,
}, { _id: false });

const cadastroSchema = new mongoose.Schema({
  nome: { type: String, required: true },
  email: { type: String, required: true },
  senha: { type: String, required: true },
  telefone: String,
  cpf: String,
  dataCadastro: { type: Date, default: Date.now },
  endereco: EnderecoSchema
});

module.exports = mongoose.model(Cadastro, UsuarioSchema);