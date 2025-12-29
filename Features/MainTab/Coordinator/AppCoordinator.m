//
//  AppCoordinator.m
//  MVVM-C-ARC
//
//  AppCoordinator Implementation - UITabBarController management
//  ARC Version
//

#import "AppCoordinator.h"
#import "DeepLinkRoute.h"
#import "DesignConstants.h"
#import "URLRouter.h"

// Feature Coordinators
#import "CartCoordinator.h"
#import "ProductsCoordinator.h"
#import "ProfileCoordinator.h"
#import "SettingsCoordinator.h"

// Services
#import "ProductService.h"
#import "UserService.h"

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

@property(nonatomic, strong, readwrite) UITabBarController *tabBarController;
@property(nonatomic, strong, readwrite) URLRouter *urlRouter;
@property(nonatomic, strong) id<ProductServiceProtocol> productService;
@property(nonatomic, strong) id<UserServiceProtocol> userService;

// Child coordinators
@property(nonatomic, strong, readwrite)
    ProductsCoordinator *productsCoordinator;
@property(nonatomic, strong, readwrite) ProfileCoordinator *profileCoordinator;
@property(nonatomic, strong, readwrite) CartCoordinator *cartCoordinator;
@property(nonatomic, strong, readwrite)
    SettingsCoordinator *settingsCoordinator;

// Navigation controllers for each tab
@property(nonatomic, strong) UINavigationController *productsNavController;
@property(nonatomic, strong) UINavigationController *profileNavController;
@property(nonatomic, strong) UINavigationController *cartNavController;
@property(nonatomic, strong) UINavigationController *settingsNavController;

@end

@implementation AppCoordinator

#pragma mark - Initialization

- (instancetype)initWithWindow:(UIWindow *)window {
  return [self initWithWindow:window
                    urlRouter:[URLRouter sharedRouter]
               productService:[ProductService defaultService]
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

  // Initialize with a placeholder nav controller (we'll use tab bar instead)
  UINavigationController *placeholderNav =
      [[UINavigationController alloc] init];

  self = [super initWithNavigationController:placeholderNav];
  if (self) {
    _window = window;
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
  os_log_info(AppCoordinatorLog(), "Starting app flow with tab bar");

  // Create tab bar controller
  [self setupTabBarController];

  // Set as root and make visible
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];

  // Start all tab coordinators
  [self.productsCoordinator start];
  [self.profileCoordinator start];
  [self.cartCoordinator start];
  [self.settingsCoordinator start];

  os_log_info(AppCoordinatorLog(), "All tab coordinators started");
}

#pragma mark - Tab Bar Setup

- (void)setupTabBarController {
  self.tabBarController = [[UITabBarController alloc] init];

  // Configure tab bar appearance
  if (@available(iOS 15.0, *)) {
    UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
    [appearance configureWithDefaultBackground];
    self.tabBarController.tabBar.standardAppearance = appearance;
    self.tabBarController.tabBar.scrollEdgeAppearance = appearance;
  }

  // Create navigation controllers for each tab
  [self setupProductsTab];
  [self setupProfileTab];
  [self setupCartTab];
  [self setupSettingsTab];

  // Set view controllers
  self.tabBarController.viewControllers = @[
    self.productsNavController, self.profileNavController,
    self.cartNavController, self.settingsNavController
  ];
}

- (void)setupProductsTab {
  self.productsNavController = [[UINavigationController alloc] init];
  self.productsNavController.navigationBar.prefersLargeTitles = YES;

  // Configure tab bar item
  UITabBarItem *tabItem =
      [[UITabBarItem alloc] initWithTitle:@"Products"
                                    image:[UIImage systemImageNamed:@"bag"]
                                      tag:TabIndexProducts];
  tabItem.accessibilityIdentifier = kAccessibilityTabProducts;
  self.productsNavController.tabBarItem = tabItem;

  // Create coordinator
  self.productsCoordinator = [[ProductsCoordinator alloc]
      initWithNavigationController:self.productsNavController
                    productService:self.productService];
  [self addChildCoordinator:self.productsCoordinator];
}

- (void)setupProfileTab {
  self.profileNavController = [[UINavigationController alloc] init];
  self.profileNavController.navigationBar.prefersLargeTitles = YES;

  // Configure tab bar item
  UITabBarItem *tabItem =
      [[UITabBarItem alloc] initWithTitle:@"Profile"
                                    image:[UIImage systemImageNamed:@"person"]
                                      tag:TabIndexProfile];
  tabItem.accessibilityIdentifier = kAccessibilityTabProfile;
  self.profileNavController.tabBarItem = tabItem;

  // Create coordinator
  self.profileCoordinator = [[ProfileCoordinator alloc]
      initWithNavigationController:self.profileNavController
                            userId:nil
                       userService:self.userService];
  [self addChildCoordinator:self.profileCoordinator];
}

- (void)setupCartTab {
  self.cartNavController = [[UINavigationController alloc] init];
  self.cartNavController.navigationBar.prefersLargeTitles = YES;

  // Configure tab bar item
  UITabBarItem *tabItem =
      [[UITabBarItem alloc] initWithTitle:@"Cart"
                                    image:[UIImage systemImageNamed:@"cart"]
                                      tag:TabIndexCart];
  tabItem.accessibilityIdentifier = kAccessibilityTabCart;
  self.cartNavController.tabBarItem = tabItem;

  // Create coordinator
  self.cartCoordinator = [[CartCoordinator alloc]
      initWithNavigationController:self.cartNavController];
  [self addChildCoordinator:self.cartCoordinator];
}

- (void)setupSettingsTab {
  self.settingsNavController = [[UINavigationController alloc] init];
  self.settingsNavController.navigationBar.prefersLargeTitles = YES;

  // Configure tab bar item
  UITabBarItem *tabItem =
      [[UITabBarItem alloc] initWithTitle:@"Settings"
                                    image:[UIImage systemImageNamed:@"gear"]
                                      tag:TabIndexSettings];
  tabItem.accessibilityIdentifier = kAccessibilityTabSettings;
  self.settingsNavController.tabBarItem = tabItem;

  // Create coordinator
  self.settingsCoordinator = [[SettingsCoordinator alloc]
      initWithNavigationController:self.settingsNavController];
  [self addChildCoordinator:self.settingsCoordinator];
}

#pragma mark - Tab Navigation

- (void)switchToTab:(NSInteger)tabIndex {
  if (tabIndex >= 0 && tabIndex < self.tabBarController.viewControllers.count) {
    self.tabBarController.selectedIndex = tabIndex;
    os_log_info(AppCoordinatorLog(), "Switched to tab: %ld", (long)tabIndex);
  }
}

#pragma mark - Deep Linking

- (BOOL)handleDeepLinkURL:(NSURL *)url {
  os_log_info(AppCoordinatorLog(), "Handling deep link: %{public}@",
              url.absoluteString);

  DeepLinkRoute *route = [self.urlRouter parseURL:url];

  if (!route) {
    os_log_error(AppCoordinatorLog(), "Could not parse URL: %{public}@",
                 url.absoluteString);
    return NO;
  }

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
  return YES; // AppCoordinator can handle any route
}

- (void)handleRoute:(DeepLinkRoute *)route {
  os_log_info(AppCoordinatorLog(), "Handling route: %{public}@",
              [route routeTypeString]);

  switch (route.type) {
  case DeepLinkRouteTypeHome:
  case DeepLinkRouteTypeProductList:
    [self switchToTab:TabIndexProducts];
    [self.productsNavController popToRootViewControllerAnimated:NO];
    break;

  case DeepLinkRouteTypeProductDetail:
  case DeepLinkRouteTypeProductReviews:
    [self switchToTab:TabIndexProducts];
    if ([self.productsCoordinator conformsToProtocol:@protocol(DeepLinkable)]) {
      [(id<DeepLinkable>)self.productsCoordinator handleRoute:route];
    }
    break;

  case DeepLinkRouteTypeUserProfile:
    [self switchToTab:TabIndexProfile];
    if (route.userId &&
        [self.profileCoordinator conformsToProtocol:@protocol(DeepLinkable)]) {
      [(id<DeepLinkable>)self.profileCoordinator handleRoute:route];
    }
    break;

  case DeepLinkRouteTypeCart:
    [self switchToTab:TabIndexCart];
    break;

  case DeepLinkRouteTypeSettings:
    [self switchToTab:TabIndexSettings];
    break;

  default:
    os_log_error(AppCoordinatorLog(), "Unknown route type: %ld",
                 (long)route.type);
    break;
  }
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(AppCoordinatorLog(), "dealloc");
}

@end
