//
//  FISBlackjackViewController.h
//  objc-BlackJackViews
//
//  Created by Flatiron School on 6/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBlackjackGame.h"


@interface FISBlackjackViewController : UIViewController
@property (strong, nonatomic) FISBlackjackGame *game;
@property (strong, nonatomic) NSArray *houseCardLabels;
@property (strong, nonatomic) NSArray *playerCardLabels;
@property (nonatomic) NSUInteger hitButtonTaps;

@property (weak, nonatomic) IBOutlet UIButton *dealNewGame;
@property (weak, nonatomic) IBOutlet UIButton *playerHitButton;
@property (weak, nonatomic) IBOutlet UIButton *playerStayButton;

@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;

@property (weak, nonatomic) IBOutlet UILabel *houseName;
@property (weak, nonatomic) IBOutlet UILabel *houseScore;
@property (weak, nonatomic) IBOutlet UILabel *houseStayed;
@property (weak, nonatomic) IBOutlet UILabel *houseWins;
@property (weak, nonatomic) IBOutlet UILabel *houseLosses;
@property (weak, nonatomic) IBOutlet UILabel *houseBusted;
@property (weak, nonatomic) IBOutlet UILabel *houseBlackjack;
@property (weak, nonatomic) IBOutlet UILabel *houseCard1;
@property (weak, nonatomic) IBOutlet UILabel *houseCard2;
@property (weak, nonatomic) IBOutlet UILabel *houseCard3;
@property (weak, nonatomic) IBOutlet UILabel *houseCard4;
@property (weak, nonatomic) IBOutlet UILabel *houseCard5;

@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UILabel *playerScore;
@property (weak, nonatomic) IBOutlet UILabel *playerStayed;
@property (weak, nonatomic) IBOutlet UILabel *playerWins;
@property (weak, nonatomic) IBOutlet UILabel *playerLosses;
@property (weak, nonatomic) IBOutlet UILabel *playerBusted;
@property (weak, nonatomic) IBOutlet UILabel *playerBlackjack;
@property (weak, nonatomic) IBOutlet UILabel *playerCard1;
@property (weak, nonatomic) IBOutlet UILabel *playerCard2;
@property (weak, nonatomic) IBOutlet UILabel *playerCard3;
@property (weak, nonatomic) IBOutlet UILabel *playerCard4;
@property (weak, nonatomic) IBOutlet UILabel *playerCard5;

@end
