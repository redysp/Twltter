//
//  ComposeViewController.m
//  twitter
//
//  Created by powercarlos25 on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)closeView:(id)sender;
- (IBAction)sendTweet:(id)sender;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendTweet:(id)sender {
    [[APIManager shared] postStatusWithText:self.textView.text completion:^(Tweet *composedTweet, NSError *error) {
        if (self.textView.text){
            [self dismissViewControllerAnimated:true completion:nil];
            [self.delegate didTweet:composedTweet];
            NSLog(@"Compose Tweet Success!");
        }
    }];
}
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
