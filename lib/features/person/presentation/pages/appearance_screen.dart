// features/settings/presentation/screens/appearance_screen.dart
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/features/person/presentation/cubit/theme_cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20),
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
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () {
                    pop(context);
                  },
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Text(
                'Appearance',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          String currentTheme = 'system';
          if (state is ThemeLoaded) {
            currentTheme = state.theme;
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
                vertical: isSmallScreen ? 16 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Theme Selection Section
                  _buildThemeSelectionSection(context, currentTheme, isSmallScreen),
                  
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  
                  // Preview Section
                  _buildPreviewSection(context, currentTheme, isSmallScreen),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeSelectionSection(
    BuildContext context,
    String currentTheme,
    bool isSmallScreen,
  ) {
    final theme = Theme.of(context);
    final themeCubit = context.read<ThemeCubit>();

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
            'Theme Mode',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onBackground,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          
          _buildThemeOption(
            context: context,
            title: 'Light Mode',
            subtitle: 'Always use light theme',
            icon: Icons.light_mode_outlined,
            isSelected: currentTheme == 'light',
            onTap: () => themeCubit.changeTheme('light'),
            isSmallScreen: isSmallScreen,
          ),
          _buildDivider(theme),
          _buildThemeOption(
            context: context,
            title: 'Dark Mode',
            subtitle: 'Always use dark theme',
            icon: Icons.dark_mode_outlined,
            isSelected: currentTheme == 'dark',
            onTap: () => themeCubit.changeTheme('dark'),
            isSmallScreen: isSmallScreen,
          ),
          _buildDivider(theme),
          _buildThemeOption(
            context: context,
            title: 'System Default',
            subtitle: 'Follow system theme',
            icon: Icons.phone_iphone_outlined,
            isSelected: currentTheme == 'system',
            onTap: () => themeCubit.changeTheme('system'),
            isSmallScreen: isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    final theme = Theme.of(context);

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
                  color: isSelected 
                    ? theme.colorScheme.primary.withOpacity(0.2)
                    : theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.onSurface.withOpacity(0.7),
                  size: isSmallScreen ? 20 : 22,
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                  size: isSmallScreen ? 20 : 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewSection(
    BuildContext context,
    String currentTheme,
    bool isSmallScreen,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
            'Preview',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onBackground,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          
          // Preview card showing how the theme looks
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sample Product',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          Text(
                            '\$29.99',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'This is how your app will look with the selected theme.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      thickness: 1,
      color: theme.dividerColor.withOpacity(0.6),
      indent: 16,
      endIndent: 16,
    );
  }
}