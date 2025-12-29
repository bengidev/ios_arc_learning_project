//
//  DeepLinkRoute.m
//  MVVM-C-ARC
//
//  DeepLinkRoute Implementation
//  ARC Version
//

#import "DeepLinkRoute.h"

@implementation DeepLinkRoute

#pragma mark - Initialization

+ (instancetype)routeWithType:(DeepLinkRouteType)type {
  DeepLinkRoute *route = [[DeepLinkRoute alloc] init];
  route.type = type;
  return route;
}

+ (instancetype)productDetailRouteWithId:(NSString *)productId {
  NSParameterAssert(productId != nil);

  DeepLinkRoute *route = [[DeepLinkRoute alloc] init];
  route.type = DeepLinkRouteTypeProductDetail;
  route.productId = productId;
  return route;
}

+ (instancetype)userProfileRouteWithId:(nullable NSString *)userId {
  DeepLinkRoute *route = [[DeepLinkRoute alloc] init];
  route.type = DeepLinkRouteTypeUserProfile;
  route.userId = userId;
  return route;
}

#pragma mark - Helpers

- (NSString *)routeTypeString {
  switch (self.type) {
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
  case DeepLinkRouteTypeUnknown:
  default:
    return @"Unknown";
  }
}

#pragma mark - Debug

- (NSString *)description {
  return [NSString
      stringWithFormat:@"<%@: type=%@, productId=%@, userId=%@>",
                       NSStringFromClass([self class]), [self routeTypeString],
                       self.productId ?: @"nil", self.userId ?: @"nil"];
}

@end
