# ExploreGame - iOS Game Catalog App

A comprehensive iOS application built with SwiftUI and VIPER architecture that showcases games from the RAWG.io API. The app features a clean, modern interface following Apple's Human Interface Guidelines.

## Features

### Core Functionality
- **Game List Screen**: Browse games with infinite scrolling
- **Game Detail Screen**: View detailed information about selected games
- **About Screen**: Developer profile and app information
- **Search Functionality**: Search games by title with real-time filtering
- **Pull to Refresh**: Refresh game data by pulling down

### Technical Features
- **VIPER Architecture**: Clean separation of concerns with View, Interactor, Presenter, Entity, and Router
- **Reactive Programming**: Combine framework for data flow and API calls
- **Networking Layer**: Custom URLSession-based network manager
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Loading States**: Progress indicators and loading animations
- **SwiftLint Integration**: Code quality enforcement

## Architecture

### VIPER Components
- **View**: SwiftUI views for UI presentation
- **Interactor**: Business logic and data fetching
- **Presenter**: View model handling UI state and user interactions
- **Entity**: Data models for API responses
- **Router**: Navigation logic and module creation

### Project Structure
```
ExploreGame/
├── Modules/
│   ├── GameList/
│   │   ├── View/
│   │   ├── Interactor/
│   │   ├── Presenter/
│   │   ├── Entity/
│   │   └── Router/
│   ├── GameDetail/
│   │   ├── View/
│   │   ├── Interactor/
│   │   ├── Presenter/
│   │   ├── Entity/
│   │   └── Router/
│   └── About/
│       ├── View/
│       ├── Presenter/
│       └── Router/
├── Core/
│   ├── Networking/
│   ├── Extensions/
│   └── Utils/
└── Assets/
```

## API Integration

### RAWG.io API
- **Base URL**: https://api.rawg.io/api/games
- **API Key**: bb59da7d47634570b63f0261386b145a
- **Endpoints**:
  - `/games` - Game list with pagination and search
  - `/games/{id}` - Game detail information

### Data Models
- **Game**: Basic game information for lists
- **GameDetail**: Comprehensive game information
- **Platform**: Gaming platform information
- **Genre**: Game genre categorization
- **ESRB Rating**: Game rating information

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Getting Started

1. Clone the repository
2. Open `ExploreGame.xcodeproj` in Xcode
3. Build and run the project

## Code Quality

The project includes SwiftLint configuration for maintaining code quality standards:
- Line length limits
- Naming conventions
- Code complexity rules
- File organization standards

## Developer

**Muhammad Azri Fatihah Susanto**
- iOS Developer
- Swift & SwiftUI Enthusiast
- Clean Architecture Advocate

## License

This project is created for educational purposes and portfolio demonstration.