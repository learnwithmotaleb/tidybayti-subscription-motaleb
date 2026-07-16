// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:provider/provider.dart';
//
// import '../service/in_app_purchase_service.dart';
//
// class SubscriptionScreen extends StatelessWidget {
//   const SubscriptionScreen({
//     super.key,
//     required this.userId,
//   });
//
//   final String userId;
//
//   @override
//   Widget build(BuildContext context) {
//     final service = context.watch<IosSubscriptionService>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Choose Your Plan'),
//       ),
//       body: RefreshIndicator(
//         onRefresh: service.loadProducts,
//         child: ListView(
//           padding: const EdgeInsets.all(20),
//           children: [
//             const Text(
//               'Plans',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const Text(
//               'Same features. Choose how you pay.',
//             ),
//             const SizedBox(height: 20),
//
//             if (service.isLoading)
//               const Center(
//                 child: CircularProgressIndicator(),
//               )
//             else if (service.products.isEmpty)
//               _EmptyProducts(
//                 error: service.errorMessage,
//                 onRetry: service.loadProducts,
//               )
//             else
//               ...service.products.map(
//                     (product) => _SubscriptionCard(
//                   product: product,
//                   selected:
//                   service.selectedProduct?.id == product.id,
//                   onTap: () => service.selectProduct(product),
//                 ),
//               ),
//
//             const SizedBox(height: 24),
//
//             const Text(
//               'All plans include',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             const _Feature(text: 'Manage multiple households'),
//             const _Feature(text: 'Add unlimited staff members'),
//             const _Feature(text: 'Assign and track tasks'),
//             const _Feature(text: 'Guided cleaning routines'),
//             const _Feature(text: 'Household budget tools'),
//             const _Feature(text: 'Smart shopping lists'),
//
//             if (service.errorMessage != null) ...[
//               const SizedBox(height: 16),
//               Text(
//                 service.errorMessage!,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             ],
//
//             const SizedBox(height: 24),
//
//             FilledButton(
//               onPressed: service.isPurchasing
//                   ? null
//                   : () => service.purchaseSelectedPlan(
//                 userId: userId,
//               ),
//               child: service.isPurchasing
//                   ? const SizedBox(
//                 width: 22,
//                 height: 22,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                 ),
//               )
//                   : const Text('Subscribe Now'),
//             ),
//
//             TextButton(
//               onPressed: service.isPurchasing
//                   ? null
//                   : service.restorePurchases,
//               child: const Text('Restore Purchases'),
//             ),
//
//             const Text(
//               'Payment will be charged to your Apple Account. '
//                   'The subscription renews automatically unless canceled.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 12),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _SubscriptionCard extends StatelessWidget {
//   const _SubscriptionCard({
//     required this.product,
//     required this.selected,
//     required this.onTap,
//   });
//
//   final ProductDetails product;
//   final bool selected;
//   final VoidCallback onTap;
//
//   bool get isYearly => product.id == 'premium_yearly';
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 14),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(
//           width: selected ? 2 : 1,
//           color: selected
//               ? Theme.of(context).colorScheme.primary
//               : Theme.of(context).dividerColor,
//         ),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(18),
//           child: Row(
//             children: [
//               Radio<bool>(
//                 value: true,
//                 groupValue: selected,
//                 onChanged: (_) => onTap(),
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       isYearly ? 'Yearly' : 'Monthly',
//                       style: const TextStyle(
//                         fontSize: 21,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       isYearly
//                           ? '${product.price} / year'
//                           : '${product.price} / month',
//                       style: const TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       isYearly
//                           ? '7-day free trial, then billed annually'
//                           : 'Billed monthly',
//                     ),
//                   ],
//                 ),
//               ),
//               if (isYearly)
//                 const Chip(
//                   label: Text('Best Value'),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _Feature extends StatelessWidget {
//   const _Feature({required this.text});
//
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       dense: true,
//       contentPadding: EdgeInsets.zero,
//       leading: const Icon(Icons.check_circle_outline),
//       title: Text(text),
//     );
//   }
// }
//
// class _EmptyProducts extends StatelessWidget {
//   const _EmptyProducts({
//     required this.error,
//     required this.onRetry,
//   });
//
//   final String? error;
//   final Future<void> Function() onRetry;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(error ?? 'No subscription plans are available.'),
//         TextButton(
//           onPressed: onRetry,
//           child: const Text('Try Again'),
//         ),
//       ],
//     );
//   }
// }