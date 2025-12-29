//
//  SettingsViewModel.h
//  MVVM-C-ARC
//
//  ViewModel for settings screen
//  ARC Version
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SettingsSection) {
  SettingsSectionAccount = 0,
  SettingsSectionPreferences,
  SettingsSectionAbout,
  SettingsSectionCount
};

@interface SettingsViewModel : NSObject

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSString *)titleForSection:(NSInteger)section;
- (NSString *)titleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)iconForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
