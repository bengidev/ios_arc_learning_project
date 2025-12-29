//
//  CartViewController.m
//  MVVM-C-ARC
//
//  CartViewController Implementation (Placeholder)
//  ARC Version
//

#import "CartViewController.h"
#import "CartViewModel.h"
#import "DesignConstants.h"

@interface CartViewController ()
@property(nonatomic, strong) UILabel *emptyLabel;
@property(nonatomic, strong) UIImageView *emptyImageView;
@end

@implementation CartViewController

- (instancetype)initWithViewModel:(CartViewModel *)viewModel {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _viewModel = viewModel;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupUI];
}

- (void)setupUI {
  self.title = @"Cart";
  self.view.backgroundColor = [UIColor systemBackgroundColor];
  self.view.accessibilityIdentifier = kAccessibilityCartView;

  // Empty cart image
  self.emptyImageView = [[UIImageView alloc] init];
  self.emptyImageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.emptyImageView.image = [UIImage systemImageNamed:@"cart"];
  self.emptyImageView.tintColor = [UIColor systemGray3Color];
  self.emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:self.emptyImageView];

  // Empty cart label
  self.emptyLabel = [[UILabel alloc] init];
  self.emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.emptyLabel.text = [self.viewModel itemCountText];
  self.emptyLabel.font = [UIFont systemFontOfSize:18];
  self.emptyLabel.textColor = [UIColor secondaryLabelColor];
  self.emptyLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:self.emptyLabel];

  [NSLayoutConstraint activateConstraints:@[
    [self.emptyImageView.centerXAnchor
        constraintEqualToAnchor:self.view.centerXAnchor],
    [self.emptyImageView.centerYAnchor
        constraintEqualToAnchor:self.view.centerYAnchor
                       constant:-40],
    [self.emptyImageView.widthAnchor constraintEqualToConstant:80],
    [self.emptyImageView.heightAnchor constraintEqualToConstant:80],

    [self.emptyLabel.topAnchor
        constraintEqualToAnchor:self.emptyImageView.bottomAnchor
                       constant:kPaddingMedium],
    [self.emptyLabel.centerXAnchor
        constraintEqualToAnchor:self.view.centerXAnchor]
  ]];
}

@end
