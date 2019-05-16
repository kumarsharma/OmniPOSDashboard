//
//  OPCategoryFetchHelper.m
//  iOmniPOS
//
//  Created by Kumar Sharma on 24/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "OPDataFetchHelper.h"
#import "OPConnection.h"
#import "KSDateUtil.h"
#import "OPReportHolder.h"
#import "UserInfo.h"
#import "OPManagedObjectHolder.h"
#import "CompanyInfo.h"
#import "ADUtils.h"

@interface OPDataFetchHelper()

@end

@implementation OPDataFetchHelper

+ (void)fetchAvailableUserInfos
{
    [UserInfo getAllDetailsWithExecutionBlock:^(BOOL success, Response *response) {
        
        OPManagedObjectHolder *mHolder = [OPManagedObjectHolder parseXml:response.responseData rootElementName:@"UserInfo" objectHoldersElementName:@"UserObjects" targetClassName:NSStringFromClass([UserInfo class])];
        if(mHolder)
        {
            NSString *uname = nil, *password = nil;
            [NetworkConfig getUserName:&uname andPassword:&password];
            
            UserInfo *thisUser = nil;
            for(UserInfo *user in mHolder.availableObjects)
            {
                if([uname isEqualToString:user.userName])
                {
                    thisUser = user;
                    break;
                }
            }
            
            if(thisUser)
            {
                [[OPDashboardAppDelegate sharedAppDelegate] storeUser:thisUser];
                [[OPDashboardAppDelegate sharedAppDelegate] setUser:thisUser];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidFinishActiveNetworkOperations object:nil];
        
    }];
}

#pragma mark - Reports

+ (void)fetchReportWithDateRange:(NSDate*)fromDate toDate:(NSDate*)toDate executionBlock:(endRequestCompletionBlk_t)complBlock
{
//    if([KSDateUtil daysBetweenFirstDate:fromDate secndDate:toDate] == 1)
//        toDate = [KSDateUtil getNextDayByCount:1 fromDate:toDate];
    
    NSString *remoteFetchPath = @"/webservices/RestaurantSalesService.asmx/getBasicAndCategorySalesReport";
    NSString *urlString = [NSString stringWithFormat:@"http://%@%@", [NetworkConfig getBaseBaseURL], remoteFetchPath];
    
    NSString *params = [NSString stringWithFormat:@"fromdate=%@&tilldate=%@&rest_Id=%@", [KSDateUtil getShortSlashSepDateOnlyString:fromDate], [KSDateUtil getShortSlashSepDateOnlyString:toDate], ([OPDashboardAppDelegate sharedAppDelegate]).currentRestaurantId];
    
    [OPConnection postWithBody:params withUrlString:urlString compBlock:complBlock];
}

+ (void)fetchBasicReportWithDateRange:(NSDate*)fromDate toDate:(NSDate*)toDate executionBlock:(endRequestCompletionBlk_t)complBlock
{
//    if([KSDateUtil daysBetweenFirstDate:fromDate secndDate:toDate] == 1)
//        toDate = [KSDateUtil getNextDayByCount:1 fromDate:toDate];
    
    NSString *remoteFetchPath = @"/webservices/RestaurantSalesService.asmx/getBasicSalesReport";
    NSString *urlString = [NSString stringWithFormat:@"http://%@%@", [NetworkConfig getBaseBaseURL], remoteFetchPath];
    
    NSString *params = [NSString stringWithFormat:@"fromdate=%@&tilldate=%@&rest_Id=%@", [KSDateUtil getShortSlashSepDateOnlyString:fromDate], [KSDateUtil getShortSlashSepDateOnlyString:toDate], ([OPDashboardAppDelegate sharedAppDelegate]).currentRestaurantId];
    
    [OPConnection postWithBody:params withUrlString:urlString compBlock:complBlock];
}

+ (void)fetchXReportWithExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], @"/getXReportInfo.asmx/getXReportDetails"];
    
    NSString *params = [NSString stringWithFormat:@"param=Rest_ID&val=%@", ([OPDashboardAppDelegate sharedAppDelegate]).currentRestaurantId];
    
    [OPConnection postWithBody:params withUrlString:urlString compBlock:complBlock];
}

+ (void)fetchCurrentSaleAllWithExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], @"/RestaurantSaleServices.asmx/GetCurrentSaleALLJSON"];
    
    NSString *params = [NSString stringWithFormat:@"companycode=%@", ([OPDashboardAppDelegate sharedAppDelegate]).company.companyCode];
    
    [OPConnection postWithBody:params withUrlString:urlString compBlock:complBlock];
}

+ (void)fetchCurrentReportWithExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], @"/RestaurantSaleServices.asmx/GetCurrentSaleSummaryByDevice"];
    
    NSString *body = [NSString stringWithFormat:@"companycode=%@&locationId=%@&deviceId=0", ([OPDashboardAppDelegate sharedAppDelegate]).company.companyCode, ([OPDashboardAppDelegate sharedAppDelegate]).currentRestaurantId];
    
    [OPConnection postWithBody:body withUrlString:urlString compBlock:complBlock];
}

+ (void)fetchSalesSummaryFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], @"/RestaurantSaleServices.asmx/GetSalesSummary"];
    
    NSString *body = [NSString stringWithFormat:@"companycode=%@&locationId=%@&fromdate=%@&tilldate=%@&userId=%@&deviceId=%@&categoryId=%@&subcategoryId=%@", ([OPDashboardAppDelegate sharedAppDelegate]).company.companyCode, ([OPDashboardAppDelegate sharedAppDelegate]).currentRestaurantId, [ADUtils getShortDateOnlyStringInMMddYYYY:fromDate], [ADUtils getShortDateOnlyStringInMMddYYYY:toDate], @"0", @"0", @"0", @"0"];
    [OPConnection postWithBody:body withUrlString:urlString compBlock:complBlock];
}

+ (void)fetchHourlySalesSummaryFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], @"/RestaurantSaleServices.asmx/GetHourlySaleSummary"];
    
    NSString *body = [NSString stringWithFormat:@"companycode=%@&locationId=%@&fromdate=%@&tilldate=%@&userId=%@&deviceId=%@&categoryId=%@&subcategoryId=%@", ([OPDashboardAppDelegate sharedAppDelegate]).company.companyCode, ([OPDashboardAppDelegate sharedAppDelegate]).currentRestaurantId, [ADUtils getShortDateOnlyStringInMMddYYYY:fromDate], [ADUtils getShortDateOnlyStringInMMddYYYY:toDate], @"0", @"0", @"0", @"0"];
    [OPConnection postWithBody:body withUrlString:urlString compBlock:complBlock];
}

+ (void)fetchIndividualItemSalesSummaryFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], @"/RestaurantSaleServices.asmx/GetItemSoldSaleSummaryJsonFormat"];
    
    NSString *body = [NSString stringWithFormat:@"companycode=%@&locationId=%@&fromdate=%@&tilldate=%@&categoryId=%@&subcategoryId=%@&userId=%@&deviceId=%@&reportType=1", ([OPDashboardAppDelegate sharedAppDelegate]).company.companyCode, ([OPDashboardAppDelegate sharedAppDelegate]).currentRestaurantId, [ADUtils getShortDateOnlyStringInMMddYYYY:fromDate], [ADUtils getShortDateOnlyStringInMMddYYYY:toDate], @"0", @"0", @"0", @"0"];
    [OPConnection postWithBody:body withUrlString:urlString compBlock:complBlock];
}

+ (void)fetchSalesSummaryItemWiseFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], @"/RestaurantSaleServices.asmx/GetSaleSummaryItemWise"];
    toDate = [KSDateUtil getNextDayByCount:1 fromDate:toDate];
    NSString *body = [NSString stringWithFormat:@"companycode=%@&locationId=%@&date1=%@&date2=%@", ([OPDashboardAppDelegate sharedAppDelegate]).company.companyCode, ([OPDashboardAppDelegate sharedAppDelegate]).currentRestaurantId, [ADUtils getDateOnlyInYYYYMMDDFormat:fromDate], [ADUtils getDateOnlyInYYYYMMDDFormat:toDate]];
    [OPConnection postWithBody:body withUrlString:urlString compBlock:complBlock];
}

+ (void)fetchXReportForDeviceId:(NSString *)deviceId withExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = nil, *body = nil;
    if(deviceId.intValue>0)
    {
        urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], @"/RestaurantSaleServices.asmx/GetCurrentSaleSummaryByDevice"];
        body = [NSString stringWithFormat:@"companycode=%@&locationId=%@&deviceId=%@", ([OPDashboardAppDelegate sharedAppDelegate]).company.companyCode, ([OPDashboardAppDelegate sharedAppDelegate]).currentRestaurantId, deviceId];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], @"/RestaurantSaleServices.asmx/GetCurrentSaleSummary"];
        body = [NSString stringWithFormat:@"companycode=%@&locationId=%@", ([OPDashboardAppDelegate sharedAppDelegate]).company.companyCode, ([OPDashboardAppDelegate sharedAppDelegate]).currentRestaurantId];
    }
    
    [OPConnection postWithBody:body withUrlString:urlString compBlock:complBlock];
}

+ (void)fetchXReportForALLWithExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = nil, *body = nil;
    
    urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], @"/RestaurantSaleServices.asmx/GetCurrentSaleSummaryByALL"];
    body = [NSString stringWithFormat:@"companycode=%@&locationId=%@&deviceId=%@&userId=%@&categoryId=%@&subcategoryId=%@", ([OPDashboardAppDelegate sharedAppDelegate]).company.companyCode, ([OPDashboardAppDelegate sharedAppDelegate]).currentRestaurantId, @"0", @"0", @"0", @"0"];
    
    [OPConnection postWithBody:body withUrlString:urlString compBlock:complBlock];
}
@end
