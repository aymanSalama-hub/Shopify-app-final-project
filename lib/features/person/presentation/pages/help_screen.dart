import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  // قائمة الأسئلة الشائعة
  final List<String> _questions = [
    'How to use the app?',
    'How to reset my password?',
    'How to update my profile?',
    'How to contact support?',
  ];

  // الرسائل التوضيحية لكل سؤال
  final List<String> _answers = [
    'Navigate through the app using the bottom navigation bar and menus.',
    'Go to Settings > Privacy & Security > Password Safety to reset your password.',
    'Tap on your profile in Settings to update your personal information.',
    'Use the Contact Support page in Settings to send us a message directly.',
  ];

  // حالة كل Tile: مفتوح أم لا
  final List<bool> _isExpanded = List.generate(4, (index) => false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = theme.colorScheme.onBackground;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help & FAQ',
          style: TextStyle(
            color: titleColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _questions.length,
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
                    _questions[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: titleColor,
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
                      _answers[index],
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
