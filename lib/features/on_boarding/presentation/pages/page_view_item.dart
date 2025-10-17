import 'package:bisky_shop/features/on_boarding/presentation/pages/page_view.dart';
import 'package:flutter/material.dart';

class page_view_onboarding extends StatelessWidget {
  const page_view_onboarding({super.key,@required this.pagecontroller});
  final PageController? pagecontroller;
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pagecontroller,
      children: [
        PageViewItem(
          title:'E Shopping' ,
          image:'assets/images/onboarding1.png' ,
          subtitle: 'Order from the best local brands with easy, on-demand delivery',
        ),
        PageViewItem(
          title:'Delivery Arrived' ,
          image:'assets/images/onboarding3.png' ,
          subtitle: 'Order from the best local brands with easy, on-demand delivery',
        ),PageViewItem(
          title:'E Shopping' ,
          image:'assets/images/onboarding2.png' ,
          subtitle: 'Order is arrived at your place',
        ),
      ],
    );
  }
}
