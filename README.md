# Task Twelve - Product Listing App

A production-ready Flutter application demonstrating product listing with API integration, image sliders, navigation, and item management features.

## Features

### Product List Screen
- ✅ Fetch product list using Dio HTTP client
- ✅ Proper error handling and loading states
- ✅ Image slider (CarouselSlider) inside each list tile (minimum 3 images)
- ✅ Product title and price display
- ✅ Pull-to-refresh functionality
- ✅ Infinite scroll pagination (load more products)
- ✅ Dismissible slide-to-delete feature
- ✅ UI updates using state management after deletion

### Product Details Screen
- ✅ Navigation using go_router (Navigator 2.0)
- ✅ Large image slider with indicators
- ✅ Complete product information display:
  - Title
  - Description
  - Price with discount calculation
  - Rating
  - Stock availability
  - Brand and Category
- ✅ Data passed via routing
- ✅ Proper null-handling and defensive programming

## Architecture

### Folder Structure
```
lib/
├── cubit/              # State management (BLoC/Cubit)
│   ├── product_list_cubit.dart
│   └── product_list_state.dart
├── models/             # Data models
│   └── product_model.dart
├── repository/         # API repository layer
│   └── product_repository.dart
├── repo_api/           # API configuration
│   ├── dio_helper.dart
│   ├── app_interceptor.dart
│   └── rest_constants.dart
├── routes/             # Navigation (go_router)
│   └── app_router.dart
├── screens/            # UI screens
│   ├── product_list_screen.dart
│   └── product_detail_screen.dart
├── resources/          # App resources
│   ├── color.dart
│   └── strings.dart
├── utils/              # Utility classes
│   ├── app_constants.dart
│   ├── app_utils.dart
│   ├── shared_preference_util.dart
│   └── slide_left_route.dart
└── main.dart          # App entry point
```

### State Management
This project uses **BLoC (Cubit)** pattern for state management:
- `ProductListCubit`: Manages product list state, pagination, and deletion
- States: `ProductListInitial`, `ProductListLoading`, `ProductListLoaded`, `ProductListError`

### Repository Pattern
- `ProductRepository`: Handles all API calls
- Separates business logic from data sources
- Provides clean interface for data operations

## Setup Instructions

### Prerequisites
- Flutter SDK (3.10.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- iOS Simulator / Android Emulator or physical device

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd tasktwelve
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### API Access
Before starting, call **8460246281** to get access to the DummyJSON API.

## Dependencies

### Core Dependencies
- `flutter_bloc: ^8.1.6` - State management
- `dio: ^5.7.0` - HTTP client
- `go_router: ^14.2.7` - Navigation (Navigator 2.0)
- `carousel_slider: ^5.0.0` - Image slider
- `cached_network_image: ^3.4.1` - Image caching
- `equatable: ^2.0.5` - Value equality
- `flutter_screenutil: ^5.9.3` - Responsive design
- `pretty_dio_logger: ^1.4.0` - API logging
- `shared_preferences: ^2.3.3` - Local storage

## API Endpoints

### Base URL
```
https://dummyjson.com/
```

### Endpoints Used
- `GET /products` - Get products list with pagination
  - Query parameters: `skip`, `limit`
- `GET /products/:id` - Get single product by ID
- `DELETE /products/:id` - Delete product (simulated)

### Example Request
```dart
GET https://dummyjson.com/products?skip=0&limit=30
```

## Key Implementation Details

### Pagination
- Loads 30 products per page
- Automatically loads more when user scrolls to 80% of the list
- Maintains scroll position during refresh

### Image Slider
- Uses CarouselSlider for smooth image transitions
- Auto-plays with 3-second intervals
- Shows at least 3 images per product
- Falls back to thumbnail if images are unavailable

### State Management Flow
1. User action triggers Cubit method
2. Cubit emits loading state
3. Repository makes API call
4. Cubit processes response and emits new state
5. UI rebuilds based on new state

### Error Handling
- Network errors are caught and displayed
- Loading states prevent duplicate requests
- Error states preserve existing data when possible
- User-friendly error messages

## Testing Checklist

- [x] Fetch product list
- [x] Pagination (infinite scroll)
- [x] Pull-to-refresh
- [x] Delete item (dismissible)
- [x] Navigate to details screen
- [x] Image slider working
- [x] Error handling
- [x] Loading states

## Demo Video Features

The demo video should showcase:
1. ✅ Fetching product list from API
2. ✅ Scrolling and pagination (loading more products)
3. ✅ Pull-to-refresh functionality
4. ✅ Deleting an item by swiping
5. ✅ Navigating to product details screen
6. ✅ Image slider working in both list and detail screens

## Notes

- The DummyJSON API doesn't actually delete products, so deletion is simulated locally
- Images are cached using `cached_network_image` for better performance
- The app uses defensive programming with null-safety throughout
- All navigation uses go_router for type-safe routing

## License

This project is created for demonstration purposes.
