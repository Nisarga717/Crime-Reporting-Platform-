# Live Crime Reporter (Satark)

## 📋 Project Overview

**Live Crime Reporter** is a comprehensive mobile application designed to revolutionize crime reporting and community safety. The app enables citizens to report criminal incidents in real-time with multimedia evidence, provides offline mesh networking capabilities for disaster scenarios, and offers advanced safety features including virtual escort services and real-time crime analytics.

The application addresses critical gaps in traditional crime reporting systems by:
- Enabling immediate incident reporting with geolocation
- Supporting offline communication through peer-to-peer mesh networking
- Providing real-time crime analytics and heatmaps
- Offering virtual escort features for enhanced personal safety
- Gamifying civic engagement through points and levels

---

## 🎯 Main Purpose

The primary objective of **Live Crime Reporter** is to:

1. **Democratize Crime Reporting**: Empower citizens to report crimes instantly with multimedia evidence (photos, videos, audio recordings)
2. **Enable Disaster-Resilient Communication**: Utilize mesh networking technology to enable reporting even when cellular networks are down
3. **Enhance Community Safety**: Provide real-time crime data visualization and analytics to help communities stay informed
4. **Protect Personal Safety**: Offer virtual escort services and emergency communication features
5. **Foster Civic Engagement**: Gamify crime reporting to encourage active community participation through points and leaderboards

---

## ✨ Key Functionalities

### 🗺️ **Interactive Map-Based Reporting**
- **Real-time Geolocation**: Automatic detection of user's current location using GPS
- **Manual Pin Placement**: Tap anywhere on the map to report incidents at specific locations
- **Crime Markers**: Visual representation of reported crimes with severity indicators
- **OpenStreetMap Integration**: Detailed street-level mapping with multiple layer support
- **Location Permissions**: Seamless handling of location permissions across platforms

### 📱 **Multimedia Evidence Capture**
- **Camera Integration**: Capture photos and videos directly from the app
- **Audio Recording**: Record voice testimonies and incident descriptions
- **Gallery Access**: Upload existing media from device gallery
- **Audio Playback**: Review recorded audio before submission
- **File Management**: Secure storage and management of evidence files

### 🌐 **Offline Mesh Networking (Bridgefy Integration)**
- **Peer-to-Peer Communication**: Send and receive crime reports without internet connectivity
- **Broadcast Mode**: Distribute reports to all nearby users via Bluetooth/WiFi Direct
- **Automatic Synchronization**: Reports sync to cloud when connectivity is restored
- **Disaster Resilience**: Critical for emergencies when cellular networks fail
- **Local Notifications**: Receive alerts for nearby incidents even offline

### 🔐 **User Authentication & Authorization**
- **Email/Password Authentication**: Traditional signup and login via Supabase
- **OAuth Integration**: Sign in with Google and Facebook
- **Email Verification**: Secure account verification process
- **Password Recovery**: Forgot password functionality with email reset
- **Session Management**: Persistent authentication sessions
- **Anonymous Reporting**: Option to report crimes anonymously

### 📊 **Real-time Crime Analytics Dashboard**
- **Crime Heatmaps**: Visual representation of crime density by region
- **Trend Analysis**: Historical data visualization and pattern recognition
- **Severity Filtering**: Filter crimes by severity level (Low, Medium, High, Critical)
- **Time-based Analytics**: View crime statistics by time of day, week, or month
- **Incident Type Breakdown**: Categorized crime statistics
- **Embedded Web View**: Integration with external analytics platform (crime-dashboard-filters.vercel.app)

### 🛡️ **Virtual Escort Service**
- **Safe Journey Mode**: Share live location with trusted contacts during travel
- **Emergency Contacts**: Quick access to emergency services and saved contacts
- **Live Location Tracking**: Real-time location sharing with configurable duration
- **Route Monitoring**: Track expected vs actual route deviation
- **SOS Alerts**: One-tap emergency notifications to contacts
- **External Integration**: Web-based escort service (satark-sehli.vercel.app)

### 🔔 **Push Notifications & Alerts**
- **Firebase Cloud Messaging**: Real-time push notifications
- **Foreground Notifications**: In-app alerts for new incidents
- **Background Message Handling**: Receive alerts even when app is closed
- **Local Notifications**: Device-level alerts for offline reports
- **Customizable Alerts**: Configure notification preferences
- **Proximity Alerts**: Notifications for crimes near user's location

### 📝 **Detailed Incident Reporting Forms**
- **Structured Data Collection**: 
  - Incident Type (Theft, Assault, Vandalism, etc.)
  - Date & Time of incident
  - Location details with coordinates
  - Perpetrator description
  - Severity level (Low/Medium/High/Critical)
  - Detailed incident narrative
  - Witness information
- **Form Validation**: Comprehensive input validation
- **Draft Saving**: Auto-save functionality for incomplete reports
- **Media Attachment**: Link photos, videos, and audio to reports

### 🎮 **Gamification System**
- **Points & Rewards**: Earn points for submitting verified reports
- **User Levels**: Progressive leveling system (every 100 points = 1 level)
- **Leaderboards**: Community engagement through competitive rankings
- **Badges & Achievements**: Recognition for consistent reporting
- **Activity Tracking**: Personal statistics and contribution history

### 🌐 **Community Integration**
- **Discussion Forums**: Community platform (satarknity.vercel.app)
- **Report Comments**: Collaborative information sharing on incidents
- **User Profiles**: Public profiles showcasing contributions
- **Following System**: Follow other users and their reports
- **Report Verification**: Community-driven report validation

### 🎥 **Video Calling & Emergency Communication**
- **Zego UIKit Integration**: High-quality video/audio calling
- **Emergency Video Calls**: Direct video link to emergency responders
- **Screen Sharing**: Share screen during emergency situations
- **Group Calls**: Multiple participants in emergency scenarios
- **Call History**: Track emergency communication logs

### 🌙 **Themes & UI Customization**
- **Light/Dark Mode**: System-level theme switching
- **Custom Color Schemes**: Branded color palette (Indigo/Deep Orange)
- **Responsive Design**: Adaptive layouts for all screen sizes
- **Consistent Theming**: Material Design 3 principles
- **Accessibility Features**: Screen reader support and high contrast modes

### 📲 **Onboarding Experience**
- **Welcome Screens**: 3-step onboarding flow
- **Feature Introduction**: Guided tour of app capabilities
- **Permission Requests**: Contextual permission explanations
- **Skip Functionality**: Option to skip onboarding for experienced users

---

## 🛠️ Technologies Used

### **Frontend Framework**
- **Flutter 3.6.1+**: Cross-platform mobile development framework
  - Dart SDK 3.6.1+
  - Material Design 3 UI components
  - GetX for state management and routing
  - Provider pattern for dependency injection

### **Backend & Database**
- **Supabase**:
  - PostgreSQL database for structured data storage
  - Real-time subscriptions for live updates
  - Row-level security (RLS) for data protection
  - RESTful API with auto-generated endpoints
  - Built-in authentication service
  - URL: `vuilqikbakoyydfrjggt.supabase.co`

- **Firebase Suite**:
  - **Firebase Core** (v3.12.1): Foundation for Firebase services
  - **Cloud Firestore** (v5.6.5): NoSQL document database for unstructured data
  - **Firebase Storage** (v12.4.4): Cloud storage for media files (images, videos, audio)
  - **Firebase Messaging** (v15.2.5): Push notifications and FCM integration
  - **Firebase Analytics**: User behavior tracking and app analytics

### **Mapping & Geolocation**
- **Flutter Map** (v8.1.1): Interactive map widget
  - OpenStreetMap tile layers
  - Custom marker support
  - Gesture handling (zoom, pan, rotate)
  - Multi-layer support
- **LatLong2** (v0.9.1): Geographic coordinate handling
- **Geolocator** (v13.0.3): 
  - GPS location tracking
  - Location permissions management
  - Distance calculations
  - Background location updates

### **Mesh Networking**
- **Bridgefy SDK** (v1.1.9):
  - Offline peer-to-peer communication
  - Bluetooth Low Energy (BLE) mesh networking
  - WiFi Direct support
  - Broadcast and direct messaging modes
  - Automatic mesh routing

### **Media & Multimedia**
- **Image Picker** (v1.1.2): Gallery and camera access
- **Camera** (v0.11.1): Advanced camera controls
- **Audioplayers** (v6.4.0): Audio playback functionality
- **Record** (v6.0.0): Audio recording with multiple formats

### **Video Communication**
- **Zego UIKit Prebuilt Call** (v4.16.27):
  - Real-time video/audio calling
  - One-on-one and group calls
  - Call invitation system
  - Screen sharing capabilities
  - Call quality monitoring

### **State Management & Architecture**
- **GetX** (v4.6.6): 
  - Reactive state management
  - Dependency injection
  - Route management
  - Internationalization support
- **Provider** (v6.1.4): Lightweight state management for simple scenarios

### **Local Storage & Persistence**
- **Shared Preferences** (v2.2.2): Key-value storage for settings
- **Get Storage** (v2.1.1): Fast, lightweight local database
- **Path Provider** (v2.1.5): File system path access
- **Sqflite**: SQLite database for offline report storage

### **Networking**
- **HTTP** (v1.3.0): RESTful API communication
- **HTTP Parser** (v4.1.2): HTTP response parsing utilities

### **UI/UX Enhancement**
- **Iconsax** (v0.0.8): Modern icon pack
- **Flutter Native Splash** (v2.4.5): Custom splash screens
- **URL Launcher** (v6.3.0): Deep linking and external URL handling
- **Vibration** (v3.1.3): Haptic feedback

### **Utilities**
- **Intl** (v0.19.0): Internationalization and date formatting
- **Logger** (v2.4.0): Advanced logging with multiple levels
- **Permission Handler** (v11.4.0): Runtime permission management

### **Notifications**
- **Flutter Local Notifications** (v19.0.0):
  - Scheduled notifications
  - Custom notification channels
  - Action buttons in notifications
  - Notification sound customization

### **Development & Quality**
- **Flutter Lints** (v5.0.0): Code quality and style enforcement
- **Flutter Test**: Unit and widget testing framework
- **Analysis Options**: Custom lint rules and code standards

### **Platform-Specific Integrations**
- **Android**:
  - Gradle build system
  - ProGuard for code obfuscation
  - Google Services integration
  - Android 12+ splash screen API

- **iOS**:
  - Xcode project configuration
  - CocoaPods dependency management
  - iOS 13+ support

- **Web**:
  - Progressive Web App (PWA) support
  - Web manifest configuration

---

## 📦 Project Structure

```
lib/
├── main.dart                      # Application entry point
├── app.dart                       # App configuration & routing
├── firebase_options.dart          # Firebase configuration
│
├── controllers/                   # Business logic controllers
│   └── form_report_controller.dart
│
├── services/                      # Backend service integrations
│   ├── bridgefy_service.dart     # Mesh networking service
│   ├── form_report_service.dart  # Report submission service
│   └── local_notification_service.dart
│
├── views/                         # UI screens
│   ├── map_screen.dart           # Main map interface
│   ├── audio_form.dart           # Audio evidence form
│   ├── video_form.dart           # Video evidence form
│   ├── screens_navbar.dart       # Navigation screens
│   ├── custom_navbar.dart        # Bottom navigation bar
│   └── bt.dart                   # Bluetooth utilities
│
├── onboarding_screen/            # Onboarding flow
│   ├── boarding.dart
│   ├── onboarding_controller.dart
│   ├── onboarding_skip.dart
│   └── onboarding_widget.dart
│
├── login_files/                  # Authentication screens
│   ├── loginscreen.dart
│   └── forgotpassword.dart
│
├── signup_files/                 # Registration screens
│   ├── signup.dart
│   ├── signupform.dart
│   ├── signup_controller.dart
│   ├── verify_email.dart
│   ├── successscreen.dart
│   └── resetscreen.dart
│
├── supabase/                     # Supabase configuration
│   ├── supa_config.dart          # Database connection
│   └── user_service.dart         # User management
│
├── utils/                        # Utility classes
│   ├── constants/                # App constants
│   │   ├── colors.dart
│   │   ├── enums.dart
│   │   ├── helperfunctions.dart
│   │   ├── image_strings.dart
│   │   ├── Logger.dart
│   │   ├── spacingstyle.dart
│   │   ├── tappbar.dart
│   │   ├── text_sizes.dart
│   │   ├── text_strings.dart
│   │   └── validators.dart
│   │
│   └── theme/                    # Theme configuration
│       ├── custom_theme/
│       │   ├── theme.dart
│       │   ├── text_theme.dart
│       │   ├── appbartheme.dart
│       │   ├── elevatedbuttontheme.dart
│       │   ├── inputdecoration.dart
│       │   └── [other theme files]
│       └── device_utility.dart
│
└── community.dart                # Community features

assets/
├── logos/                        # App logos and branding
│   ├── logo.png
│   ├── logotr.png
│   ├── google.png
│   └── fb.png
└── onboarding/                   # Onboarding images
    ├── onboarding1.png
    ├── onboarding2.png
    ├── onboarding3.png
    ├── verify_email.gif
    ├── resend_email.gif
    └── success_screen.gif
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.6.1 or higher)
- Dart SDK (3.6.1 or higher)
- Android Studio / Xcode (for mobile development)
- Firebase account with active project
- Supabase account with configured database

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd live_crime_reporter
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to `ios/Runner/`
   - Update `firebase_options.dart` with your project credentials

4. **Configure Supabase**
   - Update `lib/supabase/supa_config.dart` with your Supabase URL and anon key

5. **Configure Bridgefy**
   - Obtain API key from Bridgefy dashboard
   - Update API key in `lib/services/bridgefy_service.dart`

6. **Run the app**
```bash
flutter run
```

---

## 🔑 API Keys & Configuration

The following services require API keys:
- **Firebase**: Project configuration in `firebase_options.dart`
- **Supabase**: URL and anon key in `supa_config.dart`
- **Bridgefy**: API key in `bridgefy_service.dart`
- **Zego**: App ID and App Sign for video calling

---

## 📱 Supported Platforms
- ✅ Android (API 21+)
- ✅ iOS (13.0+)
- ⚠️ Web (limited features)
- ⚠️ Windows (limited features)
- ⚠️ macOS (limited features)
- ⚠️ Linux (limited features)

---

## 🤝 Contributing
Contributions are welcome! Please follow standard Git workflow:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

---

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👥 Team & Support
For questions, issues, or feature requests, please contact the development team or create an issue in the repository.

---

## 🔗 External Integrations
- **Analytics Dashboard**: https://crime-dashboard-filters.vercel.app
- **Community Platform**: https://satarknity.vercel.app
- **Virtual Escort Service**: https://satark-sehli.vercel.app
