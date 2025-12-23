//
//  ProductDetailViewController.h
//  MVVM-C-ARC
//
//  ProductDetailViewController - Displays product details
//  ARC Version
//

#import <UIKit/UIKit.h>

@class ProductDetailViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface ProductDetailViewController : UIViewController

/// The view model for this view controller
@property(nonatomic, strong) ProductDetailViewModel *viewModel;

/// Initializes with a view model
- (instancetype)initWithViewModel:(ProductDetailViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
