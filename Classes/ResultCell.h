#import "Result.h"
@class ResultContentView;


@interface ResultCell : UITableViewCell {
	Result *result;
	ResultContentView *mainContentView;
}

@property (retain) Result *result;
@property (readonly) ResultContentView *mainContentView;

@end

@interface ResultContentView : UIView {
	ResultCell *resultCell;
}
- (id) initWithResultCell: (ResultCell*) theCell;
@end

@interface ResultBackgroundView : UIView {
    ResultCell* resultCell;
}
- (id) initWithResultCell: (ResultCell*) theCell;
@end


@interface ResultSelectedBackgroundView : UIView {
    ResultCell* resultCell;
}
- (id) initWithResultCell: (ResultCell*) theCell;
@end