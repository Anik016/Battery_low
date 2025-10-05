import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final fontSize = ref.watch(fontProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Theme'),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (val) =>
                    ref.read(themeProvider.notifier).state =
                        val ? ThemeMode.dark : ThemeMode.light,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Font Size'),
              subtitle: Slider(
                min: 12,
                max: 30,
                divisions: 9,
                value: fontSize,
                onChanged: (val) =>
                    ref.read(fontProvider.notifier).state = val,
              ),
              trailing: Text(fontSize.toStringAsFixed(0)),
            ),
          ],
        ),
      ),
    );
  }
}
