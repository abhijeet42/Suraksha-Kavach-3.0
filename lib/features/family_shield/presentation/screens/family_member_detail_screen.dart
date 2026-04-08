import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/family_member.dart';

class FamilyMemberDetailScreen extends StatelessWidget {
  final FamilyMember member;

  const FamilyMemberDetailScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isSafe = member.safetyStatus.name == 'safe';
    final Color statusColor = isSafe ? Colors.greenAccent : Colors.redAccent;
    final String lastSyncText = DateFormat.jm().format(member.lastSync);

    return Scaffold(
      backgroundColor: const Color(0xFF090A0E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white54),
        title: Text('NODE ANALYSIS', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 16)),
        centerTitle: true,
      ),
      body: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
                    color: statusColor.withOpacity(0.05),
                    boxShadow: [
                      BoxShadow(color: statusColor.withOpacity(0.1), blurRadius: 40, spreadRadius: 10),
                    ],
                  ),
                  child: Icon(Icons.person_rounded, size: 80, color: statusColor),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                member.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2),
              ),
              const SizedBox(height: 4),
              Text(
                'ROLE: ${member.role.toUpperCase()}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.5), letterSpacing: 2),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(child: _buildMetric('SCORE', '${100 - member.riskScore}', Icons.score_rounded, Colors.blueAccent)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMetric('ALERTS', '${member.alertsCount}', Icons.warning_rounded, Colors.orangeAccent)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildMetric('SYNCED', lastSyncText, Icons.sync_rounded, Colors.purpleAccent)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMetric('STATUS', isSafe ? 'SAFE' : 'RISK', isSafe ? Icons.check_circle : Icons.gpp_bad, statusColor)),
                ],
              ),

              const SizedBox(height: 48),

              Text('NODE THREAT HISTORY', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white54)),
              const SizedBox(height: 16),
              
              if (member.recentAlerts.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.verified_user_rounded, size: 48, color: Colors.greenAccent.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text('No associated threats on this node.', style: TextStyle(color: Colors.greenAccent.withOpacity(0.5))),
                      ],
                    ),
                  ),
                )
              else
                ...member.recentAlerts.map((alert) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14171E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.bug_report_rounded, color: Colors.redAccent, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(alert.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 4),
                              Text('Severity: High', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5))),
                            ],
                          ),
                        ),
                        Text(DateFormat.jm().format(alert.timestamp), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white.withOpacity(0.3))),
                      ],
                    ),
                  );
                }),
                
                const SizedBox(height: 48),
                
                ElevatedButton.icon(
                  onPressed: () {}, 
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                  label: const Text('DISCONNECT NODE FROM NETWORK'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    foregroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 56),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14171E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 16),
          Text(value, style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.4), letterSpacing: 1)),
        ],
      ),
    );
  }
}
