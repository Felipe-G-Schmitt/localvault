import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _box = Hive.box<UserProfile>('profiles');
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pontuacaoCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  UserProfile? get _profile => _box.isEmpty ? null : _box.getAt(0);

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() {
    final p = _profile;
    if (p != null) {
      _nomeCtrl.text = p.nome;
      _emailCtrl.text = p.email;
      _pontuacaoCtrl.text = p.pontuacao.toString();
    }
  }

  Future<void> _salvarPerfil() async {
    if (!_formKey.currentState!.validate()) return;

    final nome = _nomeCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pontuacao = int.tryParse(_pontuacaoCtrl.text.trim()) ?? 0;
    final hoje = DateTime.now().toIso8601String().substring(0, 10);

    if (_box.isEmpty) {
      await _box.add(UserProfile(
        nome: nome,
        email: email,
        dataCadastro: hoje,
        pontuacao: pontuacao,
      ));
    } else {
      final p = _box.getAt(0)!;
      p.nome = nome;
      p.email = email;
      p.pontuacao = pontuacao;
      await p.save();
    }

    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Perfil salvo com sucesso!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _limparPerfil() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.delete_forever, color: Colors.red),
        title: const Text('Excluir Dados do Perfil'),
        content: const Text(
          'De acordo com a LGPD (art. 18 — Direito ao Esquecimento), '
          'todos os dados do seu perfil serão excluídos permanentemente.\n\n'
          'Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _box.clear();
      _nomeCtrl.clear();
      _emailCtrl.clear();
      _pontuacaoCtrl.clear();
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Dados excluídos (Direito ao Esquecimento — LGPD)'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _pontuacaoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _box.listenable(),
      builder: (context, Box<UserProfile> box, _) {
        final profile = box.isEmpty ? null : box.getAt(0);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil do Usuário'),
            centerTitle: true,
            actions: [
              if (profile != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Excluir dados (LGPD)',
                  onPressed: _limparPerfil,
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (profile != null) ...[
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.verified_user,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Perfil Ativo',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          _ProfileRow(Icons.person, 'Nome', profile.nome),
                          _ProfileRow(Icons.email, 'E-mail', profile.email),
                          _ProfileRow(
                              Icons.calendar_today, 'Cadastro', profile.dataCadastro),
                          _ProfileRow(
                              Icons.star, 'Pontuação', '${profile.pontuacao} pts'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Editar Perfil',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ] else ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_add_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 8),
                          const Text('Nenhum perfil salvo ainda.'),
                          const SizedBox(height: 4),
                          const Text(
                            'Preencha os campos abaixo para criar seu perfil.',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nomeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nome completo',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Informe o nome'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                            (v == null || !v.contains('@'))
                                ? 'E-mail inválido'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _pontuacaoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Pontuação',
                          prefixIcon: Icon(Icons.star_outline),
                          border: OutlineInputBorder(),
                          suffixText: 'pts',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            (v == null || int.tryParse(v) == null)
                                ? 'Informe um número válido'
                                : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                FilledButton.icon(
                  onPressed: _salvarPerfil,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(profile == null ? 'Criar Perfil' : 'Atualizar Perfil'),
                ),
                if (profile != null) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _limparPerfil,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Excluir Dados (LGPD — Direito ao Esquecimento)',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
