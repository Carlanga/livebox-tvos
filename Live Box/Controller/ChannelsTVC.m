//
//  ChannelsTVC.m
//  Live Box
//
//  Created by Joshua Collishaw on 08/01/2016.
//  Copyright © 2016 Live Box Group. All rights reserved.
//

#import "ChannelsTVC.h"
#import "ChannelsTableCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SSKeychain/SSKeychain.h>


@import AVKit;
@import AVFoundation;

@interface ChannelsTVC ()
@property (nonatomic, strong, readwrite) NSArray *applicationsArray;
@end

@implementation ChannelsTVC

- (void)viewWillAppear:(BOOL)animated {
    
    //    [[UINavigationBar appearance] setTintColor:[UIColor blueColor]];
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [super viewWillAppear:animated];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                
                // -- Reachable -- //
                
                
                
                break;
                
            }
            case AFNetworkReachabilityStatusNotReachable:
            default:
                // -- Not reachable -- //
                
                
                
                break;
        }
        
        
        
    }];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     NSString *code = [SSKeychain passwordForService:@"LiveBoxAPI$$$" account:@"LiveBoxfortvOS"];
     NSString *url=[NSString stringWithFormat:@"http://api.liveboxtv.gq/activation/json.php?code=%@", code];
NSURL *URL = [NSURL URLWithString:url];
/*    NSData *jsondata = [NSData dataWithContentsOfURL:URL];
    //NSLog(@"json %@",jsondata);
    NSArray *channels = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:nil];
    //NSLog(@"channel s %@",channels);
 */

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        self.applicationsArray = (NSArray *)responseObject;
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];

       // NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
     //   NSLog(@"Error: %@", error);
    }];

    
    [self.tableView reloadData];
    
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // JSON downloads
    // This bit loads the json file from my server, but
    
    
    
   // NSURL *URL = [[NSURL alloc] initWithString:@"http://api.liveboxtv.gq/free.json"];
   /// NSData *jsondata = [NSData dataWithContentsOfURL:URL];
   // NSLog(@"json %@",jsondata);
   // NSArray *channels = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:nil];
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
    //
    //                                                            self.applicationsArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
    //
    //        self.applicationsArray = (NSArray *)responseObject;
    //
    //        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];
    //
    //        [self.tableView reloadData];
    //        NSLog(@"JSON: %@", responseObject);
    //    } failure:^(NSURLSessionTask *operation, NSError *error) {
    //        NSLog(@"Error: %@", error);
    //    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.applicationsArray.count;
}
// Sets cell content v
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelsTableCell *cell = (ChannelsTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"appCell" forIndexPath:indexPath];
    cell.name.text = self.applicationsArray[(unsigned int)indexPath.row][@"name"];
    return cell;
}


-(IBAction)donate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=D9X7Y6LJZPZR8"]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    // Loads stream
    NSURL *url = [NSURL URLWithString: self.applicationsArray[(unsigned int)indexPath.row][@"streamurl"]];
    NSString *webcheck = self.applicationsArray[(unsigned int)indexPath.row][@"webcheck"];
    if([webcheck  isEqual: @"true"]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        
        
        AVPlayer *player = [AVPlayer playerWithURL:url];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
        player.play;
        Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.00f;
    
}


@end
