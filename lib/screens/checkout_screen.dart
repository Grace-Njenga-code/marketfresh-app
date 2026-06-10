import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../services/mpesa_service.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _mpesaPhoneController = TextEditingController();
  String _paymentMethod = AppStrings.mpesa;
  bool _isProcessing = false;
  String? _processingMessage;

  @override
  void initState() {
    super.initState();
    // Pre-fill phone from registered account
    final user = context.read<UserProvider>().currentUser;
    if (user != null) {
      _mpesaPhoneController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    _mpesaPhoneController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder(CartProvider cart) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
      _processingMessage = _paymentMethod == AppStrings.mpesa
          ? 'Sending M-Pesa prompt...'
          : 'Placing order...';
    });

    if (_paymentMethod == AppStrings.mpesa) {
      await _handleMpesaPayment(cart);
    } else {
      await _handleCashPayment(cart);
    }
  }

  Future<void> _handleMpesaPayment(CartProvider cart) async {
    final result = await MpesaService.stkPush(
      phoneNumber: _mpesaPhoneController.text.trim(),
      amount: cart.total,
      accountRef: 'MarketFresh-${DateTime.now().millisecondsSinceEpoch}',
    );

    if (!mounted) return;

    if (!result.isSuccess) {
      setState(() {
        _isProcessing = false;
        _processingMessage = null;
      });
      _showError(result.message);
      return;
    }

    // STK Push sent — now poll for confirmation
    setState(() =>
        _processingMessage = 'Waiting for M-Pesa PIN confirmation...');

    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    if (result.checkoutRequestId != null) {
      final status = await MpesaService.queryTransaction(
          result.checkoutRequestId!);

      if (!mounted) return;

      if (status == MpesaQueryResult.success) {
        _finaliseOrder(cart, paidViaMpesa: true);
      } else if (status == MpesaQueryResult.cancelled) {
        setState(() {
          _isProcessing = false;
          _processingMessage = null;
        });
        _showError('M-Pesa payment was cancelled. Please try again.');
      } else {
        // Unknown — still place order and mark as pending verification
        _finaliseOrder(cart, paidViaMpesa: false);
      }
    } else {
      _finaliseOrder(cart, paidViaMpesa: false);
    }
  }

  Future<void> _handleCashPayment(CartProvider cart) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    _finaliseOrder(cart, paidViaMpesa: false);
  }

  void _finaliseOrder(CartProvider cart, {required bool paidViaMpesa}) {
    cart.placeOrder(
      deliveryAddress: _addressController.text.trim(),
      paymentMethod: _paymentMethod,
    );
    setState(() {
      _isProcessing = false;
      _processingMessage = null;
    });
    _showSuccessDialog(paidViaMpesa: paidViaMpesa);
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment failed'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog({required bool paidViaMpesa}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: const Icon(Icons.check_circle_rounded,
                    size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Order Placed! 🎉',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                paidViaMpesa
                    ? 'Payment confirmed via M-Pesa.\nYour order is on its way!'
                    : 'Order confirmed.\nPay cash on delivery.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pop();
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.checkout)),
      body: _isProcessing
          ? _ProcessingOverlay(message: _processingMessage ?? 'Processing...')
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // ── Delivery Details ────────────────────────
                  _SectionCard(
                    title: '📍 ${AppStrings.deliveryDetails}',
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Hilton Hotel, Nairobi CBD',
                            prefixIcon:
                                Icon(Icons.location_on_outlined),
                          ),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Please enter a delivery address'
                                  : null,
                          textInputAction: TextInputAction.next,
                          maxLines: 2,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            hintText: 'Delivery notes (optional)',
                            prefixIcon: Icon(Icons.notes_outlined),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Payment Method ──────────────────────────
                  _SectionCard(
                    title: '💳 ${AppStrings.paymentMethod}',
                    child: Column(
                      children: [
                        _PaymentOption(
                          label: AppStrings.mpesa,
                          subtitle: 'Pay via M-Pesa STK Push',
                          icon: Icons.phone_android_rounded,
                          isSelected:
                              _paymentMethod == AppStrings.mpesa,
                          onTap: () => setState(
                              () => _paymentMethod = AppStrings.mpesa),
                        ),
                        if (_paymentMethod == AppStrings.mpesa) ...[
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _mpesaPhoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: '07XX XXX XXX',
                              prefixIcon:
                                  Icon(Icons.phone_outlined),
                              labelText: 'M-Pesa phone number',
                            ),
                            validator: (v) {
                              if (_paymentMethod != AppStrings.mpesa) {
                                return null;
                              }
                              if (v == null || v.trim().isEmpty) {
                                return 'Enter your M-Pesa number';
                              }
                              final digits =
                                  v.replaceAll(RegExp(r'\D'), '');
                              if (digits.length < 9) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.sm),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.info_outline,
                                    size: 14, color: AppColors.primary),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'You will receive an M-Pesa prompt on your phone. Enter your PIN to complete payment.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.sm),
                        _PaymentOption(
                          label: AppStrings.cash,
                          subtitle: 'Pay cash when order arrives',
                          icon: Icons.payments_outlined,
                          isSelected:
                              _paymentMethod == AppStrings.cash,
                          onTap: () => setState(
                              () => _paymentMethod = AppStrings.cash),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Order Summary ───────────────────────────
                  _SectionCard(
                    title: '🧾 ${AppStrings.orderSummary}',
                    child: Column(
                      children: [
                        ...cart.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(item.product.name,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textPrimary)),
                                ),
                                Text('x${item.quantity}',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary)),
                                const SizedBox(width: AppSpacing.md),
                                Text(
                                  '${AppStrings.currency} ${item.totalPrice.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: AppSpacing.lg),
                        _TotalRow(
                          label: AppStrings.subtotal,
                          value:
                              '${AppStrings.currency} ${cart.subtotal.toInt()}',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _TotalRow(
                          label: AppStrings.deliveryFee,
                          value: cart.hasFreeDelivery
                              ? 'FREE 🎉'
                              : '${AppStrings.currency} ${cart.deliveryFee.toInt()}',
                          valueColor: cart.hasFreeDelivery
                              ? AppColors.success
                              : AppColors.textPrimary,
                        ),
                        const Divider(height: AppSpacing.lg),
                        _TotalRow(
                          label: AppStrings.cartTotal,
                          value:
                              '${AppStrings.currency} ${cart.total.toInt()}',
                          isBold: true,
                          valueColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  ElevatedButton(
                    onPressed: () => _placeOrder(cart),
                    child: Text(
                      _paymentMethod == AppStrings.mpesa
                          ? 'Pay ${AppStrings.currency} ${cart.total.toInt()} via M-Pesa'
                          : AppStrings.placeOrder,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
    );
  }
}

// ── Processing overlay ───────────────────────────────────────────

class _ProcessingOverlay extends StatelessWidget {
  final String message;
  const _ProcessingOverlay({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Please do not close this screen',
            style:
                TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Reusable widgets ─────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              )),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primarySurface
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color:
                    isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon,
                  size: 22,
                  color: isSelected
                      ? AppColors.textOnPrimary
                      : AppColors.textSecondary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      )),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textHint,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check,
                      size: 12, color: AppColors.textOnPrimary)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _TotalRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: AppColors.textSecondary,
            )),
        Text(value,
            style: TextStyle(
              fontSize: isBold ? 17 : 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: valueColor ?? AppColors.textPrimary,
            )),
      ],
    );
  }
}