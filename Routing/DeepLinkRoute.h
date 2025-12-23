//
//  DeepLinkRoute.h
//  MVVM-C-ARC
//
//  DeepLinkRoute Model - Represents a parsed deep link destination
//  ARC Version
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Enum representing different route types in the app
typedef NS_ENUM(NSInteger, DeepLinkRouteType) {
  DeepLinkRouteTypeNone = 0,
  DeepLinkRouteTypeHome,
  DeepLinkRouteTypeProductList,
  DeepLinkRouteTypeProductDetail,
  DeepLinkRouteTypeProductReviews,
  DeepLinkRouteTypeUserProfile,
  DeepLinkRouteTypeSettings,
  DeepLinkRouteTypeCart
};

@interface DeepLinkRoute : NSObject

/// The type of this route
@property(nonatomic, assign) DeepLinkRouteType type;

/// Product ID (for product-related routes)
@property(nonatomic, copy, nullable) NSString *productId;

/// User ID (for user-related routes)
@property(nonatomic, copy, nullable) NSString *userId;

/// Nested child route (for deep navigation paths)
@property(nonatomic, strong, nullable) DeepLinkRoute *childRoute;

/// Query parameters from the URL
@property(nonatomic, copy, nullable)
    NSDictionary<NSString *, NSString *> *queryParams;

#pragma mark - Factory Methods

/// Creates a route from a URL
/// @param url The URL to parse (e.g., myapp://products/123/reviews)
+ (nullable instancetype)routeFromURL:(NSURL *)url;

/// Creates a route with a specific type
+ (instancetype)routeWithType:(DeepLinkRouteType)type;

/// Creates a product detail route
+ (instancetype)productDetailRouteWithId:(NSString *)productId;

#pragma mark - Utility Methods

/// Returns a string representation of the route type
- (NSString *)routeTypeString;

/// Returns YES if this route has a child route
- (BOOL)hasChildRoute;

/// Returns the deepest child route in the chain
- (DeepLinkRoute *)deepestRoute;

@end

NS_ASSUME_NONNULL_END
