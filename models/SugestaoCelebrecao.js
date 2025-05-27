const mongoose = require('mongoose');

const SugestaoCelebracaoSchema = new mongoose.Schema({
  data_importante_id: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: DataImportante, 
    required: true 
  },
  tipo_evento: { type: String, required: true },
  titulo: { type: String, required: true },
  descricao: { type: String, required: true },
  criado_em: { type: Date, required: true }
});

module.exports = mongoose.model(SugestaoCelebracao, SugestaoCelebracaoSchema);