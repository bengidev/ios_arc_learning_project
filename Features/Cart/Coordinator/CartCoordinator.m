//
//  CartCoordinator.m
//  MVVM-C-ARC
//
//  CartCoordinator Implementation
//  ARC Version
//

#import "CartCoordinator.h"
#import "CartViewController.h"
#import "CartViewModel.h"
#import <os/log.h>

static os_log_t CartCoordinatorLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "CartCoordinator");
  });
  return log;
}

@implementation CartCoordinator

- (instancetype)initWithNavigationController:
    (UINavigationController *)navigationController {
  return [super initWithNavigationController:navigationController];
}

- (void)start {
  os_log_info(CartCoordinatorLog(), "Starting cart flow");

  CartViewModel *viewModel = [[CartViewModel alloc] init];
  CartViewController *cartVC =
      [[CartViewController alloc] initWithViewModel:viewModel];

  [self.navigationController setViewControllers:@[ cartVC ] animated:NO];
}

- (void)dealloc {
  os_log_debug(CartCoordinatorLog(), "dealloc");
}

@end
