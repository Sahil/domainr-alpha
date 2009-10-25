#import "DomainrTableView.h"
#import "ResultCell.h"

@implementation DomainrTableView

#pragma mark Touch gestures interception

	- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event; {
		if (self.decelerating || self.editing == YES) {
			return [super hitTest:point withEvent:event];
		}

		// Find the cell and forward to the cell, unless we want to have vertical scrolling
		NSIndexPath *indexPathAtHitPoint = [self indexPathForRowAtPoint:point];
		ResultCell *cell = (ResultCell *)[self cellForRowAtIndexPath:indexPathAtHitPoint];
		if (cell && ![cell fingerIsMovingVertically]) {
			return (UIView *)[cell contentView];
		}
		return [super hitTest:point withEvent:event];
	}

	- (BOOL)touchesShouldCancelInContentView:(UIView *)view; {
		return YES;
	}

	- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view; {
		return YES;
	}

@end
