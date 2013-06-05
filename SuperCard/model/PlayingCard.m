//
//  PlayingCard.m
//  Matchismo
//
//  Created by Richard E Millet on 3/24/13.
//  Copyright (c) 2013 Richard Millet. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

// @Override
+ (NSArray *)getRankSymbolList {
	return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8",
					 @"9", @"10", @"J", @"Q", @"K",];
}

// @Override
+ (NSArray *)getSuitSymbolList {
	return @[@"♥", @"♦", @"♠", @"♣"];
}

- (int)match:(NSArray *)otherCards {
	int result = 0;
	
	for (Card *card in otherCards) {
		if ([card isKindOfClass:[PlayingCard class]] == YES) {
			PlayingCard *playingCard = (PlayingCard *)card;
			if ([playingCard.contents isEqualToString:self.contents]) {
				result += 8;
			} else if (playingCard.rank == self.rank) {
				result += 4;
			} else if ([playingCard.suit isEqualToString:self.suit]) {
				result += 1;
			} else {
				// We found a mismatched card, so we will reset the result to 0 and exit the loop.
				result = 0;
				break;
			}
		} else {
			NSLog(@"WARNING: Found a non 'PlayingCard' card instance.");
		}
	}
	
	return result;
}

@end
