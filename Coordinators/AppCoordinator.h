//
//  AppCoordinator.h
//  MVVM-C-ARC
//
//  AppCoordinator - Root coordinator that manages the entire app flow
//  ARC Version
//

#import "BaseCoordinator.h"
#import "DeepLinkable.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppCoordinator : BaseCoordinator <DeepLinkable>

/// The app's main window
@property(nonatomic, strong) UIWindow *window;

/// Initialize with the app's window
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
