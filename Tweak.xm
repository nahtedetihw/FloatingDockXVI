#import <UIKit/UIKit.h>

#define plistPath ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.nahtedetihw.floatingdockxviprefs.plist"] ? @"/var/mobile/Library/Preferences/com.nahtedetihw.floatingdockxviprefs.plist" : @"/var/jb/var/mobile/Library/Preferences/com.nahtedetihw.floatingdockxviprefs.plist")

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface SBFloatingDockViewController : UIViewController
@property (getter=isPresentingFolder,nonatomic,readonly) BOOL presentingFolder; 
@end

@interface SBFloatingDockPlatterView : UIView
@property (nonatomic) UIView *backgroundView;
@end

@interface SBIconListGridLayoutConfiguration : NSObject
@property (nonatomic) unsigned long long numberOfPortraitRows;
@property (nonatomic) unsigned long long numberOfPortraitColumns;
@end

@interface SBIconListView : UIView
@property (nonatomic) NSString *iconLocation;
@end

@interface SBMainSwitcherControllerCoordinator : UIViewController
+ (id)sharedInstance;
- (bool)isAnySwitcherVisible;
@end

@interface SBMainSwitcherViewController : UIViewController
+ (id)sharedInstance;
- (bool)isMainSwitcherVisible;
- (bool)isAnySwitcherVisible;
- (bool)isSlideOverSwitcherVisible;
@end

@interface SBFloatingDockController : NSObject
-(BOOL)_canPresentFloatingDock;
-(void)_dismissFloatingDockIfPresentedAnimated:(BOOL)arg1 completionHandler:(/*^block*/id)arg2;
-(void)_presentFloatingDockIfDismissedAnimated:(BOOL)arg1 completionHandler:(/*^block*/id)arg2;
@end

@interface SBFloatingDockBehaviorAssertion : NSObject
@property (nonatomic,readonly) unsigned long long level;
@property (nonatomic, readonly) SBFloatingDockController *floatingDockController;
-(id)initWithFloatingDockController:(SBFloatingDockController *)arg1 visibleProgress:(double)arg2 animated:(BOOL)arg3 gesturePossible:(BOOL)arg4 atLevel:(unsigned long long)arg5 reason:(id)arg6 withCompletion:(/*^block*/id)arg7;
@end

@interface SBHomeScreenViewController : UIViewController
@property (nonatomic) SBFloatingDockBehaviorAssertion *homeScreenFloatingDockAssertion;
@end

@interface SBIconController : UIViewController
+ (id)sharedInstance;
@property (nonatomic, readonly) SBFloatingDockController *floatingDockController;
@property (nonatomic) SBHomeScreenViewController *parentViewController;
@end

@interface SBBestAppSuggestion : NSObject
- (BOOL)isHandoff;
@end

@interface SBFloatingDockSuggestionsModel : NSObject
@property (nonatomic,readonly) SBBestAppSuggestion * currentAppSuggestion;
-(void)_reloadRecentsAndSuggestions;
@end

@interface SpringBoard : UIApplication
-(BOOL)isShowingHomescreen;
@end

static void showDock() {
    if (@available(iOS 16.0, *)) {
        [[[((SBHomeScreenViewController *)[[%c(SBIconController) sharedInstance] parentViewController]) homeScreenFloatingDockAssertion] floatingDockController] _presentFloatingDockIfDismissedAnimated:YES completionHandler:nil];
    } else {
        [[[%c(SBIconController) sharedInstance] floatingDockController] _presentFloatingDockIfDismissedAnimated:YES completionHandler:nil];
    }
}

static void hideDock() {
    if (@available(iOS 16.0, *)) {
        if (![((SpringBoard *)[%c(SpringBoard) sharedApplication]) isShowingHomescreen]) [[[((SBHomeScreenViewController *)[[%c(SBIconController) sharedInstance] parentViewController]) homeScreenFloatingDockAssertion] floatingDockController] _dismissFloatingDockIfPresentedAnimated:YES completionHandler:nil];
    } else {
        if (![((SpringBoard *)[%c(SpringBoard) sharedApplication]) isShowingHomescreen]) [[[%c(SBIconController) sharedInstance] floatingDockController] _dismissFloatingDockIfPresentedAnimated:YES completionHandler:nil];
    }
}

static NSString *preferencesNotification = @"com.nahtedetihw.floatingdockxviprefs/ReloadPrefs";

BOOL enabled, hideDockBG, removeSeparator;
NSInteger dockStyle, maxRecents, maxDockIcons, dockVisibility;

static void loadPreferences() {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    enabled = dict[@"enabled"] ? [dict[@"enabled"] boolValue] : NO;
    hideDockBG = dict[@"hideDockBG"] ? [dict[@"hideDockBG"] boolValue] : NO;
    removeSeparator = dict[@"removeSeparator"] ? [dict[@"removeSeparator"] boolValue] : NO;
    
    dockStyle = dict[@"dockStyle"] ? [dict[@"dockStyle"] integerValue] : 0;
    maxRecents = dict[@"maxRecents"] ? [dict[@"maxRecents"] integerValue] : 3;
    maxDockIcons = dict[@"maxDockIcons"] ? [dict[@"maxDockIcons"] integerValue] : 4;
    dockVisibility = dict[@"dockVisibility"] ? [dict[@"dockVisibility"] integerValue] : 0;
}

%group FloatingDockXVI
%hook SBFloatingDockController
+ (BOOL)isFloatingDockSupported {
    return YES;
}

- (void)_configureFloatingDockBehaviorAssertionForOpenFolder:(id)arg1 atLevel:(NSUInteger)arg2 {
    
}
%end

%hook SBFloatingDockPlatterView
- (void)setBackgroundView:(id)arg1 {
    %orig;
    if (hideDockBG) {
        self.backgroundView.hidden = YES;
    }
}
%end

%hook SBFloatingDockView
- (void)updateDividerVisualStyling {
    if (removeSeparator) return;
    %orig;
}
%end

%hook SBFloatingDockDefaults
- (void)setRecentsEnabled:(BOOL)arg1 {
    if (dockStyle == 0) %orig(YES);
    if (dockStyle == 1) %orig(NO);
    if (dockStyle == 2) %orig(YES);
    %orig(NO);
}
- (BOOL)recentsEnabled {
    if (dockStyle == 0) return YES;
    if (dockStyle == 1) return NO;
    if (dockStyle == 2) return YES;
    return NO;
}
- (void)setAppLibraryEnabled:(BOOL)arg1 {
    if (dockStyle == 0) %orig(NO);
    if (dockStyle == 1) %orig(YES);
    if (dockStyle == 2) %orig(YES);
    %orig(NO);
}
- (BOOL)appLibraryEnabled {
    if (dockStyle == 0) return NO;
    if (dockStyle == 1) return YES;
    if (dockStyle == 2) return YES;
    return NO;
}
%end

// control number of icons in dock
%hook SBIconListGridLayoutConfiguration
- (unsigned long long)numberOfPortraitColumns {
    unsigned long long o = %orig;
    if ([self numberOfPortraitRows] == 1 && o == 4) {
        return maxDockIcons;
    }
    return o;
}
%end

%hook SBIconListView
- (unsigned long long)maximumIconCount {
    if ([self.iconLocation isEqual:@"SBIconLocationDock" ]) {
        return maxDockIcons;
    }
    return %orig;
}
%end

%hook SBFluidSwitcherViewController
- (BOOL)isFloatingDockGesturePossible {
    BOOL orig = %orig;
    if (dockVisibility == 0) return NO;
    if (dockVisibility == 1) return YES;
    if (dockVisibility == 2) return NO;
    if (dockVisibility == 3) return YES;
    return orig;
}
- (BOOL)isFloatingDockSupported {
    BOOL orig = %orig;
    if (@available(iOS 16.0, *)) {
        if ([[%c(SBMainSwitcherControllerCoordinator) sharedInstance] isAnySwitcherVisible]) {
            if (dockVisibility == 0) return YES;
            if (dockVisibility == 1) return NO;
            if (dockVisibility == 2) return YES;
            if (dockVisibility == 3) return YES;
        }
    } else {
        if ([[%c(SBMainSwitcherViewController) sharedInstance] isMainSwitcherVisible]) {
            if (dockVisibility == 0) return YES;
            if (dockVisibility == 1) return NO;
            if (dockVisibility == 2) return YES;
            if (dockVisibility == 3) return YES;
        }
    }
    if (dockVisibility == 0) return NO;
    if (dockVisibility == 1) return YES;
    if (dockVisibility == 2) return NO;
    if (dockVisibility == 3) return YES;
    return orig;
}
%end

%hook SBMainSwitcherControllerCoordinator
-(void)layoutStateTransitionCoordinator:(id)arg1 transitionDidBeginWithTransitionContext:(id)arg2 {
    %orig;
    if (dockVisibility == 1 || dockVisibility == 2) {
        if ([((SpringBoard *)[%c(SpringBoard) sharedApplication]) isShowingHomescreen] && ![[%c(SBMainSwitcherControllerCoordinator) sharedInstance] isAnySwitcherVisible]) showDock();
        if (![((SpringBoard *)[%c(SpringBoard) sharedApplication]) isShowingHomescreen] && [[%c(SBMainSwitcherControllerCoordinator) sharedInstance] isAnySwitcherVisible]) hideDock();
    }
}
%end

%hook SBMainSwitcherViewController
-(void)layoutStateTransitionCoordinator:(id)arg1 transitionDidBeginWithTransitionContext:(id)arg2 {
    %orig;
    if (dockVisibility == 1 || dockVisibility == 2) {
        if ([((SpringBoard *)[%c(SpringBoard) sharedApplication]) isShowingHomescreen] && ![[%c(SBMainSwitcherViewController) sharedInstance] isMainSwitcherVisible]) showDock();
        if (![((SpringBoard *)[%c(SpringBoard) sharedApplication]) isShowingHomescreen] && [[%c(SBMainSwitcherViewController) sharedInstance] isMainSwitcherVisible]) hideDock();
    }
}
%end

%hook SpringBoard
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;
    loadPreferences();
}
%end
%end

%group Recents16
%hook SBFloatingDockSuggestionsModel
-(BOOL)recentDisplayItemsController:(id)arg1 shouldAddItem:(id)arg2 {
    if ([self.currentAppSuggestion isHandoff]) return NO;
    return %orig;
}

// iOS 16 method to restrict max recents in dock
- (id)initWithMaximumNumberOfSuggestions:(NSUInteger)arg1 iconController:(id)arg2 recentsController:(id)arg3 recentsDataStore:(id)arg4 recentsDefaults:(id)arg5 floatingDockDefaults:(id)arg6 appSuggestionManager:(id)arg7 applicationController:(id)arg8 {
    return %orig(maxRecents,arg2,arg3,arg4,arg5,arg6,arg7,arg8);
}

-(unsigned long long)maxSuggestions {
    return maxRecents;
}
%end

%hook SBFloatingDockSuggestionsViewController
-(id)initWithNumberOfRecents:(unsigned long long)arg1 iconController:(id)arg2 applicationController:(id)arg3 layoutStateTransitionCoordinator:(id)arg4 suggestionsModel:(id)arg5 iconViewProvider:(id)arg6 {
    return %orig(maxRecents,arg2,arg3,arg4,arg5,arg6);
}
%end
%end

%group Recents15
%hook SBFloatingDockSuggestionsModel
-(BOOL)recentDisplayItemsController:(id)arg1 shouldAddItem:(id)arg2 {
    if ([self.currentAppSuggestion isHandoff]) return NO;
    return %orig;
}

// iOS 15 method to restrict max recents in dock
-(id)initWithMaximumNumberOfSuggestions:(unsigned long long)arg1 iconController:(id)arg2 recentsController:(id)arg3 recentsDataStore:(id)arg4 recentsDefaults:(id)arg5 floatingDockDefaults:(id)arg6 appSuggestionManager:(id)arg7 analyticsClient:(id)arg8 applicationController:(id)arg9 {
    return %orig(maxRecents,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9);
}

-(unsigned long long)maxSuggestions {
    return maxRecents;
}
%end

%hook SBFloatingDockSuggestionsViewController
-(id)initWithNumberOfRecents:(unsigned long long)arg1 iconController:(id)arg2 applicationController:(id)arg3 layoutStateTransitionCoordinator:(id)arg4 suggestionsModel:(id)arg5 iconViewProvider:(id)arg6 {
    return %orig(maxRecents,arg2,arg3,arg4,arg5,arg6);
}
%end
%end

%ctor {
    loadPreferences(); // Load prefs
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPreferences, (CFStringRef)preferencesNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
    
    if (enabled) %init(FloatingDockXVI);
    if (enabled && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"16.0")) %init(Recents16);
    if (enabled && SYSTEM_VERSION_LESS_THAN(@"16.0")) %init(Recents15);
    %init;
}
