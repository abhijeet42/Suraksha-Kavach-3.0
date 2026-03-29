# Suraksha Kavach - Architecture & Setup Plan

This plan outlines a robust, scalable architecture for your mobile cybersecurity application, "Suraksha Kavach." We will use a **Feature-First Architecture** (also known as layered module structure). 

## User Review Required
> [!IMPORTANT]
> Please review the chosen **State Management (Riverpod)** and **Routing (GoRouter)** libraries. This is important because routing will handle the complex `Admin vs User` redirection logic for the Family Dashboard, and Riverpod is excellent for reactive state.
> Do you approve of Riverpod and GoRouter, or would you prefer BLoC/Provider?

## Tech Stack & Core Libraries Recommendations

1. **State Management**: **Riverpod** (`flutter_riverpod`) 
   - *Why:* Highly scalable, compile-time safe, and perfect for reactivity (e.g., listening to real-time SMS streams and updating the UI).
2. **Routing**: **GoRouter** (`go_router`)
   - *Why:* Built-in support for "Redirect Guards." We can check if a user is an `admin` or a `member` before allowing access to the `/family-dashboard` route.
3. **Local Database**: **Isar** or **Hive**
   - *Why:* Fast, NoSQL structures that are perfect for storing tons of SMS logs rapidly on-device without lagging the UI.
4. **Method Channels**: Flutter's native `MethodChannel` / `EventChannel`
   - *Why:* Required to listen to the Kotlin SMS Receiver asynchronously.

---

## Proposed Folder Structure

The project will be split into three main layers: `core`, `data`, and `features`.

```text
lib/
├── core/                        # App-wide shared components
│   ├── theme/                   # App colors, fonts, theme data (Clean UI)
│   ├── routing/                 # GoRouter config, route guards for Admin vs User
│   ├── utils/                   # Helper functions, constants
│   ├── errors/                  # Custom exceptions
│   └── platform/                # Method channels for Kotlin SMS integration
│
├── data/                        # Global Data layer
│   ├── local_db/                # Hive/Isar adapters, services
│   └── models/                  # Shared data models (SmsMessage, UserRole, RiskLevel)
│
├── features/                    # Feature-First Modules
│   ├── auth/                    # Login, Signup, Role Selection
│   │   ├── presentation/        # Screens & Widgets
│   │   └── providers/           # AuthState (Stores if current user is Admin/Member)
│   │
│   ├── dashboard/               # Generic dashboard for all users (shows alerts, quick actions)
│   │
│   ├── family_shield/           # Family System feature
│   │   ├── presentation/        # Screens: FamilyDashboardScreen (Admin only), AddMemberScreen
│   │   └── providers/           # Family metrics state
│   │
│   ├── sms_detection/           # Background/Foreground SMS listening
│   │   └── providers/           # StreamProviders bridging Kotlin to Flutter
│   │
│   ├── engine_analysis/         # Analysis Engine structure
│   │   ├── rule_based/          # Current Phase: Keyword, Regex detectors
│   │   └── ai_model/            # Future Phase: TFLite wrappers
│   │
│   ├── history/                 # SMS History and categorization UI
│   │
│   └── reporting/               # UI/Logic for reporting scams to shared DB
│
└── main.dart                    # App initialization & provider scope
```

---

## Role-Based Access Control (Admin vs User)

To handle the Family Dashboard logic seamlessly:

1. **User Model**: Your User model will have an enum/field: `Role { admin, member }`
2. **Auth Controller**: Upon login, we save the user's details and role in local storage and memory (via Riverpod).
3. **Route Guarding**: 
   When someone tries to navigate to `/family-dashboard`, GoRouter will intercept:
   ```dart
   redirect: (context, state) {
      final userRole = ref.read(authProvider).role;
      if (userRole != Role.admin) {
         return '/dashboard'; // Kick them back to standard dashboard
      }
      return null; // Proceed to family dashboard
   }
   ```
4. **UI Dynamic Rendering**: On the main standard dashboard, the "Family Shield" button will only be visible `if (userRole == Role.admin)`.

---

## Verification Plan

Once approved, I will:
1. Create the entire directory structure under `lib/` in your flutter project.
2. Install the necessary pub packages (`hooks_riverpod`, `go_router`, etc.).
3. Write a placeholder `app_router.dart` showcasing the Admin Guard logic.
4. Scaffold the main empty screens for `Auth`, `Dashboard`, and `FamilyDashboard` to demonstrate the architecture.

## Open Questions

1. **Local DB**: Do you prefer Hive (Key-Value) or Isar/SQLite for storing the SMS messages locally? (Isar is highly optimized for Flutter queries).
2. **UI Guidelines**: Do you have a specific color theme or font family in mind for the "Clean and Simple" UI, or should I define a modern cybersecurity theme (e.g., deep blue/dark mode)?
