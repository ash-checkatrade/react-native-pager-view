
#import "RNCPagerViewManager.h"

@implementation RNCPagerViewManager

#pragma mark - RTC

RCT_EXPORT_MODULE(RNCViewPager)

RCT_EXPORT_VIEW_PROPERTY(initialPage, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(pageMargin, NSInteger)

RCT_EXPORT_VIEW_PROPERTY(orientation, UIPageViewControllerNavigationOrientation)
RCT_EXPORT_VIEW_PROPERTY(onPageSelected, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPageScroll, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPageScrollStateChanged, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(overdrag, BOOL)
RCT_EXPORT_VIEW_PROPERTY(layoutDirection, NSString)


- (void) goToPage
                  : (nonnull NSNumber *)reactTag index
                  : (nonnull NSNumber *)index animated
                  : (BOOL)animated {
    [self.bridge.uiManager addUIBlock:^(
                                        RCTUIManager *uiManager,
                                        NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        RNCPagerView *view = (RNCPagerView *)viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[RNCPagerView class]]) {
            RCTLogError(@"Cannot find RNCPagerView with tag #%@", reactTag);
            return;
        }
        if (!animated || !view.animating) {
            [view goTo:index.integerValue animated:animated];
        }
    }];
}

- (void) changeScrollEnabled
: (nonnull NSNumber *)reactTag enabled
: (BOOL)enabled {
    [self.bridge.uiManager addUIBlock:^(
                                        RCTUIManager *uiManager,
                                        NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        RNCPagerView *view = (RNCPagerView *)viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[RNCPagerView class]]) {
            RCTLogError(@"Cannot find RNCPagerView with tag #%@", reactTag);
            return;
        }
        [view shouldScroll:enabled];
    }];
}

RCT_EXPORT_METHOD(setPage
                  : (nonnull NSNumber *)reactTag index
                  : (nonnull NSNumber *)index) {
    [self goToPage:reactTag index:index animated:true];
}

RCT_EXPORT_METHOD(setPageWithoutAnimation
                  : (nonnull NSNumber *)reactTag index
                  : (nonnull NSNumber *)index) {
    [self goToPage:reactTag index:index animated:false];
}

RCT_EXPORT_METHOD(setScrollEnabledImperatively
                  : (nonnull NSNumber *)reactTag enabled
                  : (nonnull NSNumber *)enabled) {
    BOOL isEnabled = [enabled boolValue];
    [self changeScrollEnabled:reactTag enabled:isEnabled];
}

RCT_CUSTOM_VIEW_PROPERTY(scrollEnabled, BOOL, RNCPagerView) {
    [view shouldScroll:[RCTConvert BOOL:json]];
}

RCT_CUSTOM_VIEW_PROPERTY(keyboardDismissMode, NSString, RNCPagerView) {
    [view shouldDismissKeyboard:[RCTConvert NSString:json]];
}


- (UIView *)view {
    return [[RNCPagerView alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

@end
