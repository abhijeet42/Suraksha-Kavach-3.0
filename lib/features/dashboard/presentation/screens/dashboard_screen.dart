import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../sms_detection/providers/sms_stream_provider.dart';
import '../../../history/providers/sms_history_provider.dart';
import '../../../engine_analysis/rule_based/rule_based_analyzer.dart';
// import '../../../../data/models/saved_sms_record.dart'; // Unused here for now

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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Manual Scan'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Paste message or link here...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text;
              if (text.isEmpty) return;
              
              Navigator.pop(ctx);
              
              // Performance manual analysis
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
    final appTheme = Theme.of(context);

    final userName = authProvider.isAdmin ? "Admin" : "Member";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suraksha Kavach'),
        centerTitle: false,
        actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   Icon(Icons.shield_outlined, size: 30, color: appTheme.primaryColor),
                   const Icon(Icons.remove_red_eye, size: 8, color: Colors.red),
                ],
              ),
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeInDown(child: Text('Hello, $userName.', style: appTheme.textTheme.titleLarge?.copyWith(fontSize: 24))),
            const SizedBox(height: 8),
            FadeInDown(delay: const Duration(milliseconds: 200), child: Text('Here is your security status today.', style: appTheme.textTheme.bodyMedium)),
            const SizedBox(height: 24),
            
            FadeInDown(
              delay: const Duration(milliseconds: 400),
              child: Card(
                color: smsProvider.isListening ? Colors.green.withAlpha(20) : Colors.grey.withAlpha(20),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: smsProvider.isListening ? Colors.green : Colors.grey, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Icon(
                        smsProvider.isListening ? Icons.security : Icons.shield_outlined,
                        size: 60,
                        color: smsProvider.isListening ? Colors.green : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              smsProvider.isListening ? 'Protected' : 'Unprotected',
                              style: appTheme.textTheme.titleLarge?.copyWith(
                                color: smsProvider.isListening ? Colors.green : Colors.grey.shade800,
                              ),
                            ),
                             if (!smsProvider.isListening)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: ElevatedButton(
                                  onPressed: () => _requestSmsPermission(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: appTheme.colorScheme.secondary,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(double.infinity, 36)
                                  ),
                                  child: const Text('Enable Protection'),
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Row(
                children: [
                  Expanded(child: _buildStatCard(context, '${historyProvider.totalScams}', 'Scams Blocked', Icons.block, Colors.red)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, '${historyProvider.totalSafe}', 'Safe Messages', Icons.check_circle_outline, Colors.green)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    context, 
                    'Manual Scan', 
                    Icons.biotech, 
                    () => _showManualScanDialog(context)
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionCard(
                    context, 
                    'Report Number', 
                    Icons.report_problem_outlined, 
                    () => DefaultTabController.of(context).animateTo(3) // Assuming report is 3
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            if (authProvider.isAdmin) ...[
              Card(
                color: appTheme.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: const ListTile(
                  leading: Icon(Icons.family_restroom, color: Colors.white),
                  title: Text('Family Safety Overview', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text('All members are currently secure.', style: TextStyle(color: Colors.white70)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(height: 24),
            ],

            const Text('Recent Live Alerts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            
            if (smsProvider.latestMessage != null)
              _buildRiskCard(context, smsProvider)
            else
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('Listening for incoming messages...', style: TextStyle(color: Colors.grey))),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String count, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(count, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskCard(BuildContext context, SmsStreamProvider provider) {
    if (provider.isAnalyzing || provider.latestAnalysis == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Analyzing threat level...'),
            ],
          ),
        ),
      );
    }

    final analysis = provider.latestAnalysis!;
    return Card(
      color: analysis.level.color.withAlpha(25),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: analysis.level.color, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(analysis.level.icon, color: analysis.level.color, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    analysis.level.displayName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: analysis.level.color,
                    ),
                  ),
                ),
                Text(
                  '${analysis.riskScore.toInt()}% Risk',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            Text('Sender: ${provider.latestMessage!.sender}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('"${provider.latestMessage!.message}"', style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            const Text('Flags:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...analysis.flagReasons.map((reason) => Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(reason)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
