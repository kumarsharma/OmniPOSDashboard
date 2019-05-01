//
//  OPCategoryFetchHelper.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 24/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPDataFetchHelper : NSObject

+ (void)fetchReportWithDateRange:(NSDate*)fromDate toDate:(NSDate*)toDate executionBlock:(endRequestCompletionBlk_t)complBlock;
+ (void)fetchXReportWithExecutionBlock:(endRequestCompletionBlk_t)complBlock;
+ (void)fetchAvailableUserInfos;
+ (void)fetchBasicReportWithDateRange:(NSDate*)fromDate toDate:(NSDate*)toDate executionBlock:(endRequestCompletionBlk_t)complBlock;
+ (void)fetchCurrentSaleAllWithExecutionBlock:(endRequestCompletionBlk_t)complBlock;

+ (void)fetchCurrentReportWithExecutionBlock:(endRequestCompletionBlk_t)complBlock;
+ (void)fetchSalesSummaryFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withExecutionBlock:(endRequestCompletionBlk_t)complBlock;
+ (void)fetchHourlySalesSummaryFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withExecutionBlock:(endRequestCompletionBlk_t)complBlock;
+ (void)fetchIndividualItemSalesSummaryFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withExecutionBlock:(endRequestCompletionBlk_t)complBlock;
+ (void)fetchXReportForDeviceId:(NSString *)deviceId withExecutionBlock:(endRequestCompletionBlk_t)complBlock;
+ (void)fetchXReportForALLWithExecutionBlock:(endRequestCompletionBlk_t)complBlock;
+ (void)fetchSalesSummaryItemWiseFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withExecutionBlock:(endRequestCompletionBlk_t)complBlock;
@end
