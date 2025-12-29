//
//  DeepLinkable.h
//  MVVM-C-ARC
//
//  DeepLinkable Protocol - Defines interface for coordinators that handle deep
//  links ARC Version
//

#import <Foundation/Foundation.h>

@class DeepLinkRoute;

NS_ASSUME_NONNULL_BEGIN

@protocol DeepLinkable <NSObject>

@required
/// Returns whether this coordinator can handle the given route
/// @param route The route to check
/// @return YES if this coordinator can handle the route
- (BOOL)canHandleRoute:(DeepLinkRoute *)route;

/// Handles the given route
/// @param route The route to handle
- (void)handleRoute:(DeepLinkRoute *)route;

@end

NS_ASSUME_NONNULL_END
