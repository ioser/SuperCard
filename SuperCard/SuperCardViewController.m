//
//  SuperCardViewController.m
//  SuperCard
//
//  Created by Richard E Millet on 5/17/13.
//  Copyright (c) 2013 Richard Millet. All rights reserved.
//

#import "SuperCardViewController.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface SuperCardViewController ()

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@property (strong, nonatomic) PlayingCardDeck *deck;

@end

@implementation SuperCardViewController

- (Deck *)deck {
	if (_deck == Nil) {
		_deck = [[PlayingCardDeck alloc] init];
	}
	return _deck;
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
	[self drawRandomPlayingCard];
	[self.playingCardView flipCard];
}

- (void)setPlayingCardView:(PlayingCardView *)playingCardView {
	_playingCardView = playingCardView;
//	playingCardView.rank = 13;
//	playingCardView.suit = @"♥";
	[self drawRandomPlayingCard];
	[self addGestures];
}

- (void)drawRandomPlayingCard {
	Card *card = [self.deck drawRandomCard];
	if ([card isKindOfClass:[PlayingCard class]] == YES) {
		PlayingCard *playingCard = (PlayingCard *)card;
		self.playingCardView.rank = [playingCard rank];
		self.playingCardView.suit = [playingCard suit];
	}
}

- (void)addGestures {
	UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self.playingCardView action:@selector(pinch:)];
	[self.playingCardView addGestureRecognizer:pinchGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
