import 'package:flutter/material.dart';

import 'app_colors.dart';

class PlanSelectionPage extends StatefulWidget {
  const PlanSelectionPage({super.key});

  @override
  State<PlanSelectionPage> createState() => _PlanSelectionPageState();
}

class _PlanSelectionPageState extends State<PlanSelectionPage> {
  bool yearly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Choose Your Plan'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          children: [
            const _CheckoutProgress(step: 1),
            const SizedBox(height: 30),
            const Text(
              'SELECT PLAN',
              style: TextStyle(color: muted, fontSize: 10, letterSpacing: 2),
            ),
            const SizedBox(height: 14),
            _planOption(
              title: 'Yearly',
              subtitle: '\$1.49/mo - billed annually',
              price: '\$17.99',
              selected: yearly,
              badge: 'BEST VALUE',
              savings: 'Save 50%',
              onTap: () => setState(() => yearly = true),
            ),
            const SizedBox(height: 12),
            _planOption(
              title: 'Monthly',
              subtitle: '\$2.99/mo - billed monthly',
              price: '\$2.99',
              selected: !yearly,
              onTap: () => setState(() => yearly = false),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF111419),
                border: Border.all(color: const Color(0xFF20242A)),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WHAT YOU GET',
                    style: TextStyle(
                      color: muted,
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 18),
                  _Benefit('Unlimited URL scans'),
                  _Benefit('Full threat reports & AI breakdown'),
                  _Benefit('30-day scan history'),
                  _Benefit('Real-time push alerts'),
                  _Benefit('Priority support'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentDetailsPage(yearly: yearly),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cyan,
                  foregroundColor: const Color(0xFF071114),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Continue to Payment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '7-DAY FREE TRIAL - CANCEL ANYTIME',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted, fontSize: 10, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planOption({
    required String title,
    required String subtitle,
    required String price,
    required bool selected,
    required VoidCallback onTap,
    String? badge,
    String? savings,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF102021) : const Color(0xFF111419),
        border: Border.all(
          color: selected ? aqua : const Color(0xFF20242A),
          width: selected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? aqua : muted,
            size: 27,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      _Badge('BEST VALUE'),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: cyan,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (savings != null)
                Text(
                  savings,
                  style: const TextStyle(
                    color: Color(0xFF63D19A),
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({super.key, required this.yearly});

  final bool yearly;

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  final cardController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    cardController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.yearly ? '\$17.99' : '\$2.99';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Payment Details'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          children: [
            const _CheckoutProgress(step: 2),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF102021),
                border: Border.all(color: const Color(0xFF214B4B)),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ScamGuard Pro - ${widget.yearly ? 'Yearly' : 'Monthly'}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$price  -  7-day free trial',
                          style: const TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'CHANGE',
                      style: TextStyle(
                        color: aqua,
                        fontSize: 11,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'CARD DETAILS',
              style: TextStyle(color: muted, fontSize: 10, letterSpacing: 2),
            ),
            const SizedBox(height: 14),
            Container(
              height: 142,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF17252E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '● ●',
                    style: TextStyle(color: Color(0xFFD26D4C), fontSize: 22),
                  ),
                  Text(
                    '••••  ••••  ••••  ••••',
                    style: TextStyle(color: muted, letterSpacing: 3),
                  ),
                  Text(
                    'CARDHOLDER NAME                                      VISA',
                    style: TextStyle(
                      color: muted,
                      fontSize: 9,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _field(
              'CARD NUMBER',
              cardController,
              '1234 5678 9012 3456',
              Icons.credit_card,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _field('EXPIRY', expiryController, 'MM/YY', null),
                ),
                const SizedBox(width: 12),
                Expanded(child: _field('CVV', cvvController, '•••', null)),
              ],
            ),
            const SizedBox(height: 16),
            _field('NAME ON CARD', nameController, 'Iman Syed', null),
            const SizedBox(height: 28),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TrustNote(Icons.lock, 'SSL Encrypted'),
                SizedBox(width: 18),
                _TrustNote(Icons.check, 'Cancel anytime'),
                SizedBox(width: 18),
                _TrustNote(Icons.bolt, 'Instant'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 58,
              child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enter card details to continue.'),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF20242A),
                  foregroundColor: muted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Enter card details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    String hint,
    IconData? icon,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: muted, fontSize: 10, letterSpacing: 2),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: muted),
          prefixIcon: icon == null ? null : Icon(icon, color: muted, size: 19),
          filled: true,
          fillColor: const Color(0xFF111419),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: line),
          ),
        ),
      ),
    ],
  );
}

class _CheckoutProgress extends StatelessWidget {
  const _CheckoutProgress({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Container(height: 4, color: cyan)),
      const SizedBox(width: 6),
      Expanded(
        child: Container(
          height: 4,
          color: step == 2 ? cyan : const Color(0xFF20242A),
        ),
      ),
    ],
  );
}

class _Benefit extends StatelessWidget {
  const _Benefit(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Color(0xFF63D19A),
          size: 19,
        ),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    ),
  );
}

class _Badge extends StatelessWidget {
  const _Badge(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFF12352D),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Color(0xFF63D19A),
        fontSize: 8,
        letterSpacing: 1,
      ),
    ),
  );
}

class _TrustNote extends StatelessWidget {
  const _TrustNote(this.icon, this.label);
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: const Color(0xFFE5BD63), size: 12),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: muted, fontSize: 9)),
    ],
  );
}
