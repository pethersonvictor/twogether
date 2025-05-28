import mongoose from 'mongoose';
import Usuario from './Usuario.js';  // Importando o model Usuario para usar na referência

const DesafioSchema = new mongoose.Schema({
  usuario_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Usuario', required: true }, // ref deve ser string com o nome do model
  titulo: { type: String, required: true },
  descricao: String,
  duracao_dias: { type: Number, required: true, min: 1 },
  criado_em: { type: Date, required: true }
});

export default mongoose.model('Desafio', DesafioSchema);