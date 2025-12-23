# MVVM-C Pattern with Deep Linking - ARC Version

A complete implementation of the MVVM-C (Model-View-ViewModel-Coordinator) pattern with deep linking support for **ARC (Automatic Reference Counting)** Objective-C projects.

## Project Structure

```
MVVM-C-ARC/
├── Protocols/
│   ├── Coordinator.h          # Base coordinator protocol
│   └── DeepLinkable.h         # Deep link handling protocol
├── Routing/
│   ├── DeepLinkRoute.h/m      # Parsed URL route model
│   └── URLRouter.h/m          # URL parsing and routing
├── Coordinators/
│   ├── BaseCoordinator.h/m    # Base coordinator class
│   ├── AppCoordinator.h/m     # Root app coordinator
│   ├── ProductsCoordinator.h/m
│   └── ProductDetailCoordinator.h/m
├── ViewModels/
│   ├── ProductListViewModel.h/m
│   └── ProductDetailViewModel.h/m
├── ViewControllers/
│   ├── ProductListViewController.h/m
│   └── ProductDetailViewController.h/m
└── Models/
    └── Product.h/m
```

## Integration

### 1. AppDelegate Setup

```objc
// AppDelegate.m
#import "AppCoordinator.h"
#import "URLRouter.h"

@interface AppDelegate ()
@property (nonatomic, strong) AppCoordinator *appCoordinator;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application 
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    // Initialize and start the app coordinator
    self.appCoordinator = [[AppCoordinator alloc] initWithWindow:self.window];
    [self.appCoordinator start];
    
    return YES;
}

// Handle custom URL schemes (e.g., myapp://products/123)
- (BOOL)application:(UIApplication *)app 
            openURL:(NSURL *)url 
            options:(NSDictionary *)options {
    return [self.appCoordinator handleDeepLinkURL:url];
}

// Handle Universal Links
- (BOOL)application:(UIApplication *)application 
    continueUserActivity:(NSUserActivity *)userActivity 
      restorationHandler:(void (^)(NSArray *))restorationHandler {
    return [self.appCoordinator handleUserActivity:userActivity];
}

@end
```

### 2. URL Scheme Configuration

Add to `Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>myapp</string>
        </array>
    </dict>
</array>
```

## Supported Deep Links

| URL | Action |
|-----|--------|
| `myapp://products` | Shows product list |
| `myapp://products/123` | Shows product with ID 123 |
| `myapp://products/123/reviews` | Shows reviews for product 123 |
| `myapp://profile` | Shows user profile |
| `myapp://settings` | Shows settings |
| `myapp://cart` | Shows shopping cart |

## Key ARC Memory Management Notes

- **Parent → Child Coordinator**: `strong` reference
- **Child → Parent Coordinator**: `weak` reference (breaks retain cycle)
- **ViewModel → Coordinator (delegate)**: `weak` reference
- **Blocks**: Use `__weak typeof(self) weakSelf = self;` pattern

## Testing Deep Links

```bash
# From Terminal
xcrun simctl openurl booted "myapp://products/101/reviews"
```
