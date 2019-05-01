

#import "LoadingIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@interface LoadingIndicatorView ()
@property(nonatomic, retain) UILabel	*messageLabel;
-(void)addSubviews;
@end

@implementation LoadingIndicatorView

@synthesize messageLabel;

-(id)initWithFrame:(CGRect)frame{
		
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		frame = CGRectMake(0, 0, 160, 160);
	else
		frame = CGRectMake(0, 0, 160, 140);	
	
	if((self = [super initWithFrame:frame])){
		self.backgroundColor = [UIColor darkTextColor];
		self.layer.cornerRadius = 10;
		self.alpha = 0.85;
		[self addSubviews];
	}
	return self;
}

-(void)addSubviews{
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[indicatorView startAnimating];	
	indicatorView.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height/2 - 45));

	UILabel *lbl = [[UILabel alloc] init];
	
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		lbl.frame = CGRectMake(1, indicatorView.center.y+45, self.frame.size.width-4, 21);
	else
		lbl.frame = CGRectMake(1, indicatorView.center.y+45, self.frame.size.width-4, 21);
	
	lbl.text = @"";
    lbl.numberOfLines = 4;
	lbl.textAlignment = UITextAlignmentCenter;
	lbl.backgroundColor = [UIColor clearColor];
	lbl.textColor = [UIColor whiteColor];
	[self addSubview:lbl];
	[self addSubview:indicatorView];
	self.messageLabel = lbl;
}

-(void)updateStatusMessage:(NSString*)statusMessage{
	
    //reposition the width
    CGRect textFrame = self.self.messageLabel.frame;
    textFrame.size.height = 21 +  (statusMessage.length / 20) * 21;
    self.messageLabel.frame = textFrame;

	self.messageLabel.text = statusMessage;
	[self.messageLabel setNeedsDisplay];
}
-(void)dealloc{
	
	self.messageLabel = nil;
}


#pragma mark - Direct call

+ (LoadingIndicatorView *)showLoadingIndicatorInView:(UIView *)view withMessage:(NSString *)message
{
    LoadingIndicatorView *liv = [[LoadingIndicatorView alloc] initWithFrame:CGRectZero];    
    liv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [liv setCenter:CGPointMake(view.bounds.size.width/2-10,(view.bounds.size.height/2 - 60))];
    [view addSubview:liv];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [liv updateStatusMessage:message];
    
    return liv;
}

+ (void)removeLoadingIndicator:(LoadingIndicatorView *)liv
{
    if(liv)
    {
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        [liv removeFromSuperview];
    }
}


@end
