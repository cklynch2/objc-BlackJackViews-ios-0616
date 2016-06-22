//
//  FISBlackjackPlayer.m
//  BlackJack
//
//  Created by Flatiron School on 6/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackPlayer.h"

@implementation FISBlackjackPlayer

-(instancetype) init {
    return [self initWithName:@""];
}

-(instancetype) initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        _cardsInHand = [[NSMutableArray alloc] init];
        _aceInHand = NO;
        _blackjack = NO;
        _busted = NO;
        _stayed = NO;
        _handscore = 0;
        _wins = 0;
        _losses = 0;
    }
    return self;
}

-(void)resetForNewGame {
    [self.cardsInHand removeAllObjects];
    self.handscore = 0;
    self.aceInHand = NO;
    self.stayed = NO;
    self.blackjack = NO;
    self.busted = NO;
}

-(void)acceptCard:(FISCard *)card {
    // Add argument card to the hand.
    [self.cardsInHand addObject:card];

    // Calculate the new handscore by adding cardValue of the argument card.
    self.handscore += card.cardValue;
    
    // Count aces in the hand.
    NSUInteger aceCount = 0;
    for (FISCard *card in self.cardsInHand) {
    if ([card.rank isEqual: @"A"])
            aceCount += 1;
    }
    
    // If there are aces in the hand and the score is less than or equal to eleven, treat the ace as a soft eleven by adding ten to the handscore.
    if (aceCount > 0) {
        self.aceInHand = YES;
        if (self.handscore < 12)
            self.handscore += 10;
    }
    
    // Determine whether the hand is a blackjack (two cards totaling 21).
    if (self.handscore == 21 && self.cardsInHand.count == 2)
        self.blackjack = YES;
    
    // Determine whether the hand is busted (handscore greater than 21).
    if (self.handscore > 21)
        self.busted = YES;
}

-(BOOL)shouldHit {
    if (self.handscore > 16) {
        self.stayed = YES;
        return NO;
    }
    return YES;
}

-(NSString *)description {
    NSMutableString *cardsInHand = [[NSMutableString alloc] init];
    for (FISCard *card in self.cardsInHand) {
        [cardsInHand appendFormat:@"%@ ", card.cardLabel];
    }
    return [NSString stringWithFormat:@"name: %@\ncards: %@\nhandscore: %lu\nace in hand: %d\nstayed: %d\nblackjack: %d\nbusted: %d\nwins: %lu\nlosses: %lu", self.name, cardsInHand, self.handscore, self.aceInHand, self.stayed, self.blackjack, self.busted, self.wins, self.losses];
}

@end
