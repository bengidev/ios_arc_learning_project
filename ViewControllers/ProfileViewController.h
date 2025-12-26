//
//  ProfileViewController.h
//  MVVM-C-ARC
//
//  ProfileViewController - Displays user profile
//  ARC Version
//

#import <UIKit/UIKit.h>

@class ProfileViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

/// The view model (strong reference - VC owns ViewModel display)
@property(nonatomic, strong, readonly) ProfileViewModel *viewModel;

/// Initialize with a view model
- (instancetype)initWithViewModel:(ProfileViewModel *)viewModel;

/// Unavailable - use designated initializer
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil
    NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
