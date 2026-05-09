# Shop App - Flutter Mobile Application

A comprehensive Flutter mobile application for online shop management with InsForge backend integration.

## Features

### User Authentication
- Login and Sign Up functionality
- Role-based access (Buyer, Owner, Admin)
- Persistent session management

### For Shop Owners
- Create and manage online shop
- Book a website for the store
- Snap product photos using camera
- Select product category from predefined list
- Fill in product information (name, description, price, category)
- Toggle product availability (Available/Sold)
- View shop statistics (total products, available, sold)
- Switch between Owner and Buyer roles

### For Buyers
- Browse all available products
- Filter products by category
- View product details with images
- Switch to Owner role to start selling

### Admin Panel
- Exclusive access for `chisomlifeeke@gamil.com`
- View all users in the system
- Monitor all registered shops
- Track all products across all shops
- Statistics dashboard

## Tech Stack

- **Frontend**: Flutter
- **Backend**: InsForge
- **State Management**: Provider
- **Image Handling**: image_picker
- **Local Storage**: shared_preferences
- **HTTP Client**: http

## Project Structure

```
shop_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   ├── user.dart            # User model
│   │   ├── shop.dart            # Shop model
│   │   └── product.dart         # Product model
│   ├── services/
│   │   ├── auth_service.dart    # Authentication service
│   │   └── insforge_service.dart # InsForge API service
│   ├── providers/
│   │   └── app_provider.dart    # State management
│   └── screens/
│       ├── auth_wrapper.dart    # Auth state handler
│       ├── login_screen.dart    # Login UI
│       ├── signup_screen.dart   # Registration UI
│       ├── home_screen.dart     # Main home screen
│       ├── create_shop_screen.dart  # Shop creation
│       ├── shop_owner_screen.dart   # Owner dashboard
│       ├── buyer_screen.dart        # Buyer marketplace
│       ├── add_product_screen.dart  # Add product with camera
│       └── admin_panel_screen.dart  # Admin dashboard
├── assets/
│   └── images/
└── pubspec.yaml
```

## Setup Instructions

### Prerequisites
1. Flutter SDK installed
2. InsForge CLI installed and linked
3. Android Studio / VS Code with Flutter extensions

### Installation

1. Navigate to the project directory:
```bash
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

## Backend Configuration

The app is configured to use InsForge as the backend. The API service is located in `lib/services/insforge_service.dart`.

Key endpoints:
- Authentication: `/auth/signup`, `/auth/signin`
- Users: `/users/{id}`, `/users/{id}/role`
- Shops: `/shops`
- Products: `/products`
- Admin: `/admin/users`, `/admin/shops`

## Usage Flow

1. **New User**: Sign up → Choose role (Buyer/Owner)
2. **Owner**: Create shop → Add products (snap photo, select category, fill info) → Manage availability
3. **Buyer**: Browse products → Filter by category → Purchase (future feature)
4. **Admin**: Access admin panel automatically if email matches `chisomlifeeke@gamil.com`

## Key Features Implementation

### Camera Integration
- Uses `image_picker` package
- Capture product photos directly
- Preview before upload
- Image compression for optimal performance

### Category Selection
- Predefined categories dropdown
- Electronics, Clothing, Food & Beverages, etc.
- Easy categorization for better browsing

### Product Availability Toggle
- Simple switch to mark items as sold
- Visual indicators for availability status
- Real-time updates

### Role Switching
- Seamless transition between Buyer and Owner roles
- Different UI based on current role
- Persistent role selection

## Notes

- The admin panel is restricted to the email `chisomlifeeke@gamil.com`
- Product images are currently stored locally; in production, integrate with cloud storage
- The InsForge API endpoints should be updated with actual backend URLs
- Add payment integration for complete e-commerce functionality

## License

MIT License
