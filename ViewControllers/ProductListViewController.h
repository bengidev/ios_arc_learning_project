//
//  ProductListViewController.h
//  MVVM-C-ARC
//
//  ProductListViewController - Displays list of products
//  ARC Version
//

#import <UIKit/UIKit.h>

@class ProductListViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface ProductListViewController : UIViewController

/// The view model for this view controller
@property(nonatomic, strong) ProductListViewModel *viewModel;

/// Initializes with a view model
- (instancetype)initWithViewModel:(ProductListViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
