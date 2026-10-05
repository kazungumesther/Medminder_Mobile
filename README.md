#  MedMinder Mobile

A cross-platform mobile application built using Flutter to help users manage medication schedules, log histories, and receive critical notification alerts seamlessly.

---

##  Live Demo

Check out the source repository and track updates here:  
**(https://github.com/kazungumesther/Medminder_Mobile)**

---

##  Features

*   **Medication Scheduling:** Configure dose frequencies, times, and specific details for various prescriptions.
*   **Comprehensive UI Views:** Specialized user screens for onboarding, authentication, dashboard overview, medication logging, history tracking, and user profile management.
*   **Automated Reminder Services:** Integrated background notification service triggers to push real-time alerts when medications are due.
*   **Rigorous Test Suite:** Complete coverage featuring unit tests for business validation and component layout behaviors.

---

##  Tech Stack

*   **Framework:** [Flutter / Dart](https://flutter.dev) (Multiplatform native target builds)
*   **Architecture Pattern:** MVVM (Model-View-ViewModel) for clean separation of concerns and scalable code structure.
*   **State Management:** ViewModels driving unidirectional data binding down to the screen layouts.

---

##  Project Structure

The project follows a clean MVVM and service-oriented directory layout:

```text
med_minder_app/
├── lib/
│   ├── models/
│   │   └── medicine.dart             # Core medication data structures
│   ├── viewmodel/
│   │   └── medication_viewmodel.dart # Business logic and application state
│   ├── screens/
│   │   ├── welcome_screen.dart       # Onboarding entrance viewport
│   │   ├── auth_screen.dart          # Secure user registration/login
│   │   ├── home_screen.dart          # Main interface dashboard
│   │   ├── add_medicine_screen.dart  # Form to register medication data
│   │   ├── medication_screen.dart    # Detailed medication lists
│   │   ├── history_screen.dart       # Chronological intake records log
│   │   └── profile_screen.dart       # User details settings panel
│   ├── services/
│   │   ├── medication_api.dart       # Remote cloud backend communication
│   │   └── notification_service.dart # Local device reminder scheduling
│   └── main.dart                     # Application engine initialization entry
└── test/
    ├── medication_test.dart          # Architecture validation and viewmodel unit tests
    └── widget_test.dart              # User interface component interaction tests
```

---

##  Getting Started

Follow these steps to set up and launch MedMinder Mobile on your machine locally.

###  Prerequisites

Ensure your system platform environment has the **Flutter SDK** and **Dart SDK** installed and configured within your global environment variables.

###  Local Setup

1. Clone this repository workspace:
   ```bash
   git clone https://://github.com.git
   ```

2. Direct your terminal shell into the root project directory:
   ```bash
   cd med_minder_app
   ```

3. Download the required dependencies:
   ```bash
   flutter pub get
   ```

###  Running the Application

To boot up the application on a connected device or local virtual emulator:

```bash
flutter run
```

---

##  Running the Test Suite

This project includes unit and architecture verification tests to ensure application reliability. Run the test command below to execute the full validation suite:

```bash
flutter test
```
