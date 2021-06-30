//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DateTools.h"
#import "NSDate+DateTools.h"
#import "TweetDetailsViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchTweets];
    
    //initialize and bind the action to the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];

    //insert the refresh control into the list
    self.refreshControl = [[UIRefreshControl alloc] init]; //initializing pull to refresh control
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchTweets {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            /*
             for (NSDictionary *dictionary in tweets) {
                NSString *text = dictionary[@"text"];
                NSLog(@"%@", text);
            }
             */
            for (Tweet *temp in tweets)
            {
                NSString *text = temp.text;
                NSLog(@"%@", text);
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didTweet:(Tweet *)tweet{
    if(!self.arrayOfTweets) {
        self.arrayOfTweets = [[NSMutableArray alloc] init];
    }
    [self.arrayOfTweets addObject:tweet];
    [self.tableView reloadData];
}
 
 

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];               //clear out access tokens
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //get cell and tweet
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    //MARK: setting everything inside the tweet cell
    //profile image
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.pfpView.image = nil;           //clear previous image if it takes too long to load
    [cell.pfpView setImageWithURL:url];
    
    //username
    cell.usernameLabel.text = tweet.user.name;
    
    //username handle
    cell.usernameHandleLabel.text = [@"@" stringByAppendingString: tweet.user.screenName];
    
    //timestamp/date published
    NSString *timestampString = tweet.createdAtString;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"E MMM d HH:mm:ss Z y"];
    NSDate *newTimestamp = [format dateFromString:timestampString];
    
    cell.timestampLabel.text = newTimestamp.shortTimeAgoSinceNow;

    //the actual tweet
    cell.tweetTextLabel.text = tweet.text;
    
    //retweets
    UIImage *retweeticon = [UIImage imageNamed:@"retweet-icon"];
//    if(tweet.retweeted) {
//        retweeticon = [UIImage imageNamed:@"retweet-icon-green"];
//    }
    [cell.retweetIconView setImage:retweeticon forState:UIControlStateNormal];
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    
    //favorite
    UIImage *favoriteicon = [UIImage imageNamed:@"favor-icon"];
//    if(tweet.favorited) {
//        favoriteicon = [UIImage imageNamed:@"favor-icon-red"];
//    }
    [cell.favoriteIconView setImage:favoriteicon forState:UIControlStateNormal];
    cell.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    cell.tweet = tweet;
    return cell;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender isKindOfClass:[UIBarButtonItem class]]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];

        TweetDetailsViewController *tweetViewController = [segue destinationViewController];
        tweetViewController.tweet = tweet;
        NSLog(@"Tapping on a tweet");
    }
    
}



@end
