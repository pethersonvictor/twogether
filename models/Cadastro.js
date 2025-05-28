// models/Cadastro.js

import mongoose from 'mongoose';

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

// Corrigido: nome do modelo como string + schema correto
const Cadastro = mongoose.model('Cadastro', cadastroSchema);

// Exporta como default para funcionar com "import Cadastro from ..."
export default Cadastro;