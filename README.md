# Task Twelve - Product Listing App

A production-ready Flutter application demonstrating product listing with API integration, image sliders, navigation, and item management features.

## Setup Instructions

• **Prerequisites**
  - Flutter SDK (3.10.1 or higher)
  - Dart SDK
  - Android Studio / VS Code with Flutter extensions
  - iOS Simulator / Android Emulator or physical device

• **Installation Steps**
  1. Clone the repository: `git clone <repository-url> && cd tasktwelve`
  2. Install dependencies: `flutter pub get`
  3. Run the app: `flutter run`

• **Key Dependencies**
  - `flutter_bloc: ^8.1.6` - State management
  - `dio: ^5.7.0` - HTTP client
  - `go_router: ^14.2.7` - Navigation (Navigator 2.0)
  - `carousel_slider: ^5.0.0` - Image slider
  - `cached_network_image: ^3.4.1` - Image caching
  - `flutter_screenutil: ^5.9.3` - Responsive design
  - `shimmer: ^3.0.0` - Loading placeholders

## Architecture Explanation

• **Folder Structure**
```
lib/
├── base/                    # Base classes
│   └── base_stateful_state.dart
├── common_widgets/          # Reusable UI components
│   └── common_widgets.dart
├── repo_api/                # API configuration
│   ├── dio_helper.dart
│   ├── app_interceptor.dart
│   └── rest_constants.dart
├── repository/               # Repository pattern
│   └── product_repository.dart
├── routes/                   # Navigation
│   └── app_router.dart
├── screens/                  # UI screens
│   └── products/
│       ├── cubit/            # State management
│       │   ├── product_list_cubit.dart
│       │   └── product_list_state.dart
│       ├── models/           # Data models
│       │   └── product_model.dart
│       ├── product_list_screen.dart
│       └── product_detail_screen.dart
├── resources/                # App resources
│   ├── color.dart
│   └── strings.dart
├── utils/                    # Utility classes
│   ├── app_constants.dart
│   ├── app_utils.dart
│   ├── shared_preference_util.dart
│   └── slide_left_route.dart
└── main.dart                 # App entry point
```

• **Architectural Patterns**
  - **Repository Pattern**: Separates data sources from business logic
  - **BLoC/Cubit Pattern**: Manages application state
  - **Base Widget Pattern**: `BaseStatefulWidgetState` for consistent screen structure
  - **Modular Structure**: Feature-based organization (products feature grouped together)

• **Data Flow**
  1. UI triggers action → Cubit method called
  2. Cubit emits loading state → Repository called
  3. Repository makes API call → Response processed
  4. Cubit emits new state → UI rebuilds

## State Management Approach

• **BLoC/Cubit Pattern**
  - Uses `flutter_bloc` package for state management
  - `ProductListCubit` manages product list state, pagination, and deletion

• **State Classes**
  - `ProductListInitial`: Initial state
  - `ProductListLoading`: Loading state (preserves existing products)
  - `ProductListLoaded`: Success state with products and pagination info
  - `ProductListError`: Error state (preserves existing products for graceful degradation)

• **State Management Features**
  - Pagination support (load more products)
  - Pull-to-refresh functionality
  - Product deletion with undo option
  - Error handling with user-friendly messages
  - Loading states prevent duplicate API calls

• **Benefits**
  - Predictable state transitions
  - Easy to test business logic
  - Separation of concerns (UI vs Business Logic)
  - Reactive UI updates

## API Endpoints Used

• **Base URL**
  ```
  https://dummyjson.com/
  ```

• **Endpoints**
  - `GET /products` - Get products list with pagination
    - Query parameters: `skip` (offset), `limit` (page size)
    - Example: `GET /products?skip=0&limit=30`
  
  - `GET /products/:id` - Get single product by ID
    - Example: `GET /products/1`
  
  - `DELETE /products/:id` - Delete product (simulated locally)

• **API Configuration**
  - Dio HTTP client with interceptors
  - Request/response logging with `pretty_dio_logger`
  - Timeout configuration (connect, receive, send)
  - Error handling for network issues

• **Response Format**
  - Products list: `{ products: [], total: number, skip: number, limit: number }`
  - Single product: Product object with all details

## Features

• **Product List Screen**
  - Fetch products with pagination
  - Image slider (CarouselSlider) with animated indicators
  - Pull-to-refresh functionality
  - Infinite scroll pagination
  - Dismissible slide-to-delete with elegant UI
  - Loading states with shimmer effects
  - Error handling with retry option

• **Product Details Screen**
  - Large image slider with indicators
  - Complete product information display
  - Dynamic discount calculation
  - Rating and stock status
  - Brand and category chips

## Notes

• The DummyJSON API doesn't actually delete products, so deletion is simulated locally
• Images are cached using `cached_network_image` for better performance
• All strings are centralized in `strings.dart` for easy localization
• Screens use `BaseStatefulWidgetState` for consistent structure and navigation helpers
• Android network security configuration included for HTTPS connections
