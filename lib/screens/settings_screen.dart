import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SectionHeader(title: 'Aparência'),
          _Card(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined),
                title: const Text('Modo Escuro'),
                subtitle: const Text('Alterna entre tema claro e escuro'),
                value: settings.darkMode,
                onChanged: (value) => settings.setDarkMode(value),
              ),
            ],
          ),

          _SectionHeader(title: 'Idioma'),
          _Card(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Idioma do App'),
                subtitle: Text(settings.language),
                trailing: DropdownButton<String>(
                  value: settings.language,
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(12),
                  items: const [
                    DropdownMenuItem(
                      value: 'Português',
                      child: Text('Português 🇧🇷'),
                    ),
                    DropdownMenuItem(
                      value: 'English',
                      child: Text('English 🇺🇸'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) settings.setLanguage(value);
                  },
                ),
              ),
            ],
          ),

          _SectionHeader(title: 'Notificações'),
          _Card(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Ativar Notificações'),
                subtitle: const Text('Receber lembretes e alertas'),
                value: settings.notifications,
                onChanged: (value) => settings.setNotifications(value),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'As preferências são salvas automaticamente via '
                        'SharedPreferences e restauradas a cada abertura do app.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.4,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(children: children),
    );
  }
}
