//
//  AppDelegate.m
//  MVVM-C-ARC
//
//  Application Delegate Implementation
//  ARC Version
//

#import "AppDelegate.h"
#import "AppCoordinator.h"
#import "URLRouter.h"

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Create the main window programmatically
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // Create and start the app coordinator
  self.appCoordinator = [[AppCoordinator alloc] initWithWindow:self.window];
  [self.appCoordinator start];

  return YES;
}

#pragma mark - Deep Linking

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:
                (NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
  // Handle custom URL scheme
  return [self.appCoordinator handleDeepLinkURL:url];
}

- (BOOL)application:(UIApplication *)application
    continueUserActivity:(NSUserActivity *)userActivity
      restorationHandler:
          (void (^)(NSArray<id<UIUserActivityRestoring>> *_Nullable))
              restorationHandler {
  // Handle Universal Links
  return [self.appCoordinator handleUserActivity:userActivity];
}

#pragma mark - Application Lifecycle

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
