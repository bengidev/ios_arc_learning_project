//
//  CartViewController.h
//  MVVM-C-ARC
//
//  View controller for cart screen
//  ARC Version
//

#import <UIKit/UIKit.h>

@class CartViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface CartViewController : UIViewController

@property(nonatomic, strong) CartViewModel *viewModel;

- (instancetype)initWithViewModel:(CartViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
