//
//  ViewController.m
//  ARC Project
//
//  Created for ARC Learning
//

#import "ViewController.h"

@implementation ViewController

#pragma mark - View Lifecycle

- (void)loadView {
  // Create the main view programmatically
  // ARC: No autorelease needed - compiler handles memory
  UIView *mainView =
      [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  mainView.backgroundColor = [UIColor whiteColor];
  self.view = mainView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupUI];
}

#pragma mark - UI Setup

- (void)setupUI {
  // Create title label
  // ARC: Just alloc/init, no release needed
  UILabel *title = [[UILabel alloc] init];
  title.text = @"ARC Learning Project";
  title.font = [UIFont boldSystemFontOfSize:24.0];
  title.textColor = [UIColor blackColor];
  title.textAlignment = NSTextAlignmentCenter;
  title.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:title];
  self.titleLabel = title;
  // ARC: No [title release] needed!

  // Create description label
  UILabel *description = [[UILabel alloc] init];
  description.text =
      @"Automatic Reference Counting\n\nThis project demonstrates ARC "
      @"patterns:\n• strong / weak / copy properties\n• No manual "
      @"retain/release\n• __weak for block captures";
  description.font = [UIFont systemFontOfSize:16.0];
  description.textColor = [UIColor darkGrayColor];
  description.textAlignment = NSTextAlignmentCenter;
  description.numberOfLines = 0;
  description.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:description];
  self.descriptionLabel = description;
  // ARC: No [description release] needed!

  // Create comparison label
  UILabel *comparison = [[UILabel alloc] init];
  comparison.text =
      @"Compare with MRR Project:\n• MRR: retain/release/autorelease\n• ARC: "
      @"strong/weak (automatic)";
  comparison.font = [UIFont systemFontOfSize:14.0];
  comparison.textColor = [UIColor systemBlueColor];
  comparison.textAlignment = NSTextAlignmentCenter;
  comparison.numberOfLines = 0;
  comparison.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:comparison];
  self.comparisonLabel = comparison;

  // Setup constraints
  [self setupConstraints];
}

- (void)setupConstraints {
  // Title constraints
  [NSLayoutConstraint activateConstraints:@[
    [self.titleLabel.centerXAnchor
        constraintEqualToAnchor:self.view.centerXAnchor],
    [self.titleLabel.topAnchor
        constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor
                       constant:60.0],
    [self.titleLabel.leadingAnchor
        constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor
                                    constant:20.0],
    [self.titleLabel.trailingAnchor
        constraintLessThanOrEqualToAnchor:self.view.trailingAnchor
                                 constant:-20.0]
  ]];

  // Description constraints
  [NSLayoutConstraint activateConstraints:@[
    [self.descriptionLabel.centerXAnchor
        constraintEqualToAnchor:self.view.centerXAnchor],
    [self.descriptionLabel.topAnchor
        constraintEqualToAnchor:self.titleLabel.bottomAnchor
                       constant:40.0],
    [self.descriptionLabel.leadingAnchor
        constraintEqualToAnchor:self.view.leadingAnchor
                       constant:30.0],
    [self.descriptionLabel.trailingAnchor
        constraintEqualToAnchor:self.view.trailingAnchor
                       constant:-30.0]
  ]];

  // Comparison constraints
  [NSLayoutConstraint activateConstraints:@[
    [self.comparisonLabel.centerXAnchor
        constraintEqualToAnchor:self.view.centerXAnchor],
    [self.comparisonLabel.topAnchor
        constraintEqualToAnchor:self.descriptionLabel.bottomAnchor
                       constant:40.0],
    [self.comparisonLabel.leadingAnchor
        constraintEqualToAnchor:self.view.leadingAnchor
                       constant:30.0],
    [self.comparisonLabel.trailingAnchor
        constraintEqualToAnchor:self.view.trailingAnchor
                       constant:-30.0]
  ]];
}

#pragma mark - ARC: Dealloc Example

// ARC: dealloc is OPTIONAL and only for non-memory cleanup
// Uncomment to see the pattern:
//
// - (void)dealloc {
//     [[NSNotificationCenter defaultCenter] removeObserver:self];
//     // NO [super dealloc] - forbidden in ARC!
//     // NO releasing properties - ARC handles automatically!
// }

@end
