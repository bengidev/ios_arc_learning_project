//
//  ViewController.h
//  ARC Project
//
//  Created for ARC Learning
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// ARC: Use 'strong' for owned objects, 'weak' for delegates/parents
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UILabel *comparisonLabel;

@end
