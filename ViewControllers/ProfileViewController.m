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
#import <os/log.h>

// Accessibility identifiers for Profile screen
static NSString *const kAccessibilityProfileAvatarImage = @"profileAvatarImage";
static NSString *const kAccessibilityProfileNameLabel = @"profileNameLabel";
static NSString *const kAccessibilityProfileEmailLabel = @"profileEmailLabel";
static NSString *const kAccessibilityProfileMembershipBadge =
    @"profileMembershipBadge";
static NSString *const kAccessibilityEditProfileButton = @"editProfileButton";
static NSString *const kAccessibilityViewOrdersButton = @"viewOrdersButton";
static NSString *const kAccessibilityLogoutButton = @"logoutButton";

static os_log_t ProfileViewControllerLog(void) {
  static os_log_t log = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    log = os_log_create("com.bengidev.mvvmc", "ProfileViewController");
  });
  return log;
}

@interface ProfileViewController ()
@property(nonatomic, strong, readwrite) ProfileViewModel *viewModel;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIStackView *stackView;
@property(nonatomic, strong) UIImageView *avatarImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *emailLabel;
@property(nonatomic, strong) UILabel *phoneLabel;
@property(nonatomic, strong) UILabel *membershipBadge;
@property(nonatomic, strong) UILabel *ordersLabel;
@property(nonatomic, strong) UILabel *memberSinceLabel;
@property(nonatomic, strong) UIButton *editProfileButton;
@property(nonatomic, strong) UIButton *viewOrdersButton;
@property(nonatomic, strong) UIButton *logoutButton;
@property(nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@end

@implementation ProfileViewController

#pragma mark - Initialization

- (instancetype)initWithViewModel:(ProfileViewModel *)viewModel {
  NSParameterAssert(viewModel != nil);

  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _viewModel = viewModel;
  }
  return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupUI];
  [self setupAccessibility];
  [self setupBindings];
  [self.viewModel loadProfile];
}

- (void)setupUI {
  self.view.backgroundColor = [UIColor systemBackgroundColor];
  self.title = @"Profile";

  // Loading indicator
  self.loadingIndicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
  self.loadingIndicator.center = self.view.center;
  self.loadingIndicator.hidesWhenStopped = YES;
  [self.view addSubview:self.loadingIndicator];
  [self.loadingIndicator startAnimating];

  // ScrollView
  self.scrollView = [[UIScrollView alloc] init];
  self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  self.scrollView.alpha = 0; // Hidden until loaded
  [self.view addSubview:self.scrollView];

  // StackView
  self.stackView = [[UIStackView alloc] init];
  self.stackView.axis = UILayoutConstraintAxisVertical;
  self.stackView.spacing = kPaddingMedium;
  self.stackView.alignment = UIStackViewAlignmentCenter;
  self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.scrollView addSubview:self.stackView];

  // Avatar
  self.avatarImageView = [[UIImageView alloc] init];
  self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
  self.avatarImageView.layer.cornerRadius = 50;
  self.avatarImageView.clipsToBounds = YES;
  self.avatarImageView.backgroundColor = [UIColor systemGray4Color];
  self.avatarImageView.image = [UIImage systemImageNamed:@"person.circle.fill"];
  self.avatarImageView.tintColor = [UIColor systemGray2Color];
  self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.stackView addArrangedSubview:self.avatarImageView];

  // Name
  self.nameLabel = [[UILabel alloc] init];
  self.nameLabel.font = [UIFont boldSystemFontOfSize:24];
  self.nameLabel.textAlignment = NSTextAlignmentCenter;
  [self.stackView addArrangedSubview:self.nameLabel];

  // Membership badge
  self.membershipBadge = [[UILabel alloc] init];
  self.membershipBadge.font = [UIFont systemFontOfSize:12
                                                weight:UIFontWeightSemibold];
  self.membershipBadge.textColor = [UIColor whiteColor];
  self.membershipBadge.backgroundColor = [UIColor systemOrangeColor];
  self.membershipBadge.textAlignment = NSTextAlignmentCenter;
  self.membershipBadge.layer.cornerRadius = kCornerRadiusSmall;
  self.membershipBadge.clipsToBounds = YES;
  [self.stackView addArrangedSubview:self.membershipBadge];

  // Email
  self.emailLabel = [[UILabel alloc] init];
  self.emailLabel.font = [UIFont systemFontOfSize:16];
  self.emailLabel.textColor = [UIColor secondaryLabelColor];
  self.emailLabel.textAlignment = NSTextAlignmentCenter;
  [self.stackView addArrangedSubview:self.emailLabel];

  // Phone
  self.phoneLabel = [[UILabel alloc] init];
  self.phoneLabel.font = [UIFont systemFontOfSize:16];
  self.phoneLabel.textColor = [UIColor secondaryLabelColor];
  self.phoneLabel.textAlignment = NSTextAlignmentCenter;
  [self.stackView addArrangedSubview:self.phoneLabel];

  // Orders count
  self.ordersLabel = [[UILabel alloc] init];
  self.ordersLabel.font = [UIFont systemFontOfSize:16
                                            weight:UIFontWeightMedium];
  self.ordersLabel.textColor = [UIColor systemBlueColor];
  self.ordersLabel.textAlignment = NSTextAlignmentCenter;
  [self.stackView addArrangedSubview:self.ordersLabel];

  // Member since
  self.memberSinceLabel = [[UILabel alloc] init];
  self.memberSinceLabel.font = [UIFont systemFontOfSize:14];
  self.memberSinceLabel.textColor = [UIColor tertiaryLabelColor];
  self.memberSinceLabel.textAlignment = NSTextAlignmentCenter;
  [self.stackView addArrangedSubview:self.memberSinceLabel];

  // Spacer
  UIView *spacer = [[UIView alloc] init];
  spacer.translatesAutoresizingMaskIntoConstraints = NO;
  [spacer.heightAnchor constraintEqualToConstant:kPaddingLarge].active = YES;
  [self.stackView addArrangedSubview:spacer];

  // Edit Profile Button
  self.editProfileButton =
      [self createButtonWithTitle:@"Edit Profile"
                           action:@selector(editProfileTapped)
                        isPrimary:NO];
  [self.stackView addArrangedSubview:self.editProfileButton];

  // View Orders Button
  self.viewOrdersButton =
      [self createButtonWithTitle:@"View Orders"
                           action:@selector(viewOrdersTapped)
                        isPrimary:NO];
  [self.stackView addArrangedSubview:self.viewOrdersButton];

  // Logout Button
  self.logoutButton = [self createButtonWithTitle:@"Logout"
                                           action:@selector(logoutTapped)
                                        isPrimary:YES];
  self.logoutButton.backgroundColor = [UIColor systemRedColor];
  [self.stackView addArrangedSubview:self.logoutButton];

  // Layout
  UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
  [NSLayoutConstraint activateConstraints:@[
    [self.scrollView.topAnchor constraintEqualToAnchor:safeArea.topAnchor],
    [self.scrollView.leadingAnchor
        constraintEqualToAnchor:safeArea.leadingAnchor],
    [self.scrollView.trailingAnchor
        constraintEqualToAnchor:safeArea.trailingAnchor],
    [self.scrollView.bottomAnchor
        constraintEqualToAnchor:safeArea.bottomAnchor],

    [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor
                                             constant:kPaddingLarge],
    [self.stackView.leadingAnchor
        constraintEqualToAnchor:self.scrollView.leadingAnchor
                       constant:kPaddingLarge],
    [self.stackView.trailingAnchor
        constraintEqualToAnchor:self.scrollView.trailingAnchor
                       constant:-kPaddingLarge],
    [self.stackView.bottomAnchor
        constraintEqualToAnchor:self.scrollView.bottomAnchor
                       constant:-kPaddingLarge],
    [self.stackView.widthAnchor
        constraintEqualToAnchor:self.scrollView.widthAnchor
                       constant:-kPaddingLarge * 2],

    [self.avatarImageView.widthAnchor constraintEqualToConstant:100],
    [self.avatarImageView.heightAnchor constraintEqualToConstant:100],

    [self.editProfileButton.widthAnchor
        constraintEqualToAnchor:self.stackView.widthAnchor],
    [self.editProfileButton.heightAnchor
        constraintEqualToConstant:kButtonHeightMedium],
    [self.viewOrdersButton.widthAnchor
        constraintEqualToAnchor:self.stackView.widthAnchor],
    [self.viewOrdersButton.heightAnchor
        constraintEqualToConstant:kButtonHeightMedium],
    [self.logoutButton.widthAnchor
        constraintEqualToAnchor:self.stackView.widthAnchor],
    [self.logoutButton.heightAnchor
        constraintEqualToConstant:kButtonHeightMedium]
  ]];
}

- (UIButton *)createButtonWithTitle:(NSString *)title
                             action:(SEL)action
                          isPrimary:(BOOL)isPrimary {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  [button setTitle:title forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont systemFontOfSize:16
                                             weight:UIFontWeightSemibold];
  button.layer.cornerRadius = kCornerRadiusMedium;

  if (isPrimary) {
    button.backgroundColor = [UIColor systemBlueColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  } else {
    button.backgroundColor = [UIColor secondarySystemBackgroundColor];
    [button setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
  }

  [button addTarget:self
                action:action
      forControlEvents:UIControlEventTouchUpInside];
  button.translatesAutoresizingMaskIntoConstraints = NO;
  return button;
}

- (void)setupAccessibility {
  self.avatarImageView.accessibilityIdentifier =
      kAccessibilityProfileAvatarImage;
  self.avatarImageView.isAccessibilityElement = YES;
  self.avatarImageView.accessibilityLabel = @"Profile avatar";

  self.nameLabel.accessibilityIdentifier = kAccessibilityProfileNameLabel;
  self.emailLabel.accessibilityIdentifier = kAccessibilityProfileEmailLabel;
  self.membershipBadge.accessibilityIdentifier =
      kAccessibilityProfileMembershipBadge;
  self.editProfileButton.accessibilityIdentifier =
      kAccessibilityEditProfileButton;
  self.viewOrdersButton.accessibilityIdentifier =
      kAccessibilityViewOrdersButton;
  self.logoutButton.accessibilityIdentifier = kAccessibilityLogoutButton;
}

- (void)setupBindings {
  __weak typeof(self) weakSelf = self;

  self.viewModel.onProfileLoaded = ^(BOOL success) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf)
      return;

    [strongSelf.loadingIndicator stopAnimating];

    if (success) {
      [strongSelf updateUI];
      [UIView animateWithDuration:kAnimationDurationNormal
                       animations:^{
                         strongSelf.scrollView.alpha = 1;
                       }];
    }
  };

  self.viewModel.onError = ^(NSError *error) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf)
      return;

    os_log_error(ProfileViewControllerLog(), "Error: %{public}@",
                 error.localizedDescription);

    [strongSelf showErrorAlert:error.localizedDescription];
  };

  self.viewModel.onLogoutComplete = ^(BOOL success) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf)
      return;

    if (success) {
      os_log_info(ProfileViewControllerLog(), "Logout completed");
    }
  };
}

- (void)updateUI {
  self.nameLabel.text = self.viewModel.displayName;
  self.emailLabel.text = self.viewModel.emailDisplay;
  self.phoneLabel.text = self.viewModel.phoneNumber;
  self.membershipBadge.text =
      [NSString stringWithFormat:@"  %@  ", self.viewModel.membershipBadge];
  self.ordersLabel.text = self.viewModel.ordersCountString;
  self.memberSinceLabel.text = self.viewModel.memberSinceString;

  // Accessibility
  self.nameLabel.accessibilityLabel = self.viewModel.displayName;
  self.membershipBadge.accessibilityLabel =
      [NSString stringWithFormat:@"%@ member", self.viewModel.membershipBadge];
}

- (void)showErrorAlert:(NSString *)message {
  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:@"Error"
                                          message:message
                                   preferredStyle:UIAlertControllerStyleAlert];

  [alert addAction:[UIAlertAction actionWithTitle:@"Retry"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *action) {
                                            [self.viewModel loadProfile];
                                          }]];

  [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                            style:UIAlertActionStyleCancel
                                          handler:nil]];

  [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Actions

- (void)editProfileTapped {
  os_log_info(ProfileViewControllerLog(), "Edit profile tapped");
  [self.viewModel editProfile];
}

- (void)viewOrdersTapped {
  os_log_info(ProfileViewControllerLog(), "View orders tapped");
  [self.viewModel viewOrders];
}

- (void)logoutTapped {
  os_log_info(ProfileViewControllerLog(), "Logout tapped");

  UIAlertController *alert = [UIAlertController
      alertControllerWithTitle:@"Logout"
                       message:@"Are you sure you want to logout?"
                preferredStyle:UIAlertControllerStyleAlert];

  [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                            style:UIAlertActionStyleCancel
                                          handler:nil]];

  [alert addAction:[UIAlertAction actionWithTitle:@"Logout"
                                            style:UIAlertActionStyleDestructive
                                          handler:^(UIAlertAction *action) {
                                            [self.viewModel logout];
                                          }]];

  [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Debug

- (void)dealloc {
  os_log_debug(ProfileViewControllerLog(), "dealloc");
}

@end
