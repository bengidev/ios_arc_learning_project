//
//  SettingsCoordinator.m
//  MVVM-C-ARC
//
//  SettingsCoordinator Implementation
//  ARC Version
//

#import "SettingsCoordinator.h"
#import "SettingsViewController.h"
#import "SettingsViewModel.h"
#import <os/log.h>

static os_log_t SettingsCoordinatorLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "SettingsCoordinator");
  });
  return log;
}

@implementation SettingsCoordinator

- (instancetype)initWithNavigationController:
    (UINavigationController *)navigationController {
  return [super initWithNavigationController:navigationController];
}

- (void)start {
  os_log_info(SettingsCoordinatorLog(), "Starting settings flow");

  SettingsViewModel *viewModel = [[SettingsViewModel alloc] init];
  SettingsViewController *settingsVC =
      [[SettingsViewController alloc] initWithViewModel:viewModel];

  [self.navigationController setViewControllers:@[ settingsVC ] animated:NO];
}

- (void)dealloc {
  os_log_debug(SettingsCoordinatorLog(), "dealloc");
}

@end
