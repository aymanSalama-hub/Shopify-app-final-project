import 'package:Shopify/features/cart_order/data/model/model_cart.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Dynamic colors based on theme
    final cardColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onBackground;
    final subtitleColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 15,
        vertical: isSmallScreen ? 4 : 5,
      ),
      padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
            child: Image.network(
              item.imageUrl,
              height: isSmallScreen ? 60 : 70,
              width: isSmallScreen ? 60 : 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: isSmallScreen ? 60 : 70,
                  width: isSmallScreen ? 60 : 70,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: subtitleColor,
                    size: isSmallScreen ? 24 : 28,
                  ),
                );
              },
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 10),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 14 : 16,
                    color: textColor,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  item.brand,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: isSmallScreen ? 12 : 13,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  '\$${item.price}',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 14 : 15,
                  ),
                ),
              ],
            ),
          ),

          // Remove Button
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: errorColor,
              size: isSmallScreen ? 20 : 22,
            ),
            onPressed: onRemove,
            tooltip: 'Remove item',
          ),

          // Quantity Controls
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 25),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Decrease Button
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    color: theme.colorScheme.onPrimary,
                    size: isSmallScreen ? 16 : 18,
                  ),
                  onPressed: onDecrease,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: isSmallScreen ? 32 : 36,
                    minHeight: isSmallScreen ? 32 : 36,
                  ),
                ),

                // Quantity Display
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    item.quantity.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                      fontSize: isSmallScreen ? 13 : 14,
                    ),
                  ),
                ),

                // Increase Button
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: theme.colorScheme.onPrimary,
                    size: isSmallScreen ? 16 : 18,
                  ),
                  onPressed: onIncrease,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: isSmallScreen ? 32 : 36,
                    minHeight: isSmallScreen ? 32 : 36,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
