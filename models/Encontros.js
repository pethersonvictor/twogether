const mongoose = require('mongoose');

const EncontroSchema = new mongoose.Schema({
  usuario_id: { type: mongoose.Schema.Types.ObjectId, ref: Usuario, required: true },
  titulo: { type: String, required: true },
  descricao: String,
  data_encontro: { type: Date, required: true },
  local: String,
  lembrete_ativo: { type: Boolean, required: true },
  criado_em: { type: Date, required: true }
});

module.exports = mongoose.model(Encontro, EncontroSchema);