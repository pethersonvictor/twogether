import mongoose from 'mongoose';

const AuthUserSchema = new mongoose.Schema({
  username: { type: String, required: true },
  email: { 
    type: String, 
    required: true, 
    match: /^.+@.+\..+$/ 
  },
  password: { type: String, required: true, minlength: 6 },
  lastLogin: { type: Date, default: null },
  createdAt: { type: Date, required: true },
  isActive: { type: Boolean, default: true }
});

// Exportando como default
const AuthUser = mongoose.model('AuthUser', AuthUserSchema);
export default AuthUser;


