//
//  TweetCell.m
//  twitter
//
//  Created by Sarah Wang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "DateTools.h"
#import "NSDate+DateTools.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited)
    {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
         [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  //TODO: show error
             }
         }];
    }
    else
    {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
         [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                 //TODO: show error
             }
         }];
    }
    [self refreshData];
}

- (IBAction)didTapRetweet:(id)sender {
    NSLog(@"tapped retweet");
    if(self.tweet.retweeted)
    {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
         [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  //TODO: show error
             }
         }];
    }
    else
    {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
         [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                 //TODO: show error
             }
         }];
    }
    [self refreshData];
}

- (void)refreshData {
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.pfpView.image = nil;
    [self.pfpView setImageWithURL:url];
    
    self.usernameLabel.text = self.tweet.user.name;
    
    self.usernameHandleLabel.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    
    NSString *timestampString = self.tweet.createdAtString; 
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"E MMM d HH:mm:ss Z y"];
    NSDate *newTimestamp = [format dateFromString:timestampString];
    
    self.timestampLabel.text = newTimestamp.shortTimeAgoSinceNow;

    self.tweetTextLabel.text = self.tweet.text;
    
    UIImage *retweeticon = [UIImage imageNamed:@"retweet-icon"];
    if (self.tweet.retweeted) {
        retweeticon = [UIImage imageNamed:@"retweet-icon-green"];
    }
    [self.retweetIconView setImage:retweeticon forState:UIControlStateNormal];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    UIImage *favoriteicon = [UIImage imageNamed:@"favor-icon"];
    if (self.tweet.favorited) {
        favoriteicon = [UIImage imageNamed:@"favor-icon-red"];
    }
    [self.favoriteIconView setImage:favoriteicon forState:UIControlStateNormal];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
}
@end
