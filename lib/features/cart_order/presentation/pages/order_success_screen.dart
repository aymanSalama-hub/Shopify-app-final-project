import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Dynamic colors based on theme
    final backgroundColor = theme.colorScheme.background;
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onBackground;
    final subtitleColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final successColor = theme.colorScheme.primary; // Using primary for success

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 20 : 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  width: isSmallScreen ? 120 : 140,
                  height: isSmallScreen ? 120 : 140,
                  decoration: BoxDecoration(
                    color: successColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: successColor,
                    size: isSmallScreen ? 80 : 100,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 24 : 32),

                // Success Title
                Text(
                  'Order Placed Successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),

                // Success Message
                Text(
                  'Your order has been confirmed.\nYou can track it from My Orders section.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: subtitleColor,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 32 : 40),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: isSmallScreen ? 50 : 55,
                  child: ElevatedButton(
                    onPressed: () =>
                        pushAndRemoveUntil(context, Routs.mainAppNavigation),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 15 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
