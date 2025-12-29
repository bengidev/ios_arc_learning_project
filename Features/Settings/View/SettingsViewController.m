//
//  SettingsViewController.m
//  MVVM-C-ARC
//
//  SettingsViewController Implementation
//  ARC Version
//

#import "SettingsViewController.h"
#import "DesignConstants.h"
#import "SettingsViewModel.h"

static NSString *const kSettingsCellIdentifier = @"SettingsCell";

@interface SettingsViewController () <UITableViewDataSource,
                                      UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation SettingsViewController

- (instancetype)initWithViewModel:(SettingsViewModel *)viewModel {
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
  self.title = @"Settings";
  self.view.backgroundColor = [UIColor systemBackgroundColor];
  self.view.accessibilityIdentifier = kAccessibilitySettingsView;

  self.tableView =
      [[UITableView alloc] initWithFrame:CGRectZero
                                   style:UITableViewStyleInsetGrouped];
  self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.accessibilityIdentifier = kAccessibilitySettingsTable;
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kSettingsCellIdentifier];
  [self.view addSubview:self.tableView];

  [NSLayoutConstraint activateConstraints:@[
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.tableView.leadingAnchor
        constraintEqualToAnchor:self.view.leadingAnchor],
    [self.tableView.trailingAnchor
        constraintEqualToAnchor:self.view.trailingAnchor],
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
  ]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.viewModel numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  return [self.viewModel titleForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:kSettingsCellIdentifier
                                      forIndexPath:indexPath];

  UIListContentConfiguration *config =
      [UIListContentConfiguration cellConfiguration];
  config.text = [self.viewModel titleForRowAtIndexPath:indexPath];
  config.image = [UIImage
      systemImageNamed:[self.viewModel iconForRowAtIndexPath:indexPath]];

  cell.contentConfiguration = config;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  // Placeholder - show alert for now
  NSString *title = [self.viewModel titleForRowAtIndexPath:indexPath];
  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:title
                                          message:@"Coming soon!"
                                   preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                          handler:nil]];
  [self presentViewController:alert animated:YES completion:nil];
}

@end
