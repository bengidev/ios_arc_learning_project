//
//  AppDelegate.m
//  ARC Project
//
//  Created for ARC Learning
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Create the main window programmatically
  // ARC: No need for autorelease - compiler handles it
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // Create the root view controller
  // ARC: No need for autorelease
  self.viewController = [[ViewController alloc] init];

  // Set as root view controller
  self.window.rootViewController = self.viewController;

  // Make visible
  [self.window makeKeyAndVisible];

  return YES;
}

// ARC: dealloc is optional and used only for non-memory cleanup
// - (void)dealloc {
//     // NO [super dealloc] in ARC!
//     // Only needed for: removing observers, invalidating timers, etc.
// }

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
