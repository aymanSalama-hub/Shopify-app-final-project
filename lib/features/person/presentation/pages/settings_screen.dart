import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/widget/custom_text_field_button.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;
  const SettingsScreen({
    super.key,
    this.name = 'mark adam',
    this.email = 'njbh_fbhbv@hotmail.com',
    this.imageUrl =
        'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.backgroundIconColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                color: Colors.black,
                onPressed: () {
                  pop(context);
                },
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 355,
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        email,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey[400], thickness: 1, height: 1),
            const SizedBox(height: 20),
            const Text(
              'Setting',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: CustomTextFieldButton(
                text: 'notification',
                icon: Icons.notifications,
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: CustomTextFieldButton(
                text: 'language',
                icon: Icons.language,
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: CustomTextFieldButton(
                text: 'privacy',
                icon: Icons.lock,
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: CustomTextFieldButton(
                text: 'about us',
                icon: Icons.info,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
