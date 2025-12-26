//
//  AppCoordinator.h
//  MVVM-C-ARC
//
//  AppCoordinator - Root coordinator that manages the entire app flow
//  ARC Version
//

#import "BaseCoordinator.h"
#import "DeepLinkable.h"

@class URLRouter;
@protocol ProductServiceProtocol;
@protocol UserServiceProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface AppCoordinator : BaseCoordinator <DeepLinkable>

/// The app's main window
@property(nonatomic, strong) UIWindow *window;

/// The URL router for handling deep links
@property(nonatomic, strong, readonly) URLRouter *urlRouter;

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

/// Initialize with window and basic dependencies
/// @param window The app's main window
/// @param urlRouter The URL router for deep linking
/// @param productService The service for fetching products
- (instancetype)initWithWindow:(UIWindow *)window
                     urlRouter:(URLRouter *)urlRouter
                productService:(id<ProductServiceProtocol>)productService;

/// Initialize with the app's window (uses default dependencies)
/// Provided for backward compatibility
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

@end

NS_ASSUME_NONNULL_END
