//
//  ProductListViewController.h
//  MVVM-C-ARC
//
//  View controller for product list screen
//  ARC Version
//

#import <UIKit/UIKit.h>

@class ProductListViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface ProductListViewController : UIViewController

/// The view model driving this view controller
@property(nonatomic, strong) ProductListViewModel *viewModel;

/// Initialize with a view model
/// @param viewModel The view model for this controller
- (instancetype)initWithViewModel:(ProductListViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
