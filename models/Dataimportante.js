import mongoose from 'mongoose';

// Certifique-se de importar o modelo de Usuario corretamente
import Usuario from './Usuario.js';

const DataImportanteSchema = new mongoose.Schema({
  usuario_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Usuario', required: true },
  titulo: { type: String, required: true },
  descricao: String,
  data_evento: { type: Date, required: true },
  lembrete_ativo: { type: Boolean, required: true },
  criado_em: { type: Date, required: true }
});

// Correção: nome do modelo como string e schema correto
const DataImportante = mongoose.model('DataImportante', DataImportanteSchema);

export default DataImportante;