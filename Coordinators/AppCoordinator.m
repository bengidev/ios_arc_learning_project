//
//  AppCoordinator.m
//  MVVM-C-ARC
//
//  AppCoordinator Implementation
//  ARC Version
//

#import "AppCoordinator.h"
#import "DeepLinkRoute.h"
#import "ProductsCoordinator.h"
#import "URLRouter.h"

@interface AppCoordinator ()
@property(nonatomic, strong) ProductsCoordinator *productsCoordinator;
@end

@implementation AppCoordinator

#pragma mark - Initialization

- (instancetype)initWithWindow:(UIWindow *)window {
  // Create the root navigation controller
  UINavigationController *navController = [[UINavigationController alloc] init];
  navController.navigationBar.prefersLargeTitles = YES;

  self = [super initWithNavigationController:navController];
  if (self) {
    _window = window;
    _window.rootViewController = navController;

    // Register with URL Router
    [URLRouter sharedRouter].rootCoordinator = self;
  }
  return self;
}

#pragma mark - Lifecycle

- (void)start {
  NSLog(@"[AppCoordinator] Starting app flow");

  // Make window visible
  [self.window makeKeyAndVisible];

  // Start the main products flow
  [self showProductsFlow];
}

#pragma mark - Navigation Flows

- (void)showProductsFlow {
  self.productsCoordinator = [[ProductsCoordinator alloc]
      initWithNavigationController:self.navigationController];

  [self addChildCoordinator:self.productsCoordinator];
  [self.productsCoordinator start];
}

#pragma mark - Deep Linking

- (BOOL)handleDeepLinkURL:(NSURL *)url {
  NSLog(@"[AppCoordinator] Handling deep link: %@", url);

  // Parse the URL into a route
  DeepLinkRoute *route = [[URLRouter sharedRouter] parseURL:url];

  if (!route) {
    NSLog(@"[AppCoordinator] Could not parse URL: %@", url);
    return NO;
  }

  // Handle the route
  [self handleRoute:route];
  return YES;
}

- (BOOL)handleUserActivity:(NSUserActivity *)userActivity {
  if ([userActivity.activityType
          isEqualToString:NSUserActivityTypeBrowsingWeb]) {
    NSURL *url = userActivity.webpageURL;
    if (url) {
      return [self handleDeepLinkURL:url];
    }
  }
  return NO;
}

#pragma mark - DeepLinkable

- (BOOL)canHandleRoute:(DeepLinkRoute *)route {
  // AppCoordinator can handle any route by forwarding to child coordinators
  return YES;
}

- (void)handleRoute:(DeepLinkRoute *)route {
  NSLog(@"[AppCoordinator] Handling route: %@", route);

  // Reset navigation to root if needed for deep links
  [self resetNavigationForDeepLink];

  switch (route.type) {
  case DeepLinkRouteTypeHome:
    // Already at home (products list)
    break;

  case DeepLinkRouteTypeProductList:
  case DeepLinkRouteTypeProductDetail:
  case DeepLinkRouteTypeProductReviews:
    // Forward to products coordinator
    if ([self.productsCoordinator conformsToProtocol:@protocol(DeepLinkable)]) {
      [self.productsCoordinator handleRoute:route];
    }
    break;

  case DeepLinkRouteTypeUserProfile:
    [self showUserProfile:route.userId];
    break;

  case DeepLinkRouteTypeSettings:
    [self showSettings];
    break;

  case DeepLinkRouteTypeCart:
    [self showCart];
    break;

  default:
    NSLog(@"[AppCoordinator] Unknown route type: %ld", (long)route.type);
    break;
  }
}

- (void)resetNavigationForDeepLink {
  // Pop to root view controller to ensure clean navigation state
  [self.navigationController popToRootViewControllerAnimated:NO];

  // Remove child coordinators from products coordinator
  [self.productsCoordinator removeAllChildCoordinators];
}

#pragma mark - Additional Navigation (Placeholder)

- (void)showUserProfile:(nullable NSString *)userId {
  NSLog(@"[AppCoordinator] Show user profile: %@", userId ?: @"current user");

  // Placeholder - would create a ProfileCoordinator
  UIViewController *profileVC = [[UIViewController alloc] init];
  profileVC.view.backgroundColor = [UIColor systemBackgroundColor];
  profileVC.title = @"User Profile";

  UILabel *label = [[UILabel alloc] init];
  label.text =
      [NSString stringWithFormat:@"User: %@", userId ?: @"Current User"];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  [profileVC.view addSubview:label];

  [NSLayoutConstraint activateConstraints:@[
    [label.centerXAnchor constraintEqualToAnchor:profileVC.view.centerXAnchor],
    [label.centerYAnchor constraintEqualToAnchor:profileVC.view.centerYAnchor]
  ]];

  [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)showSettings {
  NSLog(@"[AppCoordinator] Show settings");

  // Placeholder - would create a SettingsCoordinator
  UIViewController *settingsVC = [[UIViewController alloc] init];
  settingsVC.view.backgroundColor = [UIColor systemBackgroundColor];
  settingsVC.title = @"Settings";
  [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)showCart {
  NSLog(@"[AppCoordinator] Show cart");

  // Placeholder - would create a CartCoordinator
  UIViewController *cartVC = [[UIViewController alloc] init];
  cartVC.view.backgroundColor = [UIColor systemBackgroundColor];
  cartVC.title = @"Shopping Cart";
  [self.navigationController pushViewController:cartVC animated:YES];
}

#pragma mark - Debug

- (void)dealloc {
  NSLog(@"[AppCoordinator] dealloc");
}

@end
