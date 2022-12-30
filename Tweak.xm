#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

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

HBPreferences *preferences;
BOOL enabled, hideDockBG, disableFloatingDockInApps, removeSeparator;
NSInteger dockStyle, maxRecents, maxDockIcons;

%group FloatingDockXVI
%hook SBFloatingDockController
+ (BOOL)isFloatingDockSupported {
    return YES;
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

%hook SBFloatingDockSuggestionsModel
// iOS 16 method to restrict max recents in dock
- (id)initWithMaximumNumberOfSuggestions:(NSUInteger)arg1 iconController:(id)arg2 recentsController:(id)arg3 recentsDataStore:(id)arg4 recentsDefaults:(id)arg5 floatingDockDefaults:(id)arg6 appSuggestionManager:(id)arg7 applicationController:(id)arg8 {
    return %orig(maxRecents,arg2,arg3,arg4,arg5,arg6,arg7,arg8);
}
// iOS 15 method to restrict max recents in dock
-(id)initWithMaximumNumberOfSuggestions:(unsigned long long)arg1 iconController:(id)arg2 recentsController:(id)arg3 recentsDataStore:(id)arg4 recentsDefaults:(id)arg5 floatingDockDefaults:(id)arg6 appSuggestionManager:(id)arg7 analyticsClient:(id)arg8 applicationController:(id)arg9 {
    return %orig(maxRecents,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9);
}
%end

%hook SBFluidSwitcherViewController
- (BOOL)isFloatingDockGesturePossible {
    return !disableFloatingDockInApps;
}
%end
%end

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.nahtedetihw.floatingdockxviprefs"];
    [preferences registerBool:&enabled default:NO forKey:@"enabled"];
    [preferences registerBool:&hideDockBG default:NO forKey:@"hideDockBG"];
    [preferences registerBool:&removeSeparator default:NO forKey:@"removeSeparator"];
    [preferences registerInteger:&dockStyle default:0 forKey:@"dockStyle"];
    [preferences registerBool:&disableFloatingDockInApps default:NO forKey:@"disableFloatingDockInApps"];
    [preferences registerInteger:&maxRecents default:3 forKey:@"maxRecents"];
    [preferences registerInteger:&maxDockIcons default:4 forKey:@"maxDockIcons"];
    
    if (enabled) %init(FloatingDockXVI);
    %init;
}
