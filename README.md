# PokemansDex

A Flutter application that demonstrates modern state management using Riverpod, featuring a clean architecture approach to display Pokemon data from the PokeAPI.

## Features

- Display Pokemon list with infinite scrolling
- View detailed Pokemon statistics
- Favorite Pokemon management with persistent storage
- Clean architecture with Riverpod state management
- Responsive UI with loading states

## Tech Stack

- Flutter
- Riverpod for state management
- Dio for API requests
- GetIt for dependency injection
- SharedPreferences for local storage
- Google Fonts for typography
- Skeletonizer for loading states

## Project Structure

```
📁 lib/
 ├─📁 controllers/    # Business logic
 ├─📁 models/         # Data models
 ├─📁 providers/      # State management
 ├─📁 service/        # External services
 ├─📁 widgets/        # UI components
 └─📄 main.dart       # Application entry
```

## Getting Started

1. Clone the repository: `git clone https://github.com/LanseylowT/pokemans-dex.git`
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Project Architecture

The application follows a clean architecture pattern with:

### Providers

- `pokemanDataProvider`: Fetches individual Pokemon data
- `favoritePokemansProvider`: Manages favorite Pokemon list

### Controllers

- `HomePageController`: Handles Pokemon list pagination and state

### Services

- `HTTPService`: API communication
- `DatabaseService`: Local storage management

### Widgets

- `PokemanCard`: Displays Pokemon in grid view
- `PokemanListTile`: Shows Pokemon in list view
- `PokemanStatsCard`: Pokemon statistics dialog

## Code Documentation

For detailed documentation, see the inline documentation in each file:

- `/lib/providers/` - State management
- `/lib/controllers/` - Business logic
- `/lib/widgets/` - UI components

## Screenshots

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
