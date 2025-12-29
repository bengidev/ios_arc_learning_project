//
//  DeepLinkRoute.h
//  MVVM-C-ARC
//
//  DeepLinkRoute - Represents a parsed deep link route
//  ARC Version
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Enum representing different types of deep link routes
typedef NS_ENUM(NSInteger, DeepLinkRouteType) {
  DeepLinkRouteTypeUnknown = 0,
  DeepLinkRouteTypeHome,
  DeepLinkRouteTypeProductList,
  DeepLinkRouteTypeProductDetail,
  DeepLinkRouteTypeProductReviews,
  DeepLinkRouteTypeUserProfile,
  DeepLinkRouteTypeSettings,
  DeepLinkRouteTypeCart
};

@interface DeepLinkRoute : NSObject

/// The type of route
@property(nonatomic, assign) DeepLinkRouteType type;

/// Product ID for product-related routes
@property(nonatomic, copy, nullable) NSString *productId;

/// User ID for profile-related routes
@property(nonatomic, copy, nullable) NSString *userId;

/// Additional parameters from the URL
@property(nonatomic, copy, nullable)
    NSDictionary<NSString *, NSString *> *parameters;

#pragma mark - Initialization

/// Creates a route with the given type
+ (instancetype)routeWithType:(DeepLinkRouteType)type;

/// Creates a product detail route
+ (instancetype)productDetailRouteWithId:(NSString *)productId;

/// Creates a user profile route
+ (instancetype)userProfileRouteWithId:(nullable NSString *)userId;

#pragma mark - Helpers

/// Returns a string representation of the route type
- (NSString *)routeTypeString;

@end

NS_ASSUME_NONNULL_END
