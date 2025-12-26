//
//  BaseCoordinator.m
//  MVVM-C-ARC
//
//  BaseCoordinator Implementation
//  ARC Version
//

#import "BaseCoordinator.h"
#import <os/log.h>

static os_log_t BaseCoordinatorLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "BaseCoordinator");
  });
  return log;
}

@implementation BaseCoordinator

#pragma mark - Initialization

- (instancetype)init {
  self = [super init];
  if (self) {
    _childCoordinators = [NSMutableArray array];
  }
  return self;
}

- (instancetype)initWithNavigationController:
    (UINavigationController *)navigationController {
  self = [self init];
  if (self) {
    _navigationController = navigationController;
  }
  return self;
}

#pragma mark - Child Coordinator Management

- (void)addChildCoordinator:(id<Coordinator>)coordinator {
  if (![self.childCoordinators containsObject:coordinator]) {
    [self.childCoordinators addObject:coordinator];

    // Set parent if the coordinator supports it
    if ([coordinator respondsToSelector:@selector(setParentCoordinator:)]) {
      coordinator.parentCoordinator = self;
    }

    os_log_debug(BaseCoordinatorLog(), "[%{public}@] Added child: %{public}@",
                 NSStringFromClass([self class]),
                 NSStringFromClass([coordinator class]));
  }
}

- (void)removeChildCoordinator:(id<Coordinator>)coordinator {
  if ([self.childCoordinators containsObject:coordinator]) {
    // Clear parent reference
    if ([coordinator respondsToSelector:@selector(setParentCoordinator:)]) {
      coordinator.parentCoordinator = nil;
    }

    [self.childCoordinators removeObject:coordinator];

    os_log_debug(BaseCoordinatorLog(), "[%{public}@] Removed child: %{public}@",
                 NSStringFromClass([self class]),
                 NSStringFromClass([coordinator class]));
  }
}

- (void)removeAllChildCoordinators {
  for (id<Coordinator> coordinator in [self.childCoordinators copy]) {
    [self removeChildCoordinator:coordinator];
  }
}

#pragma mark - Lifecycle

- (void)start {
  // Subclasses must override this method
  NSAssert(NO, @"Subclasses must override the start method");
}

- (void)finish {
  // Notify parent to remove this coordinator
  if ([self.parentCoordinator
          respondsToSelector:@selector(coordinatorDidFinish:)]) {
    [self.parentCoordinator coordinatorDidFinish:self];
  }
}

#pragma mark - Coordinator Protocol

- (void)coordinatorDidFinish:(id<Coordinator>)coordinator {
  [self removeChildCoordinator:coordinator];
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(BaseCoordinatorLog(), "[%{public}@] dealloc",
               NSStringFromClass([self class]));
}

@end
