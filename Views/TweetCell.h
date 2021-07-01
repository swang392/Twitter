//
//  TweetCell.h
//  twitter
//
//  Created by Sarah Wang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
//@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
//@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteIconView;
@property (weak, nonatomic) IBOutlet UIButton *retweetIconView;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (nonatomic, strong) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
