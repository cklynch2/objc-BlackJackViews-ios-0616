//
//  FISBlackjackGame.m
//  BlackJack
//
//  Created by Flatiron School on 6/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackGame.h"

@implementation FISBlackjackGame

-(instancetype)init {
    self = [super init];
    if (self) {
        _deck = [[FISCardDeck alloc] init];
        _player = [[FISBlackjackPlayer alloc] initWithName:@"Player"];
        _house = [[FISBlackjackPlayer alloc] initWithName:@"House"];
    }
    return self;
}


-(void)playBlackjack {
    [self.deck resetDeck];
    [self.player resetForNewGame];
    [self.house resetForNewGame];
    [self dealNewRound];
    
    // Blackjack allows hand limit of five cards. dealNewRound provides two cards, so loop has a maximum of three iterations.
    NSUInteger handLimit = 5;
    for (NSUInteger i = 0; i < (handLimit - self.player.cardsInHand.count); i++) {
        
        [self dealCardToPlayer];
        [self processPlayerTurn];
        if (self.player.busted)
            break;
        
        [self dealCardToHouse];
        [self processHouseTurn];
        if (self.house.busted)
            break;
    }
    [self incrementWinsAndLossesForHouseWins: [self houseWins]];
    NSLog(@"The status of the player's hand after game: %@", self.player.description);
    NSLog(@"The status of the house's hand after game: %@", self.house.description);
}

-(void)dealNewRound {
    [self dealCardToPlayer];
    [self dealCardToHouse];
    [self dealCardToPlayer];
    [self dealCardToHouse];
}

-(void)dealCardToPlayer {
    [self.player acceptCard:[self.deck drawNextCard]];
}

-(void)dealCardToHouse {
    [self.house acceptCard:[self.deck drawNextCard]];
}

-(void)processPlayerTurn {
    if (self.player.shouldHit && !self.player.busted && !self.player.stayed)
        [self dealCardToPlayer];
}

-(void)processHouseTurn {
    if (self.house.shouldHit && !self.house.busted && !self.house.stayed)
        [self dealCardToHouse];
}

-(BOOL)houseWins {
//    if ((self.house.blackjack && !self.player.blackjack) ||
//        (!self.house.busted && self.player.busted) ||
//        (!self.house.busted && self.player.stayed && self.house.handscore >= self.player.handscore) ||
//        (self.house.stayed && self.player.stayed && self.house.handscore >= self.player.handscore)) {
//        return YES;
//    }
//    return NO;
    if (!self.player.busted && (self.house.busted ||
                                self.player.blackjack ||
                                self.player.handscore > self.house.handscore)) {
        return NO;
    }
    return YES;
}

-(BOOL)playerWins {
    if (self.player.blackjack ||
        (!self.player.busted && self.house.busted) ||
        (!self.player.busted && self.house.stayed && self.player.handscore > self.house.handscore) ||
        (self.player.stayed && self.house.stayed && self.player.handscore > self.house.handscore)) {
        return YES;
    }
    return NO;
}

-(void)incrementWinsAndLossesForHouseWins:(BOOL)houseWins {
    if (houseWins) {
        self.player.losses += 1;
        self.house.wins += 1;
        NSLog(@"The house wins.");
    } else {
        self.player.wins += 1;
        self.house.losses += 1;
        NSLog(@"The player wins.");
    }
}

@end
