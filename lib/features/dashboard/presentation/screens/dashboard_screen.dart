import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:suraksha_kavach/features/auth/providers/auth_provider.dart';
import 'package:suraksha_kavach/features/sms_detection/providers/sms_stream_provider.dart';
import 'package:suraksha_kavach/features/history/providers/sms_history_provider.dart';
import 'package:suraksha_kavach/features/engine_analysis/rule_based/rule_based_analyzer.dart';
import 'package:suraksha_kavach/features/ocr/services/ocr_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suraksha_kavach/features/family_shield/providers/family_admin_provider.dart';
import 'package:suraksha_kavach/features/family_shield/providers/family_member_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $launchUri');
    }
  }

  void _showBlockInstructions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.blockScam),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.blockScam),
            const SizedBox(height: 12),
            Text(l10n.blockStep1),
            Text(l10n.blockStep2),
            Text(l10n.blockStep3),
            const SizedBox(height: 12),
            Text(l10n.blockNote),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Open dialer as a shortcut
              final Uri launchUri = Uri(scheme: 'tel');
              launchUrl(launchUri);
            },
            child: Text(l10n.openDialer),
          ),
        ],
      ),
    );
  }

  Future<void> _requestSmsPermission(BuildContext context) async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      if (context.mounted) {
        context.read<SmsStreamProvider>().startListening();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.smsShieldActive)),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.permissionDenied)),
        );
      }
    }
  }

  void _showManualScanDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final ocrService = OcrService();
    bool useHindi = false;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.manualScan),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(l10n.hindiSupport, style: const TextStyle(fontSize: 12)),
                  const Spacer(),
                  Switch(
                    value: useHindi,
                    onChanged: (val) => setState(() => useHindi = val),
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                )
              else
                TextField(
                  controller: controller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: l10n.pasteMessageHint,
                    border: const OutlineInputBorder(),
                    suffixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera_alt_rounded),
                          onPressed: () async {
                            setState(() => isLoading = true);
                            final image = await ocrService.captureImageWithCamera();
                            if (image != null) {
                              final text = await ocrService.extractTextFromImage(image, useDevanagari: useHindi);
                              if (text != null) controller.text = text;
                            }
                            setState(() => isLoading = false);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.image_search_rounded),
                          onPressed: () async {
                            setState(() => isLoading = true);
                            final image = await ocrService.pickImageFromGallery();
                            if (image != null) {
                              final text = await ocrService.extractTextFromImage(image, useDevanagari: useHindi);
                              if (text != null) controller.text = text;
                            }
                            setState(() => isLoading = false);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                final text = controller.text;
                if (text.isEmpty) return;
                
                setState(() => isLoading = true);
                
                final analyzer = RuleBasedAnalyzer();
                final result = await analyzer.analyze(SmsMessageData(
                  sender: 'Manual Scan',
                  message: text,
                  timestamp: DateTime.now().millisecondsSinceEpoch,
                ));

                setState(() => isLoading = false);
                if (context.mounted) {
                  Navigator.pop(ctx);
                  _showAnalysisResultDialog(context, text, result);
                }
              }, 
              child: Text(l10n.analyze),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnalysisResultDialog(BuildContext context, String text, dynamic result) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => ZoomIn(
        child: AlertDialog(
          backgroundColor: const Color(0xFF101216),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(color: result.level.color.withOpacity(0.3), width: 2),
          ),
          title: Row(
            children: [
              Icon(result.level.icon, color: result.level.color),
              const SizedBox(width: 12),
              Text(
                result.level.displayName.toUpperCase(),
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: result.level.color, letterSpacing: 1),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text('"$text"', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white70, fontSize: 13)),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.threatScore, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white38)),
                  Text('${result.riskScore.toInt()}%', style: TextStyle(fontWeight: FontWeight.w900, color: result.level.color)),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: result.riskScore / 100,
                backgroundColor: Colors.white.withOpacity(0.05),
                color: result.level.color,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 24),
              Text(l10n.heuristicFlags, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white38)),
              const SizedBox(height: 8),
              ...result.flagReasons.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Colors.white54)),
                    Expanded(child: Text(f, style: const TextStyle(fontSize: 12, color: Colors.white70))),
                  ],
                ),
              )),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.dismissAnalysis, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white54)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final smsProvider = context.watch<SmsStreamProvider>();
    final historyProvider = context.watch<SmsHistoryProvider>();
    final adminProvider = context.watch<FamilyAdminProvider>();
    final memberProvider = context.watch<FamilyMemberProvider>();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final userName = authProvider.isAdmin ? "Admin" : "Member";

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
            }, 
            icon: const Icon(Icons.logout_rounded, color: Colors.white54),
            tooltip: l10n.logout,
          ),
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.shield_rounded, color: theme.primaryColor),
            tooltip: l10n.securityStatus,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.hello(authProvider.user?.displayName ?? userName),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.digitalShieldActive,
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 15),
              ),
              const SizedBox(height: 32),
              
              _buildSecurityStatusCard(context, smsProvider, theme),
              
              const SizedBox(height: 32),
              
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, '${historyProvider.totalScams}', l10n.scamsBlocked, Icons.block_rounded, Colors.redAccent)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, '${historyProvider.totalSafe}', l10n.safeMessages, Icons.check_circle_rounded, Colors.greenAccent)),
                ],
              ),
              
              const SizedBox(height: 32),

              Text(l10n.quickActions, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1, color: Colors.white38)),
              const SizedBox(height: 16),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          context, 
                          l10n.manualScan, 
                          Icons.qr_code_scanner_rounded, 
                          () => _showManualScanDialog(context)
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildQuickActionCard(
                          context, 
                          l10n.cyberReport, 
                          Icons.gavel_rounded, 
                          () => _launchURL('https://cybercrime.gov.in/')
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          context, 
                          l10n.callHelpline, 
                          Icons.phone_in_talk_rounded, 
                          () => _makeCall('1930')
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildQuickActionCard(
                          context, 
                          l10n.blockScam, 
                          Icons.block_rounded, 
                          () => _showBlockInstructions(context)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              if (authProvider.isAdmin) ...[
                Card(
                  color: theme.primaryColor,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: const Icon(Icons.family_restroom_rounded, color: Colors.black),
                    title: Text(l10n.familySecurity, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
                    subtitle: Text(l10n.membersProtected(adminProvider.members.length.toString()), style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 14),
                    onTap: () => context.go('/family-dashboard'),
                  ),
                ),
                const SizedBox(height: 32),
              ] else ...[
                Card(
                  color: memberProvider.isConnected ? Colors.greenAccent.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: memberProvider.isConnected ? Colors.greenAccent.withOpacity(0.5) : Colors.redAccent.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Icon(memberProvider.isConnected ? Icons.wifi_rounded : Icons.wifi_off_rounded, color: memberProvider.isConnected ? Colors.greenAccent : Colors.redAccent),
                    title: Text(memberProvider.isConnected ? l10n.connectedTo(memberProvider.connectedFamily?.adminName ?? 'Admin') : l10n.notConnectedToFamily, style: TextStyle(color: memberProvider.isConnected ? Colors.greenAccent : Colors.white, fontWeight: FontWeight.w900)),
                    subtitle: Text(l10n.familyCyberScore(memberProvider.familyScore.toString()), style: TextStyle(color: Colors.white.withOpacity(0.6))),
                    trailing: !memberProvider.isConnected ? TextButton(onPressed: () => context.push('/user-pairing'), child: Text(l10n.joinNow)) : null,
                  ),
                ),
                if (memberProvider.isConnected)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ElevatedButton.icon(
                      onPressed: () => memberProvider.sendMockHackathonAlert(),
                      icon: const Icon(Icons.bug_report_rounded),
                      label: Text(l10n.demoSendAlert),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.2), foregroundColor: Colors.redAccent),
                    ),
                  ),
              ],
              
              const SizedBox(height: 32),
              const UrlDefenderSection(),
              const SizedBox(height: 32),

              Text(l10n.liveAlerts, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1, color: Colors.white38)),
              const SizedBox(height: 16),
              
              if (smsProvider.latestMessage != null)
                _buildRiskCard(context, smsProvider)
              else
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color?.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.radar_rounded, color: theme.primaryColor.withOpacity(0.3), size: 48),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noThreatsDetected,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityStatusCard(BuildContext context, SmsStreamProvider provider, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final isActive = provider.isListening;
    return Card(
      color: isActive ? Colors.greenAccent.withOpacity(0.05) : theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: isActive ? Colors.greenAccent.withOpacity(0.2) : Colors.white.withOpacity(0.05), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Icon(
              isActive ? Icons.verified_user_rounded : Icons.gpp_maybe_rounded,
              size: 56,
              color: isActive ? Colors.greenAccent : Colors.white24,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isActive ? l10n.shieldActive : l10n.shieldInactive,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: isActive ? Colors.greenAccent : Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive ? l10n.liveScanningEnabled : l10n.systemUnprotected,
                    style: const TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                  if (!isActive)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: () => _requestSmsPermission(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white10,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 40),
                        ),
                        child: Text(l10n.enableNow),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String count, String label, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(count, style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white38)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 32),
              const SizedBox(height: 12),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildRiskCard(BuildContext context, SmsStreamProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    if (provider.isAnalyzing || provider.latestAnalysis == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const CircularProgressIndicator(strokeWidth: 2),
              const SizedBox(height: 20),
              Text(l10n.analyzingThreatLevel, style: TextStyle(color: Colors.white.withOpacity(0.3))),
            ],
          ),
        ),
      );
    }

    final analysis = provider.latestAnalysis!;
    return Card(
      color: analysis.level.color.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: analysis.level.color.withOpacity(0.3), width: 1.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(analysis.level.icon, color: analysis.level.color, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    analysis.level.displayName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: analysis.level.color,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: analysis.level.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${analysis.riskScore.toInt()}%',
                    style: TextStyle(fontWeight: FontWeight.w900, color: analysis.level.color, fontSize: 12),
                  ),
                ),
              ],
            ),
            const Divider(height: 48, color: Colors.white10),
            Text('SENDER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white.withOpacity(0.3), letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(provider.latestMessage!.sender, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 20),
            Text('MESSAGE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white.withOpacity(0.3), letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(provider.latestMessage!.message, style: const TextStyle(height: 1.4, fontSize: 15)),
            const SizedBox(height: 24),
            Text('REASONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white.withOpacity(0.3), letterSpacing: 1)),
            const SizedBox(height: 8),
            ...analysis.flagReasons.map((reason) => Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: CircleAvatar(radius: 2, backgroundColor: analysis.level.color),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(reason, style: const TextStyle(fontSize: 13, color: Colors.white70))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
} // End of DashboardScreen

class UrlDefenderSection extends StatefulWidget {
  const UrlDefenderSection({super.key});

  @override
  State<UrlDefenderSection> createState() => _UrlDefenderSectionState();
}

class _UrlDefenderSectionState extends State<UrlDefenderSection> {
  final TextEditingController _urlController = TextEditingController();
  bool _isScanning = false;
  Map<String, dynamic>? _scanResult;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    if (_urlController.text.isEmpty) return;
    setState(() {
      _isScanning = true;
      _scanResult = null;
    });

    // Realistic scanning simulation
    await Future.delayed(const Duration(seconds: 2));

    final url = _urlController.text.toLowerCase();
    double score = 0;
    List<String> flags = [];

    if (!url.startsWith('https://')) {
      score += 35;
      flags.add('Insecure connection (No HTTPS/SSL)');
    }
    if (url.contains('bit.ly') || url.contains('t.co') || url.contains('tinyurl') || url.contains('short.url')) {
      score += 40;
      flags.add('URL shortener detected (Common phishing tactic)');
    }
    if (RegExp(r'\.zip|\.mov|\.top|\.tk|\.ml|\.ga|\.cf|\.gq|\.app|\.icu').hasMatch(url)) {
      score += 55;
      flags.add('Suspicious TLD pattern detected');
    }
    if (RegExp(r'verify|login|bank|account|update|gift|prize|cash|claim').hasMatch(url)) {
      score += 25;
      flags.add('Contains high-risk transaction keywords');
    }

    if (score > 100) score = 100;

    if (mounted) {
      setState(() {
        _isScanning = false;
        _scanResult = {
          'score': score,
          'flags': flags,
          'isSafe': score < 30,
          'isSuspicious': score >= 30 && score < 70,
          'isMalicious': score >= 70,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: const Color(0xFF14171E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.language_rounded, color: theme.primaryColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text('URL DEFENDER', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Paste suspicious link here...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.1)),
                filled: true,
                fillColor: Colors.black.withOpacity(0.2),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isScanning ? null : _startScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('START SECURITY SCAN', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
            ),
            if (_isScanning)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Column(
                  children: [
                    const LinearProgressIndicator(color: Colors.cyanAccent, backgroundColor: Colors.white10, minHeight: 2),
                    const SizedBox(height: 12),
                    Text('INTERROGATING URL REPUTATION...', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4), letterSpacing: 2, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            if (_scanResult != null)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: (_scanResult!['isSafe'] ? Colors.greenAccent : (_scanResult!['isSuspicious'] ? Colors.orangeAccent : Colors.redAccent)).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: (_scanResult!['isSafe'] ? Colors.greenAccent : (_scanResult!['isSuspicious'] ? Colors.orangeAccent : Colors.redAccent)).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _scanResult!['isSafe'] ? Icons.verified_rounded : (_scanResult!['isSuspicious'] ? Icons.warning_rounded : Icons.gpp_maybe_rounded),
                              color: _scanResult!['isSafe'] ? Colors.greenAccent : (_scanResult!['isSuspicious'] ? Colors.orangeAccent : Colors.redAccent),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _scanResult!['isSafe'] ? 'URL: SECURE' : (_scanResult!['isSuspicious'] ? 'URL: SUSPICIOUS' : 'URL: MALICIOUS'),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: _scanResult!['isSafe'] ? Colors.greenAccent : (_scanResult!['isSuspicious'] ? Colors.orangeAccent : Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                        if (_scanResult!['flags'].isNotEmpty) ...[
                          const SizedBox(height: 16),
                          ..._scanResult!['flags'].map<Widget>((f) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                const Text('• ', style: TextStyle(color: Colors.white24)),
                                Expanded(child: Text(f, style: const TextStyle(fontSize: 12, color: Colors.white70))),
                              ],
                            ),
                          )),
                        ] else if (_scanResult!['isSafe'])
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text('No immediate threats detected in this URL pattern.', style: TextStyle(fontSize: 12, color: Colors.white60)),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
