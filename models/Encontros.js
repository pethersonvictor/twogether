import mongoose from 'mongoose';
import Usuario from './Usuario.js';  // Importa o model Usuario para referência

const EncontroSchema = new mongoose.Schema({
  usuario_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Usuario', required: true },  // ref deve ser string
  titulo: { type: String, required: true },
  descricao: String,
  data_encontro: { type: Date, required: true },
  local: String,
  lembrete_ativo: { type: Boolean, required: true },
  criado_em: { type: Date, required: true }
});

export default mongoose.model('Encontro', EncontroSchema);