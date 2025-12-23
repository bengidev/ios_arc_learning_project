//
//  URLRouter.m
//  MVVM-C-ARC
//
//  URLRouter Implementation
//  ARC Version
//

#import "URLRouter.h"
#import "Coordinator.h"
#import "DeepLinkRoute.h"
#import "DeepLinkable.h"

@interface URLRouter ()
@property(nonatomic, strong) NSMutableArray<NSString *> *registeredSchemes;
@end

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

- (instancetype)init {
  self = [super init];
  if (self) {
    _registeredSchemes = [NSMutableArray array];
    _universalLinkDomains = @[];
    _urlScheme = @"myapp"; // Default scheme
    [_registeredSchemes addObject:_urlScheme];
  }
  return self;
}

#pragma mark - URL Handling

- (nullable DeepLinkRoute *)parseURL:(NSURL *)url {
  if (![self canHandleURL:url]) {
    NSLog(@"[URLRouter] Cannot handle URL: %@", url);
    return nil;
  }

  DeepLinkRoute *route = [DeepLinkRoute routeFromURL:url];

  if (route) {
    NSLog(@"[URLRouter] Parsed URL: %@ -> %@", url, route);
  } else {
    NSLog(@"[URLRouter] Failed to parse URL: %@", url);
  }

  return route;
}

- (BOOL)handleURL:(NSURL *)url {
  DeepLinkRoute *route = [self parseURL:url];

  if (!route) {
    return NO;
  }

  // Check if root coordinator can handle deep links
  if (!self.rootCoordinator) {
    NSLog(@"[URLRouter] No root coordinator set");
    return NO;
  }

  if ([self.rootCoordinator conformsToProtocol:@protocol(DeepLinkable)]) {
    id<DeepLinkable> deepLinkable = (id<DeepLinkable>)self.rootCoordinator;

    if ([deepLinkable canHandleRoute:route]) {
      [deepLinkable handleRoute:route];
      return YES;
    }
  }

  NSLog(@"[URLRouter] Root coordinator cannot handle route: %@", route);
  return NO;
}

- (void)handleURL:(NSURL *)url
       completion:(nullable URLRouterCompletionBlock)completion {
  BOOL success = [self handleURL:url];

  if (completion) {
    // Call completion on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
      completion(success);
    });
  }
}

#pragma mark - URL Scheme Registration

- (void)registerURLSchemes:(NSArray<NSString *> *)schemes {
  for (NSString *scheme in schemes) {
    if (![self.registeredSchemes containsObject:scheme]) {
      [self.registeredSchemes addObject:scheme];
    }
  }
}

- (BOOL)canHandleURL:(NSURL *)url {
  if (!url) {
    return NO;
  }

  // Check custom URL schemes
  NSString *scheme = url.scheme.lowercaseString;
  for (NSString *registeredScheme in self.registeredSchemes) {
    if ([scheme isEqualToString:registeredScheme.lowercaseString]) {
      return YES;
    }
  }

  // Check universal link domains
  NSString *host = url.host.lowercaseString;
  for (NSString *domain in self.universalLinkDomains) {
    if ([host isEqualToString:domain.lowercaseString] ||
        [host hasSuffix:[NSString
                            stringWithFormat:@".%@", domain.lowercaseString]]) {
      return YES;
    }
  }

  return NO;
}

#pragma mark - Universal Links

- (void)registerUniversalLinkDomains:(NSArray<NSString *> *)domains {
  self.universalLinkDomains = [domains copy];
}

@end
