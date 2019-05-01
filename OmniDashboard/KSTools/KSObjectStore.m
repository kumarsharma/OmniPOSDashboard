//
//  KSObjectStore.m
//  LeaveRequest
//
//  Created by Kumar Sharma on 06/02/13.
//  Copyright (c) 2013 KSR. All rights reserved.
//

#import "KSObjectStore.h"

#define kObjectStoreFileName @"kObjectStoreFile"
#define kObjects @"Objects"

@interface KSObjectStore()

+ (NSString*)pathForUserDictionaryWithTrType:(NSString *)trType;
+ (NSString *)createEditableCopyOfFileIfNeeded:(NSString *)_filename;
+ (NSDictionary*)readCacheDataFrom:(NSString*)filePath forObjectKey:(NSString*)key;

@end

@implementation KSObjectStore

#pragma mark -
#pragma mark File Manager

+ (NSString*)pathForUserDictionaryWithTrType:(NSString *)trType
{
	NSString *path = [self createEditableCopyOfFileIfNeeded:[NSString stringWithFormat:@"%@.dat", trType]];
	
	return path;
}

+ (NSString *)createEditableCopyOfFileIfNeeded:(NSString *)_filename
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	
	NSString *cacheDirectory = nil;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	cacheDirectory = [paths objectAtIndex:0];
	paths=nil;
	
	NSString *writableSettingsPath = [cacheDirectory stringByAppendingPathComponent:_filename];
	
	if ([fileManager fileExistsAtPath:writableSettingsPath] == NO)
	{
		// The writable database does not exist, so copy the default to the appropriate location.
		BOOL success = [fileManager createFileAtPath:writableSettingsPath contents:nil attributes:nil] ;
		if (!success)
		{
			if(error != nil)
			{
				NSLog(@"Failed to create settings file with message '%@'.", [error localizedDescription]);
			}
			
			return nil;
		}
	}
	
	fileManager = nil;
	return writableSettingsPath;
}

+ (NSDictionary*)readCacheDataFrom:(NSString*)filePath forObjectKey:(NSString*)key
{
	NSDictionary *tempDict = nil;
	if(filePath != nil)
	{
		NSData *dataArea = [NSData dataWithContentsOfFile: filePath];
		
		if(!dataArea || !([dataArea length] >  0 ))
		{
			dataArea=nil;
			return nil ;
		}
		
		NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:dataArea];
		// Decode the objects we previously stored in the archive
		//		tempDict= [unarchiver decodeObjectForKey: @"profileImages"];
		tempDict= [unarchiver decodeObjectForKey: key];
		
		[unarchiver finishDecoding];
		
		dataArea=nil;
	}
	return tempDict;
}

#pragma mark - Methods

+ (BOOL)storeObject:(id)obj forKey:(NSString *)key
{
    NSDictionary *dict = nil;
	NSString *path = [self pathForUserDictionaryWithTrType:kObjectStoreFileName];
	dict = [self readCacheDataFrom:path forObjectKey:kObjects];
    
    NSMutableDictionary *mutDict = nil;
    
    mutDict = ([dict.allValues count] ? [[NSMutableDictionary alloc] initWithDictionary:dict] : [[NSMutableDictionary alloc] init]);
    
    if([mutDict valueForKey:key])
    {
        [mutDict removeObjectForKey:key];
        
#if DEBUG
        NSLog(@"EXISTING RESTAURANT DELETED");
#endif
        
    }
    [mutDict setValue:obj forKey:key];
    
    NSMutableData *dataArea = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataArea];
    
    [archiver encodeObject:mutDict forKey:kObjects];
    [archiver finishEncoding];
    
    return [dataArea writeToFile:path atomically:YES];
}

+ (id)getStoredObjectForKey:(NSString *)key
{
	NSDictionary *dict = nil;
	NSString *path = [self pathForUserDictionaryWithTrType:kObjectStoreFileName];
	dict = [self readCacheDataFrom:path forObjectKey:kObjects];

    return [dict valueForKey:key];
}

+ (BOOL)hasStoredObjectForKey:(NSString *)key
{
	NSDictionary *dict = nil;
	NSString *path = [self pathForUserDictionaryWithTrType:key];
	dict = [self readCacheDataFrom:path forObjectKey:kObjects];
    
    if(nil != [dict valueForKey:key])
        return YES;
    
    return NO;
}

@end
