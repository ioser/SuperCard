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

#define CARDBACK_IMAGE_NAME @"cardback.png"

@interface PlayingCardView ()

@property (nonatomic) CGFloat faceCardScaleFactor;

@end


@implementation PlayingCardView

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.80

#pragma mark - Draw Pips

#define PIP_FONT_SCALE_FACTOR 0.20
#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips
{
    if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:(self.rank != 7)];
    }
    if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    if ((self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
    if (upsideDown) {
		[self pushContextAndRotate180];
	}
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{ NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(
                                    middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                    );
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
}

- (CGFloat)faceCardScaleFactor {
	if (_faceCardScaleFactor == 0.0) {
		_faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
	}
	
	return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
	_faceCardScaleFactor = faceCardScaleFactor;
	[self setNeedsDisplay]; // Redraw everything.
}

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

- (void)drawCenter {
	if (self.faceUp == YES) {
		NSString *imageName = [NSString stringWithFormat:@"%@%@.jpg", [self rankAsString], self.suit];
		UIImage *faceImage = [UIImage imageNamed:imageName];
		if (faceImage != nil) {
			CGRect imageRect = CGRectInset(self.bounds,
										   self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
										   self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
			[faceImage drawInRect:imageRect];
		} else {
			[self drawPips];
		}
	} else {
		UIImage *backImage = [UIImage imageNamed:CARDBACK_IMAGE_NAME];
		[backImage drawInRect:self.bounds];
	}
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
	
	[self drawCenter];
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
