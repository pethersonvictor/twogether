import mongoose from 'mongoose';

const UsuarioSchema = new mongoose.Schema({
  nome: { type: String, required: true },
  email: { 
    type: String, 
    required: true, 
    match: /^.+@.+\..+$/ 
  },
  senha_hash: { type: String, required: true },
  casal_id: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Casal', 
    required: true 
  },
  criado_em: { type: Date, required: true }
});

export default mongoose.model('Usuario', UsuarioSchema);