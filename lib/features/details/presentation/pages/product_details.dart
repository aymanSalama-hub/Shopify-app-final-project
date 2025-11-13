// lib/features/details/presentation/pages/product_details_screen.dart
import 'dart:math';
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/features/details/presentation/cubit/addCart_cubit.dart';
import 'package:bisky_shop/features/details/presentation/cubit/addCart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../favorite/presentation/cubit/favourite_cubit.dart';
import '../../../home/data/model/product_response/product_response.dart';
import '../widgets/shared_pref_favourite_icon.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ProductResponse3 product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isFavorite = false;
  int selectedSize = 0;
  final List<String> sizes = ["8", "10", "38", "40"];
  final double rating = 3 + Random().nextDouble() * 2;
  final int reviews = Random().nextInt(200);

  @override
  void initState() {
    super.initState();
    _loadFav();
  }

  Future<void> _loadFav() async {
    final state = await FavoriteManager.getFavoriteState(widget.product.id.toString());
    if (mounted) setState(() => isFavorite = state);
  }

  Future<void> _toggleFav() async {
    final newVal = !isFavorite;
    await FavoriteManager.setFavoriteState(widget.product.id.toString(), newVal);
    if (mounted) setState(() => isFavorite = newVal);
    try {
      context.read<FavoritesCubit>().loadFavorites();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    bool isClothes =
        widget.product.category != null &&
            widget.product.category!.toLowerCase().contains('clothing');

    var cubit = context.read<AddcartCubit>();

    return BlocListener<AddcartCubit, AddCartState>(
      listener: (context, state) {
        if (state is AddCartSuccess) {
          pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${state.message}')));
        } else if (state is AddCartFailure) {
          pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add product to cart: ${state.error}'),
            ),
          );
        } else if (state is AddCartLoading) {
          showdialog(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.network(
                      (widget.product.image != null && widget.product.image!.isNotEmpty)
                          ? widget.product.image!
                          : "https://picsum.photos/200",
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/notfound.png', fit: BoxFit.cover);
                      },
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: AppColors.backgroundColorCart,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: AppColors.backgroundColorCart,
                      child: IconButton(
                        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black),
                        onPressed: _toggleFav,
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.title ?? 'No Data',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(10),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    const SizedBox(width: 4),
                                    Text(rating.toStringAsFixed(1),
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 4),
                                    Text("($reviews Reviews)"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "  \$${widget.product.price ?? 0}",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                          ),
                        ],
                      ),
                      const Gap(20),
                      const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Gap(10),
                      Text(widget.product.description ?? 'NO Data', maxLines: 4, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, height: 1.5)),
                      const Gap(20),
                      const Text("Size", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Gap(10),
                      Row(
                        children: List.generate(
                          sizes.length,
                              (index) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: isClothes
                                      ? () {
                                    setState(() {
                                      selectedSize = index;
                                    });
                                  }
                                      : null,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isClothes && selectedSize == index ? Colors.deepPurple : Colors.grey.shade300,
                                        width: 2,
                                      ),
                                      color: selectedSize == index && isClothes ? Colors.deepPurple.withOpacity(0.1) : Colors.transparent,
                                    ),
                                    child: Text(sizes[index], style: TextStyle(fontWeight: FontWeight.bold, color: isClothes ? (selectedSize == index ? Colors.deepPurple : Colors.black) : Colors.grey)),
                                  ),
                                ),
                                if (!isClothes) Icon(Icons.lock, size: 18, color: Colors.grey.shade600),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Gap(30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      cubit.toggleProductInCart(widget.product.id.toString(), widget.product);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    child: const Text("Add To Cart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
              const Gap(12),
              GestureDetector(
                onTap: () {
                  pushTo(context, Routs.cart);
                },
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(30)),
                  child: Center(child: SvgPicture.asset('assets/icons/lock.svg', color: AppColors.lightGrayColor, width: 24, height: 24)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
