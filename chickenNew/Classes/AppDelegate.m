//
//  AppDelegate.m
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 11/14/15
//
//  Copyright (c) 2015 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "AppDelegate.h"
#import "HelloWorldScene.h"

// -----------------------------------------------------------------------

@implementation AppDelegate
//@synthesize networkStatus;
//@synthesize hostReach;
//@synthesize viewController;
//@synthesize recordsScene;

// -----------------------------------------------------------------------
// This is where your app starts. It takes two steps
// 1) Setting up Cocos2D, which is done with setupCocos2dWithOptions
// 2) Call your first scene, which is done by overriding startScene

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Cocos2D takes a dictionary to start ... yeah I know ... but it does, and it is kind of neat
    NSMutableDictionary *startUpOptions = [NSMutableDictionary dictionary];
    
    // Let's add some setup stuff   
    
    // File extensions
    // You can use anything you want, and completely dropping extensions will in most cases automatically scale the artwork correct
    // To make it easy to understand what resolutions I am using, I have changed this for this demo to -4x -2x and -1x
    // Notice that I deliberately added some of the artwork without extensions
    [CCFileUtils sharedFileUtils].suffixesDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                  @"-2x", CCFileUtilsSuffixiPad,
                                                  @"-4x", CCFileUtilsSuffixiPadHD,
                                                  @"-1x", CCFileUtilsSuffixiPhone,
                                                  @"-1x", CCFileUtilsSuffixiPhoneHD,
                                                  @"-1x", CCFileUtilsSuffixiPhone5,
                                                  @"-2x", CCFileUtilsSuffixiPhone5HD,
                                                  @"", CCFileUtilsSuffixDefault,
                                                  nil];

    // Show FPS
    // We really want this when developing an app
    [startUpOptions setObject:@(YES) forKey:CCSetupShowDebugStats];
    
    // A acouple of other examples
    
    // Use a 16 bit color buffer
    // This will lower the color depth from 32 bits to 16 bits for that extra performance
    // Most will want 32, so we disbaled it
    // ---
    // [startUpOptions setObject:kEAGLColorFormatRGB565 forKey:CCSetupPixelFormat];
    
    // Use a simplified coordinate system that is shared across devices
    // Normally you work in the coordinate of the device (an iPad is 1024x768, an iPhone 4 480x320 and so on)
    // This feature makes it easier to use the same setup for all devices (easier is a relative term)
    // Most will want to handle iPad and iPhone exclusively, so it is disabled by default
    // ---
    // [startUpOptions setObject:CCScreenModeFixed forKey:CCSetupScreenMode];
    
    // All the supported keys can be found in CCConfiguration.h

    // We are done ...
    // Lets get this thing on the road!
    [self setupCocos2dWithOptions:startUpOptions];
	
    //Добавленый кусок кода--------------------------------
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];
//    
//    self.hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
//    [hostReach startNotifier];
//    [self updateInterfaceWithReachability: hostReach];
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    self.viewController = [[UIViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//    self.window.rootViewController = self.recordsScene;
 //   [self.window makeKeyAndVisible];
    //------------------------------------------------------
    
    
    // Stay positive. Always return a YES :)
	return YES;
}



//Добавленные методы------------
//- (void) updateInterfaceWithReachability: (Reachability*) curReach {
//    self.networkStatus = [curReach currentReachabilityStatus];
//}
//- (void) reachabilityChanged: (NSNotification* )note {
//    Reachability* curReach = [note object];
//    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
//    [self updateInterfaceWithReachability: curReach];
//}
//------------------------------



// -----------------------------------------------------------------------
// This method should return the very first scene to be run when your app starts.

- (CCScene *)startScene
{
	return [HelloWorldScene new];
}

// -----------------------------------------------------------------------

@end























