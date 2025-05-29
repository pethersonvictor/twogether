import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:myapp/auth_state_service.dart';
import 'package:myapp/services/api_service.dart';

class AddSpecialDateScreen extends StatefulWidget {
  const AddSpecialDateScreen({super.key});

  @override
  State<AddSpecialDateScreen> createState() => _AddSpecialDateScreenState();
}

class _AddSpecialDateScreenState extends State<AddSpecialDateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _momentController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      locale: const Locale('pt', 'BR'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF6B81),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _saveSpecialDate() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione a data.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final authService = Provider.of<AuthStateService>(
          context,
          listen: false,
        );
        final userId = authService.userId;

        if (userId == null) {
          throw Exception(
            'Usuário não autenticado. Redirecionando para o login.',
          );
        }

        final apiService = ApiService();
        final Map<String, dynamic> dateData = {
          'titulo': _nameController.text.trim(),
          'data_evento': _selectedDate!.toIso8601String(),
          'local': _locationController.text.trim(),
          'momento': _momentController.text.trim(),
          'usuario_id': userId,
        };

        final response = await apiService.addImportantDateApi(dateData);

        if (response['_id'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data especial salva com sucesso!')),
          );
          // Sinaliza para a tela anterior (CalendarScreen) que ela deve atualizar
          Navigator.pop(context, true);
        } else {
          throw Exception(
            response['message'] ??
                'Resposta inesperada do servidor ao salvar data.',
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao salvar data: ${e.toString().replaceFirst('Exception: ', '')}',
            ),
          ),
        );
        if (e.toString().contains('Não autenticado')) {
          Provider.of<AuthStateService>(context, listen: false).setLoggedOut();
          Navigator.pushReplacementNamed(context, '/welcome');
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _momentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color.fromARGB(255, 255, 107, 129),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/coraçoes.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.white);
                },
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo_cor.png",
                    height: 80,
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
                  const SizedBox(height: 20),
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
                  const Icon(Icons.edit_note, size: 80, color: Colors.grey),
                  const SizedBox(height: 30),

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

                  _buildTextInput(
                    controller: _dateController,
                    hintText: 'dd/mm/aaaa',
                    labelText: 'Quando foi essa data tão especial?',
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione a data.';
                      }
                      if (_selectedDate == null) {
                        return 'Por favor, selecione a data.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildTextInput(
                    controller: _locationController,
                    hintText: 'Ex: Restaurante X, Praia, Cidade Y, Em casa...',
                    labelText: 'Onde essa data especial aconteceu?',
                  ),
                  const SizedBox(height: 20),

                  _buildTextInput(
                    controller: _momentController,
                    hintText: '',
                    labelText: 'Qual foi o momento mais marcante desse dia?',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 40),

                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveSpecialDate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 255, 107, 129),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 160, 132, 232),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
