# MVVM-C with Tab Navigation - iOS ARC Project

A complete implementation of the MVVM-C (Model-View-ViewModel-Coordinator) pattern with `UITabBarController` navigation and per-feature folder organization.

## ✨ Features

- **Tab-Based Navigation** - 4 main tabs: Products, Profile, Cart, Settings
- **Per-Feature Organization** - Each feature contains its own Coordinator, ViewModel, View, Model, Service
- **Deep Linking** - Custom URL scheme (`mvvmc://`) support
- **Dependency Injection** - All components accept injected dependencies
- **Protocol-Based Design** - Testable architecture with service protocols
- **Modern Logging** - Uses `os_log` for efficient logging

## 📁 Project Structure

```
ios_arc_learning_project/
├── App/                          # Application entry point
│   ├── AppDelegate.h/m
│   ├── main.m
│   └── Info.plist
├── Core/                         # Shared infrastructure
│   ├── Protocols/
│   │   ├── Coordinator.h
│   │   └── DeepLinkable.h
│   ├── Base/
│   │   └── BaseCoordinator.h/m
│   ├── Routing/
│   │   ├── DeepLinkRoute.h/m
│   │   └── URLRouter.h/m
│   └── Constants/
│       └── DesignConstants.h
├── Features/                     # Feature modules
│   ├── MainTab/                  # Tab bar coordinator
│   │   └── Coordinator/
│   │       └── AppCoordinator.h/m
│   ├── Products/                 # Products feature
│   │   ├── Coordinator/
│   │   ├── ViewModel/
│   │   ├── View/
│   │   ├── Model/
│   │   └── Service/
│   ├── Profile/                  # Profile feature
│   │   ├── Coordinator/
│   │   ├── ViewModel/
│   │   ├── View/
│   │   ├── Model/
│   │   └── Service/
│   ├── Cart/                     # Cart feature (placeholder)
│   │   ├── Coordinator/
│   │   ├── ViewModel/
│   │   └── View/
│   └── Settings/                 # Settings feature
│       ├── Coordinator/
│       ├── ViewModel/
│       └── View/
└── TestSupport/                  # Test fixtures per feature
    ├── Products/
    ├── Profile/
    ├── Cart/
    └── Settings/
```

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      AppCoordinator                          │
│                    (UITabBarController)                      │
│                            │                                 │
│     ┌──────────┬───────────┼───────────┬──────────┐         │
│     │          │           │           │          │         │
│  Products   Profile      Cart     Settings        │         │
│  Coordinator Coordinator Coordinator Coordinator  │         │
│     │          │           │           │          │         │
│  (UINav)    (UINav)     (UINav)    (UINav)       │         │
└─────────────────────────────────────────────────────────────┘
```

## 🔗 Deep Linking

Supported URL schemes:
- `mvvmc://products` - Products tab
- `mvvmc://products/{id}` - Product detail
- `mvvmc://profile` - Profile tab
- `mvvmc://cart` - Cart tab
- `mvvmc://settings` - Settings tab

## 📱 Requirements

- iOS 12.0+
- Xcode 15.0+
- Objective-C with ARC

## 🚀 Getting Started

1. Open the project in Xcode
2. Select a simulator or device
3. Build and run (⌘R)

## 📄 License

Educational purposes - MIT License
