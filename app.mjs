import express from 'express';
import cors from 'cors';
import mongoose from 'mongoose';

import Usuario from './models/Usuario.js';
import Cadastro from './models/Cadastro.js';
import DataImportante from './models/Dataimportante.js';
import Desafio from './models/Desafios.js';
import Encontro from './models/Encontros.js';
import AuthUser from './models/AuthUser.js';
import SugestaoCelebracao from './models/SugestaoCelebrecao.js';
import bcrypt from 'bcrypt'; // <--- HÍFEN REMOVIDO AQUI
import jwt from 'jsonwebtoken';

const app = express();
const port = 3000;

// Middlewares
app.use(cors());
app.use(express.json());

// Conexão com MongoDB
mongoose.connect('mongodb+srv://petherson:88842198Pv@twogether.0penntu.mongodb.net/', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => {
  console.log('Conectado ao MongoDB com sucesso!');
}).catch(err => {
  console.error('Erro ao conectar ao MongoDB:', err);
});


// ROTAS USUÁRIOS
app.get('/usuarios', async (req, res) => {
  try {
    const usuarios = await Usuario.find().populate('casal_id', 'nome');
    res.json(usuarios);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar usuários', detalhes: err.message });
  }
});

app.post('/usuarios', async (req, res) => {
  try {
    const usuario = new Usuario(req.body);
    const salvo = await usuario.save();
    res.status(201).json(salvo);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar usuário', detalhes: err.message });
  }
});


// ROTAS CADASTRO
app.post('/cadastro', async (req, res) => {
  try {
    const novoCadastro = new Cadastro(req.body);
    const salvo = await novoCadastro.save();
    res.status(201).json(salvo);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar cadastro', detalhes: err.message });
  }
});


// ROTAS DATAS IMPORTANTES
app.get('/datas-importantes', async (req, res) => {
  try {
    const datas = await DataImportante.find().populate('usuario_id', 'nome email');
    res.json(datas);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar datas importantes', detalhes: err.message });
  }
});

app.post('/datas-importantes', async (req, res) => {
  try {
    const novaData = new DataImportante(req.body);
    const salva = await novaData.save();
    res.status(201).json(salva);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar data importante', detalhes: err.message });
  }
});


// ROTAS DESAFIOS
app.get('/desafios', async (req, res) => {
  try {
    const desafios = await Desafio.find().populate('usuario_id', 'nome email');
    res.json(desafios);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar desafios', detalhes: err.message });
  }
});

app.post('/desafios', async (req, res) => {
  try {
    const novoDesafio = new Desafio(req.body);
    const salvo = await novoDesafio.save();
    res.status(201).json(salvo);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar desafio', detalhes: err.message });
  }
});


// ROTAS ENCONTROS
app.get('/encontros', async (req, res) => {
  try {
    const encontros = await Encontro.find().populate('usuario_id', 'nome email');
    res.json(encontros);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar encontros', detalhes: err.message });
  }
});

app.get('/cadastro/:id/encontros', async (req, res) => {
  try {
    const encontros = await Encontro.find({ usuario_id: req.params.id });
    res.json(encontros);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar encontros do usuário', detalhes: err.message });
  }
});

app.post('/encontros', async (req, res) => {
  try {
    const novoEncontro = new Encontro(req.body);
    const salvo = await novoEncontro.save();
    res.status(201).json(salvo);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar encontro', detalhes: err.message });
  }
});


// ROTAS AUTENTICAÇÃO

app.post('/auth/register', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    const usuarioExistente = await AuthUser.findOne({ email });
    if (usuarioExistente) {
      return res.status(400).json({ message: 'Email já em uso' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const novoUsuario = new AuthUser({
      username,
      email,
      password: hashedPassword,
      createdAt: new Date(),
    });

    const salvo = await novoUsuario.save();

    const token = jwt.sign(
      { id: salvo._id, email: salvo.email },
      'seuSegredoJWT',
      { expiresIn: '1d' }
    );

    res.status(201).json({
      token,
      user: {
        id: salvo._id,
        username: salvo.username,
        email: salvo.email
      }
    });
  } catch (err) {
    res.status(400).json({ message: 'Erro ao registrar', detalhes: err.message });
  }
});

app.post('/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    const usuario = await AuthUser.findOne({ email });
    if (!usuario) {
      return res.status(401).json({ message: 'Usuário não encontrado' });
    }

    const senhaCorreta = await bcrypt.compare(password, usuario.password);
    if (!senhaCorreta) {
      return res.status(401).json({ message: 'Senha incorreta' });
    }

    const token = jwt.sign(
      { id: usuario._id, email: usuario.email },
      'seuSegredoJWT', 
      { expiresIn: '1d' }
    );

    res.json({
      token,
      user: {
        id: usuario._id,
        username: usuario.username,
        email: usuario.email
      }
    });
  } catch (err) {
    res.status(500).json({ message: 'Erro no login', detalhes: err.message });
  }
});


// ROTAS SUGESTÕES
app.get('/sugestoes', async (req, res) => {
  try {
    const sugestoes = await SugestaoCelebracao.find().populate('data_importante_id', 'titulo data_evento');
    res.json(sugestoes);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar sugestões', detalhes: err.message });
  }
});

app.post('/sugestoes', async (req, res) => {
  try {
    const novaSugestao = new SugestaoCelebracao(req.body);
    const salva = await novaSugestao.save();
    res.status(201).json(salva);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar sugestão', detalhes: err.message });
  }
});

app.get('/datas-importantes/:id/sugestoes', async (req, res) => {
  try {
    const sugestoes = await SugestaoCelebracao.find({ data_importante_id: req.params.id });
    res.json(sugestoes);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar sugestões para esta data', detalhes: err.message });
  }
});


// Inicia o servidor
app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});