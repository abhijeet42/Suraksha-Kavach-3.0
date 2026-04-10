// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SURAKSHA KAVACH';

  @override
  String hello(String name) {
    return 'Hello, $name.';
  }

  @override
  String get digitalShieldActive =>
      'Your digital shield is actively monitoring.';

  @override
  String get shieldActive => 'Shield Active';

  @override
  String get shieldInactive => 'Shield Inactive';

  @override
  String get liveScanningEnabled => 'Live scanning enabled';

  @override
  String get systemUnprotected => 'System unprotected';

  @override
  String get enableNow => 'Enable Now';

  @override
  String get scamsBlocked => 'Scams Blocked';

  @override
  String get safeMessages => 'Safe Messages';

  @override
  String get quickActions => 'QUICK ACTIONS';

  @override
  String get manualScan => 'Manual Scan';

  @override
  String get cyberReport => 'Cyber Report';

  @override
  String get callHelpline => 'Call Helpline';

  @override
  String get blockScam => 'Block Scam';

  @override
  String get familySecurity => 'Family Security';

  @override
  String get liveAlerts => 'LIVE ALERTS';

  @override
  String get noThreatsDetected =>
      'No threats detected recently.\nMonitoring in real-time...';

  @override
  String get settings => 'Settings';

  @override
  String get galaxyThemes => 'Galaxy Themes';

  @override
  String get appPreferences => 'App Preferences';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get voiceAlerts => 'Voice Alerts (Accessibility)';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get cancel => 'Cancel';

  @override
  String get areYouSureLogout =>
      'Are you sure you want to disconnect your digital shield?';

  @override
  String get hindiSupport => 'Hindi Support';

  @override
  String get analyze => 'Analyze';

  @override
  String get threatScore => 'THREAT SCORE';

  @override
  String get heuristicFlags => 'HEURISTIC FLAGS';

  @override
  String get dismissAnalysis => 'DISMISS ANALYSIS';

  @override
  String get indiasCybershield => 'INDIA\'S CYBER SHIELD';

  @override
  String get initializingMesh => 'INITIALIZING SECURE MESH';

  @override
  String get welcomeToApp => 'Welcome to Suraksha Kavach';

  @override
  String get chooseEntryPoint =>
      'Choose your entry point to the secure ecosystem.';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get adminPanelDesc =>
      'Create a family group, generate invite codes, and monitor family safety.';

  @override
  String get userPanel => 'User Panel';

  @override
  String get userPanelDesc =>
      'Join a family group and protect your device from phishing scams.';

  @override
  String get adminPortal => 'Admin Portal';

  @override
  String get userPortal => 'User Portal';

  @override
  String get chooseMethod => 'CHOOSE METHOD';

  @override
  String get welcomeBack => 'WELCOME BACK';

  @override
  String get getStarted => 'GET STARTED';

  @override
  String get howToVerify => 'How would you like to verify your identity?';

  @override
  String get adminAuthDesc =>
      'Secure access to your family guard command center.';

  @override
  String get userAuthDesc =>
      'Join your family network for real-time protection.';

  @override
  String get login => 'LOG IN';

  @override
  String get loginDesc => 'Access your existing account securely.';

  @override
  String get register => 'REGISTER';

  @override
  String get registerDesc => 'Create a new security node for your family.';

  @override
  String get phoneNumber => 'PHONE NUMBER';

  @override
  String get phoneDesc => 'Verify using a secure SMS OTP code.';

  @override
  String get emailAddress => 'EMAIL ADDRESS';

  @override
  String get emailDesc => 'Secure authentication via email verification.';

  @override
  String get goBack => 'GO BACK';

  @override
  String get secureAccount => 'SECURE ACCOUNT';

  @override
  String get systemLogin => 'SYSTEM LOGIN';

  @override
  String get enterPhone =>
      'Enter your phone number to receive a secure access token.';

  @override
  String get getOtp => 'GET SECURE OTP';

  @override
  String get alreadyRegistered => 'ALREADY REGISTERED? LOGIN';

  @override
  String get newAdmin => 'NEW ADMIN? CREATE ACCOUNT';

  @override
  String get verifyOtp => 'VERIFY OTP';

  @override
  String enterOtp(Object digits) {
    return 'Enter the $digits-digit code sent to your device.';
  }

  @override
  String get resend => 'RESEND';

  @override
  String get verify => 'VERIFY';

  @override
  String get profileSetup => 'PROFILE SETUP';

  @override
  String get tellAboutSelf => 'TELL US ABOUT YOURSELF';

  @override
  String get fullName => 'FULL NAME';

  @override
  String get completeSetup => 'COMPLETE SETUP';

  @override
  String get joinFamily => 'JOIN FAMILY';

  @override
  String get enterInviteCode => 'ENTER INVITE CODE';

  @override
  String get join => 'JOIN';

  @override
  String get scamHistory => 'SCAM HISTORY';

  @override
  String get noHistory => 'NO HISTORY YET';

  @override
  String get messageDetail => 'MESSAGE DETAILS';

  @override
  String get sender => 'SENDER';

  @override
  String get message => 'MESSAGE';

  @override
  String get familyDashboard => 'FAMILY DASHBOARD';

  @override
  String get protectedMembers => 'PROTECTED MEMBERS';

  @override
  String get addMember => 'ADD MEMBER';

  @override
  String get inviteCode => 'INVITE CODE';

  @override
  String get reportScam => 'REPORT SCAM';

  @override
  String get describeScam => 'DESCRIBE THE SCAM';

  @override
  String get submitReport => 'SUBMIT REPORT';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get faq => 'FAQ';

  @override
  String get notifications => 'Notifications';

  @override
  String get updateName => 'UPDATE NAME';

  @override
  String get saveChanges => 'SAVE CHANGES';

  @override
  String get enterEmail => 'ENTER EMAIL';

  @override
  String get emailVerificationDesc =>
      'We will send a secure verification code to your inbox.';

  @override
  String get getVerificationCode => 'GET VERIFICATION CODE';

  @override
  String get verifyAccess => 'VERIFY ACCESS';

  @override
  String get authToken => 'AUTH TOKEN';

  @override
  String get authorizeAccess => 'AUTHORIZE ACCESS';

  @override
  String get resendToken => 'RESEND TOKEN';

  @override
  String get whatIsYourName => 'WHAT IS YOUR NAME?';

  @override
  String get nameIdentifyDesc =>
      'This name will identify your device in the family network.';

  @override
  String get enterDisplayName => 'Enter Display Name';

  @override
  String get scanAdminQr => 'SCAN ADMIN QR';

  @override
  String get familyPairing => 'FAMILY PAIRING';

  @override
  String get pairDevice => 'PAIR DEVICE';

  @override
  String get joinFamilyDesc =>
      'Join a family group to enable shared threat intelligence and protected scanning.';

  @override
  String get scanQrCode => 'SCAN ADMIN QR CODE';

  @override
  String get orEnterManually => 'OR ENTER MANUALLY';

  @override
  String get joinFamilyGroup => 'JOIN FAMILY GROUP';

  @override
  String get jsonPayloadLabel => 'JSON PAYLOAD (HACKATHON OVERRIDE)';

  @override
  String get threatLogs => 'THREAT LOGS';

  @override
  String get searchSenderHint => 'Search sender or message keywords...';

  @override
  String get filterAll => 'ALL';

  @override
  String get filterScam => 'SCAM';

  @override
  String get filterSuspicious => 'SUSPICIOUS';

  @override
  String get filterSafe => 'SAFE';

  @override
  String get noMatchingThreats => 'No matching threat logs.';

  @override
  String get threatAnalysis => 'THREAT ANALYSIS';

  @override
  String riskScore(Object score) {
    return '$score% RISK SCORE';
  }

  @override
  String get senderOrigin => 'SENDER ORIGIN';

  @override
  String get timeReceived => 'TIME RECEIVED';

  @override
  String get messageBody => 'MESSAGE BODY';

  @override
  String get aiIntelligenceFlags => 'AI INTELLIGENCE FLAGS';

  @override
  String get reportToDatabase => 'REPORT TO DATABASE';

  @override
  String get deleteFromHistory => 'DELETE FROM HISTORY';

  @override
  String get shieldCommand => 'SHIELD COMMAND';

  @override
  String get nodeOnline => 'NODE ONLINE';

  @override
  String get offline => 'OFFLINE';

  @override
  String get addMemberNode => 'ADD MEMBER NODE';

  @override
  String get emergencyLock => 'EMERGENCY LOCK';

  @override
  String get activeNodes => 'Active Nodes';

  @override
  String get topTarget => 'Top Target';

  @override
  String get globalTelemetry => 'GLOBAL TELEMETRY';

  @override
  String get networkNodes => 'NETWORK NODES';

  @override
  String get liveThreatFeed => 'LIVE THREAT INTELLIGENCE FEED';

  @override
  String get outOf100 => 'OUT OF 100';

  @override
  String get networkHealth => 'NETWORK HEALTH';

  @override
  String get optimal => 'OPTIMAL';

  @override
  String get warning => 'WARNING';

  @override
  String get critical => 'CRITICAL';

  @override
  String get addNode => 'Add Node';

  @override
  String get networkSecurityLoad => 'Network Security Load';

  @override
  String get scamPhishingVolume => 'Scam/Phishing Volume';

  @override
  String get establishConnectionsDesc =>
      'Establish node connections to activate telemetry array.';

  @override
  String get lanPairingActive => 'LAN PAIRING ACTIVE';

  @override
  String get scanEncryptedNodeDesc =>
      'Tell your family member to open \"Suraksha Kavach\" -> \"User Panel\" and scan this encrypted node key.';

  @override
  String get dismissNode => 'DISMISS NODE';

  @override
  String get emergencyLockBroadcasted =>
      'Emergency lock signal broadcasted to all active nodes!';

  @override
  String get safetyReminderDesc =>
      'SAFETY REMINDER: Family Network Health is below 50%. Focus on increasing security!';

  @override
  String get networkRiskScoresReset => 'Network Risk Scores Reset';

  @override
  String get resetScores => 'Reset Scores';

  @override
  String get nodeAnalysis => 'NODE ANALYSIS';

  @override
  String get role => 'ROLE';

  @override
  String get score => 'SCORE';

  @override
  String get alerts => 'ALERTS';

  @override
  String get synced => 'SYNCED';

  @override
  String get status => 'STATUS';

  @override
  String get risk => 'RISK';

  @override
  String get nodeThreatHistory => 'NODE THREAT HISTORY';

  @override
  String get noNodeThreats => 'No associated threats on this node.';

  @override
  String get severityHigh => 'Severity: High';

  @override
  String get disconnectNode => 'DISCONNECT NODE FROM NETWORK';

  @override
  String get reportThreat => 'REPORT THREAT';

  @override
  String get communityShield => 'COMMUNITY SHIELD';

  @override
  String get communityShieldDesc =>
      'Submit suspicious numbers or phishing links to update the global AI security definitions.';

  @override
  String get senderPhoneId => 'SENDER PHONE / ID';

  @override
  String get suspiciousMessageContent => 'SUSPICIOUS MESSAGE CONTENT';

  @override
  String get submitSecureReport => 'SUBMIT SECURE REPORT';

  @override
  String get reportSubmitted => 'Report submitted to Community DB!';

  @override
  String get blockStep1 => '1. Open your Phone/SMS app.';

  @override
  String get blockStep2 => '2. Tap on the scammer\'s number.';

  @override
  String get blockStep3 => '3. Select \"Block\" or \"Report Spam\".';

  @override
  String get blockNote =>
      'Note: System-level blocking provides the most reliable protection.';

  @override
  String get openDialer => 'Open Dialer';

  @override
  String get smsShieldActive => 'SMS Shield Active and Listening!';

  @override
  String get permissionDenied => 'Permission Denied. Cannot protect SMS.';

  @override
  String get pasteMessageHint => 'Paste message or link here...';

  @override
  String get analyzingThreatLevel => 'Analyzing threat level...';

  @override
  String membersProtected(Object count) {
    return '$count members protected';
  }

  @override
  String familyCyberScore(Object score) {
    return 'Family Cyber Score: $score/100';
  }

  @override
  String get notConnectedToFamily => 'Not connected to a Family';

  @override
  String connectedTo(Object adminName) {
    return 'Connected to $adminName';
  }

  @override
  String get joinNow => 'JOIN NOW';

  @override
  String get demoSendAlert => 'DEMO: SEND MOCK SCAM ALERT';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi (हिंदी)';

  @override
  String get systemUser => 'System User';

  @override
  String roleLabel(Object role) {
    return 'Role: $role';
  }

  @override
  String get themeAmber => 'Amber';

  @override
  String get themeForest => 'Forest';

  @override
  String get themePurple => 'Purple';

  @override
  String get themePink => 'Pink';

  @override
  String get themeWhite => 'White';

  @override
  String get notificationsAlertsDesc => 'Alerts for new threat interceptions';

  @override
  String get voiceAlertsDesc => 'Read out threat warnings out loud';

  @override
  String get account => 'Account';

  @override
  String get editProfileHeader => 'EDIT PROFILE';

  @override
  String get contactInfoAuth => 'CONTACT INFO (AUTHENTICATED)';

  @override
  String get nameEmptyError => 'Name cannot be empty';

  @override
  String get profileUpdated => 'Profile updated successfully.';

  @override
  String get invalidEmailError => 'Please enter a valid email address';

  @override
  String get displayNameRequired => 'Please enter a display name';

  @override
  String get invalidQrCode => 'Invalid QR Code format';

  @override
  String get helpSupportHeader => 'HELP & SUPPORT';

  @override
  String get faqHeader => 'SURAKSHA KAVACH FAQ';

  @override
  String get q1 => 'How does AI detection work?';

  @override
  String get a1 =>
      'Our engine analyzes message syntax, sender reputation, and link metadata locally. No data leaves your device unless you manually report it.';

  @override
  String get q2 => 'Is it completely free?';

  @override
  String get a2 =>
      'Yes, the core protection features for individuals and families are free. Community reporting helps keep the database updated for everyone.';

  @override
  String get q3 => 'How to add family members?';

  @override
  String get a3 =>
      'Admins can generate an invite code in the Family tab. Members can join by scanning the QR code or entering the ID.';

  @override
  String get contactSecurityTeam => 'CONTACT SECURITY TEAM';

  @override
  String get securityStatus => 'Security Status';

  @override
  String get familyAdmin => 'Family Admin';

  @override
  String get familyMember => 'Family Member';

  @override
  String get elderlyHelpSent => 'Help request sent to your family!';

  @override
  String get elderlyFamilyNotConnected => 'Family Not Connected';

  @override
  String get elderlyNotConnectedDesc =>
      'You are not connected to a family member yet.\nWould you like to call the emergency helpline instead?';

  @override
  String get elderlyCancel => 'Cancel';

  @override
  String get elderlyCallHelpline => 'CALL 1930';

  @override
  String get elderlyHello => 'Hello!';

  @override
  String get elderlyDailySummaryText => 'Here is your daily safety summary.';

  @override
  String get elderlyPhoneSafe => 'Your Phone is Safe Today!';

  @override
  String get elderlyBeCareful => 'Be Careful Today!';

  @override
  String get elderlySafeBody =>
      'No dangerous messages were found. Your Senior Shield is working well.';

  @override
  String elderlyDangerBody(Object count) {
    return 'We blocked $count suspicious message(s) for you. Do not click unknown links.';
  }

  @override
  String get elderlyAskFamilyForHelp => 'ASK FAMILY FOR HELP';

  @override
  String get elderlyCallCyberHelpline => 'CALL CYBER HELPLINE  1930';

  @override
  String get elderlyLatestSafetyCheck => 'LATEST SAFETY CHECK';

  @override
  String get elderlyDangerousVerdict => 'DANGEROUS — Do NOT click any links!';

  @override
  String get elderlySafeVerdict => 'SAFE — This message looks okay.';

  @override
  String elderlyReadingAloud(Object verdict) {
    return 'Reading aloud: $verdict';
  }

  @override
  String elderlyFromSender(Object sender) {
    return 'From: $sender';
  }

  @override
  String get elderlyNoMessages =>
      'No messages scanned yet.\nYour shield is watching!';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navFamily => 'Family';

  @override
  String get navReport => 'Report';

  @override
  String get navSettings => 'Settings';
}
