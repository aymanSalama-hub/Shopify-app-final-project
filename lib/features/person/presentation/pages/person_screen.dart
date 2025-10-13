import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/features/person/presentation/widget/custom_text_field_button.dart';
import 'package:flutter/material.dart';

class PersonScreen extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;
  const PersonScreen({
    super.key,
    this.name = 'mark adam',
    this.email = 'njbh_fbhbv@hotmail.com',
    this.imageUrl =
        'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 76, right: 157, left: 138),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 143,
            height: 36,
            child: Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: 200,
            height: 18,
            child: Center(
              child: Text(
                email,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: CustomTextFieldButton(
              text: 'profile',
              icon: Icons.person,
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: CustomTextFieldButton(
              text: 'order',
              icon: Icons.shopping_bag,
              onTap: () {
                pushTo(context, Routs.order);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: CustomTextFieldButton(
              text: 'setting',
              icon: Icons.settings,
              onTap: () {
                pushTo(context, Routs.settings);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: CustomTextFieldButton(
              text: 'contact',
              icon: Icons.contact_mail,
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: CustomTextFieldButton(
              text: 'favorit',
              icon: Icons.favorite,
              onTap: () {},
            ),
          ),
          const SizedBox(height: 140),
          Center(
            child: GestureDetector(
              onTap: () {
                // signout action
              },
              child: Text(
                'signout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.signOutColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
