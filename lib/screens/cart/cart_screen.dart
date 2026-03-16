import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onExploreTap;

  const CartScreen({super.key, this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sepetim'),
            if (cart.itemCount > 0)
              Text(
                '${cart.itemCount} ürün',
                style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w400),
              ),
          ],
        ),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton.icon(
              onPressed: () => _confirmClear(context, cart),
              icon: const Icon(Icons.delete_outline,
                  size: 18, color: AppTheme.highlight),
              label: const Text('Temizle',
                  style: TextStyle(color: AppTheme.highlight)),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? _buildEmpty(context)
          : Column(
              children: [
                Expanded(child: _buildCartList(context, cart)),
                _buildCheckoutPanel(context, cart),
              ],
            ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined,
              size: 80, color: AppTheme.divider),
          const SizedBox(height: 16),
          const Text(
            'Sepetiniz boş',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ürünleri keşfetmeye başlayın',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onExploreTap,
            icon: const Icon(Icons.explore_outlined),
            label: const Text('Keşfet'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(BuildContext context, CartProvider cart) {
    final items = cart.items.values.toList();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final item = items[i];
        return Dismissible(
          key: Key('cart_${item.product.id}'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => cart.removeItem(item.product.id),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppTheme.highlight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete_outline,
                color: AppTheme.highlight, size: 24),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Row(
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: item.product.image,
                    width: 72,
                    height: 72,
                    fit: BoxFit.contain,
                    errorWidget: (_, __, ___) => Container(
                      width: 72,
                      height: 72,
                      color: const Color(0xFFF8F9FA),
                      child: const Icon(Icons.image_not_supported_outlined,
                          color: AppTheme.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.3),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${item.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                // Quantity controls
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _SmallButton(
                          icon: Icons.remove,
                          onTap: () =>
                              cart.decreaseQuantity(item.product.id),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        _SmallButton(
                          icon: Icons.add,
                          onTap: () => cart.addItem(item.product),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckoutPanel(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, -4))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ara Toplam',
                  style: TextStyle(
                      color: AppTheme.textSecondary, fontSize: 14)),
              Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kargo',
                  style: TextStyle(
                      color: AppTheme.textSecondary, fontSize: 14)),
              Text('Ücretsiz',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF22C55E))),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppTheme.divider),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Toplam',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showCheckoutDialog(context, cart),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Ödemeye Geç',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, CartProvider cart) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sepeti Temizle'),
        content: const Text('Tüm ürünleri sepetten çıkarmak istiyor musunuz?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hayır')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Evet, Temizle')),
        ],
      ),
    );
    if (confirm == true) cart.clearCart();
  }

  Future<void> _showCheckoutDialog(
      BuildContext context, CartProvider cart) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline_rounded,
                  color: Color(0xFF22C55E), size: 48),
            ),
            const SizedBox(height: 16),
            const Text('Siparişiniz Alındı!',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Toplam: \$${cart.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              '(Bu bir demo uygulamasıdır)',
              style:
                  TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                cart.clearCart();
                Navigator.pop(context);
              },
              child: const Text('Tamam'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SmallButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: AppTheme.textPrimary),
      ),
    );
  }
}
