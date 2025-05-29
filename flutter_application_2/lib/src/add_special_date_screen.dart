import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar a data (dd/MM/yyyy)
import 'package:myapp/src/settings_screen.dart'; // Para navegar para a tela de configurações

class AddSpecialDateScreen extends StatefulWidget {
  const AddSpecialDateScreen({super.key});

  @override
  State<AddSpecialDateScreen> createState() => _AddSpecialDateScreenState();
}

class _AddSpecialDateScreenState extends State<AddSpecialDateScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Chave para o formulário
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController =
      TextEditingController(); // Para exibir a data selecionada
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _momentController = TextEditingController();

  DateTime? _selectedDate; // Armazena a data real selecionada pelo DatePicker

  // Função para abrir o seletor de data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // Data inicial no seletor
      firstDate: DateTime(1900), // Data mínima
      lastDate: DateTime(2101), // Data máxima
      locale: const Locale('pt', 'BR'), // Garante o formato de data pt-BR
      builder: (BuildContext context, Widget? child) {
        // Aplica o tema do seu aplicativo ao DatePicker
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF6B81), // Cor primária (rosa) do seu degradê
              onPrimary: Colors.white, // Cor do texto sobre a cor primária
              onSurface: Colors.black87, // Cor do texto no calendário
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.white,
            ), // Fundo do diálogo
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Armazena a data selecionada
        _dateController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(picked); // Atualiza o campo de texto formatado
      });
    }
  }

  // Função para simular o salvamento da data especial
  void _saveSpecialDate() {
    if (_formKey.currentState!.validate()) {
      // Valida o formulário
      // Captura os dados dos controladores
      final String name = _nameController.text;
      final String date = _dateController.text;
      final String location = _locationController.text;
      final String moment = _momentController.text;

      // Imprime os dados no console para depuração
      debugPrint('Nome: $name');
      debugPrint('Data: $date (DateTime: $_selectedDate)');
      debugPrint('Local: $location');
      debugPrint('Momento: $moment');

      // Aqui você integraria com o seu backend Node.js para salvar os dados
      // Ex: await ApiService().addSpecialDate(name, _selectedDate!, location, moment);

      // Mostra uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data especial salva (UI Test)!')),
      );

      // Volta para a tela anterior (geralmente o Calendário)
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // Libera os controladores de texto da memória quando o widget é descartado
    _nameController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _momentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Fundo branco
      appBar: AppBar(
        // AppBar personalizada, como na imagem
        backgroundColor:
            Colors.transparent, // Transparente para ver o padrão de fundo
        elevation: 0, // Sem sombra
        leading: IconButton(
          // Botão de voltar personalizado
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color.fromARGB(255, 255, 107, 129),
          ), // Cor rosa do degradê
          onPressed: () => Navigator.pop(context), // Volta para a tela anterior
        ),
        actions: [
          // Ícone de configurações
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black), // Cor preta
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/settings',
              ); // Navega para a tela de configurações
            },
          ),
        ],
      ),
      body: Stack(
        // Usa Stack para o padrão de corações no fundo
        children: [
          // Padrão de Corações
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/hearts_pattern.png', // Imagem do padrão de corações
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.white);
                },
              ),
            ),
          ),
          SingleChildScrollView(
            // Permite rolagem do conteúdo
            padding: const EdgeInsets.all(20.0),
            child: Form(
              // Agrupa os campos para validação
              key: _formKey, // Associa a chave
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centraliza alguns elementos
                children: [
                  Image.asset(
                    "assets/logo_cor.png", // LOGO COLORIDA ADICIONADA AQUI (nome do arquivo atualizado)
                    height: 80, // Ajuste a altura conforme necessário
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'gether',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ), // Espaçamento entre a logo e o título
                  const Text(
                    'Salvar data especial',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Icon(
                    Icons.edit_note,
                    size: 80,
                    color: Colors.grey,
                  ), // Ícone de lápis/bloco
                  const SizedBox(height: 30),

                  // Campo 1: Nome da Data
                  _buildTextInput(
                    controller: _nameController,
                    hintText: 'ex: aniversário de namoro, casamento, noivado',
                    labelText: 'Digite um nome para o dia de vocês!',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite um nome para a data.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Campo 2: Data (Date Picker)
                  _buildTextInput(
                    controller: _dateController,
                    hintText: 'dd/mm/aaaa',
                    labelText: 'Quando foi essa data tão especial?',
                    readOnly: true, // Impede digitação direta
                    onTap:
                        () =>
                            _selectDate(context), // Abre o DatePicker ao tocar
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione a data.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Campo 3: Onde (Local)
                  _buildTextInput(
                    controller: _locationController,
                    hintText: 'Ex: Restaurante X, Praia, Cidade Y, Em casa...',
                    labelText: 'Onde essa data especial aconteceu?',
                  ),
                  const SizedBox(height: 20),

                  // Campo 4: Momento Marcante
                  _buildTextInput(
                    controller: _momentController,
                    hintText: '', // Hint vazio conforme a imagem
                    labelText: 'Qual foi o momento mais marcante desse dia?',
                    maxLines: 3, // Permite múltiplas linhas
                  ),
                  const SizedBox(height: 40),

                  // Botão Salvar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _saveSpecialDate, // Chama a função de salvamento simulado
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Cor do botão
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para criar os TextFormFields com o estilo da imagem
  Widget _buildTextInput({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Alinha o labelText à esquerda
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w600, // Um pouco mais de peso
          ),
        ),
        const SizedBox(height: 8), // Espaçamento entre label e campo
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.white, // Fundo branco do campo
            border: OutlineInputBorder(
              // Borda padrão (sem cor)
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              // Borda para estado normal (não focado)
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 255, 107, 129),
                width: 2,
              ), // Cor rosa do degradê
            ),
            focusedBorder: OutlineInputBorder(
              // Borda para estado focado
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 160, 132, 232),
                width: 2,
              ), // Cor roxa do degradê
            ),
            errorBorder: OutlineInputBorder(
              // Borda para erro
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              // Borda para erro e focado
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ), // Preenchimento interno
          ),
          validator: validator, // Função de validação
        ),
      ],
    );
  }
}
