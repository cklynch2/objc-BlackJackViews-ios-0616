//
//  FISCardDeck.m
//  OOP-Cards-Model
//
//  Created by Flatiron School on 6/15/16.
//  Copyright © 2016 Al Tyus. All rights reserved.
//

#import "FISCardDeck.h"

@implementation FISCardDeck

-(instancetype)init {
    self = [super init];
    if (self) {
        _remainingCards = [[NSMutableArray alloc] init];
        _dealtCards = [[NSMutableArray alloc] init];
    }
    [self generateFullDeck];
    return self;
}

-(void)generateFullDeck {
    for (NSString *suit in [FISCard validSuits]) {
        for (NSString *rank in [FISCard validRanks]) {
            FISCard *card = [[FISCard alloc] initWithSuit:suit rank:rank];
            [self.remainingCards addObject:card];
        }
    }
}

-(FISCard *)drawNextCard {
    if (self.remainingCards.count == 0) {
        NSLog(@"The deck is empty.");
        return nil;
    }
    FISCard *nextCard = self.remainingCards[0];
    [self.remainingCards removeObject:nextCard];
    [self.dealtCards addObject:nextCard];
    return nextCard;
}

-(void)resetDeck {
    [self gatherDealtCards];
    [self shuffleRemainingCards];
}

-(void)gatherDealtCards {
    [self.remainingCards addObjectsFromArray:self.dealtCards];
    [self.dealtCards removeAllObjects];
}

-(void)shuffleRemainingCards {
    for (NSUInteger i = 0; i < self.remainingCards.count; i++) {
        uint32_t cardsCount = (uint32_t)self.remainingCards.count;
        NSUInteger randomIndex = arc4random_uniform(cardsCount - 1);
        [self.remainingCards exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
    }
}

-(NSString *)description {
    NSMutableString *description = [[NSString stringWithFormat: @"count: %lu \ncards:", self.remainingCards.count] mutableCopy];
    for (FISCard *card in self.remainingCards) {
        [description appendFormat:@" %@", card.description];
    }
    return description;
}

@end
