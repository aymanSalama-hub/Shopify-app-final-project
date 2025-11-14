import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Shopify/core/constants/size_responsive.dart';
import 'package:Shopify/core/routes/navigation.dart';
import 'package:Shopify/core/routes/routs.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/product_card.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return BlocProvider(
      create: (context) => HomeCubit()..fechHomeData(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          elevation: 0,
          title: TextField(
            controller: _controller,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Discover your Product...',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          actions: [
            if (_controller.text.isNotEmpty)
              IconButton(
                icon: Icon(
                  Icons.cancel, 
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  _controller.clear();
                  setState(() {});
                },
              ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(Sizeresponsive.defaultSize! * 1.5),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final cubit = BlocProvider.of<HomeCubit>(context);

              if (state is LoadingHomeSTate) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }

              if (state is ErrorHomeState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: Sizeresponsive.defaultSize! * 6,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      SizedBox(height: Sizeresponsive.defaultSize! * 2),
                      Text(
                        'Error loading products',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: Sizeresponsive.defaultSize! * 1.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: Sizeresponsive.defaultSize! * 1),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          fontSize: Sizeresponsive.defaultSize! * 1.4,
                        ),
                      ),
                      SizedBox(height: Sizeresponsive.defaultSize! * 2),
                      ElevatedButton(
                        onPressed: () => cubit.fechHomeData(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              final products = cubit.productList3 ?? [];

              final filteredList = products.where((p) {
                final title = p?.title?.toLowerCase() ?? '';
                return title.contains(_controller.text.toLowerCase());
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_controller.text.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Sizeresponsive.defaultSize! * 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Results for "${_controller.text}"',
                            style: TextStyle(
                              fontSize: Sizeresponsive.defaultSize! * 1.6,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '${filteredList.length} ${filteredList.length == 1 ? 'Result' : 'Results'} Found',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Sizeresponsive.defaultSize! * 1.4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: Sizeresponsive.defaultSize! * 1),
                  Expanded(
                    child: filteredList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_controller.text.isEmpty)
                                  Icon(
                                    Icons.search,
                                    size: Sizeresponsive.defaultSize! * 8,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                                  )
                                else
                                  Icon(
                                    Icons.search_off,
                                    size: Sizeresponsive.defaultSize! * 8,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                                  ),
                                SizedBox(height: Sizeresponsive.defaultSize! * 2),
                                Text(
                                  _controller.text.isEmpty
                                      ? 'Start typing to search products...'
                                      : 'No products found for "${_controller.text}"',
                                  style: TextStyle(
                                    fontSize: Sizeresponsive.defaultSize! * 1.6,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    fontWeight: _controller.text.isEmpty 
                                        ? FontWeight.normal 
                                        : FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (_controller.text.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: Sizeresponsive.defaultSize! * 1),
                                    child: Text(
                                      'Try different keywords or browse all products',
                                      style: TextStyle(
                                        fontSize: Sizeresponsive.defaultSize! * 1.3,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            itemCount: filteredList.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: Sizeresponsive.defaultSize! * 1.5,
                              crossAxisSpacing: Sizeresponsive.defaultSize! * 1.5,
                              childAspectRatio: 0.85,
                            ),
                            itemBuilder: (context, index) {
                              final product = filteredList[index];
                              return GestureDetector(
                                onTap: () {
                                  pushTo(context, Routs.details, extra: product);
                                },
                                child: ProductCard(item: product),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}