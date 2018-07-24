@import Foundation;
@import ObjectiveC.runtime;
@import UIKit;

// Used for swizzling on iOS 11+. UIDebuggingInformationOverlay is a subclass of UIWindow
@implementation UIWindow (DocsUIDebuggingInformationOverlaySwizzler)

- (instancetype)swizzle_basicInit {
	return [super init];
}

// [[UIDebuggingInformationOverlayInvokeGestureHandler mainHandler] _handleActivationGesture:(UIGestureRecognizer *)]
// requires a UIGestureRecognizer, as it checks the state of it. We just fake that here.
- (UIGestureRecognizerState)state {
	return UIGestureRecognizerStateEnded;
}

@end

@interface DebuggingOverlay : NSObject

@end

@implementation DebuggingOverlay

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
+ (void)toggleOverlay {
	id infoOverlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");

	// In iOS 11, Apple added additional checks to disable this overlay unless the
	// device is an internal device. To get around this, we swizzle out the
	// -[UIDebuggingInformationOverlay init] method (which returns nil now if
	// the device is non-internal), and we call:
	// [[UIDebuggingInformationOverlayInvokeGestureHandler mainHandler] _handleActivationGesture:(UIGestureRecognizer *)]
	// to show the window, since that now adds the debugging view controllers, and calls
	// [overlay toggleVisibility] for us.
	if (@available(iOS 11.0, *)) {

		id handlerClass = NSClassFromString(@"UIDebuggingInformationOverlayInvokeGestureHandler");
		
		UIWindow *window = [[UIWindow alloc] init];
		
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			// Swizzle init of debugInfo class
			Method originalInit = class_getInstanceMethod(infoOverlayClass, @selector(init));
			IMP swizzledInit = [window methodForSelector:@selector(swizzle_basicInit)];
			method_setImplementation(originalInit, swizzledInit);
		});
		
		id debugOverlayInstance = [infoOverlayClass performSelector:NSSelectorFromString(@"overlay")];
		[debugOverlayInstance setFrame:[[UIScreen mainScreen] bounds]];
		
		id handler = [handlerClass performSelector:NSSelectorFromString(@"mainHandler")];
		[handler performSelector:NSSelectorFromString(@"_handleActivationGesture:") withObject:window];

  } else if (@available(iOS 9.0, *)) {

    [infoOverlayClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
    id overlay = [infoOverlayClass performSelector:NSSelectorFromString(@"overlay")];
    [overlay performSelector:NSSelectorFromString(@"toggleVisibility")];

  } else {
    NSLog(@"UIDebuggingInformationOverlay not support in OS under 9.0");
  }

}
#pragma clang diagnostic pop

@end

