
#import <Foundation/Foundation.h>


@interface LoadingIndicatorView : UIView {
	UILabel	*messageLabel;

}
- (id)initWithFrame:(CGRect)frame;
- (void)updateStatusMessage:(NSString*)statusMessage;

+ (LoadingIndicatorView *)showLoadingIndicatorInView:(UIView *)view withMessage:(NSString *)message;
+ (void)removeLoadingIndicator:(LoadingIndicatorView *)liv;
@end
