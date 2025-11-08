import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/features/home/presentation/cubit/home_cubit.dart';
import 'package:bisky_shop/features/home/presentation/cubit/home_state.dart';
import 'package:bisky_shop/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/size_responsive.dart';

class ProductGrideScreen extends StatefulWidget {
  const ProductGrideScreen({super.key});

  @override
  State<ProductGrideScreen> createState() => _ProductGrideScreenState();
}

class _ProductGrideScreenState extends State<ProductGrideScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fechHomeData(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            top: Sizeresponsive.defaultSize! * 6,
            bottom: Sizeresponsive.defaultSize! * 0.2,
            left: Sizeresponsive.defaultSize! * 1.6,
            right: Sizeresponsive.defaultSize! * 1.6,
          ),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final cubit = context.read<HomeCubit>();

              // ✅ حالة التحميل
              if (state is LoadingHomeSTate) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // ✅ حالة الخطأ
              if (state is ErrorHomeState) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              }

              // ✅ البيانات جاهزة
              if (cubit.productList == null || cubit.productList!.isEmpty) {
                return const Center(
                  child: Text(
                    "No products available.",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return GridView.builder(
                itemCount: cubit.productList!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  var product = cubit.productList![index];
                  return GestureDetector(
                    onTap: () {
                      pushTo(context, Routs.details, extra: product);
                    },
                    child: ProductCard(item: product),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
