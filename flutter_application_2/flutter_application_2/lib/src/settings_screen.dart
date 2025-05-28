import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 160, 132, 232), // Uma cor do seu degradê
        foregroundColor: Colors.white,
        leading: IconButton( // Botão de voltar personalizado
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFFF6B81), Color(0xFFA084E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Opção 1: Perfil do Casal
            _buildSettingsTile(
              context,
              icon: Icons.people,
              title: 'Perfil do Casal',
              subtitle: 'Gerencie as informações do casal, foto e data de namoro.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Perfil do Casal (em desenvolvimento)')),
                );
                // FUTURO: Navigator.pushNamed(context, '/couple_profile');
              },
            ),
            const SizedBox(height: 10),

            // Opção 2: Notificações
            _buildSettingsTile(
              context,
              icon: Icons.notifications,
              title: 'Notificações',
              subtitle: 'Configure alertas para eventos e desafios.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Configurações de Notificações (em desenvolvimento)')),
                );
                // FUTURO: Navigator.pushNamed(context, '/notification_settings');
              },
            ),
            const SizedBox(height: 10),

            // Opção 3: Tema e Aparência
            _buildSettingsTile(
              context,
              icon: Icons.color_lens,
              title: 'Tema e Aparência',
              subtitle: 'Altere cores e visual do aplicativo.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Tema e Aparência (em desenvolvimento)')),
                );
              },
            ),
            const SizedBox(height: 10),

            // Opção 4: Ajuda e Suporte
            _buildSettingsTile(
              context,
              icon: Icons.help_outline,
              title: 'Ajuda e Suporte',
              subtitle: 'Tire suas dúvidas e entre em contato.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Ajuda e Suporte (em desenvolvimento)')),
                );
              },
            ),
            const SizedBox(height: 10),

            // Opção 5: Sobre o Aplicativo
            _buildSettingsTile(
              context,
              icon: Icons.info_outline,
              title: 'Sobre o Aplicativo',
              subtitle: 'Versão, termos de uso e política de privacidade.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Sobre o Aplicativo (em desenvolvimento)')),
                );
              },
            ),
            const SizedBox(height: 20),

            // Botão de Logout (destacado)
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Simula o logout
                  Navigator.pushReplacementNamed(context, '/welcome');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logout UI simulado!')),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Sair da Conta', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700, // Cor de destaque para logout
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para os itens de configuração
  Widget _buildSettingsTile(BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell( // Torna o card clicável
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: const Color.fromARGB(255, 160, 132, 232)), // Cor roxa do degradê
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}