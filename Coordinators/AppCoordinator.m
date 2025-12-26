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
#import "ProfileCoordinator.h"
#import "URLRouter.h"
#import "UserService.h"
#import "UserServiceProtocol.h"
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
@property(nonatomic, strong) ProfileCoordinator *profileCoordinator;
@property(nonatomic, strong, readwrite) URLRouter *urlRouter;
@property(nonatomic, strong) id<ProductServiceProtocol> productService;
@property(nonatomic, strong) id<UserServiceProtocol> userService;
@end

@implementation AppCoordinator

#pragma mark - Initialization

- (instancetype)initWithWindow:(UIWindow *)window {
  // Use default dependencies for backward compatibility
  return [self initWithWindow:window
                    urlRouter:[URLRouter sharedRouter]
               productService:[ProductService defaultService]
                  userService:[UserService defaultService]];
}

- (instancetype)initWithWindow:(UIWindow *)window
                     urlRouter:(URLRouter *)urlRouter
                productService:(id<ProductServiceProtocol>)productService {
  return [self initWithWindow:window
                    urlRouter:urlRouter
               productService:productService
                  userService:[UserService defaultService]];
}

- (instancetype)initWithWindow:(UIWindow *)window
                     urlRouter:(URLRouter *)urlRouter
                productService:(id<ProductServiceProtocol>)productService
                   userService:(id<UserServiceProtocol>)userService {
  NSParameterAssert(window != nil);
  NSParameterAssert(urlRouter != nil);
  NSParameterAssert(productService != nil);
  NSParameterAssert(userService != nil);

  // Create the root navigation controller
  UINavigationController *navController = [[UINavigationController alloc] init];
  navController.navigationBar.prefersLargeTitles = YES;

  self = [super initWithNavigationController:navController];
  if (self) {
    _window = window;
    _window.rootViewController = navController;
    _urlRouter = urlRouter;
    _productService = productService;
    _userService = userService;

    // Register with URL Router
    _urlRouter.rootCoordinator = self;

    os_log_info(AppCoordinatorLog(),
                "Initialized with window and all dependencies");
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

- (void)showProfileFlow:(nullable NSString *)userId {
  os_log_info(AppCoordinatorLog(), "Showing profile for user: %{public}@",
              userId ?: @"current");

  // Remove existing profile coordinator if any
  if (self.profileCoordinator) {
    [self removeChildCoordinator:self.profileCoordinator];
  }

  self.profileCoordinator = [[ProfileCoordinator alloc]
      initWithNavigationController:self.navigationController
                            userId:userId
                       userService:self.userService];

  [self addChildCoordinator:self.profileCoordinator];
  [self.profileCoordinator start];
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
    [self showProfileFlow:route.userId];
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

  // Remove child coordinators (except products which is always present)
  if (self.profileCoordinator) {
    [self removeChildCoordinator:self.profileCoordinator];
    self.profileCoordinator = nil;
  }
  [self.productsCoordinator removeAllChildCoordinators];
}

#pragma mark - Additional Navigation (Placeholder)

- (void)showSettings {
  os_log_info(AppCoordinatorLog(), "Show settings");

  // Placeholder - would create a SettingsCoordinator
  UIViewController *settingsVC = [[UIViewController alloc] init];
  settingsVC.view.backgroundColor = [UIColor systemBackgroundColor];
  settingsVC.title = @"Settings";

  UILabel *label = [[UILabel alloc] init];
  label.text = @"Settings\n(Coming Soon)";
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:20];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  [settingsVC.view addSubview:label];

  [NSLayoutConstraint activateConstraints:@[
    [label.centerXAnchor constraintEqualToAnchor:settingsVC.view.centerXAnchor],
    [label.centerYAnchor constraintEqualToAnchor:settingsVC.view.centerYAnchor]
  ]];

  [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)showCart {
  os_log_info(AppCoordinatorLog(), "Show cart");

  // Placeholder - would create a CartCoordinator
  UIViewController *cartVC = [[UIViewController alloc] init];
  cartVC.view.backgroundColor = [UIColor systemBackgroundColor];
  cartVC.title = @"Shopping Cart";

  UILabel *label = [[UILabel alloc] init];
  label.text = @"Shopping Cart\n(Coming Soon)";
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:20];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  [cartVC.view addSubview:label];

  [NSLayoutConstraint activateConstraints:@[
    [label.centerXAnchor constraintEqualToAnchor:cartVC.view.centerXAnchor],
    [label.centerYAnchor constraintEqualToAnchor:cartVC.view.centerYAnchor]
  ]];

  [self.navigationController pushViewController:cartVC animated:YES];
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(AppCoordinatorLog(), "dealloc");
}

@end
