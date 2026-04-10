import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'SURAKSHA KAVACH'**
  String get appTitle;

  /// A greeting message
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}.'**
  String hello(String name);

  /// No description provided for @digitalShieldActive.
  ///
  /// In en, this message translates to:
  /// **'Your digital shield is actively monitoring.'**
  String get digitalShieldActive;

  /// No description provided for @shieldActive.
  ///
  /// In en, this message translates to:
  /// **'Shield Active'**
  String get shieldActive;

  /// No description provided for @shieldInactive.
  ///
  /// In en, this message translates to:
  /// **'Shield Inactive'**
  String get shieldInactive;

  /// No description provided for @liveScanningEnabled.
  ///
  /// In en, this message translates to:
  /// **'Live scanning enabled'**
  String get liveScanningEnabled;

  /// No description provided for @systemUnprotected.
  ///
  /// In en, this message translates to:
  /// **'System unprotected'**
  String get systemUnprotected;

  /// No description provided for @enableNow.
  ///
  /// In en, this message translates to:
  /// **'Enable Now'**
  String get enableNow;

  /// No description provided for @scamsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Scams Blocked'**
  String get scamsBlocked;

  /// No description provided for @safeMessages.
  ///
  /// In en, this message translates to:
  /// **'Safe Messages'**
  String get safeMessages;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'QUICK ACTIONS'**
  String get quickActions;

  /// No description provided for @manualScan.
  ///
  /// In en, this message translates to:
  /// **'Manual Scan'**
  String get manualScan;

  /// No description provided for @cyberReport.
  ///
  /// In en, this message translates to:
  /// **'Cyber Report'**
  String get cyberReport;

  /// No description provided for @callHelpline.
  ///
  /// In en, this message translates to:
  /// **'Call Helpline'**
  String get callHelpline;

  /// No description provided for @blockScam.
  ///
  /// In en, this message translates to:
  /// **'Block Scam'**
  String get blockScam;

  /// No description provided for @familySecurity.
  ///
  /// In en, this message translates to:
  /// **'Family Security'**
  String get familySecurity;

  /// No description provided for @liveAlerts.
  ///
  /// In en, this message translates to:
  /// **'LIVE ALERTS'**
  String get liveAlerts;

  /// No description provided for @noThreatsDetected.
  ///
  /// In en, this message translates to:
  /// **'No threats detected recently.\nMonitoring in real-time...'**
  String get noThreatsDetected;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @galaxyThemes.
  ///
  /// In en, this message translates to:
  /// **'Galaxy Themes'**
  String get galaxyThemes;

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @voiceAlerts.
  ///
  /// In en, this message translates to:
  /// **'Voice Alerts (Accessibility)'**
  String get voiceAlerts;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disconnect your digital shield?'**
  String get areYouSureLogout;

  /// No description provided for @hindiSupport.
  ///
  /// In en, this message translates to:
  /// **'Hindi Support'**
  String get hindiSupport;

  /// No description provided for @analyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get analyze;

  /// No description provided for @threatScore.
  ///
  /// In en, this message translates to:
  /// **'THREAT SCORE'**
  String get threatScore;

  /// No description provided for @heuristicFlags.
  ///
  /// In en, this message translates to:
  /// **'HEURISTIC FLAGS'**
  String get heuristicFlags;

  /// No description provided for @dismissAnalysis.
  ///
  /// In en, this message translates to:
  /// **'DISMISS ANALYSIS'**
  String get dismissAnalysis;

  /// No description provided for @indiasCybershield.
  ///
  /// In en, this message translates to:
  /// **'INDIA\'S CYBER SHIELD'**
  String get indiasCybershield;

  /// No description provided for @initializingMesh.
  ///
  /// In en, this message translates to:
  /// **'INITIALIZING SECURE MESH'**
  String get initializingMesh;

  /// No description provided for @welcomeToApp.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Suraksha Kavach'**
  String get welcomeToApp;

  /// No description provided for @chooseEntryPoint.
  ///
  /// In en, this message translates to:
  /// **'Choose your entry point to the secure ecosystem.'**
  String get chooseEntryPoint;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @adminPanelDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a family group, generate invite codes, and monitor family safety.'**
  String get adminPanelDesc;

  /// No description provided for @userPanel.
  ///
  /// In en, this message translates to:
  /// **'User Panel'**
  String get userPanel;

  /// No description provided for @userPanelDesc.
  ///
  /// In en, this message translates to:
  /// **'Join a family group and protect your device from phishing scams.'**
  String get userPanelDesc;

  /// No description provided for @adminPortal.
  ///
  /// In en, this message translates to:
  /// **'Admin Portal'**
  String get adminPortal;

  /// No description provided for @userPortal.
  ///
  /// In en, this message translates to:
  /// **'User Portal'**
  String get userPortal;

  /// No description provided for @chooseMethod.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE METHOD'**
  String get chooseMethod;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'WELCOME BACK'**
  String get welcomeBack;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'GET STARTED'**
  String get getStarted;

  /// No description provided for @howToVerify.
  ///
  /// In en, this message translates to:
  /// **'How would you like to verify your identity?'**
  String get howToVerify;

  /// No description provided for @adminAuthDesc.
  ///
  /// In en, this message translates to:
  /// **'Secure access to your family guard command center.'**
  String get adminAuthDesc;

  /// No description provided for @userAuthDesc.
  ///
  /// In en, this message translates to:
  /// **'Join your family network for real-time protection.'**
  String get userAuthDesc;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get login;

  /// No description provided for @loginDesc.
  ///
  /// In en, this message translates to:
  /// **'Access your existing account securely.'**
  String get loginDesc;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'REGISTER'**
  String get register;

  /// No description provided for @registerDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a new security node for your family.'**
  String get registerDesc;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'PHONE NUMBER'**
  String get phoneNumber;

  /// No description provided for @phoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify using a secure SMS OTP code.'**
  String get phoneDesc;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'EMAIL ADDRESS'**
  String get emailAddress;

  /// No description provided for @emailDesc.
  ///
  /// In en, this message translates to:
  /// **'Secure authentication via email verification.'**
  String get emailDesc;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'GO BACK'**
  String get goBack;

  /// No description provided for @secureAccount.
  ///
  /// In en, this message translates to:
  /// **'SECURE ACCOUNT'**
  String get secureAccount;

  /// No description provided for @systemLogin.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM LOGIN'**
  String get systemLogin;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to receive a secure access token.'**
  String get enterPhone;

  /// No description provided for @getOtp.
  ///
  /// In en, this message translates to:
  /// **'GET SECURE OTP'**
  String get getOtp;

  /// No description provided for @alreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'ALREADY REGISTERED? LOGIN'**
  String get alreadyRegistered;

  /// No description provided for @newAdmin.
  ///
  /// In en, this message translates to:
  /// **'NEW ADMIN? CREATE ACCOUNT'**
  String get newAdmin;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'VERIFY OTP'**
  String get verifyOtp;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the {digits}-digit code sent to your device.'**
  String enterOtp(Object digits);

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'RESEND'**
  String get resend;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'VERIFY'**
  String get verify;

  /// No description provided for @profileSetup.
  ///
  /// In en, this message translates to:
  /// **'PROFILE SETUP'**
  String get profileSetup;

  /// No description provided for @tellAboutSelf.
  ///
  /// In en, this message translates to:
  /// **'TELL US ABOUT YOURSELF'**
  String get tellAboutSelf;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'FULL NAME'**
  String get fullName;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'COMPLETE SETUP'**
  String get completeSetup;

  /// No description provided for @joinFamily.
  ///
  /// In en, this message translates to:
  /// **'JOIN FAMILY'**
  String get joinFamily;

  /// No description provided for @enterInviteCode.
  ///
  /// In en, this message translates to:
  /// **'ENTER INVITE CODE'**
  String get enterInviteCode;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'JOIN'**
  String get join;

  /// No description provided for @scamHistory.
  ///
  /// In en, this message translates to:
  /// **'SCAM HISTORY'**
  String get scamHistory;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'NO HISTORY YET'**
  String get noHistory;

  /// No description provided for @messageDetail.
  ///
  /// In en, this message translates to:
  /// **'MESSAGE DETAILS'**
  String get messageDetail;

  /// No description provided for @sender.
  ///
  /// In en, this message translates to:
  /// **'SENDER'**
  String get sender;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'MESSAGE'**
  String get message;

  /// No description provided for @familyDashboard.
  ///
  /// In en, this message translates to:
  /// **'FAMILY DASHBOARD'**
  String get familyDashboard;

  /// No description provided for @protectedMembers.
  ///
  /// In en, this message translates to:
  /// **'PROTECTED MEMBERS'**
  String get protectedMembers;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'ADD MEMBER'**
  String get addMember;

  /// No description provided for @inviteCode.
  ///
  /// In en, this message translates to:
  /// **'INVITE CODE'**
  String get inviteCode;

  /// No description provided for @reportScam.
  ///
  /// In en, this message translates to:
  /// **'REPORT SCAM'**
  String get reportScam;

  /// No description provided for @describeScam.
  ///
  /// In en, this message translates to:
  /// **'DESCRIBE THE SCAM'**
  String get describeScam;

  /// No description provided for @submitReport.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT REPORT'**
  String get submitReport;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @updateName.
  ///
  /// In en, this message translates to:
  /// **'UPDATE NAME'**
  String get updateName;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'ENTER EMAIL'**
  String get enterEmail;

  /// No description provided for @emailVerificationDesc.
  ///
  /// In en, this message translates to:
  /// **'We will send a secure verification code to your inbox.'**
  String get emailVerificationDesc;

  /// No description provided for @getVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'GET VERIFICATION CODE'**
  String get getVerificationCode;

  /// No description provided for @verifyAccess.
  ///
  /// In en, this message translates to:
  /// **'VERIFY ACCESS'**
  String get verifyAccess;

  /// No description provided for @authToken.
  ///
  /// In en, this message translates to:
  /// **'AUTH TOKEN'**
  String get authToken;

  /// No description provided for @authorizeAccess.
  ///
  /// In en, this message translates to:
  /// **'AUTHORIZE ACCESS'**
  String get authorizeAccess;

  /// No description provided for @resendToken.
  ///
  /// In en, this message translates to:
  /// **'RESEND TOKEN'**
  String get resendToken;

  /// No description provided for @whatIsYourName.
  ///
  /// In en, this message translates to:
  /// **'WHAT IS YOUR NAME?'**
  String get whatIsYourName;

  /// No description provided for @nameIdentifyDesc.
  ///
  /// In en, this message translates to:
  /// **'This name will identify your device in the family network.'**
  String get nameIdentifyDesc;

  /// No description provided for @enterDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Enter Display Name'**
  String get enterDisplayName;

  /// No description provided for @scanAdminQr.
  ///
  /// In en, this message translates to:
  /// **'SCAN ADMIN QR'**
  String get scanAdminQr;

  /// No description provided for @familyPairing.
  ///
  /// In en, this message translates to:
  /// **'FAMILY PAIRING'**
  String get familyPairing;

  /// No description provided for @pairDevice.
  ///
  /// In en, this message translates to:
  /// **'PAIR DEVICE'**
  String get pairDevice;

  /// No description provided for @joinFamilyDesc.
  ///
  /// In en, this message translates to:
  /// **'Join a family group to enable shared threat intelligence and protected scanning.'**
  String get joinFamilyDesc;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'SCAN ADMIN QR CODE'**
  String get scanQrCode;

  /// No description provided for @orEnterManually.
  ///
  /// In en, this message translates to:
  /// **'OR ENTER MANUALLY'**
  String get orEnterManually;

  /// No description provided for @joinFamilyGroup.
  ///
  /// In en, this message translates to:
  /// **'JOIN FAMILY GROUP'**
  String get joinFamilyGroup;

  /// No description provided for @jsonPayloadLabel.
  ///
  /// In en, this message translates to:
  /// **'JSON PAYLOAD (HACKATHON OVERRIDE)'**
  String get jsonPayloadLabel;

  /// No description provided for @threatLogs.
  ///
  /// In en, this message translates to:
  /// **'THREAT LOGS'**
  String get threatLogs;

  /// No description provided for @searchSenderHint.
  ///
  /// In en, this message translates to:
  /// **'Search sender or message keywords...'**
  String get searchSenderHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get filterAll;

  /// No description provided for @filterScam.
  ///
  /// In en, this message translates to:
  /// **'SCAM'**
  String get filterScam;

  /// No description provided for @filterSuspicious.
  ///
  /// In en, this message translates to:
  /// **'SUSPICIOUS'**
  String get filterSuspicious;

  /// No description provided for @filterSafe.
  ///
  /// In en, this message translates to:
  /// **'SAFE'**
  String get filterSafe;

  /// No description provided for @noMatchingThreats.
  ///
  /// In en, this message translates to:
  /// **'No matching threat logs.'**
  String get noMatchingThreats;

  /// No description provided for @threatAnalysis.
  ///
  /// In en, this message translates to:
  /// **'THREAT ANALYSIS'**
  String get threatAnalysis;

  /// No description provided for @riskScore.
  ///
  /// In en, this message translates to:
  /// **'{score}% RISK SCORE'**
  String riskScore(Object score);

  /// No description provided for @senderOrigin.
  ///
  /// In en, this message translates to:
  /// **'SENDER ORIGIN'**
  String get senderOrigin;

  /// No description provided for @timeReceived.
  ///
  /// In en, this message translates to:
  /// **'TIME RECEIVED'**
  String get timeReceived;

  /// No description provided for @messageBody.
  ///
  /// In en, this message translates to:
  /// **'MESSAGE BODY'**
  String get messageBody;

  /// No description provided for @aiIntelligenceFlags.
  ///
  /// In en, this message translates to:
  /// **'AI INTELLIGENCE FLAGS'**
  String get aiIntelligenceFlags;

  /// No description provided for @reportToDatabase.
  ///
  /// In en, this message translates to:
  /// **'REPORT TO DATABASE'**
  String get reportToDatabase;

  /// No description provided for @deleteFromHistory.
  ///
  /// In en, this message translates to:
  /// **'DELETE FROM HISTORY'**
  String get deleteFromHistory;

  /// No description provided for @shieldCommand.
  ///
  /// In en, this message translates to:
  /// **'SHIELD COMMAND'**
  String get shieldCommand;

  /// No description provided for @nodeOnline.
  ///
  /// In en, this message translates to:
  /// **'NODE ONLINE'**
  String get nodeOnline;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'OFFLINE'**
  String get offline;

  /// No description provided for @addMemberNode.
  ///
  /// In en, this message translates to:
  /// **'ADD MEMBER NODE'**
  String get addMemberNode;

  /// No description provided for @emergencyLock.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY LOCK'**
  String get emergencyLock;

  /// No description provided for @deepScanNetwork.
  ///
  /// In en, this message translates to:
  /// **'DEEP SCAN NETWORK'**
  String get deepScanNetwork;

  /// No description provided for @activeNodes.
  ///
  /// In en, this message translates to:
  /// **'Active Nodes'**
  String get activeNodes;

  /// No description provided for @topTarget.
  ///
  /// In en, this message translates to:
  /// **'Top Target'**
  String get topTarget;

  /// No description provided for @globalTelemetry.
  ///
  /// In en, this message translates to:
  /// **'GLOBAL TELEMETRY'**
  String get globalTelemetry;

  /// No description provided for @networkNodes.
  ///
  /// In en, this message translates to:
  /// **'NETWORK NODES'**
  String get networkNodes;

  /// No description provided for @liveThreatFeed.
  ///
  /// In en, this message translates to:
  /// **'LIVE THREAT INTELLIGENCE FEED'**
  String get liveThreatFeed;

  /// No description provided for @outOf100.
  ///
  /// In en, this message translates to:
  /// **'OUT OF 100'**
  String get outOf100;

  /// No description provided for @networkHealth.
  ///
  /// In en, this message translates to:
  /// **'NETWORK HEALTH'**
  String get networkHealth;

  /// No description provided for @optimal.
  ///
  /// In en, this message translates to:
  /// **'OPTIMAL'**
  String get optimal;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'WARNING'**
  String get warning;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL'**
  String get critical;

  /// No description provided for @addNode.
  ///
  /// In en, this message translates to:
  /// **'Add Node'**
  String get addNode;

  /// No description provided for @networkSecurityLoad.
  ///
  /// In en, this message translates to:
  /// **'Network Security Load'**
  String get networkSecurityLoad;

  /// No description provided for @scamPhishingVolume.
  ///
  /// In en, this message translates to:
  /// **'Scam/Phishing Volume'**
  String get scamPhishingVolume;

  /// No description provided for @establishConnectionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Establish node connections to activate telemetry array.'**
  String get establishConnectionsDesc;

  /// No description provided for @lanPairingActive.
  ///
  /// In en, this message translates to:
  /// **'LAN PAIRING ACTIVE'**
  String get lanPairingActive;

  /// No description provided for @scanEncryptedNodeDesc.
  ///
  /// In en, this message translates to:
  /// **'Tell your family member to open \"Suraksha Kavach\" -> \"User Panel\" and scan this encrypted node key.'**
  String get scanEncryptedNodeDesc;

  /// No description provided for @dismissNode.
  ///
  /// In en, this message translates to:
  /// **'DISMISS NODE'**
  String get dismissNode;

  /// No description provided for @emergencyLockBroadcasted.
  ///
  /// In en, this message translates to:
  /// **'Emergency lock signal broadcasted to all active nodes!'**
  String get emergencyLockBroadcasted;

  /// No description provided for @safetyReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'SAFETY REMINDER: Family Network Health is below 50%. Focus on increasing security!'**
  String get safetyReminderDesc;

  /// No description provided for @analyzingNetworkNodes.
  ///
  /// In en, this message translates to:
  /// **'ANALYZING NETWORK NODES...'**
  String get analyzingNetworkNodes;

  /// No description provided for @evaluatingThreatVectors.
  ///
  /// In en, this message translates to:
  /// **'Evaluating cross-device threat vectors'**
  String get evaluatingThreatVectors;

  /// No description provided for @networkAuditReport.
  ///
  /// In en, this message translates to:
  /// **'NETWORK AUDIT REPORT'**
  String get networkAuditReport;

  /// No description provided for @globalHealthIndex.
  ///
  /// In en, this message translates to:
  /// **'Global Health Index'**
  String get globalHealthIndex;

  /// No description provided for @secureNodes.
  ///
  /// In en, this message translates to:
  /// **'Secure Nodes'**
  String get secureNodes;

  /// No description provided for @warningNodes.
  ///
  /// In en, this message translates to:
  /// **'Warning Nodes'**
  String get warningNodes;

  /// No description provided for @criticalNodes.
  ///
  /// In en, this message translates to:
  /// **'Critical Nodes'**
  String get criticalNodes;

  /// No description provided for @perimeterSecure.
  ///
  /// In en, this message translates to:
  /// **'Your family perimeter is secure. No action required.'**
  String get perimeterSecure;

  /// No description provided for @vulnerabilitiesDetected.
  ///
  /// In en, this message translates to:
  /// **'Vulnerabilities detected. Review \"Critical Nodes\" history immediately.'**
  String get vulnerabilitiesDetected;

  /// No description provided for @acknowledge.
  ///
  /// In en, this message translates to:
  /// **'ACKNOWLEDGE'**
  String get acknowledge;

  /// No description provided for @networkRiskScoresReset.
  ///
  /// In en, this message translates to:
  /// **'Network Risk Scores Reset'**
  String get networkRiskScoresReset;

  /// No description provided for @resetScores.
  ///
  /// In en, this message translates to:
  /// **'Reset Scores'**
  String get resetScores;

  /// No description provided for @nodeAnalysis.
  ///
  /// In en, this message translates to:
  /// **'NODE ANALYSIS'**
  String get nodeAnalysis;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'ROLE'**
  String get role;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'SCORE'**
  String get score;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'ALERTS'**
  String get alerts;

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'SYNCED'**
  String get synced;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get status;

  /// No description provided for @risk.
  ///
  /// In en, this message translates to:
  /// **'RISK'**
  String get risk;

  /// No description provided for @nodeThreatHistory.
  ///
  /// In en, this message translates to:
  /// **'NODE THREAT HISTORY'**
  String get nodeThreatHistory;

  /// No description provided for @noNodeThreats.
  ///
  /// In en, this message translates to:
  /// **'No associated threats on this node.'**
  String get noNodeThreats;

  /// No description provided for @severityHigh.
  ///
  /// In en, this message translates to:
  /// **'Severity: High'**
  String get severityHigh;

  /// No description provided for @disconnectNode.
  ///
  /// In en, this message translates to:
  /// **'DISCONNECT NODE FROM NETWORK'**
  String get disconnectNode;

  /// No description provided for @reportThreat.
  ///
  /// In en, this message translates to:
  /// **'REPORT THREAT'**
  String get reportThreat;

  /// No description provided for @communityShield.
  ///
  /// In en, this message translates to:
  /// **'COMMUNITY SHIELD'**
  String get communityShield;

  /// No description provided for @communityShieldDesc.
  ///
  /// In en, this message translates to:
  /// **'Submit suspicious numbers or phishing links to update the global AI security definitions.'**
  String get communityShieldDesc;

  /// No description provided for @senderPhoneId.
  ///
  /// In en, this message translates to:
  /// **'SENDER PHONE / ID'**
  String get senderPhoneId;

  /// No description provided for @suspiciousMessageContent.
  ///
  /// In en, this message translates to:
  /// **'SUSPICIOUS MESSAGE CONTENT'**
  String get suspiciousMessageContent;

  /// No description provided for @submitSecureReport.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT SECURE REPORT'**
  String get submitSecureReport;

  /// No description provided for @reportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report submitted to Community DB!'**
  String get reportSubmitted;

  /// No description provided for @blockStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Open your Phone/SMS app.'**
  String get blockStep1;

  /// No description provided for @blockStep2.
  ///
  /// In en, this message translates to:
  /// **'2. Tap on the scammer\'s number.'**
  String get blockStep2;

  /// No description provided for @blockStep3.
  ///
  /// In en, this message translates to:
  /// **'3. Select \"Block\" or \"Report Spam\".'**
  String get blockStep3;

  /// No description provided for @blockNote.
  ///
  /// In en, this message translates to:
  /// **'Note: System-level blocking provides the most reliable protection.'**
  String get blockNote;

  /// No description provided for @openDialer.
  ///
  /// In en, this message translates to:
  /// **'Open Dialer'**
  String get openDialer;

  /// No description provided for @smsShieldActive.
  ///
  /// In en, this message translates to:
  /// **'SMS Shield Active and Listening!'**
  String get smsShieldActive;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied. Cannot protect SMS.'**
  String get permissionDenied;

  /// No description provided for @pasteMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Paste message or link here...'**
  String get pasteMessageHint;

  /// No description provided for @analyzingThreatLevel.
  ///
  /// In en, this message translates to:
  /// **'Analyzing threat level...'**
  String get analyzingThreatLevel;

  /// No description provided for @membersProtected.
  ///
  /// In en, this message translates to:
  /// **'{count} members protected'**
  String membersProtected(Object count);

  /// No description provided for @familyCyberScore.
  ///
  /// In en, this message translates to:
  /// **'Family Cyber Score: {score}/100'**
  String familyCyberScore(Object score);

  /// No description provided for @notConnectedToFamily.
  ///
  /// In en, this message translates to:
  /// **'Not connected to a Family'**
  String get notConnectedToFamily;

  /// No description provided for @connectedTo.
  ///
  /// In en, this message translates to:
  /// **'Connected to {adminName}'**
  String connectedTo(Object adminName);

  /// No description provided for @joinNow.
  ///
  /// In en, this message translates to:
  /// **'JOIN NOW'**
  String get joinNow;

  /// No description provided for @demoSendAlert.
  ///
  /// In en, this message translates to:
  /// **'DEMO: SEND MOCK SCAM ALERT'**
  String get demoSendAlert;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi (हिंदी)'**
  String get hindi;

  /// No description provided for @systemUser.
  ///
  /// In en, this message translates to:
  /// **'System User'**
  String get systemUser;

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role: {role}'**
  String roleLabel(Object role);

  /// No description provided for @themeAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get themeAmber;

  /// No description provided for @themeForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get themeForest;

  /// No description provided for @themePurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get themePurple;

  /// No description provided for @themePink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get themePink;

  /// No description provided for @themeWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get themeWhite;

  /// No description provided for @notificationsAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Alerts for new threat interceptions'**
  String get notificationsAlertsDesc;

  /// No description provided for @voiceAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Read out threat warnings out loud'**
  String get voiceAlertsDesc;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @editProfileHeader.
  ///
  /// In en, this message translates to:
  /// **'EDIT PROFILE'**
  String get editProfileHeader;

  /// No description provided for @contactInfoAuth.
  ///
  /// In en, this message translates to:
  /// **'CONTACT INFO (AUTHENTICATED)'**
  String get contactInfoAuth;

  /// No description provided for @nameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameEmptyError;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdated;

  /// No description provided for @invalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmailError;

  /// No description provided for @displayNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a display name'**
  String get displayNameRequired;

  /// No description provided for @invalidQrCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR Code format'**
  String get invalidQrCode;

  /// No description provided for @helpSupportHeader.
  ///
  /// In en, this message translates to:
  /// **'HELP & SUPPORT'**
  String get helpSupportHeader;

  /// No description provided for @faqHeader.
  ///
  /// In en, this message translates to:
  /// **'SURAKSHA KAVACH FAQ'**
  String get faqHeader;

  /// No description provided for @q1.
  ///
  /// In en, this message translates to:
  /// **'How does AI detection work?'**
  String get q1;

  /// No description provided for @a1.
  ///
  /// In en, this message translates to:
  /// **'Our engine analyzes message syntax, sender reputation, and link metadata locally. No data leaves your device unless you manually report it.'**
  String get a1;

  /// No description provided for @q2.
  ///
  /// In en, this message translates to:
  /// **'Is it completely free?'**
  String get q2;

  /// No description provided for @a2.
  ///
  /// In en, this message translates to:
  /// **'Yes, the core protection features for individuals and families are free. Community reporting helps keep the database updated for everyone.'**
  String get a2;

  /// No description provided for @q3.
  ///
  /// In en, this message translates to:
  /// **'How to add family members?'**
  String get q3;

  /// No description provided for @a3.
  ///
  /// In en, this message translates to:
  /// **'Admins can generate an invite code in the Family tab. Members can join by scanning the QR code or entering the ID.'**
  String get a3;

  /// No description provided for @contactSecurityTeam.
  ///
  /// In en, this message translates to:
  /// **'CONTACT SECURITY TEAM'**
  String get contactSecurityTeam;

  /// No description provided for @securityStatus.
  ///
  /// In en, this message translates to:
  /// **'Security Status'**
  String get securityStatus;

  /// No description provided for @familyAdmin.
  ///
  /// In en, this message translates to:
  /// **'Family Admin'**
  String get familyAdmin;

  /// No description provided for @familyMember.
  ///
  /// In en, this message translates to:
  /// **'Family Member'**
  String get familyMember;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
