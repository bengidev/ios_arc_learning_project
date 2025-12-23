//
//  URLRouter.h
//  MVVM-C-ARC
//
//  URLRouter - Singleton router for handling and parsing deep link URLs
//  ARC Version
//

#import <Foundation/Foundation.h>

@class DeepLinkRoute;
@protocol Coordinator;

NS_ASSUME_NONNULL_BEGIN

/// Block called when a route is successfully handled
typedef void (^URLRouterCompletionBlock)(BOOL success);

@interface URLRouter : NSObject

/// Shared singleton instance
+ (instancetype)sharedRouter;

/// The root coordinator that will handle routes
@property(nonatomic, weak, nullable) id<Coordinator> rootCoordinator;

#pragma mark - URL Handling

/// Parses a URL and returns a DeepLinkRoute
/// @param url The URL to parse
/// @return A DeepLinkRoute representing the parsed URL, or nil if invalid
- (nullable DeepLinkRoute *)parseURL:(NSURL *)url;

/// Handles an incoming URL by parsing it and routing to the appropriate
/// coordinator
/// @param url The URL to handle
/// @return YES if the URL was successfully handled
- (BOOL)handleURL:(NSURL *)url;

/// Handles an incoming URL with a completion callback
/// @param url The URL to handle
/// @param completion Called when routing is complete
- (void)handleURL:(NSURL *)url
       completion:(nullable URLRouterCompletionBlock)completion;

#pragma mark - URL Scheme Registration

/// The registered URL scheme for the app (e.g., "myapp")
@property(nonatomic, copy) NSString *urlScheme;

/// Registers one or more URL schemes
- (void)registerURLSchemes:(NSArray<NSString *> *)schemes;

/// Checks if a URL can be handled by this router
- (BOOL)canHandleURL:(NSURL *)url;

#pragma mark - Universal Links

/// The registered universal link domains
@property(nonatomic, copy) NSArray<NSString *> *universalLinkDomains;

/// Registers domains for universal links
- (void)registerUniversalLinkDomains:(NSArray<NSString *> *)domains;

@end

NS_ASSUME_NONNULL_END
