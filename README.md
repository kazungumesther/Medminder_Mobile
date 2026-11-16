
#  MedMinder Mobile

A cross-platform mobile application built using Flutter to help users manage medication schedules, log histories, and receive critical notification alerts seamlessly.

---

##  Live Demo

<img width="523" height="1071" alt="Screenshot from 2026-11-10 21-41-31" src="https://github.com/user-attachments/assets/dc312026-bd51-4194-a56a-7c42833d33f8" />

<img width="523" height="1071" alt="Screenshot from 2026-11-10 21-41-39" src="https://github.com/user-attachments/assets/baac851f-1676-452c-a9f9-d6051ca7a0ce" />

<img width="523" height="1071" alt="Screenshot from 2026-11-10 21-44-03" src="https://github.com/user-attachments/assets/c1427e58-0b25-457c-b462-078808928951" />

<img width="533" height="1072" alt="Screenshot from 2026-11-16 10-24-08" src="https://github.com/user-attachments/assets/9e3eede2-3b2b-468c-abe6-7e2f71c47f40" />
<img width="533" height="1072" alt="Screenshot from 2026-11-16 10-23-46" src="https://github.com/user-attachments/assets/404a70c9-b116-4603-a652-bc266698a4b9" />


<img width="533" height="1072" alt="Screenshot from 2026-11-16 10-22-40" src="https://github.com/user-attachments/assets/46d77703-efba-4d57-ba5f-58ee8d13a700" />

Check out the source repository and track updates here:  
**(https://github.com/kazungumesther/Medminder_Mobile)**




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
