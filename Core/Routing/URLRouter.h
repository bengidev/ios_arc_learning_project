//
//  URLRouter.h
//  MVVM-C-ARC
//
//  URLRouter - Handles URL parsing and routing
//  ARC Version
//

#import "DeepLinkable.h"
#import <Foundation/Foundation.h>

@class DeepLinkRoute;

NS_ASSUME_NONNULL_BEGIN

/// URL scheme for the app
static NSString *const kURLScheme = @"mvvmc";

/// Universal link domain
static NSString *const kUniversalLinkDomain = @"example.com";

@interface URLRouter : NSObject

/// The root coordinator that handles routes
@property(nonatomic, weak, nullable) id<DeepLinkable> rootCoordinator;

#pragma mark - Singleton

/// Returns the shared URL router instance
+ (instancetype)sharedRouter;

#pragma mark - URL Parsing

/// Parses a URL into a DeepLinkRoute
/// @param url The URL to parse
/// @return A DeepLinkRoute if the URL was valid, nil otherwise
- (nullable DeepLinkRoute *)parseURL:(NSURL *)url;

/// Parses URL path components into a route
/// @param pathComponents The path components to parse
/// @param queryItems The query parameters
/// @return A DeepLinkRoute if valid, nil otherwise
- (nullable DeepLinkRoute *)
    parsePathComponents:(NSArray<NSString *> *)pathComponents
             queryItems:(nullable NSArray<NSURLQueryItem *> *)queryItems;

#pragma mark - Route Handling

/// Routes a URL through the coordinator hierarchy
/// @param url The URL to route
/// @return YES if the URL was handled
- (BOOL)routeURL:(NSURL *)url;

#pragma mark - URL Building

/// Builds a URL for a product detail
/// @param productId The product ID
/// @return The deep link URL
+ (NSURL *)urlForProductDetail:(NSString *)productId;

/// Builds a URL for a user profile
/// @param userId The user ID (nil for current user)
/// @return The deep link URL
+ (NSURL *)urlForUserProfile:(nullable NSString *)userId;

/// Builds a URL for the cart
/// @return The deep link URL
+ (NSURL *)urlForCart;

/// Builds a URL for settings
/// @return The deep link URL
+ (NSURL *)urlForSettings;

@end

NS_ASSUME_NONNULL_END
