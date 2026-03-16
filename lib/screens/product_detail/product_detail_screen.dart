import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Product) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ürün')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 56,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ürün detayı açılamadı.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lütfen ürün listesine dönüp tekrar deneyin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Geri Dön'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final product = args;
    final cart = context.watch<CartProvider>();
    final inCart = cart.isInCart(product.id);
    final quantity = cart.getQuantity(product.id);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: AppTheme.surface,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8)
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: AppTheme.textPrimary),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(32),
                child: Hero(
                  tag: 'product_${product.id}',
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) => const Icon(
                        Icons.image_not_supported_outlined,
                        size: 64,
                        color: AppTheme.textSecondary),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.background,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                          letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        height: 1.3),
                  ),
                  const SizedBox(height: 12),

                  // Price & Rating row
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary),
                      ),
                      const Spacer(),
                      if (product.rating > 0)
                        Row(
                          children: [
                            ...List.generate(5, (i) {
                              final full = i < product.rating.floor();
                              final half = !full &&
                                  i < product.rating &&
                                  product.rating - i >= 0.5;
                              return Icon(
                                full
                                    ? Icons.star_rounded
                                    : half
                                        ? Icons.star_half_rounded
                                        : Icons.star_outline_rounded,
                                size: 20,
                                color: const Color(0xFFFFA500),
                              );
                            }),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary),
                            ),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: AppTheme.divider),
                  const SizedBox(height: 16),

                  // Description title
                  const Text(
                    'Açıklama',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isEmpty
                        ? 'Bu ürün için açıklama bulunmamaktadır.'
                        : product.description,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        height: 1.6),
                  ),

                  const SizedBox(height: 32),

                  // Cart quantity row if in cart
                  if (inCart) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppTheme.primary.withOpacity(0.15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sepetteki adet',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary)),
                          Row(
                            children: [
                              _QuantityButton(
                                icon: Icons.remove,
                                onTap: () => context
                                    .read<CartProvider>()
                                    .decreaseQuantity(product.id),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: Text(
                                  '$quantity',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              _QuantityButton(
                                icon: Icons.add,
                                onTap: () => context
                                    .read<CartProvider>()
                                    .addItem(product),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Add to cart / Remove button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (inCart) {
                          context
                              .read<CartProvider>()
                              .removeItem(product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Sepetten çıkarıldı'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        } else {
                          context.read<CartProvider>().addItem(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${product.name} sepete eklendi ✓'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            inCart ? AppTheme.highlight : AppTheme.primary,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: Icon(
                        inCart
                            ? Icons.remove_shopping_cart_outlined
                            : Icons.shopping_bag_outlined,
                        size: 20,
                      ),
                      label: Text(
                        inCart ? 'Sepetten Çıkar' : 'Sepete Ekle',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}
