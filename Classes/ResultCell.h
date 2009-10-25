#import "Result.h"
@class ResultContentView;

@interface ResultCell : UITableViewCell {
	Result *result;
	ResultContentView *mainContentView;
	
	/* swiping related */
	BOOL swiping;
	BOOL hasSwiped;
	BOOL hasSwipedLeft;
	BOOL hasSwipedRight;
	BOOL fingerIsMovingLeftOrRight;
	BOOL fingerMovingVertically;
	
	CGPoint startTouchPosition;
}

@property (retain) Result *result;
@property (readonly) ResultContentView *mainContentView;
@property BOOL swiping;
@property BOOL hasSwiped;
@property BOOL hasSwipedLeft;
@property BOOL hasSwipedRight;
@property BOOL fingerIsMovingLeftOrRight;
@property BOOL fingerMovingVertically;

- (BOOL)isTouchGoingLeftOrRight:(UITouch *)touch;
- (BOOL)fingerIsMovingVertically;
- (void)lookForSwipeGestureInTouches:(NSSet *)touches withEvent:(UIEvent *)event;	

@end

@interface ResultContentView : UIView {
	ResultCell *resultCell;
}
- (id) initWithResultCell: (ResultCell*) theCell;
@end