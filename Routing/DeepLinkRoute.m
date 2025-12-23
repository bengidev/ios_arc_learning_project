//
//  DeepLinkRoute.m
//  MVVM-C-ARC
//
//  DeepLinkRoute Model Implementation
//  ARC Version
//

#import "DeepLinkRoute.h"

@implementation DeepLinkRoute

#pragma mark - Factory Methods

+ (nullable instancetype)routeFromURL:(NSURL *)url {
  if (!url || !url.host) {
    return nil;
  }

  // Parse path components: myapp://products/123/reviews -> ["products", "123",
  // "reviews"]
  NSArray<NSString *> *pathComponents = url.pathComponents;
  NSMutableArray<NSString *> *components = [NSMutableArray array];

  // Add host as first component (e.g., "products" from myapp://products/...)
  [components addObject:url.host];

  // Add path components, filtering out "/"
  for (NSString *component in pathComponents) {
    if (![component isEqualToString:@"/"]) {
      [components addObject:component];
    }
  }

  // Parse query parameters
  NSMutableDictionary<NSString *, NSString *> *queryParams =
      [NSMutableDictionary dictionary];
  NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                              resolvingAgainstBaseURL:NO];
  for (NSURLQueryItem *item in urlComponents.queryItems) {
    if (item.value) {
      queryParams[item.name] = item.value;
    }
  }

  // Build route chain from components
  return [self buildRouteChainFromComponents:components
                                 queryParams:queryParams];
}

+ (instancetype)buildRouteChainFromComponents:(NSArray<NSString *> *)components
                                  queryParams:
                                      (NSDictionary<NSString *, NSString *> *)
                                          queryParams {
  if (components.count == 0) {
    return nil;
  }

  DeepLinkRoute *rootRoute = nil;
  DeepLinkRoute *currentRoute = nil;
  NSString *pendingProductId = nil;

  for (NSInteger i = 0; i < components.count; i++) {
    NSString *component = components[i];
    DeepLinkRoute *route = [[DeepLinkRoute alloc] init];
    route.queryParams = queryParams;

    // Determine route type based on component
    if ([component isEqualToString:@"home"]) {
      route.type = DeepLinkRouteTypeHome;
    } else if ([component isEqualToString:@"products"]) {
      route.type = DeepLinkRouteTypeProductList;
    } else if ([component isEqualToString:@"reviews"]) {
      route.type = DeepLinkRouteTypeProductReviews;
      route.productId = pendingProductId;
    } else if ([component isEqualToString:@"profile"]) {
      route.type = DeepLinkRouteTypeUserProfile;
    } else if ([component isEqualToString:@"settings"]) {
      route.type = DeepLinkRouteTypeSettings;
    } else if ([component isEqualToString:@"cart"]) {
      route.type = DeepLinkRouteTypeCart;
    } else if ([self isNumericString:component]) {
      // This is likely an ID
      if (currentRoute.type == DeepLinkRouteTypeProductList) {
        route.type = DeepLinkRouteTypeProductDetail;
        route.productId = component;
        pendingProductId = component;
      } else if (currentRoute.type == DeepLinkRouteTypeUserProfile) {
        currentRoute.userId = component;
        continue; // Don't create a new route, just set the ID
      } else {
        continue; // Unknown context for ID
      }
    } else {
      continue; // Unknown component, skip
    }

    // Chain routes together
    if (!rootRoute) {
      rootRoute = route;
    } else {
      currentRoute.childRoute = route;
    }
    currentRoute = route;
  }

  return rootRoute;
}

+ (BOOL)isNumericString:(NSString *)string {
  NSCharacterSet *nonDigits =
      [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  return string.length > 0 &&
         [string rangeOfCharacterFromSet:nonDigits].location == NSNotFound;
}

+ (instancetype)routeWithType:(DeepLinkRouteType)type {
  DeepLinkRoute *route = [[DeepLinkRoute alloc] init];
  route.type = type;
  return route;
}

+ (instancetype)productDetailRouteWithId:(NSString *)productId {
  DeepLinkRoute *route = [[DeepLinkRoute alloc] init];
  route.type = DeepLinkRouteTypeProductDetail;
  route.productId = productId;
  return route;
}

#pragma mark - Utility Methods

- (NSString *)routeTypeString {
  switch (self.type) {
  case DeepLinkRouteTypeNone:
    return @"None";
  case DeepLinkRouteTypeHome:
    return @"Home";
  case DeepLinkRouteTypeProductList:
    return @"ProductList";
  case DeepLinkRouteTypeProductDetail:
    return @"ProductDetail";
  case DeepLinkRouteTypeProductReviews:
    return @"ProductReviews";
  case DeepLinkRouteTypeUserProfile:
    return @"UserProfile";
  case DeepLinkRouteTypeSettings:
    return @"Settings";
  case DeepLinkRouteTypeCart:
    return @"Cart";
  }
  return @"Unknown";
}

- (BOOL)hasChildRoute {
  return self.childRoute != nil;
}

- (DeepLinkRoute *)deepestRoute {
  DeepLinkRoute *route = self;
  while (route.childRoute) {
    route = route.childRoute;
  }
  return route;
}

- (NSString *)description {
  NSMutableString *desc = [NSMutableString
      stringWithFormat:@"<%@: %@", NSStringFromClass([self class]),
                       [self routeTypeString]];
  if (self.productId) {
    [desc appendFormat:@", productId=%@", self.productId];
  }
  if (self.userId) {
    [desc appendFormat:@", userId=%@", self.userId];
  }
  if (self.childRoute) {
    [desc appendFormat:@" -> %@", self.childRoute];
  }
  [desc appendString:@">"];
  return desc;
}

@end
