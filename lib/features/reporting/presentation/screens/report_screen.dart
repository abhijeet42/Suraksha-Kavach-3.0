import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';
import '../../providers/threat_provider.dart';
import '../../../../data/models/threat_report.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final threatProvider = context.watch<ThreatProvider>();
    final dateFormat = DateFormat('HH:mm:ss');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.liveThreatFeed)),
      body: Column(
        children: [
          // Threat Map / Radar Section
          _buildRadarSection(theme, l10n),
          
          const Divider(height: 1, color: Colors.white10),
          
          // Live Feed Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Row(
              children: [
                Pulse(
                  infinite: true,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.liveThreatFeed.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.white54,
                  ),
                ),
                const Spacer(),
                Text(
                  '${threatProvider.threats.length} NODES LOGGED',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
                ),
              ],
            ),
          ),

          // Threat Feed List
          Expanded(
            child: threatProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : threatProvider.threats.isEmpty
                    ? _buildEmptyFeed(l10n)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: threatProvider.threats.length,
                        itemBuilder: (context, index) {
                          final threat = threatProvider.threats[index];
                          return FadeInUp(
                            duration: const Duration(milliseconds: 400),
                            delay: Duration(milliseconds: index * 50),
                            child: _buildThreatItem(threat, dateFormat, theme),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarSection(ThemeData theme, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.cyan.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Radar Rings
              ...List.generate(3, (index) => 
                _buildRadarRing(index + 1),
              ),
              // Center Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyanAccent.withOpacity(0.1),
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3), width: 2),
                ),
                child: const Icon(Icons.radar_rounded, size: 48, color: Colors.cyanAccent),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.communityShield,
            style: GoogleFonts.orbitron(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              letterSpacing: 4,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ACTIVE GLOBAL ANALYTICS MESH',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: Colors.cyanAccent.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarRing(int factor) {
    return Pulse(
      infinite: true,
      duration: Duration(seconds: 2 * factor),
      child: Container(
        width: 100.0 * factor,
        height: 100.0 * factor,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.1 / factor), width: 1),
        ),
      ),
    );
  }

  Widget _buildThreatItem(ThreatReport threat, DateFormat dateFormat, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: threat.riskLevel.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(threat.riskLevel.icon, color: threat.riskLevel.color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      threat.sender,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                    ),
                    Text(
                      dateFormat.format(threat.timestamp),
                      style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  threat.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 10, color: Colors.cyanAccent.withOpacity(0.5)),
                    const SizedBox(width: 4),
                    Text(
                      threat.location.toUpperCase(),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.cyanAccent.withOpacity(0.5)),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.person_outline_rounded, size: 10, color: Colors.white24),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'BY ${threat.reportedBy.toUpperCase()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFeed(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, size: 64, color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 16),
          Text(
            'LOG CLEAR. NO RECENT THREATS.',
            style: TextStyle(color: Colors.white.withOpacity(0.2), fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}
// Note: The above extensions are just to prevent red squiggles in some IDEs if animate_do was used differently, 
// but since we are using animate_do, Pulse and FadeInUp work fine. 
// I'll rewrite the red pulsating dot to use animate_do's Pulse.
