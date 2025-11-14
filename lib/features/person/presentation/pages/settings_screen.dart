import 'dart:io';


import 'package:Shopify/core/routes/navigation.dart';
import 'package:Shopify/core/routes/routs.dart';
import 'package:Shopify/features/notification/presentation/pages/notification_page.dart';
import 'package:Shopify/features/person/presentation/cubit/profile_cubit.dart';
import 'package:Shopify/features/person/presentation/cubit/profile_state.dart';
import 'package:Shopify/features/person/presentation/pages/privacy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/Custom_Button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Dynamic colors based on theme
    final backgroundColor = theme.brightness == Brightness.dark
        ? Colors.grey[900]
        : const Color.fromARGB(255, 223, 219, 219);

    final cardColor = theme.colorScheme.surface;
    final appBarColor = theme.colorScheme.surface;
    final iconColor = theme.colorScheme.onSurface;
    final titleColor = theme.colorScheme.onBackground;
    final subtitleColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final dividerColor = theme.dividerColor.withOpacity(0.6);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
              ),
              child: Row(
                children: [
                  Container(
                    width: isSmallScreen ? 44 : 48,
                    height: isSmallScreen ? 44 : 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: isSmallScreen ? 18 : 22,
                      ),
                      color: iconColor,
                      onPressed: () {
                        pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12 : 16),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 18 : 20,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
                vertical: isSmallScreen ? 16 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Section
                  _buildAccountSection(
                    context,
                    theme,
                    isSmallScreen,
                    cardColor,
                    titleColor,
                    subtitleColor,
                    dividerColor,
                    cubit,
                    state,
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  // Settings Section
                  _buildSettingsSection(
                    context,
                    theme,
                    isSmallScreen,
                    cardColor,
                    titleColor,
                    dividerColor,
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccountSection(
    BuildContext context,
    ThemeData theme,
    bool isSmallScreen,
    Color cardColor,
    Color titleColor,
    Color subtitleColor,
    Color dividerColor,
    ProfileCubit cubit,
    ProfileState state,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                pushTo(context, Routs.profile);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: dividerColor),
                ),
                child: Row(
                  children: [
                    if (state is! ProfileLoadingState)
                      Container(
                        width: isSmallScreen ? 48 : 56,
                        height: isSmallScreen ? 48 : 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: isSmallScreen ? 22 : 26,
                          backgroundImage: (() {
                            final String url = cubit.imageUrl;
                            if (url.isEmpty) {
                              return const NetworkImage(
                                'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png',
                              );
                            }
                            if (url.startsWith('http')) {
                              return NetworkImage(url) as ImageProvider<Object>;
                            }
                            return FileImage(File(url))
                                as ImageProvider<Object>;
                          })(),
                          onBackgroundImageError: (exception, stackTrace) {},
                        ),
                      ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cubit.name,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: titleColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            cubit.email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: subtitleColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: isSmallScreen ? 16 : 18,
                      color: subtitleColor,
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

  Widget _buildSettingsSection(
    BuildContext context,
    ThemeData theme,
    bool isSmallScreen,
    Color cardColor,
    Color titleColor,
    Color dividerColor,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferences',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          _buildSettingsButton(
            'Notifications',
            Icons.notifications_outlined,
            Icons.chevron_right,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
            theme,
            isSmallScreen,
            titleColor,
          ),
          _buildDivider(dividerColor),
          _buildSettingsButton(
            'Language',
            Icons.language_outlined,
            Icons.chevron_right,
            () => _showLanguageDialog(context),
            theme,
            isSmallScreen,
            titleColor,
          ),
          _buildDivider(dividerColor),
          _buildSettingsButton(
            'Privacy & Security',
            Icons.lock_outline,
            Icons.chevron_right,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyScreen()),
              );
            },
            theme,
            isSmallScreen,
            titleColor,
          ),
          _buildDivider(dividerColor),
          _buildSettingsButton(
            'Appearance',
            Icons.palette_outlined,
            Icons.chevron_right,
            () {
              pushTo(context, Routs.appearance);
            },
            theme,
            isSmallScreen,
            titleColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(
    String text,
    IconData leadingIcon,
    IconData trailingIcon,
    VoidCallback onTap,
    ThemeData theme,
    bool isSmallScreen,
    Color titleColor,
  ) {
    final subtitleColor = theme.colorScheme.onSurface.withOpacity(0.5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  leadingIcon,
                  color: theme.colorScheme.primary,
                  size: isSmallScreen ? 20 : 22,
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                  ),
                ),
              ),
              Icon(
                trailingIcon,
                color: subtitleColor,
                size: isSmallScreen ? 20 : 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Divider(
      height: 1,
      thickness: 1,
      color: color,
      indent: 16,
      endIndent: 16,
    );
  }

  void _showLanguageDialog(BuildContext context) async {
    String savedLang = await LanguageService.getLanguage();
    String selectedLang = savedLang;

    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final bgColor = theme.dialogBackgroundColor;
    final textColor = theme.colorScheme.onBackground;
    final subTextColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final buttonColor = theme.colorScheme.primary;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: bgColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: RoundCheckBox(
                    size: 30,
                    isChecked: selectedLang == 'ar',
                    checkedColor: buttonColor,
                    onTap: (selected) {
                      setState(() {
                        selectedLang = 'ar';
                      });
                    },
                  ),
                  title: Text(
                    'العربية',
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                ),
                ListTile(
                  leading: RoundCheckBox(
                    size: 30,
                    isChecked: selectedLang == 'en',
                    checkedColor: buttonColor,
                    onTap: (selected) {
                      setState(() {
                        selectedLang = 'en';
                      });
                    },
                  ),
                  title: Text(
                    'English',
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Genral_Button(
                    text: 'Apply',
                    ontap: () async {
                      await LanguageService.saveLanguage(selectedLang);
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: TextStyle(color: subTextColor, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LanguageService {
  static const String key = 'selected_language';

  static Future<void> saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, lang);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? 'en';
  }
}
