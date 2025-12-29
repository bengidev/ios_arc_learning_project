//
//  ProfileViewController.m
//  MVVM-C-ARC
//
//  ProfileViewController Implementation
//  ARC Version
//

#import "ProfileViewController.h"
#import "DesignConstants.h"
#import "ProfileViewModel.h"
#import "User.h"
#import <os/log.h>

@interface ProfileViewController () <ProfileViewModelDelegate>
@property(nonatomic, strong) UIStackView *contentStack;
@property(nonatomic, strong) UILabel *avatarLabel;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *emailLabel;
@property(nonatomic, strong) UILabel *memberSinceLabel;
@property(nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@end

@implementation ProfileViewController

- (instancetype)initWithViewModel:(ProfileViewModel *)viewModel {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _viewModel = viewModel;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupUI];
  self.viewModel.delegate = self;
  [self.viewModel loadProfile];
}

- (void)setupUI {
  self.title = @"Profile";
  self.view.backgroundColor = [UIColor systemBackgroundColor];
  self.view.accessibilityIdentifier = kAccessibilityProfileView;

  // Avatar
  self.avatarLabel = [[UILabel alloc] init];
  self.avatarLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.avatarLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightBold];
  self.avatarLabel.textAlignment = NSTextAlignmentCenter;
  self.avatarLabel.textColor = [UIColor whiteColor];
  self.avatarLabel.backgroundColor = [UIColor systemBlueColor];
  self.avatarLabel.layer.cornerRadius = 50;
  self.avatarLabel.clipsToBounds = YES;

  // Name
  self.nameLabel = [[UILabel alloc] init];
  self.nameLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
  self.nameLabel.textAlignment = NSTextAlignmentCenter;
  self.nameLabel.accessibilityIdentifier = kAccessibilityProfileName;

  // Email
  self.emailLabel = [[UILabel alloc] init];
  self.emailLabel.font = [UIFont systemFontOfSize:16];
  self.emailLabel.textColor = [UIColor secondaryLabelColor];
  self.emailLabel.textAlignment = NSTextAlignmentCenter;
  self.emailLabel.accessibilityIdentifier = kAccessibilityProfileEmail;

  // Member Since
  self.memberSinceLabel = [[UILabel alloc] init];
  self.memberSinceLabel.font = [UIFont systemFontOfSize:14];
  self.memberSinceLabel.textColor = [UIColor tertiaryLabelColor];
  self.memberSinceLabel.textAlignment = NSTextAlignmentCenter;

  // Stack
  self.contentStack = [[UIStackView alloc] initWithArrangedSubviews:@[
    self.avatarLabel, self.nameLabel, self.emailLabel, self.memberSinceLabel
  ]];
  self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;
  self.contentStack.axis = UILayoutConstraintAxisVertical;
  self.contentStack.spacing = kPaddingMedium;
  self.contentStack.alignment = UIStackViewAlignmentCenter;
  [self.view addSubview:self.contentStack];

  // Loading
  self.loadingIndicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
  self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
  self.loadingIndicator.hidesWhenStopped = YES;
  [self.view addSubview:self.loadingIndicator];

  [NSLayoutConstraint activateConstraints:@[
    [self.avatarLabel.widthAnchor constraintEqualToConstant:100],
    [self.avatarLabel.heightAnchor constraintEqualToConstant:100],
    [self.contentStack.centerXAnchor
        constraintEqualToAnchor:self.view.centerXAnchor],
    [self.contentStack.centerYAnchor
        constraintEqualToAnchor:self.view.centerYAnchor
                       constant:-50],
    [self.loadingIndicator.centerXAnchor
        constraintEqualToAnchor:self.view.centerXAnchor],
    [self.loadingIndicator.centerYAnchor
        constraintEqualToAnchor:self.view.centerYAnchor]
  ]];
}

#pragma mark - ProfileViewModelDelegate

- (void)userDidLoad:(User *)user {
  self.avatarLabel.text = [user initials];
  self.nameLabel.text = [self.viewModel displayName];
  self.emailLabel.text = [self.viewModel displayEmail];
  self.memberSinceLabel.text = [self.viewModel memberSince];
  self.contentStack.hidden = NO;
}

- (void)loadingStateDidChange:(BOOL)isLoading {
  if (isLoading) {
    [self.loadingIndicator startAnimating];
    self.contentStack.hidden = YES;
  } else {
    [self.loadingIndicator stopAnimating];
  }
}

@end
