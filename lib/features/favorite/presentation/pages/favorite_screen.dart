import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favourite_cubit.dart';
import '../cubit/favourite_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Favourit',
            style: TextStyle(
               color:  Color(0xFF6C63FF), fontSize: 30, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoritesError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is FavoritesLoaded) {
              final favouriteProducts = state.products;

              if (favouriteProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 100,
                        color: const Color(0xFF6C63FF),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Your favorites list is empty',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Looks like you haven\'t added any items to your favorites yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: favouriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favouriteProducts[index];
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 5)
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.white,
                          elevation: 6,
                          borderRadius: BorderRadius.circular(60),
                          child: ClipRRect(

                            borderRadius: BorderRadius.circular(60),
                            child: SizedBox(
                              height: 95,
                              width: 95,
                              child: product.image != null && product.image!.isNotEmpty
                                  ? Image.network(product.image!, fit: BoxFit.cover)
                                  : Image.asset('assets/images/notfound.png', fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(product.title ?? 'No title',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Text(
                                    '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF6C63FF)),
                                  ),
                                  const SizedBox(width: 10),
                                  if (product.rating?.rate != null)
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          (product.rating!.rate!).toStringAsFixed(1),
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                ],
                              ),

                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () async {
                              await context.read<FavoritesCubit>().removeFavorite(product.id.toString());
                            },
                            icon: const Icon(Icons.cancel),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
