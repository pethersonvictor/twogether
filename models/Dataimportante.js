const mongoose = require('mongoose');

const DataImportanteSchema = new mongoose.Schema({
  usuario_id: { type: mongoose.Schema.Types.ObjectId, ref: Usuario, required: true },
  titulo: { type: String, required: true },
  descricao: String,
  data_evento: { type: Date, required: true },
  lembrete_ativo: { type: Boolean, required: true },
  criado_em: { type: Date, required: true }
});

module.exports = mongoose.model(DataImportante, DataImportanteSchema);