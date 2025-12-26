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
#import <os/log.h>

static os_log_t URLRouterLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "URLRouter");
  });
  return log;
}

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

#pragma mark - Initialization

- (instancetype)init {
  return [self initWithScheme:@"myapp"];
}

- (instancetype)initWithScheme:(NSString *)scheme {
  self = [super init];
  if (self) {
    _registeredSchemes = [NSMutableArray array];
    _universalLinkDomains = @[];
    _urlScheme = [scheme copy];
    [_registeredSchemes addObject:_urlScheme];

    os_log_debug(URLRouterLog(), "Initialized with scheme: %{public}@", scheme);
  }
  return self;
}

#pragma mark - URL Handling

- (nullable DeepLinkRoute *)parseURL:(NSURL *)url {
  if (![self canHandleURL:url]) {
    os_log_info(URLRouterLog(), "Cannot handle URL: %{public}@",
                url.absoluteString);
    return nil;
  }

  DeepLinkRoute *route = [DeepLinkRoute routeFromURL:url];

  if (route) {
    os_log_info(URLRouterLog(), "Parsed URL: %{public}@ -> %{public}@",
                url.absoluteString, [route routeTypeString]);
  } else {
    os_log_error(URLRouterLog(), "Failed to parse URL: %{public}@",
                 url.absoluteString);
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
    os_log_error(URLRouterLog(), "No root coordinator set");
    return NO;
  }

  if ([self.rootCoordinator conformsToProtocol:@protocol(DeepLinkable)]) {
    id<DeepLinkable> deepLinkable = (id<DeepLinkable>)self.rootCoordinator;

    if ([deepLinkable canHandleRoute:route]) {
      os_log_info(URLRouterLog(), "Routing to coordinator for: %{public}@",
                  [route routeTypeString]);
      [deepLinkable handleRoute:route];
      return YES;
    }
  }

  os_log_error(URLRouterLog(),
               "Root coordinator cannot handle route: %{public}@",
               [route routeTypeString]);
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
      os_log_debug(URLRouterLog(), "Registered scheme: %{public}@", scheme);
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
  os_log_debug(URLRouterLog(), "Registered %lu universal link domains",
               (unsigned long)domains.count);
}

@end
