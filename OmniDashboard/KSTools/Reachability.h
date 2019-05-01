

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface Reachability : NSObject {
	SCNetworkReachabilityRef reachabilityRef;
	BOOL startedNotifier;
}

//reachabilityForInternetConnection- checks whether the default route is available.  
+ (Reachability*) createReachabilityForInternetConnection;
+ (Reachability*)sharedManager;
//Start listening for reachability notifications on the current run loop
- (BOOL) startNotifer;
- (void) stopNotifer;
- (NetworkStatus) currentReachabilityStatus;

@end
