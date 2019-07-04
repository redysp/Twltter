//
//  ComposeViewController.h
//  twitter
//
//  Created by powercarlos25 on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TimelineViewController.h"

NS_ASSUME_NONNULL_BEGIN



@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end



@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
