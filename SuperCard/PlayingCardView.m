//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Richard E Millet on 5/17/13.
//  Copyright (c) 2013 Richard Millet. All rights reserved.
//

#import "PlayingCardView.h"

#define ROUNDED_CORNER_RADIANS 12.0
#define CORNER_SCALE_FACTOR 0.20
#define CORNER_OFFSET 2.0

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

- (void)pushContextAndRotate180 {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
	CGContextRotateCTM(context, M_PI);
}

- (void)popContext {
	CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (NSString *)rankAsString {
	return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

- (NSString *)getPlayingCardCornerString {
	NSString *result = nil;
	
	result = [NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit];
	
	return result;
}

- (void)drawPlayingCardCorners {
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.alignment = NSTextAlignmentCenter;
	
	UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * CORNER_SCALE_FACTOR];
	NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:
									  [self getPlayingCardCornerString] attributes:@{NSParagraphStyleAttributeName : paragraphStyle,
														   NSFontAttributeName : cornerFont}];
	
	CGRect cornerTextBounds;
	cornerTextBounds.origin.x = self.bounds.origin.x + CORNER_OFFSET;
	cornerTextBounds.origin.y = self.bounds.origin.y + CORNER_OFFSET;
	cornerTextBounds.size = [cornerText size];
	
	// Draw the upper left corner
	[cornerText drawInRect:cornerTextBounds];
	
	// Draw the lower right corner
	[self pushContextAndRotate180];
	[cornerText drawInRect:cornerTextBounds];
	[self popContext];
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
	
	[self drawPlayingCardCorners];
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
