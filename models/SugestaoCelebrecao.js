import mongoose from 'mongoose';
import DataImportante from './Dataimportante.js'; // Importa o model DataImportante

const SugestaoCelebracaoSchema = new mongoose.Schema({
  data_importante_id: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'DataImportante',  // ref deve ser string com nome do model
    required: true 
  },
  tipo_evento: { type: String, required: true },
  titulo: { type: String, required: true },
  descricao: { type: String, required: true },
  criado_em: { type: Date, required: true }
});

export default mongoose.model('SugestaoCelebracao', SugestaoCelebracaoSchema);