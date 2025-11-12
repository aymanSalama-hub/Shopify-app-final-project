import 'dart:io';

import 'package:bisky_shop/features/person/presentation/cubit/profile_cubit.dart';
import 'package:bisky_shop/features/person/presentation/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize with user data (in real app, fetch from API/SharedPreferences)
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    var cubit = context.read<ProfileCubit>();

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            title: Text(
              'Profile',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            backgroundColor: theme.colorScheme.background,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Navigator.of(context).pop('back');
              },
            ),
            actions: [
              if (state is! ProfileLoadingState)
                IconButton(
                  icon: Icon(
                    cubit.isEditing ? Icons.close : Icons.edit_rounded,
                  ),
                  onPressed: cubit.toggleEditing,
                ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Image Section
                _buildProfileImageSection(theme, isDarkMode, cubit),

                const SizedBox(height: 32),

                // Personal Information Section
                _buildPersonalInfoSection(theme, cubit, state),

                const SizedBox(height: 24),

                // Account Settings Section
                //_buildAccountSettingsSection(theme),
              ],
            ),
          ),
          bottomNavigationBar: cubit.isEditing
              ? _buildSaveButton(theme, cubit)
              : null,
        );
      },
    );
  }

  Widget _buildProfileImageSection(
    ThemeData theme,
    bool isDarkMode,
    ProfileCubit cubit,
  ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
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
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: theme.cardColor,
                  child: CircleAvatar(
                    radius: 52,
                    backgroundImage: cubit.profileImageUrl.startsWith('http')
                        ? NetworkImage(cubit.profileImageUrl)
                        : FileImage(File(cubit.profileImageUrl)),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: cubit.pickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.cardColor, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Tap camera icon to update photo',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(
    ThemeData theme,
    ProfileCubit cubit,
    ProfileState state,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state is ProfileLoadingState) ...[
            const Center(child: CircularProgressIndicator()),
          ] else ...[
            Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Personal Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Name Field
            _buildEditableField(
              theme: theme,
              label: 'Full Name',
              controller: cubit.nameController,
              icon: Icons.person_rounded,
              isEditing: cubit.isEditing,
              state: state,
            ),
            const SizedBox(height: 16),

            // Email Field
            _buildEditableField(
              theme: theme,
              label: 'Email Address',
              controller: cubit.emailController,
              icon: Icons.email_rounded,
              isEditing: cubit.isEditing,
              state: state,
              readOnly: true, // Email usually can't be changed
            ),
            const SizedBox(height: 16),

            // Phone Field
            _buildEditableField(
              theme: theme,
              label: 'Phone Number',
              controller: cubit.phoneController,
              icon: Icons.phone_rounded,
              isEditing: cubit.isEditing,
              state: state,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            // Address Field
            _buildEditableField(
              theme: theme,
              label: 'Address',
              controller: cubit.addressController,
              icon: Icons.location_on_rounded,
              isEditing: cubit.isEditing,
              state: state,
              maxLines: 2,
            ),
          ],
        ],
      ),
    );
  }

  // Widget _buildAccountSettingsSection(ThemeData theme) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: theme.cardColor,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 20,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(
  //               Icons.settings_outlined,
  //               color: theme.colorScheme.primary,
  //               size: 20,
  //             ),
  //             const SizedBox(width: 8),
  //             Text(
  //               'Account Settings',
  //               style: theme.textTheme.titleMedium?.copyWith(
  //                 fontWeight: FontWeight.w600,
  //                 color: theme.colorScheme.onBackground,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),

  //         // Change Password
  //         _buildSettingItem(
  //           theme: theme,
  //           icon: Icons.lock_outline_rounded,
  //           title: 'Change Password',
  //           subtitle: 'Update your password regularly',
  //           onTap: () {
  //             // Navigate to change password screen
  //           },
  //         ),
  //         const SizedBox(height: 16),

  //         // Privacy Settings
  //         _buildSettingItem(
  //           theme: theme,
  //           icon: Icons.privacy_tip_outlined,
  //           title: 'Privacy Settings',
  //           subtitle: 'Manage your privacy preferences',
  //           onTap: () {
  //             // Navigate to privacy settings
  //           },
  //         ),
  //         const SizedBox(height: 16),

  //         // Notification Settings
  //         _buildSettingItem(
  //           theme: theme,
  //           icon: Icons.notifications_outlined,
  //           title: 'Notification Settings',
  //           subtitle: 'Control your notification preferences',
  //           onTap: () {
  //             // Navigate to notification settings
  //           },
  //         ),
  //         const SizedBox(height: 16),

  //         // Language Settings
  //         _buildSettingItem(
  //           theme: theme,
  //           icon: Icons.language_rounded,
  //           title: 'Language',
  //           subtitle: 'English (US)',
  //           onTap: () {
  //             // Navigate to language settings
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildEditableField({
    required ThemeData theme,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isEditing,
    required ProfileState state,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state is! ProfileLoadingState)
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: isEditing
                ? theme.colorScheme.primary.withOpacity(0.05)
                : theme.colorScheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEditing
                  ? theme.colorScheme.primary.withOpacity(0.3)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary.withOpacity(0.7),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: isEditing && !readOnly,
                    readOnly: readOnly,
                    keyboardType: keyboardType,
                    maxLines: maxLines,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: readOnly
                          ? theme.colorScheme.onSurface.withOpacity(0.4)
                          : theme.colorScheme.onBackground,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: label,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildSettingItem({
  //   required ThemeData theme,
  //   required IconData icon,
  //   required String title,
  //   required String subtitle,
  //   required VoidCallback onTap,
  // }) {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: onTap,
  //       borderRadius: BorderRadius.circular(12),
  //       child: Container(
  //         padding: const EdgeInsets.all(12),
  //         child: Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: theme.colorScheme.primary.withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Icon(icon, color: theme.colorScheme.primary, size: 20),
  //             ),
  //             const SizedBox(width: 16),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     title,
  //                     style: theme.textTheme.bodyLarge?.copyWith(
  //                       fontWeight: FontWeight.w500,
  //                       color: theme.colorScheme.onBackground,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 2),
  //                   Text(
  //                     subtitle,
  //                     style: theme.textTheme.bodySmall?.copyWith(
  //                       color: theme.colorScheme.onSurface.withOpacity(0.6),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Icon(
  //               Icons.chevron_right_rounded,
  //               color: theme.colorScheme.onSurface.withOpacity(0.4),
  //               size: 20,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSaveButton(ThemeData theme, ProfileCubit cubit) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: cubit.saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Save Changes',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
