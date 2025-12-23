//
//  BaseCoordinator.m
//  MVVM-C-ARC
//
//  BaseCoordinator Implementation
//  ARC Version
//

#import "BaseCoordinator.h"

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

    NSLog(@"[%@] Added child coordinator: %@", NSStringFromClass([self class]),
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

    NSLog(@"[%@] Removed child coordinator: %@",
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
  NSLog(@"[%@] dealloc", NSStringFromClass([self class]));
}

@end
