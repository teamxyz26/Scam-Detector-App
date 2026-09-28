import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'checkout_pages.dart';

class ProSubscriptionPage extends StatelessWidget {
  const ProSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 28),
      const Text(
        'SCAMGUARD PRO',
        style: TextStyle(color: muted, fontSize: 9, letterSpacing: 1.7),
      ),
      const SizedBox(height: 12),
      const Text(
        'Upgrade to Pro and get unlimited scans, full\nthreat reports, and saved history.',
        textAlign: TextAlign.center,
        style: TextStyle(color: muted, fontSize: 13, height: 1.45),
      ),
      const SizedBox(height: 22),
      Row(
        children: [
          _planCard('\$2.99', '/month', 'MONTHLY', false),
          const SizedBox(width: 10),
          _planCard('\$1.49', '/month', 'YEARLY', true),
        ],
      ),
      const SizedBox(height: 18),
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111419),
          border: Border.all(color: const Color(0xFF20242A)),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            _proFeature(
              Icons.all_inclusive,
              'Unlimited scans',
              'No daily cap, ever',
            ),
            _proFeature(
              Icons.description_outlined,
              'Full threat report',
              'All risk indicators unlocked',
            ),
            _proFeature(
              Icons.access_time,
              'Saved scan history',
              '30-day searchable log',
            ),
            _proFeature(
              Icons.psychology_outlined,
              'AI risk breakdown',
              'Detailed pattern analysis',
            ),
            _proFeature(
              Icons.notifications_none,
              'Real-time alerts',
              'Push notifications for threats',
            ),
            _proFeature(
              Icons.search,
              'Basic URL scans',
              '3 per day',
              enabled: false,
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      SizedBox(
        height: 58,
        child: ElevatedButton(
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const PlanSelectionPage())),
          style: ElevatedButton.styleFrom(
            backgroundColor: cyan,
            foregroundColor: const Color(0xFF071114),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            'Start Free Trial - 7 Days',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const SizedBox(height: 15),
      const Text(
        'Cancel anytime. Billed via RevenueCat. No hidden fees.',
        textAlign: TextAlign.center,
        style: TextStyle(color: muted, fontSize: 11),
      ),
      const SizedBox(height: 19),
      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TrustNote(Icons.lock, 'Secure'),
          SizedBox(width: 19),
          _TrustNote(Icons.check, 'Cancel anytime'),
          SizedBox(width: 19),
          _TrustNote(Icons.bolt, 'Instant access'),
        ],
      ),
    ],
  );

  Widget _planCard(
    String price,
    String suffix,
    String label,
    bool selected,
  ) => Expanded(
    child: Container(
      height: 144,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF111B1D) : const Color(0xFF111419),
        border: Border.all(
          color: selected ? const Color(0xFF258D8D) : const Color(0xFF20242A),
          width: selected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: muted,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 17),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      color: selected ? const Color(0xFFD97A42) : Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    suffix,
                    style: const TextStyle(color: muted, fontSize: 10),
                  ),
                ],
              ),
              if (selected) ...[
                const SizedBox(height: 8),
                const Text(
                  'billed annually',
                  style: TextStyle(color: muted, fontSize: 9),
                ),
              ],
            ],
          ),
          if (selected)
            Positioned(
              top: -34,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: cyan,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'SAVE 50%',
                  style: TextStyle(
                    color: Color(0xFF071114),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );

  Widget _proFeature(
    IconData icon,
    String title,
    String subtitle, {
    bool enabled = true,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFF20242A))),
    ),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFF112A28) : const Color(0xFF17191E),
            border: Border.all(
              color: enabled
                  ? const Color(0xFF23504D)
                  : const Color(0xFF20242A),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: enabled ? const Color(0xFFD9E0DE) : muted,
            size: 21,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: enabled ? Colors.white : muted,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: muted, fontSize: 11),
              ),
            ],
          ),
        ),
        Icon(
          enabled ? Icons.check_circle_outline : Icons.remove_circle_outline,
          color: enabled ? const Color(0xFF63D19A) : const Color(0xFF454A52),
          size: 21,
        ),
      ],
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
