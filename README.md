# Currency Converter

A robust Flutter application designed to convert currencies using real-time exchange rates. This project demonstrates modern Flutter development practices, including Clean Architecture, Provider state management, and comprehensive testing.

## Screenshots

| Light Mode | Dark Mode |
|:---:|:---:|
| <!-- Insert Light Mode Screenshot Here --> <br> ![Light Mode]() | <!-- Insert Dark Mode Screenshot Here --> <br> ![Dark Mode]() |

## Features

*   **Real-time Conversion**: Convert amounts between different currencies with up-to-date exchange rates.
*   **Dynamic Theming**: Seamlessly switch between Light and Dark modes with a premium aesthetic.
*   **Clean Architecture**: structured codebase separating logic into Core and Feature layers for scalability and testability.
*   **State Management**: Efficient state handling using the `Provider` package.
*   **Robust Networking**: Reliable API interactions using `Dio`.

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Ensure you have the following installed:

*   [Flutter SDK](https://flutter.dev/docs/get-started/install)
*   Dart SDK (included with Flutter)

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/antigravity_demo.git
    cd antigravity_demo
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the application**
    ```bash
    flutter run
    ```

## Project Structure

The project adheres to a Clean Architecture pattern:

```
lib/
├── core/                   # Core functionality shared across the app
│   ├── errors/             # Custom exception handling
│   ├── network/            # Network managers (Dio)
│   ├── services/           # Shared services (CurrencyService)
│   └── theme/              # App theme definitions and provider
├── features/               # Feature-specific code
│   └── currency_converter/ # Currency Converter feature
│       ├── view/           # UI Screens
│       ├── view_model/     # State management logic
│       └── widgets/        # Reusable widgets
└── main.dart               # Application entry point
```

## Libraries & Tools

*   [Flutter](https://flutter.dev/) - UI Toolkit
*   [Provider](https://pub.dev/packages/provider) - State Management
*   [Dio](https://pub.dev/packages/dio) - HTTP Client
*   [Mocktail](https://pub.dev/packages/mocktail) - Testing

## Testing

To run the unit and widget tests:

```bash
flutter test
```
