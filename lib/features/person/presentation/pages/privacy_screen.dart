import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final List<bool> _isExpanded = List.generate(4, (index) => false);

  final List<String> _titles = [
    'Password Safety',
    'Two-Factor Authentication',
    'Data Privacy',
    'App Permissions',
  ];

  final List<String> _messages = [
    'Use strong passwords and never share them with anyone.',
    'Enable 2FA to add an extra layer of security to your account.',
    'We respect your data privacy and do not share your info with third parties.',
    'Only grant permissions that are necessary for the app to function properly.',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _titles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black54 : Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    _titles[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  trailing: Icon(
                    _isExpanded[index]
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.colorScheme.primary,
                  ),
                  onTap: () {
                    setState(() {
                      _isExpanded[index] = !_isExpanded[index];
                    });
                  },
                ),
                if (_isExpanded[index])
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      _messages[index],
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
