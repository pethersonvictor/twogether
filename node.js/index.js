import express, { json } from 'express';
import { connect, Schema, model } from 'mongoose';

const app = express();
const port = 3000;

// Middleware para ler JSON*
app.use(json());

// Conexão com o MongoDB
connect('mongodb+srv://petherson:88842198Pv@twogether.0penntu.mongodb.net/', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log('Conectado ao MongoDB com sucesso!');
}).catch((err) => {
  console.error('Erro ao conectar ao MongoDB:', err);
});

// Definição do schema/modelo*
const UsuarioSchema = new Schema({
  nome: String,
  email: String
});

const Usuario = model('Usuario', UsuarioSchema);

// ROTA: Inserir novo usuário
app.post('/usuarios', async (req, res) => {
  try {
    const novoUsuario = new Usuario(req.body);
    const salvo = await novoUsuario.save();
    res.status(201).json(salvo);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar usuário', detalhes: err });
  }
});

// ROTA: Listar todos os usuários
app.get('/usuarios', async (req, res) => {
  try {
    const usuarios = await find();
    res.json(usuarios);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar usuários', detalhes: err });
  }
});

// Iniciar servidor
app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
    
 //cadastro

 import { find } from './models/cadastro';
  
 // POST: Criar novo cadastro
app.post('/models/Cadastro.js', async (req, res) => {
  try {
    const novoUsuario = new Usuario(req.body);
    const salvo = await novoUsuario.save();
    res.status(201).json(salvo);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar Cadast', detalhes: err.message });
  }
});

 //datasImportantes

 import DataImportante, { find as _find } from './models/DataImportante';
import Cadastro from '../models/Cadastro';

 //rotas datasImportantes

 app.post('/models/Dataimportante.js', async (req, res) => {
  try {
    const novaData = new DataImportante(req.body);
    const salva = await novaData.save();
    res.status(201).json(salva);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar data importante', detalhes: err.message });
  }
});

app.get('/models/datas-importante', async (req, res) => {
  try {
    const datas = await _find().populate('usuario_id', 'nome email');
    res.json(datas);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar datas importantes', detalhes: err.message });
  }
});

//desafios

    const Desafio = require(  '/models/Desafio');

//rotas desafios

app.post('/models/Desafios.js', async (req, res) => {
  try {
    const novoDesafio = new Desafio(req.body);
    const salvo = await novoDesafio.save();
    res.status(201).json(salvo);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar desafio', detalhes: err.message });
  }
});

app.get('/models/Desafios.js', async (req, res) => {
  try {
    const desafios = await Desafio.find().populate(usuario_id, nome_email);
    res.json(desafios);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar desafios', detalhes: err.message });
  }
});

//encontros

const Encontro = require('/models/Encontros');

//rotas encontros

app.post('/models/Encontros.js', async (req, res) => {
  try {
    const novoEncontro = new Encontro(req.body);
    const salvo = await novoEncontro.save();
    res.status(201).json(salvo);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar encontro', detalhes: err.message });
  }
});

app.get('/models/encontros', async (req, res) => {
  try {
    const encontros = await Encontro.find().populate('usuario_id', 'nome email');
    res.json(encontros);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar encontros', detalhes: err.message });
  }
});

app.get('Cadastro/id/Encontro', async (req, res) => {
  try {
    const encontros = await Encontro.find({ usuario_id: req.params.id });
    res.json(encontros);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar encontros do usuário', detalhes: err.message });
  }
});

//login

const AuthUser = require(/models/AuthUser);

//rotas login

app.post('/auth/register', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    const novoUsuario = new AuthUser({
      username,
      email,
      password,
      createdAt: new Date()
    });

    const salvo = await novoUsuario.save();
    res.status(201).json(salvo);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao registrar usuário', detalhes: err.message });
  }
});

//sugestoes celebracao

const SugestaoCelebracao = require(/models/SugestaoCelebracao);

//rotas sugestoes celebracao

app.post('/sugestoes', async (req, res) => {
  try {
    const novaSugestao = new SugestaoCelebracao(req.body);
    const salva = await novaSugestao.save();
    res.status(201).json(salva);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar sugestão', detalhes: err.message });
  }
});

app.get('/sugestoes', async (req, res) => {
  try {
    const sugestoes = await SugestaoCelebracao.find()
      .populate('data_importante_id', 'titulo data_evento');
    res.json(sugestoes);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar sugestões', detalhes: err.message });
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

//usuarios

const usuario = require(/models/Usuario);

//rotas usuarios

app.post(usuarios, async (req, res) => {
  try {
    const usuario = new Usuario(req.body);
    const salvo = await usuario.save();
    res.status(201).json(salvo);
  } catch (err) {
    res.status(400).json({ erro: 'Erro ao salvar usuário', detalhes: err.message });
  }
});

app.get('usuario's async (req, res) => {
  try {
    const usuarios = await Usuario.find().populate('casal_id', 'nome');
    res.json(usuarios);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar usuários', detalhes: err.message });
  }
});

