//
//  SettingsViewModel.m
//  MVVM-C-ARC
//
//  SettingsViewModel Implementation
//  ARC Version
//

#import "SettingsViewModel.h"

@implementation SettingsViewModel

- (NSInteger)numberOfSections {
  return SettingsSectionCount;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
  switch (section) {
  case SettingsSectionAccount:
    return 2;
  case SettingsSectionPreferences:
    return 3;
  case SettingsSectionAbout:
    return 2;
  default:
    return 0;
  }
}

- (NSString *)titleForSection:(NSInteger)section {
  switch (section) {
  case SettingsSectionAccount:
    return @"Account";
  case SettingsSectionPreferences:
    return @"Preferences";
  case SettingsSectionAbout:
    return @"About";
  default:
    return @"";
  }
}

- (NSString *)titleForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
  case SettingsSectionAccount:
    return indexPath.row == 0 ? @"Edit Profile" : @"Change Password";
  case SettingsSectionPreferences:
    switch (indexPath.row) {
    case 0:
      return @"Notifications";
    case 1:
      return @"Appearance";
    case 2:
      return @"Privacy";
    default:
      return @"";
    }
  case SettingsSectionAbout:
    return indexPath.row == 0 ? @"Version" : @"Terms of Service";
  default:
    return @"";
  }
}

- (NSString *)iconForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
  case SettingsSectionAccount:
    return indexPath.row == 0 ? @"person.circle" : @"lock";
  case SettingsSectionPreferences:
    switch (indexPath.row) {
    case 0:
      return @"bell";
    case 1:
      return @"paintbrush";
    case 2:
      return @"hand.raised";
    default:
      return @"gear";
    }
  case SettingsSectionAbout:
    return indexPath.row == 0 ? @"info.circle" : @"doc.text";
  default:
    return @"gear";
  }
}

@end
