//
//  KSObjectStore.h
//  LeaveRequest
//
//  Created by Kumar Sharma on 06/02/13.
//  Copyright (c) 2013 KSR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSObjectStore : NSObject

+ (BOOL)storeObject:(id)obj forKey:(NSString *)key;
+ (id)getStoredObjectForKey:(NSString *)key;
+ (BOOL)hasStoredObjectForKey:(NSString *)key;

@end
