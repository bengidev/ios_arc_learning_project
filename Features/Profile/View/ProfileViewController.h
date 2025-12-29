//
//  ProfileViewController.h
//  MVVM-C-ARC
//
//  View controller for profile screen
//  ARC Version
//

#import <UIKit/UIKit.h>

@class ProfileViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property(nonatomic, strong) ProfileViewModel *viewModel;

- (instancetype)initWithViewModel:(ProfileViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
