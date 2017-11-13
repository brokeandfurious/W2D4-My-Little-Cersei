//
//  ViewController.m
//  MLC-Last
//
//  Created by Murat Ekrem Kolcalar on 11/12/17.
//  Copyright © 2017 murtilicious. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) BOOL isAsleep;

@property (nonatomic) float cerseiRestfulness;

@property (nonatomic, retain) NSDate *sleepStartDate;
@property (nonatomic, retain) NSDate *sleepEndDate;
@property (nonatomic) NSTimeInterval secondsSlept;

@property (weak, nonatomic) IBOutlet UILabel *topLogoLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *restfulnessLabel;

@property (weak, nonatomic) IBOutlet UIImageView *cerseiImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftBucketView;
@property (weak, nonatomic) IBOutlet UIImageView *rightBucketView;
@property (weak, nonatomic) IBOutlet UIImageView *coinView;
@property (nonatomic) UIImageView *coinImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gobletView;
@property (nonatomic) UIImageView *gobletImageView;

@property (weak, nonatomic) IBOutlet UIProgressView *restfulnessBarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAsleep = NO;
    self.messageLabel.alpha = 0;
    self.cerseiRestfulness = 0;
    self.restfulnessBarView.progress = 0.0;
    self.secondsSlept = 0;
}

- (IBAction)cerseiPetted:(UIPanGestureRecognizer*)sender {
    CGPoint velocity = [sender velocityInView:(self.view)];
    int velocityX = (int)round(velocity.x);
    int velocityY = (int)round(velocity.y);
    if (velocityY > [self cerseiStopsSleeping:[self cerseiStartsSleeping]])
    {
        NSLog(@"Pan velocity is higher than Cersei's resting points");
        if (self.isAsleep) {
            [self cerseiStopsSleeping:[self cerseiStartsSleeping]];
        }
        [self cerseiFaceImageNamed:@"cerseigrumpy"];
        [self cerseiMessage:@"I AM THE QUEEN! Have you lost your mind?!"];
    } else if (velocityY < 15) {
        if (self.isAsleep) {
            [self cerseiStopsSleeping:[self cerseiStartsSleeping]];
        }
        [self cerseiFaceImageNamed:@"cerseihappy"];
        [self cerseiMessage:@"That little worm between your legs does half your thinking."];
    }
}

- (IBAction)coinLongPressed:(UILongPressGestureRecognizer*)sender {
    NSLog(@"Initial log.");
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self newCoin];
        NSLog(@"Longpress began.");
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Longpress ended.");
    }
}

- (IBAction)gobletLongPressed:(UILongPressGestureRecognizer*)sender {
    NSLog(@"Initial log.");
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self newGoblet];
        NSLog(@"Longpress began.");
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Longpress ended.");
    }
}


- (void)cerseiFaceImageNamed:(NSString* )name {
    [UIView transitionWithView:self.cerseiImageView
                      duration:1.0f                 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.cerseiImageView.image = [UIImage imageNamed:name];
                    } completion:nil];
    
    [self performSelector:@selector(cerseiMessageFadeOut)
               withObject:self
               afterDelay:(1)];
    
}

- (void) cerseiMessageFadeOut {
    [UIView transitionWithView:self.messageLabel
                      duration:3.0f                 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.messageLabel.alpha = 0;
                    } completion:nil];
}

- (void)cerseiMessage:(NSString*)message {
    self.messageLabel.text = message;
    [UIView transitionWithView:self.messageLabel
                      duration:1.0f                 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.messageLabel.alpha = 1;
                    } completion:nil];
}

// NEW COINS AND GOBLETS

- (void) newCoin {
    NSLog(@"New Coin was created");
    self.coinImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coin"]];
    self.coinImageView.frame = CGRectMake(0, 0, 75, 75);
    self.coinImageView.center = self.coinView.center;
    [self.view addSubview:self.coinImageView];
    self.coinImageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *moveCoin = [UIPanGestureRecognizer new];
    [self.coinImageView addGestureRecognizer:moveCoin];
    [moveCoin addTarget:self action:@selector(dropCoin:)];
}

- (void) dropCoin: (UIPanGestureRecognizer*)sender {
    self.coinImageView.center = [sender locationInView:self.view];
    if (sender.state == UIGestureRecognizerStateEnded) {
        //IF DROPPED INSIDE FRAME
        if (CGRectContainsPoint(self.cerseiImageView.frame, self.coinImageView.center)) {
            [self.coinImageView removeFromSuperview];
            [self cerseiFaceImageNamed:@"cerseihappy"];
            [self cerseiMessage:@"Lannisters always pay their debts."];
            if (self.isAsleep) {
                [self cerseiStopsSleeping:[self cerseiStartsSleeping]];
            }
        } else {
            [UIView animateWithDuration:2.0 animations:^{
                self.coinImageView.center = CGPointMake(self.coinImageView.center.x, 1000);
                [self cerseiFaceImageNamed:@"cerseigrumpy"];
                [self cerseiMessage:@"Every breath you draw in my presence annoys me."];
                if (self.isAsleep) {
                    [self cerseiStopsSleeping:[self cerseiStartsSleeping]];
                }
            }];
        }
    }
}

- (void) newGoblet {
    NSLog(@"New goblet was created");
    self.gobletImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gotgoblet"]];
    self.gobletImageView.frame = CGRectMake(0, 0, 50, 75);
    self.gobletImageView.center = self.gobletView.center;
    [self.view addSubview:self.gobletImageView];
    self.gobletImageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *moveGoblet = [UIPanGestureRecognizer new];
    [self.gobletImageView addGestureRecognizer:moveGoblet];
    [moveGoblet addTarget:self action:@selector(dropGoblet:)];
}

- (void) dropGoblet: (UIPanGestureRecognizer*)sender {
    self.gobletImageView.center = [sender locationInView:self.view];
    if (sender.state == UIGestureRecognizerStateEnded) {
        //IF DROPPED INSIDE FRAME
        if (CGRectContainsPoint(self.cerseiImageView.frame, self.gobletImageView.center)) {
            [self.gobletImageView removeFromSuperview];
            [self cerseiFaceImageNamed:@"cerseihappy"];
            [self cerseiMessage:@"An unhappy wife is a wine merchant's best friend."];
            if (self.isAsleep) {
                [self cerseiStopsSleeping:[self cerseiStartsSleeping]];
            } else {
                [self cerseiStartsSleeping];
            }
        } else {
            [UIView animateWithDuration:2.0 animations:^{
                self.gobletImageView.center = CGPointMake(self.gobletImageView.center.x, 1000);
                [self cerseiFaceImageNamed:@"cerseigrumpy"];
                [self cerseiMessage:@"I'll have you strangled in your sleep."];
                if (self.isAsleep) {
                    [self cerseiStopsSleeping:[self cerseiStartsSleeping]];
//                    NSLog(@"TEST %f", [self cerseiStopsSleeping:[self cerseiStartsSleeping]]);
                }
            }];
        }
    }
}

- (NSDate*) cerseiStartsSleeping {
    self.isAsleep = YES;
    self.sleepStartDate = [NSDate date];
    NSLog(@"Started to sleep: %@", self.sleepStartDate);
    self.cerseiRestfulness+=0.1;
    _restfulnessBarView.progress+=0.1;
    return _sleepStartDate;
}

- (float) cerseiStopsSleeping:(NSDate*)placeholderDate {
    self.isAsleep = NO;
    self.sleepEndDate = [NSDate date];
    NSTimeInterval secondsSlept = [_sleepEndDate timeIntervalSinceDate:placeholderDate];
    NSLog(@"The amount slept: %f", secondsSlept);
    self.cerseiRestfulness += secondsSlept;
    NSLog(@"Restfulness: %f", self.cerseiRestfulness);
    _restfulnessBarView.progress = self.cerseiRestfulness;
    float secondValue = secondsSlept * 40000;
    if (self.cerseiRestfulness == 0) {
        self.isAsleep = YES;
    }
    return secondValue;
}

@end
