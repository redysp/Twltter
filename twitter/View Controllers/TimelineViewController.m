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

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIRefreshControl *refreshControl;



// Property for array of tweets
@property (strong, nonatomic) NSArray *tweets;

@end

@implementation TimelineViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Complete "handshake"
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    // Get timeline tweets
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            self.tweets = tweets;
            
            [self.tableView reloadData]; 
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
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


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // Get reusable table cell
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *specificTweet = self.tweets[indexPath.row];
    User *user = specificTweet.user;
    
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
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

// Refresh function

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    // Create NSURL and NSURLRequest
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // ... Use the new data to update the data source ...
        // Reload the tableView now that there is new data
        [self.tableView reloadData];
        // Tell the refreshControl to stop spinning
        [refreshControl endRefreshing];
     }];
    
    [task resume];
}

@end
