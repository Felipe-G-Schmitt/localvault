import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';

class SecureScreen extends StatefulWidget {
  const SecureScreen({super.key});

  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  final _service = SecureStorageService();
  final _controller = TextEditingController();
  String? _tokenExibido;
  bool _loading = false;
  bool _obscureToken = true;

  Future<void> _salvarToken() async {
    final token = _controller.text.trim();
    if (token.isEmpty) {
      _showSnackBar('⚠️ Informe um token antes de salvar');
      return;
    }
    setState(() => _loading = true);
    await _service.saveToken(token);
    setState(() {
      _loading = false;
      _tokenExibido = null;
    });
    _showSnackBar('🔐 Token salvo com segurança!');
  }

  Future<void> _lerToken() async {
    setState(() => _loading = true);
    final token = await _service.readToken();
    setState(() {
      _loading = false;
      _tokenExibido = token ?? '(nenhum token encontrado)';
    });
  }

  Future<void> _deletarToken() async {
    setState(() => _loading = true);
    await _service.deleteToken();
    setState(() {
      _loading = false;
      _tokenExibido = null;
      _controller.clear();
    });
    _showSnackBar('🗑️ Token excluído com sucesso!');
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Armazenamento Seguro'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'flutter_secure_storage',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Dados criptografados via Keystore (Android) '
                            'e Keychain (iOS).',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              obscureText: _obscureToken,
              maxLines: _obscureToken ? 1 : 3,
              decoration: InputDecoration(
                labelText: 'Token de Autenticação',
                hintText: 'ex: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
                prefixIcon: const Icon(Icons.key_outlined),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureToken ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscureToken = !_obscureToken),
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: _salvarToken,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Salvar Token'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _lerToken,
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Recuperar Token'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _deletarToken,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Deletar Token',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),

            if (_tokenExibido != null) ...[
              const SizedBox(height: 20),
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lock_open_outlined,
                            size: 18,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Token Recuperado:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SelectableText(
                        _tokenExibido!,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          color:
                              Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
