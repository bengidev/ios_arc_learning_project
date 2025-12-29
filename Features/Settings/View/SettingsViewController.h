//
//  SettingsViewController.h
//  MVVM-C-ARC
//
//  View controller for settings screen
//  ARC Version
//

#import <UIKit/UIKit.h>

@class SettingsViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewController : UIViewController

@property(nonatomic, strong) SettingsViewModel *viewModel;

- (instancetype)initWithViewModel:(SettingsViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
