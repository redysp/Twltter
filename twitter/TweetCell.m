//
//  TweetCell.m
//  twitter
//
//  Created by powercarlos25 on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "TimelineViewController.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)didTapRetweet:(id)sender {
    
    if (self.tweet.retweeted){
        [self.retweet setSelected:NO];
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
    }
    else{
        [self.retweet setSelected:YES];
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
        
        NSString *retweetedCount = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
        self.retweetCount.text = retweetedCount;
    }
}

- (IBAction)didTapLike:(id)sender {
    // Update the local tweet model
    
    if (self.tweet.favorited){
        [self.like setSelected:NO];
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
    }
    else{
        [self.like setSelected:YES];
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
        NSString *likedCount = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
        self.likesCount.text = likedCount;
    }
}

@end
