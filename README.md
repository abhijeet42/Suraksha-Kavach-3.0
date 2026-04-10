<div align="center">
  <img src="./assets/images/logo.png" width="220" height="220" alt="Suraksha Kavach Logo">
  <h1>SURAKSHA KAVACH 🛡️</h1>
  <p><b>A Sovereign, Zero-Cloud LAN Shield for Family Cyber-Defense</b></p>

  [![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
  [![Shelf](https://img.shields.io/badge/Backend-Shelf_LAN_Server-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://pub.dev/packages/shelf)
  [![Provider](https://img.shields.io/badge/State--Management-Provider-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://pub.dev/packages/provider)
  [![Privacy](https://img.shields.io/badge/Privacy-Zero--Cloud-%234CAF50.svg?style=for-the-badge&logo=shieldui&logoColor=white)](#)
</div>

---

## 🔒 Project Overview

**Suraksha Kavach** is an advanced, "Cyber-Elite" aesthetic application designed to protect families from SMS scams, phishing (smishing), and digital fraud. Unlike traditional apps that rely on intrusive cloud uploads, Suraksha Kavach uses a **Local Area Network (LAN) Peer-to-Peer architecture** to keep all data strictly within your home or immediate Wi-Fi vicinity.

> [!IMPORTANT]
> **Zero-Cloud Architecture**: Your family's SMS data never hits a central server. All synchronization between Members and the Admin happens over encrypted local HTTP tunnels.

---

## ✨ Advanced "Family Shield" Features

### 🏢 Command Center (Admin Dashboard)
*   **Family Cyber Score**: A real-time, dynamic health gauge measuring the collective security status of all connected nodes.
*   **Global Telemetry Array**: Visual tracking of network security load and phishing volumes across the family mesh.
*   **Live Threat Intelligence**: A chronological feed of intercepted threats, identifying the "Top Target" in the family.
*   **Emergency Lockdown**: One-tap broadcast to send emergency signals to all active family nodes.

### 📱 Member Protection (Node View)
*   **Silent Monitoring**: Members are protected by a background heuristic engine that flags scam messages instantly.
*   **Real-time Alert Sync**: Detected threats are instantly pushed to the Guardian's dashboard over the local Wi-Fi.
*   **Zero-Knowledge Transfers**: Only threat metadata (category, risk level, timestamp) is shared—raw private message content never leaves the member's device.

### 🧓 Elderly Shield Mode (Accessibility)
*   **High-Contrast Simplified UI**: A specialized dashboard stripped of complex telemetry, offering large typography, simplified warnings, and clear action buttons (Call Helpline/Ask Family).
*   **Synchronized Voice Alerts**: Features a deeply integrated Text-To-Speech (`flutter_tts`) engine that automatically speaks incoming SMS safety verdicts out loud entirely without UI race-conditions.
*   **Dynamic Language Synthesis**: Fully integrated with Flutter's `.arb` localizations. Switching the app to Hindi instantly translates the entire UI *and* sets the voice engine to synthesize native Hindi (`hi-IN`).

### 🌐 Global Threat Reporting & Collaboration
*   **Community Threat Pool**: Members can actively report verified scam messages and phone numbers to a centralized Firebase Cloud Firestore repository.
*   **Threat Provider Syncing**: Pulls live global cyber-threat metrics, ensuring the local on-device intelligence is bolstered by real-world community reports.

### 📶 Bulletproof LAN Syncing
*   **QR-Node Pairing**: Admin generates a dynamic QR containing their local IP and encrypted Family ID for instant pairing.
*   **Automatic Handshake**: Includes multi-interface IP detection to ensure connectivity even behind restrictive routers or on emulators.

---

## 🧠 AI Model Integration

Suraksha Kavach utilizes advanced, on-device machine learning to accurately identify scam and phishing messages without compromising user privacy.

*   **Model Name**: DistilBERT-based SMS Fraud Detection Model (`sms_fraud_model_quantized.tflite`)
*   **Architecture**: Quantized DistilBERT Transformer running via TensorFlow Lite Mobile Inference.
*   **Description**: The application features a locally embedded Language Model trained specifically on a 3-class system (Safe, Suspicious, Spam/Fraud) to analyze SMS text semantics. Since the inference pipeline runs entirely on-device, it achieves zero-latency threat detection while ensuring that your private messages are never uploaded to any external server.

---

## 🚀 How to Run the Demo

To demonstrate the real-time syncing between two devices (e.g., Admin and Member):

### 1. Networking Setup (Crucial)
> [!TIP]
> For the best demo experience, turn on a **Mobile Hotspot** on the Admin device and connect the Member device to it. This bypasses "Client Isolation" found on public/office Wi-Fi networks.

### 2. Admin Flow
1. Open the app -> Select **Admin Panel**.
2. Go to the **Family Shield** tab.
3. Tap **"GENERATE INVITE QR"**. The local node server will boot on port 8080.

### 3. Member Flow
1. Open the app on a second device -> Select **User Panel**.
2. Tap **"Scan Admin QR"** and scan the Admin's screen.
3. Once connected, tap **"DEMO: SEND MOCK SCAM ALERT"** on the Member's dashboard.
4. Watch the Admin's dashboard update **instantly** with the new threat log and a drop in the Cyber Score.

---

## 🛠️ Technical Stack

| Layer | Technology | Purpose |
| :--- | :--- | :--- |
| **Client** | Flutter (Dart) | Cross-platform high-fidelity UI |
| **Local Server** | Shelf / Shelf Router | Lightweight HTTP node for Admin device |
| **State** | Provider | Reactive UI updates across nodes |
| **Scanning** | Mobile Scanner | QR detection for node-to-node pairing |
| **Localization** | flutter_localizations | Dynamic dual-language (Hindi/English) .arb pipeline |
| **Accessibility** | flutter_tts | Automatic text-to-speech for seniors |
| **Cloud Sync** | cloud_firestore | Aggregating verified community threat reports |
| **Aesthetics** | Animate Do / Google Fonts | Premium visual system |
| **Network** | Network Info Plus | Dynamic IPv4 resolution for LAN |

---

## 🛡️ Privacy Manifesto
We believe privacy is a human right. Suraksha Kavach is designed to be **Cloud-Agnostic**.
- **No** central database of your messages.
- **No** tracking of your family's location.
- **No** data harvesting.
Just pure, decentralized protection.

---
<div align="center">
  *Suraksha Kavach: Decentralized Defense for the Modern Family* 🇮🇳
</div>
