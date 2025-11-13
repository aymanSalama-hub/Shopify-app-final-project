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

    // Dynamic colors based on theme
    final cardColor = theme.colorScheme.surface;
    final backgroundColor = theme.colorScheme.background;
    final textColor = theme.colorScheme.onBackground;
    final subtitleColor = theme.colorScheme.onSurface.withOpacity(0.7);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              'Profile',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            centerTitle: true,
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: textColor),
              onPressed: () {
                Navigator.of(context).pop('back');
              },
            ),
            actions: [
              if (state is! ProfileLoadingState)
                IconButton(
                  icon: Icon(
                    cubit.isEditing ? Icons.close : Icons.edit_rounded,
                    color: textColor,
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
                _buildProfileImageSection(
                  theme,
                  isDarkMode,
                  cubit,
                  state,
                  cardColor,
                  textColor,
                  subtitleColor,
                ),

                const SizedBox(height: 32),

                // Personal Information Section
                _buildPersonalInfoSection(
                  theme,
                  cubit,
                  state,
                  cardColor,
                  textColor,
                  subtitleColor,
                ),

                const SizedBox(height: 24),

                // Account Settings Section (commented out but theme-ready)
                //_buildAccountSettingsSection(theme, cardColor, textColor, subtitleColor),
              ],
            ),
          ),
          bottomNavigationBar: cubit.isEditing
              ? _buildSaveButton(theme, cubit, backgroundColor)
              : null,
        );
      },
    );
  }

  Widget _buildProfileImageSection(
    ThemeData theme,
    bool isDarkMode,
    ProfileCubit cubit,
    ProfileState state,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
  ) {
    return Column(
      children: [
        if (state is! ProfileLoadingState)
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
                    backgroundColor: cardColor,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage: cubit.profileImageUrl.startsWith('http')
                          ? NetworkImage(cubit.profileImageUrl)
                                as ImageProvider<Object>
                          : FileImage(File(cubit.profileImageUrl)),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Handle image loading error
                      },
                    ),
                  ),
                ),
              ),
              cubit.isEditing
                  ? Positioned(
                      bottom: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: cubit.pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: cardColor, width: 3),
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
                    )
                  : const SizedBox(),
            ],
          ),
        const SizedBox(height: 16),
        Text(
          'Tap camera icon to update photo',
          style: theme.textTheme.bodySmall?.copyWith(color: subtitleColor),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(
    ThemeData theme,
    ProfileCubit cubit,
    ProfileState state,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
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
                    color: textColor,
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
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
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
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
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
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
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
              cardColor: cardColor,
              textColor: textColor,
              subtitleColor: subtitleColor,
              maxLines: 2,
            ),
          ],
        ],
      ),
    );
  }

  // Widget _buildAccountSettingsSection(
  //   ThemeData theme,
  //   Color cardColor,
  //   Color textColor,
  //   Color subtitleColor,
  // ) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: cardColor,
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
  //                 color: textColor,
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
  //           textColor: textColor,
  //           subtitleColor: subtitleColor,
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
  //           textColor: textColor,
  //           subtitleColor: subtitleColor,
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
  //           textColor: textColor,
  //           subtitleColor: subtitleColor,
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
  //           textColor: textColor,
  //           subtitleColor: subtitleColor,
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
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
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
              color: subtitleColor,
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
                          ? subtitleColor.withOpacity(0.6)
                          : textColor,
                    ),
                    maxLength: label == 'Phone Number' ? 11 : null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: label,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: subtitleColor.withOpacity(0.4),
                      ),
                      counterText: '',
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
  //   required Color textColor,
  //   required Color subtitleColor,
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
  //                       color: textColor,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 2),
  //                   Text(
  //                     subtitle,
  //                     style: theme.textTheme.bodySmall?.copyWith(
  //                       color: subtitleColor,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Icon(
  //               Icons.chevron_right_rounded,
  //               color: subtitleColor.withOpacity(0.6),
  //               size: 20,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSaveButton(
    ThemeData theme,
    ProfileCubit cubit,
    Color backgroundColor,
  ) {
    return SafeArea(
      child: Container(
        color: backgroundColor,
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
      ),
    );
  }
}
