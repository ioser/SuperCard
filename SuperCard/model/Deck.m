//
//  Deck.m
//  Matchismo
//
//  Created by Richard E Millet on 3/24/13.
//  Copyright (c) 2013 Richard Millet. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation Deck

- (NSMutableArray *)cards {
	if (_cards == nil) {
		_cards = [[NSMutableArray alloc] init];
	}
	return _cards;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop {
	if (atTop) {
		[self.cards insertObject:card atIndex:0];
	} else {
		[self.cards addObject:card];
	}
}

- (Card *)drawRandomCard {
	Card *result = nil;
	
	if (self.cards.count != 0) {
		int randomIndex = arc4random() % self.cards.count;
		result = self.cards[randomIndex];
		[self.cards removeObjectAtIndex:randomIndex];
	}
	
	return result;
}

- (NSUInteger)countOfCards {
	return [self.cards count];
}

@end
