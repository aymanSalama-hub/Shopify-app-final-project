import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bisky_shop/core/constants/size_responsive.dart';
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
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
    return BlocProvider(
      create: (context) => HomeCubit()..fechHomeData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          title: TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Discover your Product...',
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          actions: [
            if (_controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.black),
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
              var cubit = context.read<HomeCubit>();


              var filteredList = cubit.productList!
                  .where((p) =>
                  p!.title!.toLowerCase().contains(_controller.text.toLowerCase()))
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_controller.text.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizeresponsive.defaultSize! * 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Results for "${_controller.text}"',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${filteredList.length} Results Found',
                            style: const TextStyle(
                              color: Color(0xFF6055D8),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),


                  Expanded(
                    child: state is LoadingHomeSTate
                        ? const Center(child: CircularProgressIndicator())
                        : filteredList.isEmpty
                        ? Center(
                      child: Text(
                        _controller.text.isEmpty
                            ? 'Start typing to search products...'
                            : 'No products found for "${_controller.text}"',
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                        : GridView.builder(
                      itemCount: filteredList.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        var product = filteredList[index];
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
