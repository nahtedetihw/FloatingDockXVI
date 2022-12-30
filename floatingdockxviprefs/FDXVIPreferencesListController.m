#include "FDXVIPreferencesListController.h"
#import <AudioToolbox/AudioServices.h>
#import <Cephei/HBPreferences.h>

UIBarButtonItem *respringButtonItem;
UIBarButtonItem *changelogButtonItem;
UIBarButtonItem *twitterButtonItem;
UIViewController *popController;
UIColor *backgroundDynamicColor;
UIColor *tintDynamicColor;
_UIBackdropView *backdropViewRespring;
UIView *blackViewRespring;

@implementation FDXVIPreferencesListController
@synthesize killButton;
@synthesize versionArray;

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
    }

    return _specifiers;
}

- (instancetype)init {

    self = [super init];

    if (self) {
        
        backgroundDynamicColor = [UIColor colorWithRed:15/255.0f green:130/255.0f blue:193/255.0f alpha:1.0f];
        
        tintDynamicColor = [UIColor colorWithRed:119/255.0f green:181/255.0f blue:166/255.0f alpha:1.0f];
        
        FDXVIAppearanceSettings *appearanceSettings = [[FDXVIAppearanceSettings alloc] init];
        self.hb_appearanceSettings = appearanceSettings;
        UIButton *respringButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        respringButton.frame = CGRectMake(0,0,30,30);
        respringButton.layer.cornerRadius = respringButton.frame.size.height / 2;
        respringButton.layer.masksToBounds = YES;
        respringButton.backgroundColor = tintDynamicColor;
        respringButton.tintColor = backgroundDynamicColor;
        [respringButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/floatingdockxviprefs.bundle/CHECKMARK.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [respringButton addTarget:self action:@selector(apply:) forControlEvents:UIControlEventTouchUpInside];
        
        respringButtonItem = [[UIBarButtonItem alloc] initWithCustomView:respringButton];
        
        UIButton *changelogButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        changelogButton.frame = CGRectMake(0,0,30,30);
        changelogButton.layer.cornerRadius = changelogButton.frame.size.height / 2;
        changelogButton.layer.masksToBounds = YES;
        changelogButton.backgroundColor = tintDynamicColor;
        changelogButton.tintColor = backgroundDynamicColor;
        [changelogButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/floatingdockxviprefs.bundle/CHANGELOG.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [changelogButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        
        changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changelogButton];
        
        UIButton *twitterButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        twitterButton.frame = CGRectMake(0,0,30,30);
        twitterButton.layer.cornerRadius = twitterButton.frame.size.height / 2;
        twitterButton.layer.masksToBounds = YES;
        twitterButton.backgroundColor = tintDynamicColor;
        twitterButton.tintColor = backgroundDynamicColor;
        [twitterButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/floatingdockxviprefs.bundle/TWITTER.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [twitterButton addTarget:self action:@selector(twitter:) forControlEvents:UIControlEventTouchUpInside];
        
        twitterButtonItem = [[UIBarButtonItem alloc] initWithCustomView:twitterButton];
        
        NSArray *rightButtons;
        rightButtons = @[respringButtonItem, changelogButtonItem, twitterButtonItem];
        self.navigationItem.rightBarButtonItems = rightButtons;
        self.navigationItem.titleView = [UIView new];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = @"";
        self.titleLabel.textColor = tintDynamicColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem.titleView addSubview:self.titleLabel];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/floatingdockxviprefs.bundle/headericon.png"];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.alpha = 0.0;
        [self.navigationItem.titleView addSubview:self.iconView];

        [NSLayoutConstraint activateConstraints:@[
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
            [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        ]];

    }

    return self;

}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {

    return UIModalPresentationNone;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    self.navigationController.navigationController.navigationBar.barTintColor = [UIColor labelColor];
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.tintColor = [UIColor labelColor];
    self.navigationController.navigationController.navigationBar.translucent = NO;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    _UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

    backdropViewRespring = [[_UIBackdropView alloc] initWithSettings:settings];
    backdropViewRespring.layer.masksToBounds = YES;
    backdropViewRespring.clipsToBounds = YES;
    backdropViewRespring.frame = [UIScreen mainScreen].bounds;
    backdropViewRespring.alpha = 0;
    [[[UIApplication sharedApplication] keyWindow] addSubview:backdropViewRespring];
    
    blackViewRespring = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    blackViewRespring.layer.masksToBounds = YES;
    blackViewRespring.clipsToBounds = YES;
    blackViewRespring.alpha = 0;
    blackViewRespring.backgroundColor = [UIColor blackColor];
    [[[UIApplication sharedApplication] keyWindow] addSubview:blackViewRespring];

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.table.bounds.size.width,300)];
    
    self.artworkView = [[UIImageView alloc] initWithFrame:CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height)];
    self.artworkView.contentMode = UIViewContentModeScaleAspectFit;
    self.artworkView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/floatingdockxviprefs.bundle/banner.png"];
    self.artworkView.layer.masksToBounds = YES;
    
    [self.headerView insertSubview:self.artworkView atIndex:0];
    
    self.artworkView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [self.artworkView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.artworkView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.artworkView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.artworkView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];
    _table.tableHeaderView = self.headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 1.0;
            self.titleLabel.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 0.0;
            self.titleLabel.alpha = 1.0;
        }];
    }

    if (offsetY > 0) offsetY = 0;
    self.artworkView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, 200 - offsetY);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
}

- (void)apply:(UIButton *)sender {
    
    popController = [[UIViewController alloc] init];
    popController.modalPresentationStyle = UIModalPresentationPopover;
    popController.preferredContentSize = CGSizeMake(200,130);
    UILabel *respringLabel = [[UILabel alloc] init];
    respringLabel.frame = CGRectMake(20, 20, 160, 60);
    respringLabel.numberOfLines = 2;
    respringLabel.textAlignment = NSTextAlignmentCenter;
    respringLabel.adjustsFontSizeToFitWidth = YES;
    respringLabel.font = [UIFont boldSystemFontOfSize:20];
    respringLabel.textColor = tintDynamicColor;
    respringLabel.text = @"Are you sure you want to respring?";
    [popController.view addSubview:respringLabel];
    
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yesButton addTarget:self
                  action:@selector(handleYesGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    yesButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [yesButton setTitleColor:tintDynamicColor forState:UIControlStateNormal];
    yesButton.frame = CGRectMake(100, 100, 100, 30);
    [popController.view addSubview:yesButton];
    
    UIButton *noButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noButton addTarget:self
                  action:@selector(handleNoGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [noButton setTitle:@"No" forState:UIControlStateNormal];
    noButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [noButton setTitleColor:tintDynamicColor forState:UIControlStateNormal];
    noButton.frame = CGRectMake(0, 100, 100, 30);
    [popController.view addSubview:noButton];
     
    UIPopoverPresentationController *popover = popController.popoverPresentationController;
    popover.delegate = self;
    //[popover _setBackgroundBlurDisabled:YES];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.barButtonItem = respringButtonItem;
    //popover.backgroundColor = backgroundDynamicColor;
    
    [self presentViewController:popController animated:YES completion:nil];
    
    AudioServicesPlaySystemSound(1519);

}

- (void)showMenu:(id)sender {
    
    AudioServicesPlaySystemSound(1519);

    self.changelogController = [[OBWelcomeController alloc] initWithTitle:@"FloatingDockXVI" detailText:@"1.1" icon:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/floatingdockxviprefs.bundle/changelogControllerIcon.png"]];
    
    [self.changelogController addBulletedListItemWithTitle:@"Dock Apps" description:@"Added the ability to change max number of Dock Apps." image:[UIImage systemImageNamed:@"1.circle.fill"]];

    [self.changelogController addBulletedListItemWithTitle:@"Recent Apps" description:@"Added the ability to change max number of Recent Apps." image:[UIImage systemImageNamed:@"2.circle.fill"]];
    
    [self.changelogController addBulletedListItemWithTitle:@"Separator" description:@"Added an option to remove the separator in the dock when recent apps are enabled." image:[UIImage systemImageNamed:@"3.circle.fill"]];
    
    [self.changelogController addBulletedListItemWithTitle:@"Disable" description:@"Added an option to disable floating dock in apps." image:[UIImage systemImageNamed:@"4.circle.fill"]];
    
    [self.changelogController addBulletedListItemWithTitle:@"Bugs" description:@"Fixed a bug where the dock would jump around when transitioning from landscape." image:[UIImage systemImageNamed:@"5.circle.fill"]];

    _UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

    _UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
    backdropView.layer.masksToBounds = YES;
    backdropView.clipsToBounds = YES;
    backdropView.frame = self.changelogController.viewIfLoaded.frame;
    [self.changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];
    
    backdropView.translatesAutoresizingMaskIntoConstraints = false;
    [backdropView.bottomAnchor constraintEqualToAnchor:self.changelogController.viewIfLoaded.bottomAnchor constant:0].active = YES;
    [backdropView.leftAnchor constraintEqualToAnchor:self.changelogController.viewIfLoaded.leftAnchor constant:0].active = YES;
    [backdropView.rightAnchor constraintEqualToAnchor:self.changelogController.viewIfLoaded.rightAnchor constant:0].active = YES;
    [backdropView.topAnchor constraintEqualToAnchor:self.changelogController.viewIfLoaded.topAnchor constant:0].active = YES;

    self.changelogController.viewIfLoaded.backgroundColor = [UIColor clearColor];
    self.changelogController.modalPresentationStyle = UIModalPresentationPageSheet;
    self.changelogController.modalInPresentation = NO;
    [self presentViewController:self.changelogController animated:YES completion:nil];
}
- (void)dismissVC {
    [self.changelogController dismissViewControllerAnimated:YES completion:nil];
}

- (void)twitter:(id)sender {
    AudioServicesPlaySystemSound(1519);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/EthanWhited"] options:@{} completionHandler:nil];
}

- (void)twitterMTAC:(id)sender {
    AudioServicesPlaySystemSound(1519);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/MTAC8"] options:@{} completionHandler:nil];
}

- (void)handleYesGesture:(UIButton *)sender {
    AudioServicesPlaySystemSound(1519);

    [popController dismissViewControllerAnimated:YES completion:nil];

    [UIView animateWithDuration:1.0 animations:^{
        backdropViewRespring.alpha = 1;
    }];
    
    [UIView animateWithDuration:2.0 animations:^{
        blackViewRespring.alpha = 1;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    pid_t pid;
    const char* args[] = {"sbreload", NULL};
    posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
    });
}

- (void)handleNoGesture:(UIButton *)sender {
    AudioServicesPlaySystemSound(1519);
    [popController dismissViewControllerAnimated:YES completion:nil];
}
@end

@implementation FDXVIAppearanceSettings: HBAppearanceSettings
- (UIColor *)tintColor {
    return [UIColor colorWithRed:119/255.0f green:181/255.0f blue:166/255.0f alpha:1.0f];
}

- (UIColor *)tableViewCellSeparatorColor {
    return [UIColor clearColor];
}
@end

@implementation PBSwitch
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)identifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier];
	if (self) {
		[((UISwitch *)[self control]) setOnTintColor:TINT_COLOR];
		self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
		self.detailTextLabel.textColor = TINT_COLOR;
        self.detailTextLabel.text = specifier.properties[@"subtitle"] ?: @"";
        CGSize size = [self.detailTextLabel.text sizeWithAttributes:@{NSFontAttributeName:self.detailTextLabel.font}];
        if (size.width > self.detailTextLabel.bounds.size.width) {
            [self.detailTextLabel setMarqueeEnabled:YES];
            [self.detailTextLabel setMarqueeRunning:YES];
        }
	}
	return self;
}
- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
	[super refreshCellContentsWithSpecifier:specifier];
	if ([self respondsToSelector:@selector(tintColor)]) {
		self.detailTextLabel.textColor = TINT_COLOR;
		self.detailTextLabel.highlightedTextColor = TINT_COLOR;
        self.detailTextLabel.text = specifier.properties[@"subtitle"] ?: @"";
        CGSize size = [self.detailTextLabel.text sizeWithAttributes:@{NSFontAttributeName:self.detailTextLabel.font}];
        if (size.width > self.detailTextLabel.bounds.size.width) {
            [self.detailTextLabel setMarqueeEnabled:YES];
            [self.detailTextLabel setMarqueeRunning:YES];
        }
        if (([self.specifier.properties[@"key"] isEqualToString:@"enabled"])) {
			if ([(UISwitch *)self.control isOn]) {
				self.detailTextLabel.text = @"Currently: Enabled";
			} else {
				self.detailTextLabel.text = @"Currently: Disabled";
			}
		}
    }
}
- (void)controlChanged:(UISwitch *)arg1 {
	[super controlChanged:arg1];
	if (([self.specifier.properties[@"key"] isEqualToString:@"enabled"])) {
		if (arg1.isOn) {
			self.detailTextLabel.text = @"Currently: Enabled";
		} else {
			self.detailTextLabel.text = @"Currently: Disabled";
		}
	}
}
@end

@implementation PBTableCell
- (void)tintColorDidChange {
	[super tintColorDidChange];
	self.detailTextLabel.textColor = TINT_COLOR;
}
- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
	[super refreshCellContentsWithSpecifier:specifier];
	if ([self respondsToSelector:@selector(tintColor)]) {
		self.detailTextLabel.textColor = TINT_COLOR;
        self.detailTextLabel.text = specifier.properties[@"subtitle"] ?: @"";
        CGSize size = [self.detailTextLabel.text sizeWithAttributes:@{NSFontAttributeName:self.detailTextLabel.font}];
        if (size.width > self.detailTextLabel.bounds.size.width) {
            [self.detailTextLabel setMarqueeEnabled:YES];
            [self.detailTextLabel setMarqueeRunning:YES];
        }
		self.textLabel.highlightedTextColor = TINT_COLOR;
	}
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)identifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier];
	if (self) {
		self.detailTextLabel.text = specifier.properties[@"subtitle"] ?: @"";
        CGSize size = [self.detailTextLabel.text sizeWithAttributes:@{NSFontAttributeName:self.detailTextLabel.font}];
        if (size.width > self.detailTextLabel.bounds.size.width) {
            [self.detailTextLabel setMarqueeEnabled:YES];
            [self.detailTextLabel setMarqueeRunning:YES];
        }
		self.detailTextLabel.textColor = TINT_COLOR;
		self.detailTextLabel.numberOfLines = 2;
	}
	return self;
}
@end
