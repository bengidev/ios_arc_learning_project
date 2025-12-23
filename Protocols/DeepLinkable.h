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
/// Returns YES if this coordinator can handle the given route
/// @param route The deep link route to check
- (BOOL)canHandleRoute:(DeepLinkRoute *)route;

/// Handles the deep link route, potentially creating child coordinators
/// @param route The deep link route to handle
- (void)handleRoute:(DeepLinkRoute *)route;

@optional
/// Called to reset the coordinator's state before handling a new deep link
- (void)resetStateForDeepLink;

@end

NS_ASSUME_NONNULL_END
