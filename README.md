<div align="center">
  <img src="./assets/images/logo.png" width="200" height="200" alt="Suraksha Kavach Logo">
  <h1>Suraksha Kavach 🛡️</h1>
  <p><b>Your Family's Advanced Digital Shield Against SMS Threats</b></p>

  [![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Provider](https://img.shields.io/badge/State--Management-Provider-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://pub.dev/packages/provider)
  [![Hive](https://img.shields.io/badge/Local--DB-Hive-%23FFC107.svg?style=for-the-badge&logo=hive&logoColor=black)](https://pub.dev/packages/hive)
</div>

---

## 🔒 Project Overview

**Suraksha Kavach** is a high-performance, premium cybersecurity application designed for families. In an era of increasing digital scams, it provides a **proactive, real-time shield** against SMS-based phishing (smishing) and scam attempts. 

> [!TIP]
> **Suraksha Kavach** focuses on three core pillars: **Proactive Protection**, **Family Safety**, and **Premium Experience**.

---

## ✨ Key Features

### 🛡️ Proactive SMS Protection
*   **Real-time Analysis**: Monitors incoming SMS for suspicious links, keywords, and malicious patterns.
*   **Dynamic Rule Engine**: Employs an intelligent analyzer to flag potential phishing URLs and scam bait.
*   **Instant Alerts**: Provides immediate feedback on high-risk messages to prevent data theft.

### 👨‍👩‍👧‍👦 Family Shield (Admin & Member)
*   **Guardian Dashboard**: Admins can oversee the security health of their entire family from one view.
*   **Instant Pairing**: Connect family members securely via **Dynamic QR Codes** or unique **Invite Codes**.
*   **Zero-Config for Users**: Managed members receive protection without needing to configure complex settings.

### 💎 Premium Aesthetic & Performance
*   **Cyber-Elite UI**: A dark-mode-first design inspired by modern security centers.
*   **Micro-Animations**: Smooth transitions using `animate_do` for a responsive, "alive" interface.
*   **Custom Themes**: Support for multiple aesthetic modes including High-Contrast and Light themes.

---

## 🚀 How to Use

### 1️⃣ Role Initialization
Choose your role on the boot menu: **Admin Panel** for guardians or **User Panel** for family members.

### 2️⃣ The Guardian Flow (Admin)
1.  **Identity**: Sign up via phone number with secure **OTP verification**.
2.  **Initialize**: Generate your unique family ID and invite system automatically.
3.  **Expand**:
    *   Open **Family Shield** to show your **QR Code** or share your **Invite Code**.
4.  **Monitor**: View the real-time safety status and alert counts for all protected members.

### 3️⃣ The Member Flow (User)
1.  **Join**: Select **User Panel** and scan the Admin's **QR Code**.
2.  **Sync**: Enter the **Invite Code** manually if preferred.
3.  **Protection**: Once paired, the app activates the background security tunnel immediately.

---

## 🛠️ Technical Deep Dive

### Core Architecture
Built with a **Feature-First Layered Architecture** for maximum scalability:
*   `lib/core/`: Application framework, routing, and centralized theme tokens.
*   `lib/data/`: Global data models and Hive/Isar adapters.
*   `lib/features/`: Fully decoupled modules (Auth, Dashboard, Shield, Analysis).

### Tech Integrations
| Layer | Technology |
| :--- | :--- |
| **Logic** | Provider (State Management) |
| **Navigation** | GoRouter (Guarded Routing) |
| **Storage** | Hive (High-speed Local NoSQL) |
| **Analysis** | Rule-Based Regex & Keyword Analyzers |
| **Scanner** | Mobile Scanner (QR-based Pairing) |

---

## 📦 Installation & Setup

```bash
# Clone the repository
git clone https://github.com/your-repo/suraksha_kavach.git

# Navigate to project root
cd suraksha_kavach

# Get dependencies
flutter pub get

# Run on your device
flutter run
```

---

## 🛡️ Privacy First
We believe security should never come at the cost of privacy. All message analysis is performed **locally on-device**. No SMS content ever leaves your hardware, ensuring 100% data sovereignty for your family.

---
<div align="center">
  *Designed & Built for a Safer Digital India* 🇮🇳
</div>
