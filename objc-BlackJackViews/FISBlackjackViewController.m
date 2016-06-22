//
//  FISBlackjackViewController.m
//  objc-BlackJackViews
//
//  Created by Flatiron School on 6/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackViewController.h"

@interface FISBlackjackViewController ()

@end

@implementation FISBlackjackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self newGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)newGame {
    self.game = [[FISBlackjackGame alloc] init];
    
    self.hitButtonTaps = 0;
    
    self.winnerLabel.hidden = YES;
    
    self.houseCardLabels = @[self.houseCard1, self.houseCard2, self.houseCard3, self.houseCard4, self.houseCard5];
    for (UILabel *cardLabel in self.houseCardLabels) {
        cardLabel.hidden = YES;
    }
    self.houseBusted.hidden = YES;
    self.houseStayed.hidden = YES;
    self.houseBlackjack.hidden = YES;
    self.houseScore.hidden = YES;
    
    self.playerCardLabels = @[self.playerCard1, self.playerCard2, self.playerCard3, self.playerCard4, self.playerCard5];
    for (UILabel *cardLabel in self.playerCardLabels) {
        cardLabel.hidden = YES;
    }
    self.playerBusted.hidden = YES;
    self.playerStayed.hidden = YES;
    self.playerBlackjack.hidden = YES;
    self.playerScore.text = @"Score: 0";
}

-(void)displayCardInHandAtIndex:(NSUInteger)index UsingLabels:(NSArray *)labelsArray ForPlayer:(FISBlackjackPlayer *)player {
    FISCard *card = player.cardsInHand[index];
    UILabel *cardLabel = labelsArray[index];
    cardLabel.hidden = NO;
    cardLabel.text = card.cardLabel;
}

-(void)updateScoreForLabel:(UILabel *)scoreLabel ForPlayer:(FISBlackjackPlayer *)player {
    scoreLabel.hidden = NO;
    scoreLabel.text = [NSString stringWithFormat:@"Score: %lu", player.handscore];
}

-(void)updateBustedLabel:(UILabel *)bustedLabel ForPlayer:(FISBlackjackPlayer *)player {
    if (player.busted)
        bustedLabel.hidden = NO;
}

-(void)updateBlackjackLabel:(UILabel *)blackjackLabel ForPlayer:(FISBlackjackPlayer *)player {
    if (player.blackjack)
        blackjackLabel.hidden = NO;
}

-(void)updateStayedLabel:(UILabel *)stayedLabel ForPlayer:(FISBlackjackPlayer *)player {
    if (player.stayed)
        stayedLabel.hidden = NO;
}

-(void)housePlaysTurn {
    NSUInteger houseCardCountBeforeTurn = self.game.house.cardsInHand.count;
    [self.game processHouseTurn];
    NSUInteger houseCardCountAfterTurn = self.game.house.cardsInHand.count;
    if (houseCardCountBeforeTurn < houseCardCountAfterTurn) {
        [self displayCardInHandAtIndex:(houseCardCountAfterTurn - 1) UsingLabels:self.houseCardLabels ForPlayer:self.game.house];
        [self updateBustedLabel:self.houseBusted ForPlayer:self.game.house];
    } else if (houseCardCountBeforeTurn == houseCardCountAfterTurn) {
        self.game.house.stayed = YES;
        [self updateStayedLabel:self.houseStayed ForPlayer:self.game.house];
    }
    [self updateScoreForLabel:self.houseScore ForPlayer:self.game.house];
}

-(void)updateWinnerLabel {
    self.winnerLabel.hidden = NO;
    if (self.game.houseWins) {
        self.winnerLabel.text = @"You lost!";
    } else if (self.game.playerWins)
        self.winnerLabel.text = @"You win!";
}

-(BOOL)checkForWinner {
    if (self.game.houseWins || self.game.playerWins) {
        return YES;
    }
    return NO;
}

-(void)gameOver {
    [self updateWinnerLabel];
    self.playerHitButton.enabled = NO;
    self.playerStayButton.enabled = NO;
    self.dealNewGame.enabled = YES;
}

// Blackjack can only be acheived on the first deal, because you must only have two cards in your hand. Therefore this is the only method where the blackjack labels need to be updated.
- (IBAction)dealButtonTapped:(id)sender {
    if ([self checkForWinner]) {
        [self newGame];
    }
    
    [self.game.deck shuffleRemainingCards];
    [self.game dealNewRound];
    
    // Update card labels to reflect the two cards that have been dealt each to house and player.
    [self displayCardInHandAtIndex:0 UsingLabels:self.houseCardLabels ForPlayer:self.game.house];
    [self displayCardInHandAtIndex:1 UsingLabels:self.houseCardLabels ForPlayer:self.game.house];
    
    [self displayCardInHandAtIndex:0 UsingLabels:self.playerCardLabels ForPlayer:self.game.player];
    [self displayCardInHandAtIndex:1 UsingLabels:self.playerCardLabels ForPlayer:self.game.player];
    
    // Update score label for player. House score should stay hidden until someone wins.
    [self updateScoreForLabel:self.playerScore ForPlayer:self.game.player];
    
    // Update blackjack labels for house and player.
    [self updateBlackjackLabel:self.playerBlackjack ForPlayer:self.game.player];
    [self updateBlackjackLabel:self.houseBlackjack ForPlayer:self.game.house];
    
    // If there is no winner after the first deal, enable the stay and hit buttons for the player and disable the deal button. If there is a winner, call gameOver in order to update the houseScore label and the winner label.
    if (!self.game.player.blackjack && !self.game.house.blackjack) {
        self.playerHitButton.enabled = YES;
        self.playerStayButton.enabled = YES;
        self.dealNewGame.enabled = NO;
    } else
        [self updateWinnerLabel];

}

- (IBAction)hitButtonTapped:(id)sender {
    // Player hand can have a maximum of five cards. Keep track of the button taps in a variable hitButtonTaps which is initialized to zero in ViewDidLoad. Use the number of taps to access the correct card in the cardsInHand array and display corresponding label from playerCardLabels array. (The index of the correct card is one ahead of hitButtonTaps because you deal two cards to each player initially.)
    [self updateScoreForLabel:self.houseScore ForPlayer:self.game.house];
    
    self.hitButtonTaps += 1;
    [self.game dealCardToPlayer];
    [self displayCardInHandAtIndex:(self.hitButtonTaps + 1) UsingLabels:self.playerCardLabels ForPlayer:self.game.player];
    [self updateBustedLabel:self.playerBusted ForPlayer:self.game.player];
    [self updateScoreForLabel:self.playerScore ForPlayer:self.game.player];
}

// Player finishes his hand before the house plays. The player can finish in three ways: blackjack on first deal, keep hitting until bust, or stay. Then the house plays its turn. Therefore the house play should be initiated when stay button is tapped by player.
- (IBAction)stayButtonTapped:(id)sender {
    self.game.player.stayed = YES;
    [self updateStayedLabel:self.playerStayed ForPlayer:self.game.player];
    self.playerHitButton.enabled = NO;

    while (self.game.house.cardsInHand.count <= 5 && !self.game.house.busted && !self.game.house.stayed && !self.game.house.blackjack) {
        [self housePlaysTurn];
    }
    
    if ([self checkForWinner]) {
        [self gameOver];
    }
}


@end
