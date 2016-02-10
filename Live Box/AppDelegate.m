//
//  AppDelegate.m
//  Live Box
//
//  Created by Joshua Collishaw on 26/12/2015.
//  Copyright © 2015 Live Box Group. All rights reserved.
//

#import "AppDelegate.h"
#import "SSKeychain.h"
#import <AFNetworking/AFNetworking.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    NSString *activationcode = [SSKeychain passwordForService:@"LiveBoxAPI$$$" account:@"LiveBoxfortvOS"];
   //NSURL *URL = [[NSURL alloc] initWithString:@"http://api.liveboxtv.gq/activation/verify_activation.php"];
 /*   NSData *jsondata = [NSData dataWithContentsOfURL:URL];
    NSLog(@"json %@",jsondata);
    */
    NSString *url = [NSString stringWithFormat:@"http://api.liveboxtv.gq/activation/verify_activation.php?code=%@", activationcode];
    NSLog(@"This:%@",activationcode);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    NSLog(@"JSON:%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"JSON:%@",responseObject);
            NSString *result = [responseObject objectForKey:@"result"];
            if([result isEqualToString:@"true"]) {
                self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                NSLog(@"Authorized");
            }
            else {
                
                [SSKeychain deletePasswordForService:@"LiveBoxAPI$$$" account:@"LiveBoxfortvOS"];
                UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"login"];
                UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
                self.window.rootViewController = navigation;
                                NSLog(@"Force login");
                [navigation setNavigationBarHidden:YES animated:NO];
            }
       } else {
            UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"login"];
            UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
            self.window.rootViewController = navigation;
                            NSLog(@"Login by not needed");
            [navigation setNavigationBarHidden:YES animated:NO];
        } 
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"internet"];
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        self.window.rootViewController = navigation;
        
        [navigation setNavigationBarHidden:YES animated:NO];
    }];
    
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
