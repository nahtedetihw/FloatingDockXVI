#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

@interface SBFloatingDockPlatterView : UIView
@property (nonatomic) UIView *backgroundView;
@end

HBPreferences *preferences;
BOOL enabled;
BOOL hideDockBG;
NSInteger dockStyle;

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
%end

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.nahtedetihw.floatingdockxviprefs"];
    [preferences registerBool:&enabled default:NO forKey:@"enabled"];
    [preferences registerBool:&hideDockBG default:NO forKey:@"hideDockBG"];
    [preferences registerInteger:&dockStyle default:0 forKey:@"dockStyle"];
    
    if (enabled) %init(FloatingDockXVI);
    %init;
}
