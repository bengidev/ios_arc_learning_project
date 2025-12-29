//
//  AppCoordinator.h
//  MVVM-C-ARC
//
//  AppCoordinator - Root coordinator that manages UITabBarController
//  ARC Version
//

#import "BaseCoordinator.h"
#import "DeepLinkable.h"

@class URLRouter;
@class ProductsCoordinator;
@class ProfileCoordinator;
@class CartCoordinator;
@class SettingsCoordinator;
@protocol ProductServiceProtocol;
@protocol UserServiceProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface AppCoordinator : BaseCoordinator <DeepLinkable>

/// The app's main window
@property(nonatomic, strong) UIWindow *window;

/// The tab bar controller managing the main tabs
@property(nonatomic, strong, readonly) UITabBarController *tabBarController;

/// The URL router for handling deep links
@property(nonatomic, strong, readonly) URLRouter *urlRouter;

#pragma mark - Child Coordinators

/// Products tab coordinator
@property(nonatomic, strong, readonly) ProductsCoordinator *productsCoordinator;

/// Profile tab coordinator
@property(nonatomic, strong, readonly) ProfileCoordinator *profileCoordinator;

/// Cart tab coordinator
@property(nonatomic, strong, readonly) CartCoordinator *cartCoordinator;

/// Settings tab coordinator
@property(nonatomic, strong, readonly) SettingsCoordinator *settingsCoordinator;

#pragma mark - Initialization

/// Initialize with all dependencies (preferred for full DI)
/// @param window The app's main window
/// @param urlRouter The URL router for deep linking
/// @param productService The service for fetching products
/// @param userService The service for fetching user data
- (instancetype)initWithWindow:(UIWindow *)window
                     urlRouter:(URLRouter *)urlRouter
                productService:(id<ProductServiceProtocol>)productService
                   userService:(id<UserServiceProtocol>)userService;

/// Initialize with the app's window (uses default dependencies)
/// Provided for convenience
- (instancetype)initWithWindow:(UIWindow *)window;

#pragma mark - Deep Linking

/// Handles an incoming deep link URL
/// @param url The URL to handle
/// @return YES if the URL was successfully handled
- (BOOL)handleDeepLinkURL:(NSURL *)url;

/// Handles a Universal Link via NSUserActivity
/// @param userActivity The user activity containing the URL
/// @return YES if the activity was successfully handled
- (BOOL)handleUserActivity:(NSUserActivity *)userActivity;

#pragma mark - Tab Navigation

/// Switches to the specified tab
/// @param tabIndex The index of the tab to switch to
- (void)switchToTab:(NSInteger)tabIndex;

@end

NS_ASSUME_NONNULL_END
