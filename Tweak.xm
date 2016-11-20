static BOOL WatchNotifictionsHooked = NO;


@interface WNContainerView : UIView
@end

@interface CBRGradientView : UIView
@end

%group WatchNotifictions
%hook WNContainerView
- (void)layoutContentView {
  %orig;
  if ([self superview]) {
    for (UIView *view in [[self superview] subviews]) {
      if ([view isKindOfClass:NSClassFromString(@"CBRGradientView")]) {
        UIView *container = (UIView *)[self valueForKey:@"notificationContainerView"];
        container.backgroundColor = [view.backgroundColor colorWithAlphaComponent:view.alpha];
        CAGradientLayer *gradientLayer = nil;
        BOOL isNewGradientLayer = NO;
        for (CALayer *layerObject in container.layer.sublayers) {
          if ([layerObject isKindOfClass:[CAGradientLayer class]]) {
            gradientLayer = (CAGradientLayer *)layerObject;
            break;
          }
        }
        if (!gradientLayer) {
          gradientLayer = [CAGradientLayer new];
          isNewGradientLayer = YES;
        }
        gradientLayer.frame = CGRectMake(0,0,container.frame.size.width,container.frame.size.height);
        gradientLayer.colors = ((CAGradientLayer *)view.layer).colors;
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        if (isNewGradientLayer)
          [container.layer insertSublayer:gradientLayer atIndex:0];
      	view.hidden = YES;
      }
    }
  }
}
- (void)updateViews {
  %orig;
  if ([self superview]) {
    for (UIView *view in [[self superview] subviews]) {
      if ([view isKindOfClass:NSClassFromString(@"CBRGradientView")]) {
        UIView *container = (UIView *)[self valueForKey:@"notificationContainerView"];
        container.backgroundColor = [view.backgroundColor colorWithAlphaComponent:view.alpha];
        CAGradientLayer *gradientLayer = nil;
        BOOL isNewGradientLayer = NO;
        for (CALayer *layerObject in container.layer.sublayers) {
          if ([layerObject isKindOfClass:[CAGradientLayer class]]) {
            gradientLayer = (CAGradientLayer *)layerObject;
            break;
          }
        }
        if (!gradientLayer) {
          gradientLayer = [CAGradientLayer new];
          isNewGradientLayer = YES;
        }
        gradientLayer.frame = CGRectMake(0,0,container.frame.size.width,container.frame.size.height);
        gradientLayer.colors = ((CAGradientLayer *)view.layer).colors;
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        // gradientLayer.mask = container.layer.mask;

        if (isNewGradientLayer)
          [container.layer insertSublayer:gradientLayer atIndex:0];
      	view.hidden = YES;
      }
    }
  }
}
%end
%end


%hook SBLockScreenNotificationListView

// TODO(DavidGoldman): Try to improve this somehow. Not exactly sure which coloring part causes
// slowdowns (probably the gradient though).
// 
// Move this into -|tableView:cellForRowAtIndexPath:| to provide proper PrettierBanners support.
- (void)_setContentForTableCell:(id)cell
                       withItem:(id)item
                    atIndexPath:(id)path {
                      %orig;
                      if (!WatchNotifictionsHooked) {
      if (NSClassFromString(@"WNContainerView")) {
        %init(WatchNotifictions);
        WatchNotifictionsHooked = YES;
      }
    }
}
%end

%ctor {
	%init;
}