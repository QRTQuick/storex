# Shop App - Flutter Mobile Application

A complete Flutter mobile app for online shop management with InsForge backend.

## Features

- **User Authentication**: Login/Signup with role selection (Buyer/Owner)
- **Shop Management**: Create shops with website booking
- **Product Management**: 
  - Snap product photos using camera
  - Select from 10 categories
  - Fill in product info (name, description, price)
  - Toggle availability (Available/Sold)
- **Role Switching**: Switch between Owner and Buyer modes
- **Admin Panel**: Exclusive access for chisomlifeeke@gamil.com

## Backend

This app uses **InsForge** as the backend service.

### Setup InsForge CLI

```bash
# Login to InsForge
npx @insforge/cli login --user-api-key uak_vVzpTs7_PMX--OcfwcxLg2-YD8y_8k2XaxHxXWwh8PM

# Link project
npx @insforge/cli link --project-id 3b4bec2b-c107-4241-a90e-aa4e98065648
```

## Getting Started

### Prerequisites

- Flutter SDK (3.24.0 or higher)
- Java JDK 17
- Android Studio / VS Code
- InsForge CLI

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd shop_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Build APK

### Local Build

```bash
cd shop_app
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

### GitHub Actions Build

This project includes a GitHub Actions workflow that automatically builds the APK:

1. Push code to `main` or `master` branch
2. GitHub Actions will automatically:
   - Set up Flutter and Java
   - Install dependencies
   - Build the release APK
   - Upload the APK as an artifact
   - Create a GitHub Release with the APK attached

#### Manual Trigger

You can also manually trigger the build:
1. Go to the **Actions** tab in your GitHub repository
2. Select **Build Flutter APK** workflow
3. Click **Run workflow**
4. Download the APK from the artifacts or release section

## Project Structure

```
shop_app/
├── lib/
│   ├── main.dart              # App entry point
│   ├── models/                # Data models
│   │   ├── user.dart
│   │   ├── shop.dart
│   │   └── product.dart
│   ├── services/              # API and auth services
│   │   ├── auth_service.dart
│   │   └── insforge_service.dart
│   ├── providers/             # State management
│   │   └── app_provider.dart
│   └── screens/               # UI screens
│       ├── login_screen.dart
│       ├── signup_screen.dart
│       ├── home_screen.dart
│       ├── shop_create_screen.dart
│       ├── shop_detail_screen.dart
│       ├── product_add_screen.dart
│       ├── product_list_screen.dart
│       ├── admin_screen.dart
│       └── splash_screen.dart
├── .github/
│   └── workflows/
│       └── build_apk.yml      # GitHub Actions workflow
├── pubspec.yaml               # Dependencies
└── README.md
```

## Admin Access

The admin panel is exclusively accessible to:
- Email: `chisomlifeeke@gamil.com`

## License

This project is licensed under the MIT License.

## Support

For issues and questions, please open an issue on the GitHub repository.
