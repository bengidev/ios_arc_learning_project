//
//  ProductDetailViewController.h
//  MVVM-C-ARC
//
//  View controller for product detail screen
//  ARC Version
//

#import <UIKit/UIKit.h>

@class ProductDetailViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface ProductDetailViewController : UIViewController

/// The view model driving this view controller
@property(nonatomic, strong) ProductDetailViewModel *viewModel;

/// Initialize with a view model
/// @param viewModel The view model for this controller
- (instancetype)initWithViewModel:(ProductDetailViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
