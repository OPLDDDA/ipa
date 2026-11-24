#import <UIKit/UIKit.h>

%hook SBAppIconLabelView

- (void)setHidden:(BOOL)hidden {
    %orig(YES);
}

%end

%hook SBDockView

- (void)layoutSubviews {
    %orig;
    self.layer.cornerRadius = 24.0;
    self.layer.masksToBounds = YES;
}

%end

%hook SBFolderView

- (void)setBackgroundView:(UIView *)backgroundView {
    %orig;
    backgroundView.alpha = 0.88;
}

%end

%ctor {
    NSLog(@"[WallpaperStudioTweaks] loaded");
}
