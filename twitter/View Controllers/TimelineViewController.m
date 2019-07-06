//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

// Step #1: subview of view Controller (can be viewed at storyboard also)

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (IBAction)logOut:(id)sender;

// Property for array of tweets
@property (strong, nonatomic) NSArray *tweets;

@end

@implementation TimelineViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Step #3: set dataSource and delegate in viewDidLoad
    
    // Complete "handshake"
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self loadTimeline];
    
    // Initialize a UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTimeline)forControlEvents:UIControlEventValueChanged];
    
    // Add to tableView
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)loadTimeline {
    
    // Step #5 API manager calls completion
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            // Step 6
            self.tweets = tweets;
            
            // Step 7
            [self.tableView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
}

// Step #9
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // Get reusable table cell
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *specificTweet = self.tweets[indexPath.row];
    User *user = specificTweet.user;
    
    cell.tweet = specificTweet;
    // Gets name and handle from Tweet -> User class
    cell.name.text = user.name;
    cell.handle.text = [@"@" stringByAppendingString:user.screenName];
    
    // Gets the rest of the information from Tweet class
    cell.date.text = specificTweet.createdAtString;
    cell.tweetText.text = specificTweet.text;
    
    cell.retweetCount.text = [NSString stringWithFormat:@
                         "%d", specificTweet.retweetCount];
    cell.likesCount.text = [NSString stringWithFormat:@
                      "%d", specificTweet.favoriteCount];
    
    NSURL *imageURL = [NSURL URLWithString:user.image];
    [cell.image setImageWithURL:imageURL];
    
    return cell;
}

// Step 10
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)didTweet:(Tweet *)tweet{
    
    // Create Mutable Array
    NSMutableArray *updatedTweets = [[NSMutableArray alloc]init];
    updatedTweets = [NSMutableArray arrayWithArray:self.tweets];

    // Add tweet to it
    [updatedTweets addObject:tweet];
    
    // Make array back
    self.tweets = updatedTweets;
    NSLog(@"%@", self.tweets);
    
    [self.tableView reloadData];
}

- (IBAction)logOut:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

@end

