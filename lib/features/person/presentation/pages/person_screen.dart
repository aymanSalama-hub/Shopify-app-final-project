import 'dart:io';

import 'package:Shopify/core/routes/navigation.dart';
import 'package:Shopify/core/routes/routs.dart';
import 'package:Shopify/features/person/presentation/cubit/profile_cubit.dart';
import 'package:Shopify/features/person/presentation/cubit/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contact_support.dart';
import 'help_screen.dart';

class PersonScreen extends StatelessWidget {
  const PersonScreen({super.key});

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
    final signOutButtonColor = theme.colorScheme.surface;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Section
                    _buildProfileSection(
                      context,
                      theme,
                      isSmallScreen,
                      cubit,
                      state,
                      cardColor,
                    ),

                    // Menu Buttons Section
                    _buildMenuSection(context, theme, isSmallScreen, cardColor),

                    // Sign Out Section
                    _buildSignOutSection(
                      context,
                      theme,
                      isSmallScreen,
                      signOutButtonColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    ThemeData theme,
    bool isSmallScreen,
    ProfileCubit cubit,
    ProfileState state,
    Color cardColor,
  ) {
    return Container(
      width: isSmallScreen ? 220 : 250,
      margin: EdgeInsets.all(isSmallScreen ? 20 : 24),
      padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (state is! ProfileLoadingState)
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: isSmallScreen ? 44 : 56,
                    backgroundColor: theme.scaffoldBackgroundColor,
                    child: CircleAvatar(
                      radius: isSmallScreen ? 40 : 52,
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
                        return FileImage(File(url)) as ImageProvider<Object>;
                      })(),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Handle image loading error
                      },
                    ),
                  ),
                ),
              ],
            ),

          SizedBox(height: isSmallScreen ? 16 : 20),
          Text(
            cubit.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isSmallScreen ? 4 : 8),
          Text(
            cubit.email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Premium Member',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    ThemeData theme,
    bool isSmallScreen,
    Color cardColor,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 24),
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
        children: [
          _buildMenuButton(
            'Profile',
            Icons.person_outline,
            Icons.chevron_right,
            () async {
              var resut = await pushTo(context, Routs.profile);
              if (resut != null) {
                context.read<ProfileCubit>().loadUserData();
              }
            },
            theme,
            isSmallScreen,
          ),
          _buildDivider(theme),
          _buildMenuButton(
            'Order History',
            Icons.shopping_bag_outlined,
            Icons.chevron_right,
            () => pushTo(context, Routs.order),
            theme,
            isSmallScreen,
          ),
          _buildDivider(theme),
          _buildMenuButton(
            'Settings',
            Icons.settings_outlined,
            Icons.chevron_right,
            () => pushTo(context, Routs.settings),
            theme,
            isSmallScreen,
          ),
          _buildDivider(theme),
          _buildMenuButton(
            'Contact Support',
            Icons.contact_support_outlined,
            Icons.chevron_right,
            () {
Navigator.push(context, MaterialPageRoute(builder: (context) => ContactSupportScreen(),));            },
            theme,
            isSmallScreen,
          ),
          _buildDivider(theme),
          _buildMenuButton(
            'Help & FAQ',
            Icons.help_outline,
            Icons.chevron_right,
            () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen(),));
            },
            theme,
            isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    String text,
    IconData leadingIcon,
    IconData trailingIcon,
    VoidCallback onTap,
    ThemeData theme,
    bool isSmallScreen,
  ) {
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
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              ),
              Icon(
                trailingIcon,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                size: isSmallScreen ? 20 : 22,
              ),
            ],
          ),
        ),
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

  Widget _buildSignOutSection(
    BuildContext context,
    ThemeData theme,
    bool isSmallScreen,
    Color signOutButtonColor,
  ) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
      child: Column(
        children: [
          // App version info
          Text(
            'App Version 1.0.0',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          // Sign out button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.error.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await _showSignOutDialog(context, theme);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 14 : 16,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: signOutButtonColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: theme.colorScheme.error,
                        size: isSmallScreen ? 18 : 20,
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Text(
                        'Sign Out',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSignOutDialog(BuildContext context, ThemeData theme) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: theme.colorScheme.error),
              SizedBox(width: 12),
              Text(
                'Sign Out',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onBackground,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to sign out? You\'ll need to sign in again to access your account.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              child: Text('Cancel', style: theme.textTheme.bodyLarge),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                pushAndRemoveUntil(context, Routs.login);
              },
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: Text(
                'Sign Out',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
