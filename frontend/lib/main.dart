import 'package:flutter/material.dart';

void main(){
  runApp(const ScamGuardApp());
}

const muted = Color(0xFF718083);
const aqua = Color(0xFF53D8D0);
const cyan = Color(0xFF49BFDF);
const panel = Color(0xFF101719);
const line = Color(0xFF1D2A2D);

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
      home: const ScamGuardShell(),
    );
  }
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
    final value = urlController.text.trim();
    if (value.isEmpty) {
      setState(() => scanMessage = 'Paste a URL first.');
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
  }

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
            if (tab == 3) _proPage(),
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
      Container(
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
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            colors: [Color(0xFF16575A), Color(0xFF0E1517)],
            radius: 1.1,
          ),
          border: Border.all(color: const Color(0xFF235254)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Icon(Icons.shield_outlined, color: aqua, size: 38),
            const SizedBox(height: 12),
            const Text(
              'Total Protection,',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Zero Limits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 9),
            const Text(
              'Upgrade to Pro for unlimited scans, full threat reports, and saved history.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted, fontSize: 10),
            ),
            const SizedBox(height: 15),
            const Text(
              '\$1.49',
              style: TextStyle(
                color: Color(0xFFF0C96D),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('/ month', style: TextStyle(color: muted, fontSize: 9)),
          ],
        ),
      ),
      const SizedBox(height: 12),
      _action(
        'Upgrade to Pro',
        () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pro checkout is ready to connect.')),
        ),
      ),
      _card(
        Column(
          children: [
            _sectionTitle('INCLUDED WITH PRO'),
            ...[
              ['UNLIMITED SCANS', 'No daily scan limit'],
              ['FULL THREAT REPORT', 'AI risk breakdown'],
              ['SAVED SCAN HISTORY', 'Never lose a result'],
              ['REAL-TIME ALERTS', 'Know when a threat is found'],
            ].map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.check_circle_outline,
                  color: aqua,
                  size: 18,
                ),
                title: Text(
                  item[0],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  item[1],
                  style: const TextStyle(color: muted, fontSize: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
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
