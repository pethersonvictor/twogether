const mongoose = require('mongoose');

const DesafioSchema = new mongoose.Schema({
  usuario_id: { type: mongoose.Schema.Types.ObjectId, ref: Usuario, required: true },
  titulo: { type: String, required: true },
  descricao: String,
  duracao_dias: { type: Number, required: true, min: 1 },
  criado_em: { type: Date, required: true }
});

module.exports = mongoose.model(Desafio, DesafioSchema);