//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Richard E Millet on 5/17/13.
//  Copyright (c) 2013 Richard Millet. All rights reserved.
//

#import "PlayingCardView.h"

#define ROUNDED_CORNER_RADIANS 12.0

@implementation PlayingCardView

- (void)setup {
	// Do initialization
}

- (void)awakeFromNib {
	[self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:ROUNDED_CORNER_RADIANS];
	[roundedRect addClip];
	
	[[UIColor whiteColor] setFill];
	UIRectFill(self.bounds);
	
	[[UIColor blackColor] setStroke];
	[roundedRect stroke];
}


- (void)setRank:(NSUInteger)rank {
	_rank = rank;
	[self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit {
	_suit = suit;
	[self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
	_faceUp = faceUp;
	[self setNeedsDisplay];
}

@end
