#import "ResultCell.h"

#define optimization

@implementation ResultCell

	@synthesize result, mainContentView;

//	enum ImageType {
//		kAvailable = 0,
//		kMaybe,
//		kTaken,
//		kTLD
//	};

	- (id) initWithStyle: (UITableViewCellStyle)style reuseIdentifier: (NSString*) reuseIdentifier; {
		self = [super initWithStyle:style reuseIdentifier: reuseIdentifier];
		
		for (UIView* view in [self.contentView subviews])
			[view removeFromSuperview];
		
		self.opaque = YES;

		self.clearsContextBeforeDrawing = NO;
		
		#ifdef optimization
		mainContentView = [[ResultContentView alloc] initWithResultCell: self];
		mainContentView.opaque = YES;
		mainContentView.backgroundColor = [UIColor whiteColor];
		mainContentView.clearsContextBeforeDrawing = NO;
		mainContentView.contentMode = UIViewContentModeRedraw;
		[[self contentView] addSubview: mainContentView];
		#endif
		
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

#pragma mark -

	- (void) setSelected: (BOOL) selected animated: (BOOL) animated; {
		if (self.selectionStyle != UITableViewCellSeparatorStyleNone) {
			[super setSelected: selected animated: animated];
			
			#ifdef optimization
			[self.mainContentView setNeedsDisplay];
			#endif
		}
	}

	- (void) setResult: (Result*) theResult; {
		result.resultCell = nil;
		Release(result);
		result = [theResult retain];
		result.resultCell = self;
		
		#ifdef optimization
		[self.mainContentView setNeedsDisplay];
		#else
		[self.backgroundView setNeedsDisplay];
		#endif
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
		UIColor *lightTextColor = nil;
		
		if(self.highlighted) {
			mainTextColor = [UIColor whiteColor];
			lightTextColor = [UIColor whiteColor];
		} 
		else {
			if(result.imageType == kUnavailable)
				mainTextColor = [UIColor blackColor];
			else
				mainTextColor = UIColorFromRGB(0x2160AD);
			lightTextColor = [UIColor grayColor];
			self.backgroundColor = [UIColor whiteColor];
		}
		
		[mainTextColor set];
		[result.domainName drawInRect:CGRectMake(30, 8, rect.size.width - 60, rect.size.height) withFont:domainFont lineBreakMode:UILineBreakModeWordWrap];
		
		[lightTextColor set];
		[result.availability drawInRect:CGRectMake(30, rect.size.height - 25, rect.size.width - 50, 20) withFont:availabilityFont lineBreakMode:UILineBreakModeWordWrap];
		
		if(result.imageType == kAvailable)
		 	[[UIImage imageNamed:@"available.png"] drawInRect: CGRectMake(10, 15, 10, 10) blendMode: kCGBlendModeNormal alpha: 1.0];
		else if(result.imageType == kMaybe)
		 	[[UIImage imageNamed:@"maybe.png"] drawInRect: CGRectMake(10, 15, 10, 10) blendMode: kCGBlendModeNormal alpha: 1.0];
		else if(result.imageType == kTLD)
			[[UIImage imageNamed:@"tld.png"] drawInRect: CGRectMake(10, 15, 10, 10) blendMode: kCGBlendModeNormal alpha: 1.0];

	}

	- (void) drawCellBackgroundInRect: (CGRect) theRect; {
		
	}

	- (void) drawSelectedCellBackgroundInRect: (CGRect) theRect; {
		
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


@implementation ResultBackgroundView

	- (id) initWithResultCell: (ResultCell*) theCell; {
		self = [super init];
		resultCell = theCell;
		return self;
	}

	- (void) drawRect: (CGRect) theRect; {
		[resultCell drawCellBackgroundInRect: theRect];
	#ifndef optimization
		[resultCell drawCellInteriorInRect: theRect isSelected: NO];
	#endif
	}

@end


@implementation ResultSelectedBackgroundView

	- (id) initWithResultCell: (ResultCell*) theCell; {
		self = [super init];
		resultCell = theCell;
		return self;
	}

	- (void) drawRect: (CGRect) theRect; {
		[resultCell drawSelectedCellBackgroundInRect: theRect];
	#ifndef optimization
		[resultCell drawCellInteriorInRect: theRect isSelected: YES];
	#endif
	}

@end
