import 'package:Shopify/core/constants/size_responsive.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductCard extends StatelessWidget {
  final dynamic item;
  final bool? isFavorite;
  final VoidCallback? onFavoritePressed;

  const ProductCard({
    super.key,
    required this.item,
    this.isFavorite,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    Sizeresponsive().init(context);
    final ds = Sizeresponsive.defaultSize!;
    final sw = Sizeresponsive.screenWidth!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: sw * 0.4,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ds * 2),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black54 : Colors.black12,
            blurRadius: ds * 0.5,
            offset: Offset(0, ds * 0.25),
          ),
        ],
        border: isDarkMode
            ? Border.all(color: Colors.grey[800]!, width: 0.5)
            : null,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(ds * 2),
                  ),
                  child: Container(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    child: Image.network(
                      (item?.image is String && item.image!.isNotEmpty)
                          ? item.image!
                          : "https://picsum.photos/200",
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: isDarkMode
                                ? Colors.grey[600]
                                : Colors.grey[400],
                            size: ds * 4,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Product Info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(ds * 0.7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title and Rating
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title ?? "No Title",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: ds * 1.4,
                              color: Theme.of(context).colorScheme.onBackground,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gap(ds * 0.25),

                          // Rating Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${item.price?.toStringAsFixed(2) ?? '0.00'}",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ds * 1.6,
                                ),
                              ),
                              if (item.rating?.rate != null) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ds * 0.6,
                                    vertical: ds * 0.2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(ds * 1),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: ds * 1.2,
                                      ),
                                      Gap(ds * 0.25),
                                      Text(
                                        item.rating!.rate!.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontSize: ds * 1.1,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Favorite Button
          if (onFavoritePressed != null)
            Positioned(
              top: ds * 0.5,
              right: ds * 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: onFavoritePressed,
                  icon: Icon(
                    isFavorite == true ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite == true
                        ? Colors.red
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                    size: ds * 1.8,
                  ),
                  padding: EdgeInsets.all(ds * 0.5),
                  constraints: BoxConstraints(),
                  iconSize: ds * 1.8,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
