#import "ResultCell.h"

@implementation ResultCell

	@synthesize result, mainContentView;
	@synthesize swiping, hasSwiped, hasSwipedLeft, hasSwipedRight, fingerIsMovingLeftOrRight, fingerMovingVertically;

	- (id) initWithStyle: (UITableViewCellStyle)style reuseIdentifier: (NSString*) reuseIdentifier; {
		self = [super initWithStyle:style reuseIdentifier: reuseIdentifier];
		
		for (UIView* view in [self.contentView subviews])
			[view removeFromSuperview];
		
		self.opaque = YES;
		self.clearsContextBeforeDrawing = NO;

		mainContentView = [[ResultContentView alloc] initWithResultCell: self];
		mainContentView.opaque = YES;
		mainContentView.backgroundColor = [UIColor whiteColor];
		mainContentView.clearsContextBeforeDrawing = NO;
		mainContentView.contentMode = UIViewContentModeRedraw;
		[[self contentView] addSubview: mainContentView];
		
		return self;
	}

	- (void) setFrame: (CGRect) theFrame; {
		[super setFrame: theFrame];
		if (!CGSizeEqualToSize(theFrame.size, mainContentView.frame.size))
			mainContentView.frame = CGRectMake(0, 0, theFrame.size.width, theFrame.size.height);
	}

	- (void) dealloc; {
		Release(mainContentView);
		Release(result);
		[super dealloc];
	}

	- (void) setSelected: (BOOL) selected animated: (BOOL) animated; {
		if (self.selectionStyle != UITableViewCellSeparatorStyleNone) {
			[super setSelected: selected animated: animated];
			
			[self.mainContentView setNeedsDisplay];
		}
	}

	- (void) setResult: (Result*) theResult; {
		result.resultCell = nil;
		Release(result);
		result = [theResult retain];
		result.resultCell = self;
		
		[self.mainContentView setNeedsDisplay];
	}

	#pragma mark -

	static UIFont* domainFont = nil;
	static UIFont* availabilityFont = nil;

	- (void) drawCellInteriorInRect: (CGRect) rect isSelected: (BOOL) isSelected; {
		if (!domainFont) {
			domainFont = [[UIFont systemFontOfSize:17] retain];
			availabilityFont = [[UIFont systemFontOfSize:14] retain];
		}
		
		UIColor *mainTextColor = nil;
		UIColor *grayTextColor = nil;
		UIColor *lightTextColor = nil;
		
		if(self.highlighted) {
			mainTextColor = [UIColor whiteColor];
			grayTextColor = [UIColor whiteColor];
			lightTextColor = [UIColor whiteColor];
		} 
		else {
			if(result.imageType == kUnavailable){
				mainTextColor = [UIColor blackColor];
			}
			else {	
				mainTextColor = UIColorFromRGB(0x2160AD);
			}
			grayTextColor = [UIColor grayColor];
			lightTextColor = [UIColor lightGrayColor];
			self.backgroundColor = [UIColor whiteColor];
		}
		
		[mainTextColor set];
		CGSize domainTextSize = [result.domainName drawInRect:CGRectMake(30, 8, rect.size.width - 60, rect.size.height) 
													 withFont:domainFont 
												lineBreakMode:UILineBreakModeWordWrap];
		
		/* temporary solution (long strings won't work) */
		if(domainTextSize.height == 21) {
			[lightTextColor set];
			[result.path drawInRect:CGRectMake(30 + domainTextSize.width, 8, rect.size.width - 30 - domainTextSize.width - 35, 16) 
						   withFont:domainFont
					  lineBreakMode:UILineBreakModeTailTruncation];			
		}
		
		[grayTextColor set];
		[result.availability drawInRect:CGRectMake(30, rect.size.height - 25, rect.size.width - 50, 20) 
							   withFont:availabilityFont
						  lineBreakMode:UILineBreakModeWordWrap];
		
		if(result.imageType == kAvailable)
		 	[[UIImage imageNamed:@"available.png"] drawInRect:CGRectMake(10, 15, 10, 10) 
													blendMode:kCGBlendModeNormal 
														alpha:1.0];
		else if(result.imageType == kMaybe)
		 	[[UIImage imageNamed:@"maybe.png"] drawInRect:CGRectMake(10, 15, 10, 10)
												blendMode:kCGBlendModeNormal 
													alpha:1.0];
		else if(result.imageType == kTLD)
			[[UIImage imageNamed:@"tld.png"] drawInRect:CGRectMake(10, 15, 10, 10)
											  blendMode:kCGBlendModeNormal
												  alpha:1.0];
	}

#pragma mark -

	#define HORIZ_SWIPE_DRAG_MIN 12
	#define VERT_SWIPE_DRAG_MAX 4

	- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event; {
		UITouch *touch = [touches anyObject];
		startTouchPosition = [touch locationInView:self];
		self.swiping = NO;
		self.hasSwiped = NO;
		self.hasSwipedLeft = NO;
		self.hasSwipedRight = NO;
		self.fingerIsMovingLeftOrRight = NO;
		self.fingerMovingVertically = NO;
		[self.nextResponder touchesBegan:touches withEvent:event];
	}


	- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event; {
		if ([self isTouchGoingLeftOrRight:[touches anyObject]]) {
			[self lookForSwipeGestureInTouches:(NSSet *)touches withEvent:(UIEvent *)event];
			[super touchesMoved:touches withEvent:event];
		} else {
			[self.nextResponder touchesMoved:touches withEvent:event];
		}
	}


	// Determine what kind of gesture the finger event is generating
	- (BOOL)isTouchGoingLeftOrRight:(UITouch *)touch; {
		CGPoint currentTouchPosition = [touch locationInView:self];
		if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= 1.0) {
			self.fingerIsMovingLeftOrRight = YES;
			return YES;
		} else {
			self.fingerIsMovingLeftOrRight = NO;
			return NO;
		}
		if (fabsf(startTouchPosition.y - currentTouchPosition.y) >= 2.0) {
			self.fingerMovingVertically = YES;
		} else {
			self.fingerMovingVertically = NO;
		}
	}

	- (BOOL)fingerIsMovingVertically; {
		return self.fingerMovingVertically;
	}

	// Check for swipe gestures
	- (void)lookForSwipeGestureInTouches:(NSSet *)touches withEvent:(UIEvent *)event; {
		UITouch *touch = [touches anyObject];
		CGPoint currentTouchPosition = [touch locationInView:self];
		
		[self setSelected:NO];
		self.swiping = YES;
		
		if (hasSwiped == NO) {
			if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
				fabsf(startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX) {
				// It's a swipe!
				if (startTouchPosition.x < currentTouchPosition.x) {
					hasSwiped = YES;
					hasSwipedRight = YES;
					swiping = NO;
					
					//NSLog(@"Swipe Right");
				} else {
					hasSwiped = YES;
					hasSwipedLeft = YES;
					swiping = NO;
					//NSLog(@"Swipe Left");
				}
			} else {
				// No swipe
			}
			
		}
	}

	- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event; {
		self.swiping = NO;
		self.hasSwiped = NO;
		self.hasSwipedLeft = NO;
		self.hasSwipedRight = NO;
		self.fingerMovingVertically = NO;
		[self.nextResponder touchesEnded:touches withEvent:event];
	}

@end

@implementation ResultContentView

	- (id) initWithResultCell: (ResultCell*) theCell; {
		self = [super init];
		resultCell = theCell;
		return self;
	}

	- (void) drawRect: (CGRect) theRect; {
		[resultCell drawCellInteriorInRect: theRect isSelected: resultCell.selected];
	}

@end