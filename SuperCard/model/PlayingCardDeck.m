//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Richard E Millet on 3/25/13.
//  Copyright (c) 2013 Richard Millet. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (id)init {
	self = [super init];
	if (self != nil) {
		for (NSString *suit in [PlayingCard getSuitSymbolList]) {
			for (int i = 0; i <= [PlayingCard maxRank]; i++) {
				PlayingCard *card = [[PlayingCard alloc] init];
				card.rank = i;
				card.suit = suit;
				[self addCard:card atTop:YES];
			}
		}
	}
	
	return self;
}

@end
