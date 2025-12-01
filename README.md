<div align="center">
  <img src="assests/Banner.jpeg" alt="Pokedex Banner" width="100%" style="border-radius: 20px;"/>
</div>

<div align="center">
  <img src="assests/Symbol.png" alt="Pokemon Logo" width="80"/>
  
  <h1>Pokédex App</h1>
  
  <h3>Complete Pokémon Discovery & Collection System</h3>
  <p><em>Browse, search, and favorite your Pokémon with authentication, infinite scrolling, and beautiful light/dark mode UI</em></p>

  <p>
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
    <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase"/>
    <img src="https://img.shields.io/badge/API-PokeAPI-EF5350?style=for-the-badge&logo=pokemon&logoColor=white" alt="PokeAPI"/>
  </p>
</div>

---

A beautiful and modern Flutter application that allows users to browse, search,
and favorite Pokémon using the [PokeAPI](https://pokeapi.co/). Features Firebase
authentication with Google Sign-In, infinite scroll pagination, favorites
management, light/dark mode, and a clean Material Design interface.

## Features ✨

- 🔐 **Firebase Authentication** - Secure user authentication with
  email/password and Google Sign-In
- 👤 **User Profiles** - Personalized profiles with Firebase user data
- 🔍 **Search Functionality** - Search for Pokémon by name or ID with real-time
  filtering
- 📱 **Responsive UI** - Clean and modern Material Design interface with grid
  layout
- 🌓 **Light/Dark Mode** - Beautiful theme switching with persistent preferences
- 🌐 **API Integration** - Fetches real-time Pokémon data from PokeAPI with
  parallel requests
- 🖼️ **High-Quality Images** - Displays official Pokémon artwork (PNG format)
- 📋 **Infinite Scroll** - Automatically loads more Pokémon as you scroll (20 at
  a time)
- ❤️ **Favorites System** - Add/remove Pokémon to favorites with persistent
  state
- 🔎 **Favorites Search** - Search through your favorite Pokémon
- 📊 **Detailed Pokemon Info** - View stats, abilities, types, and evolution
  chains
- 🎯 **Optimized Performance** - Parallel API requests for faster loading
- 🎨 **Beautiful Cards** - Pokémon cards with images, names, and formatted IDs
- 🧭 **Bottom Navigation** - Easy navigation between Home, Favorites, and
  Profile screens

## Project Structure 📁

```
lib/
├── main.dart                      # App entry point with Firebase initialization
├── firebase_options.dart          # Firebase configuration
├── models/
│   ├── pokemon.dart              # Pokemon data model with equality methods
│   ├── pokemon_detail.dart       # Detailed Pokemon information model
│   └── user_profile.dart         # User profile model
├── controllers/
│   ├── pokemon_controller.dart   # Pokemon fetching logic
│   ├── favorites_controller.dart # Favorites management with ChangeNotifier
│   ├── theme_controller.dart     # Theme management with light/dark mode
│   └── auth_controller.dart      # Authentication controller
├── services/
│   ├── api_services.dart         # API service with parallel requests
│   └── auth_service.dart         # Firebase authentication service
└── views/
    ├── screens/
    │   ├── auth_wrapper.dart     # Authentication state wrapper
    │   ├── login_screen.dart     # Login with email/Google
    │   ├── signup_screen.dart    # User registration
    │   ├── forgot_password_screen.dart # Password reset
    │   ├── home_screen.dart      # Main screen with infinite scroll
    │   ├── favorites_screen.dart # Favorites management screen
    │   ├── profile_screen.dart   # User profile with settings
    │   └── details_screen.dart   # Pokemon detail view with stats/evolution
    └── widgets/
        ├── search_bar.dart       # Custom search bar widget
        └── pokemon_card.dart     # Reusable Pokemon card with favorite button

test/
├── controllers/
│   └── pokemon_controller_test.dart # Unit tests for Pokemon controller
└── views/
    └── widgets/
        ├── pokemon_card_test.dart   # Widget tests for Pokemon card
        └── search_bar_test.dart     # Widget tests for search bar
```

## Technologies Used 🛠️

- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **Firebase Auth** - User authentication and management
- **Firebase Core** - Firebase platform integration
- **Google Sign-In** - OAuth authentication with Google
- **HTTP Package** - For API requests
- **PokeAPI** - RESTful Pokemon API

## Getting Started 🚀

### Prerequisites

- Flutter SDK (3.10.0 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/itumelengseema/pokedex_app.git
   cd pokedex_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   - Create a Firebase project at
     [Firebase Console](https://console.firebase.google.com/)
   - Add an Android app to your Firebase project
   - Download `google-services.json` and place it in `android/app/`
   - Enable Email/Password and Google Sign-In in Authentication settings
   - For Google Sign-In, add your SHA-1 fingerprint (see
     [GOOGLE_SIGNIN_SETUP.md](GOOGLE_SIGNIN_SETUP.md))

4. **Run the app**
   ```bash
   flutter run
   ```

## API Integration 🌐

The app uses the [PokeAPI](https://pokeapi.co/) to fetch Pokémon data:

- **Base URL**: `https://pokeapi.co/api/v2/pokemon/`
- **Endpoints Used**:
  - `/pokemon?offset={offset}&limit={limit}` - Fetch paginated list of Pokémon
  - `/pokemon/{id}/` - Fetch individual Pokémon details
- **Image Source**: Official artwork from
  `sprites.other.official-artwork.front_default`
- **Optimization**: Parallel API requests using `Future.wait()` for faster
  loading

## App Screenshots 📸

<p align="center">
  <img src="assests/screenshots/splash_screen.png" width="200" />
  <img src="assests/screenshots/home_screen.png" width="200" />
  <img src="assests/screenshots/profile_screen.png" width="200" />
  <img src="assests/screenshots/pokemon_detail.png" width="200" />
</p>


## Key Components 🔑

### Authentication System

- Email/password authentication with Firebase
- Google Sign-In integration with OAuth
- Password reset functionality
- Secure user session management
- Auth state wrapper for protected routes
- Clean modern login/signup UI with black theme

### Home Screen

- Displays Pokémon logo and branding
- Search bar for filtering Pokémon
- 2-column grid view with infinite scroll
- Favorite buttons on each card
- Automatic pagination (loads 20 Pokémon at a time)
- Loading indicators for smooth UX
- ScrollController for detecting scroll position
- Light/dark mode support

### Profile Screen

- Firebase user information display
- Theme toggle for light/dark mode
- Member since date
- Edit profile option (coming soon)
- Logout functionality with confirmation
- Modern card-based layout

### Details Screen

- Comprehensive Pokémon information
- Stats visualization with progress bars
- Types and abilities display
- Evolution chain with images
- Height and weight information
- Full light/dark mode support
- Dynamic color theming

### Favorites Screen

- Displays all favorited Pokémon
- Search functionality to filter favorites
- Add/remove favorites with heart icon
- Empty state with helpful messaging
- Real-time updates when favorites change
- Grid layout matching home screen

### Pokémon Card Widget

- Reusable component with favorite functionality
- High-quality Pokémon images with error handling
- Formatted Pokémon ID (#001, #025, etc.)
- Capitalized Pokémon names
- Heart icon for favorites (filled when favorited)
- Smooth animations and interactions

### Theme Controller

- Light/dark mode switching
- Persistent theme preferences
- ChangeNotifier for reactive updates
- Dynamic color schemes throughout app

### Favorites Controller

- ChangeNotifier for state management
- Add/remove/toggle favorites
- Search favorites by name or ID
- Persistent favorites list
- Notifies listeners on changes

### API Services

- Parallel HTTP requests for performance
- Handles pagination with offset/limit
- Parses JSON responses efficiently
- Error handling with fallbacks
- Fetches high-quality PNG artwork
- Detailed Pokémon information including evolution chains
- Graceful degradation if images fail

## Dependencies 📦

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.6.0                    # For API requests
  firebase_core: ^4.2.1           # Firebase platform integration
  firebase_auth: ^6.1.2           # User authentication
  google_sign_in: ^6.2.2          # Google OAuth authentication
  flutter_native_splash: ^2.4.7   # Native splash screen
  mockito: ^5.6.1                 # Mocking for tests

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0           # Flutter linting rules
  build_runner: ^2.10.4           # Code generation for mocks
```

## Testing 🧪

The app includes comprehensive unit and widget tests to ensure code quality and reliability.

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/controllers/pokemon_controller_test.dart
```

### Test Structure

- **Unit Tests**: Test business logic in controllers
  - `pokemon_controller_test.dart` - Tests Pokemon fetching logic
- **Widget Tests**: Test UI components
  - `pokemon_card_test.dart` - Tests Pokemon card widget behavior
  - `search_bar_test.dart` - Tests search functionality

### Test Coverage

- Controllers: Unit tested with mocked HTTP clients
- Widgets: Widget tested for user interactions and display
- Mocking: Uses Mockito for dependency injection

## Development 💻

### Architecture Pattern

- **MVC Pattern**: Separation of Models, Views, and Controllers
- **State Management**: ChangeNotifier for favorites and theme
- **Firebase Integration**: Authentication and user management
- **Widget Composition**: Reusable, modular widgets
- **Service Layer**: Abstracted API and authentication calls
- **Auth Wrapper**: Stream-based authentication state management
- **Test-Driven Development**: Comprehensive unit and widget tests

### Adding New Features

1. Create new widgets in `lib/views/widgets/`
2. Add business logic to `lib/controllers/`
3. Update models in `lib/models/` if needed
4. Integrate API calls through `lib/services/api_services.dart`
5. Write unit/widget tests in `test/` directory
6. Run tests to ensure functionality

### Performance Optimizations

- Parallel API requests reduce loading time by ~10x
- Infinite scroll loads data on-demand
- Image caching for faster subsequent loads
- Efficient list rendering with GridView.builder
- Optimized widget rebuilds with ChangeNotifier


## Acknowledgments 🙏

- [PokeAPI](https://pokeapi.co/) for providing the Pokemon data
- [Firebase](https://firebase.google.com/) for authentication services
- Flutter team for the amazing framework
- Pokemon Company for the wonderful Pokemon universe

## Contact 📧

**Itumeleng Seema**

- GitHub: [@itumelengseema](https://github.com/itumelengseema)

