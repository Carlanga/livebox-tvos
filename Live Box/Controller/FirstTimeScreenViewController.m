//
//  FirstTimeScreenViewController.m
//  
//
//
//
#import "AppDelegate.h"
#import "SSKeychain.h"
#import <AFNetworking/AFNetworking.h>
#import "FirstTimeScreenViewController.h"

@interface FirstTimeScreenViewController ()

@end

@implementation FirstTimeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)activatebutton:(id)sender {
    
    


    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    if ([self.code.text isEqualToString:@""]) {
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter your Live Box for tvOS activation code" preferredStyle:UIAlertControllerStyleAlert];
        [errorAlert addAction:closeAction];
        [self presentViewController:errorAlert animated:YES completion:nil];
    } else {
        NSString *url = [NSString stringWithFormat:@"http://api.liveboxtv.gq/activation/new_activation.php?code=%@", self.code.text];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            BOOL valid = [[responseObject objectForKey:@"valid"] isEqualToString:@"1"];
            NSString *result = [responseObject objectForKey:@"result"];
            if (valid) {
                NSString *parsedsessionid = self.code.text;
                [SSKeychain setPassword:parsedsessionid forService:@"LiveBoxAPI$$$" account:@"LiveBoxfortvOS"];
                
                AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                appDelegateTemp.window.rootViewController = [self.storyboard instantiateInitialViewController];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:result preferredStyle:UIAlertControllerStyleAlert];
                [errorAlert addAction:closeAction];
                [self presentViewController:errorAlert animated:YES completion:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Network Error" preferredStyle:UIAlertControllerStyleAlert];
            [errorAlert addAction:closeAction];
            [self presentViewController:errorAlert animated:YES completion:nil];

        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
