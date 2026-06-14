import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import '../../../../core/localization/localization_service.dart';
import '../../../../dependency_injection/injection.dart';
import '../../../../routes/route_names.dart';

class LanguageSelectPage extends StatefulWidget {
  const LanguageSelectPage({super.key});

  @override
  State<LanguageSelectPage> createState() => _LanguageSelectPageState();
}

class _LanguageSelectPageState extends State<LanguageSelectPage> {
  String _selectedCode = 'en';

  @override
  void initState() {
    super.initState();
    _selectedCode =
        sl<LocalizationService>().currentLocale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.language, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Seleccionar idioma',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),

              // English Option
              _buildLanguageTile(
                code: 'en',
                label: 'English',
                flag: '🇬🇧',
              ),
              const SizedBox(height: 16),

              // Spanish Option
              _buildLanguageTile(
                code: 'es',
                label: 'Español',
                flag: '🇪🇸',
              ),
              const SizedBox(height: 48),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await sl<LocalizationService>()
                        .setLocale(Locale(_selectedCode));
                    if (mounted) {
                      context.go(RouteNames.splash);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue / Continuar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile({
    required String code,
    required String label,
    required String flag,
  }) {
    final isSelected = _selectedCode == code;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCode = code;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.blue, size: 24),
          ],
        ),
      ),
    );
  }
}