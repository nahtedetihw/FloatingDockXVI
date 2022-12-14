#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <spawn.h>
#include <objc/runtime.h>

#define TINT_COLOR [UIColor colorWithRed:119/255.0f green:181/255.0f blue:166/255.0f alpha:1.0f]

@interface UILabel (FloatingDockXVI)
- (void)setMarqueeRunning:(BOOL)arg1;
- (void)setMarqueeEnabled:(BOOL)arg1;
- (BOOL)marqueeEnabled;
- (BOOL)marqueeRunning;
@end

@interface BSAction : NSObject
@end

@interface SBSRelaunchAction : BSAction
+ (id)actionWithReason:(id)arg1 options:(unsigned long long)arg2 targetURL:(id)arg3;
@end

@interface FBSSystemService : NSObject
+ (id)sharedService;
- (void)sendActions:(id)arg1 withResult:(id)arg2;
@end

@interface UIPopoverPresentationController (Private)
@property (assign,setter=_setPopoverBackgroundStyle:,nonatomic) long long _popoverBackgroundStyle;
@property (assign,setter=_setBackgroundBlurDisabled:,nonatomic) BOOL _backgroundBlurDisabled;
@end

@interface OBButtonTray : UIView
@property (nonatomic,retain) UIVisualEffectView * effectView;
- (void)addButton:(id)arg1;
- (void)addCaptionText:(id)arg1;;
@end

@interface OBBoldTrayButton : UIButton
- (void)setTitle:(id)arg1 forState:(unsigned long long)arg2;
+ (id)buttonWithType:(long long)arg1;
@end

@interface OBWelcomeController : UIViewController
@property (nonatomic, retain) UIView *viewIfLoaded;
@property (nonatomic, strong) UIColor *backgroundColor;
- (OBButtonTray *)buttonTray;
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end

@interface _UIBackdropView : UIView
-(id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3 ;
@property (assign,nonatomic) BOOL blurRadiusSetOnce;
@property (assign,nonatomic) double _blurRadius;
@property (nonatomic,copy) NSString * _blurQuality;
-(id)initWithSettings:(id)arg1 ;
@end

@interface _UIBackdropViewSettings : NSObject
+(id)settingsForStyle:(long long)arg1 ;
@end

@interface FDXVIPreferencesListController : PSListController<UIPopoverPresentationControllerDelegate> {

    UITableView * _table;

}
@property (nonatomic, strong) UIImageView *artworkView;
@property (nonatomic, strong) UIImageView *artworkView2;
@property (nonatomic, retain) UIBarButtonItem *killButton;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) NSArray *versionArray;
@property (nonatomic, retain) OBWelcomeController *changelogController;
- (void)apply:(UIButton *)sender;
- (void)showMenu:(UIButton *)sender;
- (void)twitter:(UIButton *)sender;
- (void)handleYesGesture:(UIButton *)sender;
- (void)handleNoGesture:(UIButton *)sender;
@end

@interface FDXVIAppearanceSettings: HBAppearanceSettings
@end

@interface PBSwitch: PSSwitchTableCell
@end

@interface PBTableCell : PSTableCell
@end
