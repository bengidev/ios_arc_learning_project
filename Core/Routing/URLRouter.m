//
//  URLRouter.m
//  MVVM-C-ARC
//
//  URLRouter Implementation
//  ARC Version
//

#import "URLRouter.h"
#import "DeepLinkRoute.h"
#import <os/log.h>

static os_log_t URLRouterLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "URLRouter");
  });
  return log;
}

@implementation URLRouter

#pragma mark - Singleton

+ (instancetype)sharedRouter {
  static URLRouter *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[URLRouter alloc] init];
  });
  return sharedInstance;
}

#pragma mark - URL Parsing

- (nullable DeepLinkRoute *)parseURL:(NSURL *)url {
  if (!url) {
    return nil;
  }

  os_log_info(URLRouterLog(), "Parsing URL: %{public}@", url.absoluteString);

  // Check if it's our custom scheme or universal link
  BOOL isCustomScheme = [url.scheme isEqualToString:kURLScheme];
  BOOL isUniversalLink = [url.host isEqualToString:kUniversalLinkDomain];

  if (!isCustomScheme && !isUniversalLink) {
    os_log_error(URLRouterLog(), "URL not recognized: %{public}@",
                 url.absoluteString);
    return nil;
  }

  // Get path components (removing empty strings)
  NSMutableArray<NSString *> *pathComponents =
      [[url.pathComponents mutableCopy] ?: [NSMutableArray array] mutableCopy];
  [pathComponents removeObject:@"/"];

  // For custom scheme, host is the first path component
  if (isCustomScheme && url.host) {
    [pathComponents insertObject:url.host atIndex:0];
  }

  // Parse query items
  NSURLComponents *components = [NSURLComponents componentsWithURL:url
                                           resolvingAgainstBaseURL:NO];
  NSArray<NSURLQueryItem *> *queryItems = components.queryItems;

  return [self parsePathComponents:pathComponents queryItems:queryItems];
}

- (nullable DeepLinkRoute *)
    parsePathComponents:(NSArray<NSString *> *)pathComponents
             queryItems:(nullable NSArray<NSURLQueryItem *> *)queryItems {
  if (pathComponents.count == 0) {
    return [DeepLinkRoute routeWithType:DeepLinkRouteTypeHome];
  }

  NSString *firstComponent = pathComponents.firstObject.lowercaseString;

  // Home
  if ([firstComponent isEqualToString:@"home"]) {
    return [DeepLinkRoute routeWithType:DeepLinkRouteTypeHome];
  }

  // Products
  if ([firstComponent isEqualToString:@"products"]) {
    if (pathComponents.count == 1) {
      return [DeepLinkRoute routeWithType:DeepLinkRouteTypeProductList];
    }

    NSString *productId = pathComponents[1];

    if (pathComponents.count >= 3 &&
        [pathComponents[2].lowercaseString isEqualToString:@"reviews"]) {
      DeepLinkRoute *route =
          [DeepLinkRoute routeWithType:DeepLinkRouteTypeProductReviews];
      route.productId = productId;
      return route;
    }

    return [DeepLinkRoute productDetailRouteWithId:productId];
  }

  // Profile
  if ([firstComponent isEqualToString:@"profile"] ||
      [firstComponent isEqualToString:@"user"]) {
    NSString *userId = pathComponents.count > 1 ? pathComponents[1] : nil;
    return [DeepLinkRoute userProfileRouteWithId:userId];
  }

  // Cart
  if ([firstComponent isEqualToString:@"cart"]) {
    return [DeepLinkRoute routeWithType:DeepLinkRouteTypeCart];
  }

  // Settings
  if ([firstComponent isEqualToString:@"settings"]) {
    return [DeepLinkRoute routeWithType:DeepLinkRouteTypeSettings];
  }

  os_log_error(URLRouterLog(), "Unknown path: %{public}@", firstComponent);
  return nil;
}

#pragma mark - Route Handling

- (BOOL)routeURL:(NSURL *)url {
  DeepLinkRoute *route = [self parseURL:url];

  if (!route) {
    return NO;
  }

  if (self.rootCoordinator && [self.rootCoordinator canHandleRoute:route]) {
    [self.rootCoordinator handleRoute:route];
    return YES;
  }

  os_log_error(URLRouterLog(), "No coordinator available to handle route");
  return NO;
}

#pragma mark - URL Building

+ (NSURL *)urlForProductDetail:(NSString *)productId {
  NSString *urlString =
      [NSString stringWithFormat:@"%@://products/%@", kURLScheme, productId];
  return [NSURL URLWithString:urlString];
}

+ (NSURL *)urlForUserProfile:(nullable NSString *)userId {
  NSString *urlString;
  if (userId) {
    urlString =
        [NSString stringWithFormat:@"%@://profile/%@", kURLScheme, userId];
  } else {
    urlString = [NSString stringWithFormat:@"%@://profile", kURLScheme];
  }
  return [NSURL URLWithString:urlString];
}

+ (NSURL *)urlForCart {
  NSString *urlString = [NSString stringWithFormat:@"%@://cart", kURLScheme];
  return [NSURL URLWithString:urlString];
}

+ (NSURL *)urlForSettings {
  NSString *urlString =
      [NSString stringWithFormat:@"%@://settings", kURLScheme];
  return [NSURL URLWithString:urlString];
}

@end
