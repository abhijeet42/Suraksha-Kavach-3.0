import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';
import 'package:suraksha_kavach/features/family_shield/providers/family_admin_provider.dart';
import 'package:suraksha_kavach/features/auth/providers/auth_provider.dart';
import 'package:suraksha_kavach/features/family_shield/models/family_member.dart';

class FamilyDashboardScreen extends StatefulWidget {
  const FamilyDashboardScreen({super.key});

  @override
  State<FamilyDashboardScreen> createState() => _FamilyDashboardScreenState();
}

class _FamilyDashboardScreenState extends State<FamilyDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FamilyAdminProvider>().startServer();
    });
  }

  void _showQrOverlay(BuildContext context, String payloadJson) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: AlertDialog(
          backgroundColor: const Color(0xFF101216),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(color: Colors.amber.withOpacity(0.3), width: 2),
          ),
          title: Column(
            children: [
              const Icon(Icons.wifi_tethering_rounded, color: Colors.greenAccent, size: 32),
              const SizedBox(height: 8),
              Text(
                l10n.lanPairingActive,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 2, color: Colors.white),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.scanEncryptedNodeDesc,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6), height: 1.5),
              ),
              const SizedBox(height: 32),
              Container(
                width: 260,
                height: 260,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)
                  ],
                ),
                child: QrImageView(
                  data: payloadJson,
                  version: QrVersions.auto,
                  size: 220.0,
                  gapless: false,
                  eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
                  dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.black87),
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.dismissNode, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1, color: Colors.white54)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _triggerEmergencyBroadcast() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(AppLocalizations.of(context)!.emergencyLockBroadcasted)),
          ],
        ),
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSafetyReminder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.security_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(AppLocalizations.of(context)!.safetyReminderDesc)),
          ],
        ),
        backgroundColor: Colors.orangeAccent.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            context.read<FamilyAdminProvider>().dismissSafetyReminder();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<FamilyAdminProvider>();
    
    // Listen for low health score to show notification
    if (adminProvider.shouldShowSafetyReminder) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showSafetyReminder());
    }

    final theme = Theme.of(context);

    // Dynamic stats
    String mostTargeted = "None";
    int highestAlerts = 0;
    for (var m in adminProvider.members) {
      if (m.alertsCount > highestAlerts) {
        highestAlerts = m.alertsCount;
        mostTargeted = m.name;
      }
    }

    final totalBlocked = adminProvider.members.fold(0, (sum, m) => sum + m.alertsCount);

    return Scaffold(
      backgroundColor: const Color(0xFF090A0E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.shieldCommand, style: GoogleFonts.outfit(fontWeight: FontWeight.w900, letterSpacing: 1)),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: adminProvider.isServerRunning ? Colors.greenAccent.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: adminProvider.isServerRunning ? Colors.greenAccent.withOpacity(0.3) : Colors.redAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.circle, size: 8, color: adminProvider.isServerRunning ? Colors.greenAccent : Colors.redAccent),
                const SizedBox(width: 6),
                Text(adminProvider.isServerRunning ? AppLocalizations.of(context)!.nodeOnline : AppLocalizations.of(context)!.offline, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: adminProvider.isServerRunning ? Colors.greenAccent : Colors.redAccent)),
              ],
            ),
          )
        ],
      ),
      body: FadeIn(
        duration: const Duration(milliseconds: 800),
        child: RefreshIndicator(
          onRefresh: () async {
            // Fake refresh for UI feedback
            await Future.delayed(const Duration(milliseconds: 800));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Cyber Score Dashboard
                _buildCyberScoreHeader(context, adminProvider.familyCyberScore, theme),
                
                // 2. Action Buttons & Quick Stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              title: AppLocalizations.of(context)!.addMemberNode,
                              icon: Icons.qr_code_scanner_rounded,
                              color: Colors.amber,
                              onTap: () {
                                final adminName = context.read<AuthProvider>().user?.displayName ?? 'Guardian Admin';
                                var payload = adminProvider.generateQrPayload(adminName);
                                if (payload == null) {
                                  adminProvider.forceFallbackIp();
                                  payload = adminProvider.generateQrPayload(adminName);
                                }
                                if (payload != null) _showQrOverlay(context, payload.toJson());
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionButton(
                              title: AppLocalizations.of(context)!.emergencyLock,
                              icon: Icons.lock_person_rounded,
                              color: Colors.redAccent.shade400,
                              onTap: _triggerEmergencyBroadcast,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Quick Stats
                      Row(
                        children: [
                          Expanded(child: _buildInsightCard(AppLocalizations.of(context)!.activeNodes, '${adminProvider.members.length}', Icons.device_hub_rounded, Colors.blueAccent)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInsightCard(AppLocalizations.of(context)!.scamsBlocked, '$totalBlocked', Icons.shield_rounded, Colors.greenAccent)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInsightCard(AppLocalizations.of(context)!.topTarget, mostTargeted.split(' ').first, Icons.my_location_rounded, Colors.orangeAccent)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Global Telemetry Chart UI
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(AppLocalizations.of(context)!.globalTelemetry, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white54)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14171E),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: adminProvider.members.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Text(AppLocalizations.of(context)!.establishConnectionsDesc, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.3), fontStyle: FontStyle.italic)),
                                ),
                              )
                            : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(AppLocalizations.of(context)!.networkSecurityLoad, style: TextStyle(color: Colors.white.withOpacity(0.5))),
                                      Text(AppLocalizations.of(context)!.optimal, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  LinearProgressIndicator(
                                    value: 0.15,
                                    backgroundColor: Colors.white.withOpacity(0.05),
                                    color: Colors.cyanAccent,
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(AppLocalizations.of(context)!.scamPhishingVolume, style: TextStyle(color: Colors.white.withOpacity(0.5))),
                                      Text(AppLocalizations.of(context)!.optimal, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  LinearProgressIndicator(
                                    value: 0.05,
                                    backgroundColor: Colors.white.withOpacity(0.05),
                                    color: Colors.amberAccent,
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 3. Member Grid / List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.networkNodes, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white54)),
                      const Spacer(),
                      Icon(Icons.edit_rounded, size: 16, color: Colors.white.withOpacity(0.3)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: adminProvider.members.length + 1,
                    itemBuilder: (context, index) {
                      if (index == adminProvider.members.length) {
                        // Add Button
                        return Container(
                          width: 140,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
                                  child: const Icon(Icons.add_rounded, color: Colors.white54),
                                ),
                                const SizedBox(height: 12),
                                Text(AppLocalizations.of(context)!.addNode, style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        );
                      }
                      return _buildMemberCard(context, adminProvider.members[index]);
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // 4. Live Global Feed
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(AppLocalizations.of(context)!.liveThreatFeed, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white54)),
                ),
                const SizedBox(height: 16),
                _buildLiveFeed(adminProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCyberScoreHeader(BuildContext context, int score, ThemeData theme) {
    Color scoreColor = score > 80 ? Colors.greenAccent : (score > 50 ? Colors.orangeAccent : Colors.redAccent);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF14171E),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: scoreColor.withOpacity(0.05), blurRadius: 40, spreadRadius: -10),
        ],
      ),
      child: Stack(
        children: [
          // Reset Button
          Positioned(
            top: 0,
            left: 20,
            child: IconButton(
              onPressed: () {
                context.read<FamilyAdminProvider>().resetRiskScores();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.networkRiskScoresReset), behavior: SnackBarBehavior.floating),
                );
              },
              icon: Icon(Icons.refresh_rounded, color: Colors.white.withOpacity(0.3), size: 20),
              tooltip: AppLocalizations.of(context)!.resetScores,
            ),
          ),
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 12,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      color: scoreColor,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$score',
                        style: GoogleFonts.outfit(fontSize: 56, fontWeight: FontWeight.w900, color: Colors.white, height: 1.0),
                      ),
                      Text(AppLocalizations.of(context)!.outOf100, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.4), letterSpacing: 2)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.health_and_safety_rounded, color: scoreColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${AppLocalizations.of(context)!.networkHealth}: ${score > 80 ? AppLocalizations.of(context)!.optimal : (score > 50 ? AppLocalizations.of(context)!.warning : AppLocalizations.of(context)!.critical)}',
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w900, color: scoreColor, letterSpacing: 1.5),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton({required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF14171E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.4))),
        ],
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, FamilyMember member) {
    final bool isSafe = member.safetyStatus.name == 'safe';
    final Color statusColor = isSafe ? Colors.greenAccent : Colors.orangeAccent;

    return GestureDetector(
      onTap: () {
        context.push('/member-detail', extra: member);
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF14171E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            if (!isSafe) BoxShadow(color: statusColor.withOpacity(0.1), blurRadius: 20),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.person_outline_rounded, color: Colors.blueAccent, size: 20),
                ),
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: statusColor, blurRadius: 4)]),
                )
              ],
            ),
            const Spacer(),
            Text(member.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 4),
            Text(member.role.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white.withOpacity(0.4), letterSpacing: 1)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shield_rounded, size: 10, color: Colors.white54),
                  const SizedBox(width: 4),
                  Text('Score: ${100 - member.riskScore}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLiveFeed(FamilyAdminProvider adminProvider) {
    // Gather all alerts from all members, sort chronologically
    List<Map<String, dynamic>> allAlerts = [];
    for (var m in adminProvider.members) {
      for (var a in m.recentAlerts) {
        allAlerts.add({'member': m.name, 'alert': a});
      }
    }
    allAlerts.sort((a, b) => b['alert'].timestamp.compareTo(a['alert'].timestamp));

    if (allAlerts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text('Log clears. No threats intercepted recently.', 
            style: TextStyle(color: Colors.white.withOpacity(0.3), fontStyle: FontStyle.italic)),
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: allAlerts.length,
      itemBuilder: (context, index) {
        final alertData = allAlerts[index];
        final alert = alertData['alert'];
        final memberName = alertData['member'];
        final timeFormat = DateFormat.jm().format(alert.timestamp);

        return SlideInUp(
          duration: Duration(milliseconds: 400 + (index * 100)),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: const Border(left: BorderSide(color: Colors.redAccent, width: 4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.gpp_bad_rounded, color: Colors.redAccent, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alert.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Target: $memberName', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5))),
                    ],
                  ),
                ),
                Text(timeFormat, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white.withOpacity(0.3))),
              ],
            ),
          ),
        );
      },
    );
  }
}
