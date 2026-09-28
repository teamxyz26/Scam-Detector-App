import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'pro_subscription_page.dart';

void main() {
  runApp(const ScamGuardApp());
}

class ScamGuardApp extends StatelessWidget {
  const ScamGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScamGuard AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080C0D),
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: aqua,
          brightness: Brightness.dark,
        ),
      ),
      home: AuthScreen(destinationBuilder: () => const ScamGuardShell()),
    );
  }
}

class ScanReportPage extends StatelessWidget {
  const ScanReportPage({
    super.key,
    required this.url,
    required this.suspicious,
    required this.onNavigate,
  });

  final String url;
  final bool suspicious;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final accent = suspicious
        ? const Color(0xFFEF777E)
        : const Color(0xFF63D19A);

    return Scaffold(
      backgroundColor: const Color(0xFF080C0D),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 27, 18, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _reportHeader(context),
                        const SizedBox(height: 28),
                        const Text(
                          'Scan Result',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 26),
                        _scorePanel(accent),
                        const SizedBox(height: 20),
                        _urlRow(),
                        const SizedBox(height: 24),
                        _indicatorHeader(),
                        const SizedBox(height: 13),
                        _indicator('Valid SSL certificate (EV)', !suspicious),
                        _indicator('Domain 8+ years registered', !suspicious),
                        _indicator('No malicious redirects found', !suspicious),
                        const SizedBox(height: 22),
                        _unlockButton(context),
                        const SizedBox(height: 14),
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(58),
                            foregroundColor: muted,
                            side: const BorderSide(color: Color(0xFF20242A)),
                            backgroundColor: const Color(0xFF17191E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Scan Another',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _reportNav(),
          ],
        ),
      ),
    );
  }

  Widget _reportHeader(BuildContext context) => Row(
    children: [
      IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: muted),
        tooltip: 'Back',
      ),
      const SizedBox(width: 4),
      const Text(
        'S C A M G U A R D  A I',
        style: TextStyle(
          color: aqua,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    ],
  );

  Widget _scorePanel(Color accent) => Container(
    padding: const EdgeInsets.fromLTRB(18, 24, 18, 25),
    decoration: BoxDecoration(
      color: const Color(0xFF0B1D17),
      border: Border.all(color: accent.withValues(alpha: .25)),
      borderRadius: BorderRadius.circular(28),
    ),
    child: Column(
      children: [
        SizedBox(
          width: 174,
          height: 174,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accent.withValues(alpha: .16),
                    width: 10,
                  ),
                ),
              ),
              Icon(
                suspicious ? Icons.close : Icons.check,
                color: accent,
                size: 62,
              ),
              Positioned(
                bottom: 30,
                child: Text(
                  suspicious ? '82/100' : '8/100',
                  style: TextStyle(color: accent, fontSize: 17),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: .1),
            border: Border.all(color: accent.withValues(alpha: .25)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            suspicious ? '⚠ LINK NEEDS ATTENTION' : '✓ LINK IS SAFE',
            style: TextStyle(
              color: accent,
              fontSize: 11,
              letterSpacing: 1.3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          suspicious ? 'Potential Threat Detected' : "You're Safe to Proceed",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          suspicious
              ? 'Suspicious patterns were found in this link.'
              : 'No threats detected across 40+ security checks.\nThis link appears legitimate.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: muted, fontSize: 15, height: 1.5),
        ),
      ],
    ),
  );

  Widget _urlRow() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
    decoration: BoxDecoration(
      color: const Color(0xFF0D1113),
      border: Border.all(color: const Color(0xFF151D1F)),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        const Icon(Icons.link, color: const Color(0xFF54CBA4), size: 20),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            url,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: muted, fontSize: 13),
          ),
        ),
      ],
    ),
  );

  Widget _indicatorHeader() => const Row(
    children: [
      Text(
        'THREAT INDICATORS',
        style: TextStyle(color: muted, fontSize: 10, letterSpacing: 2),
      ),
      Spacer(),
      Icon(Icons.lock_outline, color: cyan, size: 13),
      SizedBox(width: 4),
      Text(
        'FULL REPORT: PRO',
        style: TextStyle(color: cyan, fontSize: 10, letterSpacing: .8),
      ),
    ],
  );

  Widget _indicator(String label, bool safe) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
    decoration: BoxDecoration(
      color: const Color(0xFF0D1415),
      border: Border.all(color: const Color(0xFF172426)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Icon(
          Icons.circle,
          color: safe ? const Color(0xFF63D19A) : Colors.redAccent,
          size: 10,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: muted, fontSize: 15),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: safe ? const Color(0xFF12352D) : const Color(0xFF3A2026),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            safe ? 'SAFE' : 'RISK',
            style: TextStyle(
              color: safe ? const Color(0xFF6BD19A) : Colors.redAccent,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: .8,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _unlockButton(BuildContext context) => SizedBox(
    height: 60,
    child: OutlinedButton.icon(
      onPressed: () => onNavigate(3),
      icon: const Icon(Icons.star_border, color: cyan),
      label: const Text(
        'Unlock Full Threat Report',
        style: TextStyle(
          color: cyan,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF23696A)),
        backgroundColor: const Color(0xFF0D2224),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );

  Widget _reportNav() => Container(
    padding: const EdgeInsets.fromLTRB(7, 8, 7, 10),
    decoration: const BoxDecoration(
      color: Color(0xF70C1214),
      border: Border(top: BorderSide(color: line)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ReportNavItem(
          Icons.shield_outlined,
          'SHIELD',
          onTap: () => onNavigate(0),
        ),
        _ReportNavItem(
          Icons.search,
          'SCAN',
          active: true,
          onTap: () => onNavigate(1),
        ),
        _ReportNavItem(Icons.history, 'HISTORY', onTap: () => onNavigate(2)),
        _ReportNavItem(Icons.star_border, 'PRO', onTap: () => onNavigate(3)),
      ],
    ),
  );
}

class _ReportNavItem extends StatelessWidget {
  const _ReportNavItem(
    this.icon,
    this.label, {
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF15383B) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: active ? aqua : muted),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: active ? aqua : muted,
              fontSize: 8,
              letterSpacing: .7,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ReportBadge extends StatelessWidget {
  const _ReportBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFF15181D),
      border: Border.all(color: const Color(0xFF272C33)),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Text(
      label,
      style: const TextStyle(color: muted, fontSize: 10, letterSpacing: 1.5),
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

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.destinationBuilder});

  final Widget Function() destinationBuilder;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignIn = true;
  bool obscurePassword = true;

  void continueToApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => widget.destinationBuilder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 34, 28, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10292B),
                      border: Border.all(color: const Color(0xFF23696A)),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: const [
                        BoxShadow(color: Color(0x3324BFC0), blurRadius: 30),
                      ],
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: aqua,
                      size: 43,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'S C A M G U A R D  A I',
                    style: TextStyle(
                      color: aqua,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.4,
                    ),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    isSignIn ? 'Welcome back' : 'Create account',
                    style: const TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSignIn
                        ? 'Sign in to your account'
                        : 'Start protecting yourself today',
                    style: const TextStyle(color: muted, fontSize: 16),
                  ),
                  const SizedBox(height: 34),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: panel,
                      border: Border.all(color: line),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _authTab('SIGN IN', isSignIn, () {
                          setState(() => isSignIn = true);
                        }),
                        _authTab('SIGN UP', !isSignIn, () {
                          setState(() => isSignIn = false);
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: OutlinedButton.icon(
                      onPressed: continueToApp,
                      icon: const Text(
                        'G',
                        style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: line),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: line)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'O R',
                          style: TextStyle(color: muted, letterSpacing: 2),
                        ),
                      ),
                      const Expanded(child: Divider(color: line)),
                    ],
                  ),
                  const SizedBox(height: 23),
                  _authField('EMAIL', 'you@example.com', Icons.mail_outline),
                  const SizedBox(height: 17),
                  _authField(
                    'PASSWORD',
                    '••••••••',
                    Icons.lock_outline,
                    trailing: IconButton(
                      onPressed: () =>
                          setState(() => obscurePassword = !obscurePassword),
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: muted,
                        size: 20,
                      ),
                    ),
                  ),
                  if (isSignIn)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'FORGOT PASSWORD?',
                          style: TextStyle(color: aqua, fontSize: 11),
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 17),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: continueToApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cyan,
                        foregroundColor: const Color(0xFF071114),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        isSignIn ? 'Sign In' : 'Create Account',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: continueToApp,
                    child: const Text(
                      'Continue as guest',
                      style: TextStyle(color: muted, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'By continuing you agree to our Terms and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _authTab(String label, bool selected, VoidCallback onTap) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0D1214) : Colors.transparent,
          border: selected ? Border.all(color: line) : null,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : muted,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ),
    ),
  );

  Widget _authField(
    String label,
    String hint,
    IconData icon, {
    Widget? trailing,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: muted, fontSize: 10, letterSpacing: 2),
      ),
      const SizedBox(height: 8),
      TextField(
        obscureText: label == 'PASSWORD' && obscurePassword,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: muted, fontSize: 15),
          prefixIcon: Icon(icon, color: muted, size: 20),
          suffixIcon: trailing,
          filled: true,
          fillColor: const Color(0xFF101216),
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

class ScanEntry {
  ScanEntry(this.url, this.status, this.time);
  final String url;
  final String status;
  final String time;
}

class ScamGuardShell extends StatefulWidget {
  const ScamGuardShell({super.key});

  @override
  State<ScamGuardShell> createState() => _ScamGuardShellState();
}

class _ScamGuardShellState extends State<ScamGuardShell> {
  int tab = 0;
  final urlController = TextEditingController();
  final history = <ScanEntry>[
    ScanEntry('netflix.com', 'SAFE', 'Today, 8:41 AM'),
    ScanEntry('secure-login-bankamerica.tk', 'CRITICAL', 'Yesterday, 7:43 PM'),
    ScanEntry('google.com', 'SAFE', 'Monday, 11:10 AM'),
  ];
  String? scanMessage;
  bool? scanIsSafe;

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  void scanUrl() {
    final rawValue = urlController.text.trim();
    if (rawValue.isEmpty) {
      setState(() {
        scanMessage = 'Paste a link first.';
        scanIsSafe = null;
      });
      return;
    }
    final value = rawValue.startsWith(RegExp(r'https?://'))
        ? rawValue
        : 'https://$rawValue';
    final uri = Uri.tryParse(value);
    final host = uri?.host ?? '';
    final validUrl =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        host.contains('.') &&
        !host.contains(' ') &&
        !value.contains(RegExp(r'\s'));
    if (!validUrl) {
      setState(() {
        scanMessage = 'Enter a valid link, such as https://example.com.';
        scanIsSafe = null;
      });
      return;
    }
    final lower = value.toLowerCase();
    final suspicious =
        [
          'login',
          'verify',
          'secure',
          'prize',
          'bank',
          'free',
        ].any(lower.contains) ||
        lower.endsWith('.tk');
    setState(() {
      scanIsSafe = !suspicious;
      scanMessage = suspicious
          ? 'This address contains patterns commonly associated with phishing.'
          : 'No immediate threats were found in this address.';
      history.insert(
        0,
        ScanEntry(value, suspicious ? 'CRITICAL' : 'SAFE', 'Today, now'),
      );
    });
    _showScanResult(value, suspicious);
  }

  void _showScanResult(String value, bool suspicious) {
    if (suspicious) {
      _showFakeUrlSheet(value);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScanReportPage(
          url: value,
          suspicious: suspicious,
          onNavigate: (index) {
            if (!mounted) return;
            Navigator.pop(context);
            setState(() => tab = index);
          },
        ),
      ),
    );
  }

  void _showFakeUrlSheet(String value) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0E1012),
      barrierColor: const Color(0xCC000000),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 54,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF293135),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Container(
                    width: 74,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF293135)),
                    ),
                    child: const Icon(Icons.link_off, color: muted, size: 34),
                  ),
                  const SizedBox(width: 18),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ReportBadge('NOT FOUND'),
                        SizedBox(height: 11),
                        Text(
                          "This URL Doesn't Exist",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  _sheetMetric('N/A', 'RISK SCORE', muted),
                  _sheetMetric('6', 'CHECKS RUN', cyan),
                  _sheetMetric('EMPTY', 'STATUS', muted),
                ],
              ),
              const SizedBox(height: 18),
              _sheetUrl(value),
              const SizedBox(height: 18),
              SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScanReportPage(
                          url: value,
                          suspicious: true,
                          onNavigate: (index) {
                            if (!mounted) return;
                            Navigator.pop(context);
                            setState(() => tab = index);
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25282E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'View Full Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(sheetContext),
                child: const Text('Dismiss', style: TextStyle(color: muted)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetMetric(String value, String label, Color color) => Expanded(
    child: Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF14161B),
        border: Border.all(color: const Color(0xFF20242A)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: muted, fontSize: 8, letterSpacing: 1),
          ),
        ],
      ),
    ),
  );

  Widget _sheetUrl(String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
    decoration: BoxDecoration(
      color: const Color(0xFF14161B),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        const Icon(Icons.link, color: muted, size: 17),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: muted, fontSize: 12),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _page()),
            _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _page() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _topBar(),
            if (tab == 0) _shieldPage(),
            if (tab == 1) _scanPage(),
            if (tab == 2) _historyPage(),
            if (tab == 3) const ProSubscriptionPage(),
          ],
        ),
      ),
    ),
  );

  Widget _topBar() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      RichText(
        text: const TextSpan(
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          children: [
            TextSpan(text: 'SCAM'),
            TextSpan(
              text: 'GUARD',
              style: TextStyle(color: aqua),
            ),
            TextSpan(text: ' AI'),
          ],
        ),
      ),
      GestureDetector(
        onTap: () => setState(() => tab = 3),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF123437),
            border: Border.all(color: const Color(0xFF23696A)),
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Text(
            'UPGRADE',
            style: TextStyle(
              color: aqua,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    ],
  );

  Widget _shieldPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 28),
      _eyebrow('FREE SCANS TODAY', trailing: '2 / 3'),
      _progress(.67),
      const SizedBox(height: 22),
      const Text(
        'Your protection is active.',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 13),
      _card(
        Column(
          children: [
            _sectionTitle('SECURITY SCORE'),
            Row(
              children: [
                _scoreRing(),
                const SizedBox(width: 18),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatText('17', 'Threats blocked', Colors.redAccent),
                      _StatText('284', 'Safe sites', Color(0xFF6BD19A)),
                      _StatText('2.1', 'Avg risk / day', aqua),
                    ],
                  ),
                ),
              ],
            ),
            _bar('Phishing links caught', '87%', .87, Colors.redAccent),
            _bar('Trackers blocked', '92%', .92, aqua),
            _bar('Malware attempts', '22%', .22, aqua),
          ],
        ),
      ),
      _action('Scan a link now', () => setState(() => tab = 1)),
      const SizedBox(height: 13),
      _card(
        Column(
          children: [
            _sectionTitle('RECENT SCANS', trailing: '3 / 3'),
            ...history.take(3).map(_scanRow),
          ],
        ),
      ),
    ],
  );

  Widget _scanPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 28),
      _eyebrow('DEEP LINK INSPECTION'),
      const Text(
        'Scan a Link',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 6),
      const Text(
        'Paste any suspicious link, email URL, or QR destination.',
        style: TextStyle(color: muted, fontSize: 11),
      ),
      const SizedBox(height: 16),
      _card(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionTitle('PASTE A SUSPICIOUS URL'),
            TextField(
              controller: urlController,
              style: const TextStyle(fontSize: 11),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              autocorrect: false,
              enableSuggestions: false,
              onSubmitted: (_) => scanUrl(),
              decoration: _inputDecoration('Paste URL here...'),
            ),
            const SizedBox(height: 12),
            _action('Run security scan', scanUrl),
            if (scanMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: scanIsSafe == true
                      ? const Color(0xFF102D2A)
                      : const Color(0xFF351E23),
                  border: Border.all(
                    color: scanIsSafe == true
                        ? const Color(0xFF24655C)
                        : const Color(0xFF72333A),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  scanMessage!,
                  style: TextStyle(
                    color: scanIsSafe == true
                        ? const Color(0xFF9DE1C9)
                        : const Color(0xFFEE7C82),
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      _card(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionTitle('WHAT WE CHECK'),
            LayoutBuilder(
              builder: (context, constraints) {
                final tileWidth = (constraints.maxWidth - 10) / 2;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    'SSL & HTTPS',
                    'AI Detection',
                    'Domain Age',
                    '40+ Blocklists',
                    'URL Structure',
                    'Redirect Chain',
                  ].map((label) => _checkTile(label, tileWidth)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    ],
  );

  Widget _historyPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 28),
      _eyebrow('YOUR ACTIVITY'),
      const Text(
        'Scan History',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 14),
      _card(
        const Row(
          children: [
            Icon(Icons.lock_outline, color: Color(0xFFE5BD63), size: 15),
            SizedBox(width: 8),
            Text(
              'History locked to 3 entries',
              style: TextStyle(color: Color(0xFFE5BD63), fontSize: 10),
            ),
            Spacer(),
            Text('›', style: TextStyle(color: muted)),
          ],
        ),
      ),
      Row(
        children: [
          _metric('TOTAL', '${history.length}', cyan),
          _metric(
            'SAFE',
            '${history.where((e) => e.status == 'SAFE').length}',
            const Color(0xFF6BD19A),
          ),
          _metric(
            'THREATS',
            '${history.where((e) => e.status == 'CRITICAL').length}',
            Colors.redAccent,
          ),
        ],
      ),
      _card(
        Column(
          children: [_sectionTitle('ALL SCANS'), ...history.map(_scanRow)],
        ),
      ),
    ],
  );

  Widget _proPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 28),
      _eyebrow('SCAMGUARD PRO'),
      const SizedBox(height: 12),
      const Text(
        'Upgrade to Pro and get unlimited scans, full\nthreat reports, and saved history.',
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
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Free trial checkout is ready to connect.'),
            ),
          ),
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

  Widget _bottomNav() => Container(
    padding: const EdgeInsets.fromLTRB(7, 5, 7, 7),
    decoration: const BoxDecoration(
      color: Color(0xF70C1214),
      border: Border(top: BorderSide(color: line)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _navItem(Icons.shield_outlined, 'SHIELD', 0),
        _navItem(Icons.search, 'SCAN', 1),
        _navItem(Icons.history, 'HISTORY', 2),
        _navItem(Icons.star_border, 'PRO', 3),
      ],
    ),
  );
  Widget _navItem(IconData icon, String label, int index) => InkWell(
    onTap: () => setState(() => tab = index),
    child: Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: tab == index ? const Color(0xFF15383B) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: tab == index ? aqua : muted),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: tab == index ? aqua : muted,
              fontSize: 8,
              letterSpacing: .7,
            ),
          ),
        ],
      ),
    ),
  );
  Widget _eyebrow(String text, {String? trailing}) => Row(
    children: [
      Text(
        text,
        style: const TextStyle(color: muted, fontSize: 9, letterSpacing: 1.7),
      ),
      if (trailing != null) ...[
        const Spacer(),
        Text(trailing, style: const TextStyle(color: muted, fontSize: 9)),
      ],
    ],
  );
  Widget _progress(double value) => Container(
    height: 4,
    margin: const EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
      color: const Color(0xFF203134),
      borderRadius: BorderRadius.circular(8),
    ),
    child: FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: value,
      child: Container(
        decoration: BoxDecoration(
          color: aqua,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
  Widget _card(Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: panel,
      border: Border.all(color: line),
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
  Widget _sectionTitle(String title, {String? trailing}) => Row(
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: .5,
        ),
      ),
      if (trailing != null) ...[
        const Spacer(),
        Text(trailing, style: const TextStyle(color: muted, fontSize: 9)),
      ],
    ],
  );
  Widget _scoreRing() => Container(
    width: 108,
    height: 108,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: aqua, width: 8),
      boxShadow: const [BoxShadow(color: Color(0x33123B3C), blurRadius: 22)],
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '87',
          style: TextStyle(
            color: aqua,
            fontSize: 31,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'PROTECTED',
          style: TextStyle(color: muted, fontSize: 7, letterSpacing: 1),
        ),
      ],
    ),
  );
  Widget _bar(String label, String value, double amount, Color color) =>
      Padding(
        padding: const EdgeInsets.only(top: 9),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(color: muted, fontSize: 9)),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                ),
              ],
            ),
            const SizedBox(height: 5),
            LinearProgressIndicator(
              value: amount,
              minHeight: 3,
              backgroundColor: const Color(0xFF223033),
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
  Widget _action(String text, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.only(bottom: 1),
    child: SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: cyan,
          foregroundColor: const Color(0xFF071114),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
  Widget _scanRow(ScanEntry entry) => Container(
    padding: const EdgeInsets.symmetric(vertical: 11),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFF1A2729))),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.url,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFFC7D3D3), fontSize: 10),
              ),
              const SizedBox(height: 4),
              Text(
                entry.time,
                style: const TextStyle(color: muted, fontSize: 8),
              ),
            ],
          ),
        ),
        _status(entry.status),
      ],
    ),
  );
  Widget _status(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
    decoration: BoxDecoration(
      color: text == 'SAFE' ? const Color(0xFF12352D) : const Color(0xFF3A2026),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: text == 'SAFE' ? const Color(0xFF6BD19A) : Colors.redAccent,
        fontSize: 8,
        fontWeight: FontWeight.bold,
        letterSpacing: .7,
      ),
    ),
  );
  Widget _metric(String label, String value, Color color) => Expanded(
    child: Container(
      margin: const EdgeInsets.only(right: 6, bottom: 12),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1214),
        border: Border.all(color: line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: muted, fontSize: 8, letterSpacing: 1),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: muted, fontSize: 11),
    filled: true,
    fillColor: const Color(0xFF0B1214),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF26383B)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF26383B)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );

  Widget _checkTile(String label, double width) => SizedBox(
    width: width,
    child: Container(
      height: 72,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1416),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(color: aqua, fontSize: 17, height: .85),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              height: 1.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Threat analysis',
            style: TextStyle(color: muted, fontSize: 8, height: 1.05),
          ),
        ],
      ),
    ),
  );
}

class _StatText extends StatelessWidget {
  const _StatText(this.value, this.label, this.color);
  final String value;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: muted, fontSize: 9)),
      ],
    ),
  );
}
