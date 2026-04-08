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

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _requestSmsPermission(BuildContext context) async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      if (context.mounted) {
        context.read<SmsStreamProvider>().startListening();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SMS Shield Active and Listening!')),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission Denied. Cannot protect SMS.')),
        );
      }
    }
  }

  void _showManualScanDialog(BuildContext context) {
    final controller = TextEditingController();
    final ocrService = OcrService();
    bool useHindi = false;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Manual Scan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Hindi Support', style: TextStyle(fontSize: 12)),
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
                    hintText: 'Paste message or link here...',
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
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                final text = controller.text;
                if (text.isEmpty) return;
                
                Navigator.pop(ctx);
                
                final analyzer = RuleBasedAnalyzer();
                final result = await analyzer.analyze(SmsMessageData(
                  sender: 'Manual Scan',
                  message: text,
                  timestamp: DateTime.now().millisecondsSinceEpoch,
                ));

                if (context.mounted) {
                  _showAnalysisResultDialog(context, text, result);
                }
              }, 
              child: const Text('Analyze'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnalysisResultDialog(BuildContext context, String text, dynamic result) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(result.level.displayName, style: TextStyle(color: result.level.color)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Score: ${result.riskScore.toInt()}% Risk'),
            const SizedBox(height: 16),
            const Text('Flags:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...result.flagReasons.map((f) => Text('• $f')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final smsProvider = context.watch<SmsStreamProvider>();
    final historyProvider = context.watch<SmsHistoryProvider>();
    final theme = Theme.of(context);

    final userName = authProvider.isAdmin ? "Admin" : "Member";

    return Scaffold(
      appBar: AppBar(
        title: const Text('SURAKSHA KAVACH'),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.shield_rounded, color: theme.primaryColor),
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
                'Hello, $userName.',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your digital shield is actively monitoring.',
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 15),
              ),
              const SizedBox(height: 32),
              
              _buildSecurityStatusCard(context, smsProvider, theme),
              
              const SizedBox(height: 32),
              
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, '${historyProvider.totalScams}', 'Scams Blocked', Icons.block_rounded, Colors.redAccent)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, '${historyProvider.totalSafe}', 'Safe Messages', Icons.check_circle_rounded, Colors.greenAccent)),
                ],
              ),
              
              const SizedBox(height: 32),

              const Text('QUICK ACTIONS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1, color: Colors.white38)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context, 
                      'Manual Scan', 
                      Icons.qr_code_scanner_rounded, 
                      () => _showManualScanDialog(context)
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickActionCard(
                      context, 
                      'Report', 
                      Icons.flag_rounded, 
                      () => DefaultTabController.of(context).animateTo(3)
                    ),
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
                    title: const Text('Family Security', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
                    subtitle: const Text('3 members protected', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 14),
                    onTap: () => context.go('/family-dashboard'),
                  ),
                ),
                const SizedBox(height: 32),
              ],

              const Text('LIVE ALERTS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1, color: Colors.white38)),
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
                          'No threats detected recently.\nMonitoring in real-time...',
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
                    isActive ? 'Shield Active' : 'Shield Inactive',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: isActive ? Colors.greenAccent : Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive ? 'Live scanning enabled' : 'System unprotected',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
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
                        child: const Text('Enable Now'),
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
    if (provider.isAnalyzing || provider.latestAnalysis == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const CircularProgressIndicator(strokeWidth: 2),
              const SizedBox(height: 20),
              Text('Analyzing threat level...', style: TextStyle(color: Colors.white.withOpacity(0.3))),
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
}
