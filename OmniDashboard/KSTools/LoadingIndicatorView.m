

#import "LoadingIndicatorView.h"
#import <QuartzCore/QuartzCore.h>
#import "DGActivityIndicatorView.h"

@interface LoadingIndicatorView ()
@property(nonatomic, retain) UILabel	*messageLabel;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;
-(void)addSubviews;
@end

@implementation LoadingIndicatorView

@synthesize messageLabel;
@synthesize activityIndicatorView;

-(id)initWithFrame:(CGRect)frame{
		
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		frame = CGRectMake(0, 0, 80, 60);
	else
		frame = CGRectMake(0, 0, 80, 60);	
	
	if((self = [super initWithFrame:frame])){
		self.backgroundColor = [UIColor darkGrayColor];
		self.layer.cornerRadius = 10;
		self.alpha = 0.85;
		[self addSubviews];
	}
	return self;
}

-(void)addSubviews{
    
    if(nil == self.activityIndicatorView)
    {
        DGActivityIndicatorView *ind = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotate tintColor:[UIColor whiteColor]];
        CGFloat width = 400;
        CGFloat height = 400;
        self.activityIndicatorView = ind;
        self.activityIndicatorView.frame = CGRectMake(10, 10, width, height);
        
        [self addSubview:self.activityIndicatorView];
    }
    self.activityIndicatorView.center = self.center;
    [self.activityIndicatorView startAnimating];
    
    /*
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
	self.messageLabel = lbl;*/
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
        [liv.activityIndicatorView stopAnimating];
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        [liv removeFromSuperview];
    }
}


@end
