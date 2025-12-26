//
//  AppCoordinator.m
//  MVVM-C-ARC
//
//  AppCoordinator Implementation
//  ARC Version
//

#import "AppCoordinator.h"
#import "DeepLinkRoute.h"
#import "ProductService.h"
#import "ProductServiceProtocol.h"
#import "ProductsCoordinator.h"
#import "URLRouter.h"
#import <os/log.h>

static os_log_t AppCoordinatorLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "AppCoordinator");
  });
  return log;
}

@interface AppCoordinator ()
@property(nonatomic, strong) ProductsCoordinator *productsCoordinator;
@property(nonatomic, strong, readwrite) URLRouter *urlRouter;
@property(nonatomic, strong) id<ProductServiceProtocol> productService;
@end

@implementation AppCoordinator

#pragma mark - Initialization

- (instancetype)initWithWindow:(UIWindow *)window {
  // Use default dependencies for backward compatibility
  return [self initWithWindow:window
                    urlRouter:[URLRouter sharedRouter]
               productService:[ProductService defaultService]];
}

- (instancetype)initWithWindow:(UIWindow *)window
                     urlRouter:(URLRouter *)urlRouter
                productService:(id<ProductServiceProtocol>)productService {
  // Create the root navigation controller
  UINavigationController *navController = [[UINavigationController alloc] init];
  navController.navigationBar.prefersLargeTitles = YES;

  self = [super initWithNavigationController:navController];
  if (self) {
    _window = window;
    _window.rootViewController = navController;
    _urlRouter = urlRouter;
    _productService = productService;

    // Register with URL Router
    _urlRouter.rootCoordinator = self;

    os_log_info(AppCoordinatorLog(),
                "Initialized with window and dependencies");
  }
  return self;
}

#pragma mark - Lifecycle

- (void)start {
  os_log_info(AppCoordinatorLog(), "Starting app flow");

  // Make window visible
  [self.window makeKeyAndVisible];

  // Start the main products flow
  [self showProductsFlow];
}

#pragma mark - Navigation Flows

- (void)showProductsFlow {
  self.productsCoordinator = [[ProductsCoordinator alloc]
      initWithNavigationController:self.navigationController
                    productService:self.productService];

  [self addChildCoordinator:self.productsCoordinator];
  [self.productsCoordinator start];
}

#pragma mark - Deep Linking

- (BOOL)handleDeepLinkURL:(NSURL *)url {
  os_log_info(AppCoordinatorLog(), "Handling deep link: %{public}@",
              url.absoluteString);

  // Parse the URL into a route
  DeepLinkRoute *route = [self.urlRouter parseURL:url];

  if (!route) {
    os_log_error(AppCoordinatorLog(), "Could not parse URL: %{public}@",
                 url.absoluteString);
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
  os_log_info(AppCoordinatorLog(), "Handling route: %{public}@",
              [route routeTypeString]);

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
    os_log_error(AppCoordinatorLog(), "Unknown route type: %ld",
                 (long)route.type);
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
  os_log_info(AppCoordinatorLog(), "Show user profile: %{public}@",
              userId ?: @"current user");

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
  os_log_info(AppCoordinatorLog(), "Show settings");

  // Placeholder - would create a SettingsCoordinator
  UIViewController *settingsVC = [[UIViewController alloc] init];
  settingsVC.view.backgroundColor = [UIColor systemBackgroundColor];
  settingsVC.title = @"Settings";
  [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)showCart {
  os_log_info(AppCoordinatorLog(), "Show cart");

  // Placeholder - would create a CartCoordinator
  UIViewController *cartVC = [[UIViewController alloc] init];
  cartVC.view.backgroundColor = [UIColor systemBackgroundColor];
  cartVC.title = @"Shopping Cart";
  [self.navigationController pushViewController:cartVC animated:YES];
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(AppCoordinatorLog(), "dealloc");
}

@end
